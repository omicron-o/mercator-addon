-- Copyright 2023 <omicron.me@protonmail.com>
--
-- This file is part of Mercator.
-- 
-- Mercator is free software: you can redistribute it and/or modify it under the
-- terms of the GNU General Public License as published by the Free Software
-- Foundation, either version 3 of the License, or (at your option) any later
-- version.
--
-- Mercator is distributed in the hope that it will be useful, but WITHOUT ANY
-- WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR
-- A PARTICULAR PURPOSE. See the GNU General Public License for more details.
--
-- You should have received a copy of the GNU General Public License along with
-- Mercator. If not, see <https://www.gnu.org/licenses/>. 
local merc = select(2, ...)
local data = merc.data

-- Scan flow:
-- 1. Make a list of all the items we want to scan
-- 2. SendSearchQuery()
-- 3. *_RESULTS_UPDATED
-- 4. AUCTION_HOUSE_THROTTLED_SYSTEM_READY
-- 5. *_RESULTS_UPDATED
--      These can keep coming in for a bit
--      not sure what happens if you immediately send a new request after 4.

-- Commodities we care about that we want to scan
merc.commodities = {
    ['200054'] = true,      -- Enchant Weapon - Sophic Devotion Q3
    ['200012'] = true,      -- Enchant Weapon - Sophic Devotion Q2
    ['199970'] = false,     -- Enchant Weapon - Sophic Devotion Q1
    
    ['200056'] = true,      -- Enchant Weapon - Frozen Devotion Q3
    ['200014'] = true,      -- Enchant Weapon - Frozen Devotion Q2
    ['199972'] = false,     -- Enchant Weapon - Frozen Devotion Q1

    ['200020'] = true,      -- Enchant Boots - Watcher's Loam Q3
    ['199978'] = true,      -- Enchant Boots - Watcher's Loam Q2
    ['199936'] = false,      -- Enchant Boots - Watcher's Loam Q1
    
    ['200113'] = true,      -- Resonant Crystal
    ['194124'] = true,      -- Vibrant Shard
    ['194123'] = true,      -- Chromatic Dust

    ['201406'] = true,      -- Glowing Titan Orb

    ['190324'] = true,      -- Awakened Order
    ['190327'] = true,      -- Awakened Air
    ['190316'] = true,      -- Awakened Earth
    ['190329'] = true,      -- Awakened Frost
    ['190321'] = true,      -- Awakened Fire

    ['194821'] = false,     -- Buzzing rune Q1
    ['194822'] = true,      -- Buzzing rune Q2
    ['194823'] = true,      -- Buzzing rune Q3
}

-- The current progress of a scan
merc.scanning = false
merc.currentScan = nil
merc.scanData = {}

-- A scan is a three part system (mostly):
--  1. A command handler starts the scan and sends the first query
--  2. The search results event gathers data
--  3. The throttle ready function queues up the next scan query
function merc.AuctionScanCommand()
    if not AuctionHouseFrame:IsShown() then
        print("The AH has to be open")
        return
    elseif merc.scanning then
        print("Scan already in progress")
        return
    else
        print("Starting auction scan")
        merc.scanData = {}
        merc.scanning = true
        merc.currentScan = nil
        merc.ScanNextItem()
    end
end

function merc.ScanNextItem()
    if not merc.scanning then
        -- This stops queued ScanNextItem() calls if the scan is aborted before
        -- the call is made. See AUCTION_HOUSE_CLOSED handler.
        return
    end
    
    local shouldScan = false
    repeat
        merc.currentScan, shouldScan = next(merc.commodities, merc.currentScan)
    until(itemId == nil or shouldScan == true)

    if merc.currentScan == nil then
        print("The scan has completed")
        merc.scanning = false
    else
        local itemId = tonumber(merc.currentScan)
        local name, link = GetItemInfo(itemId)
        print("Scanning for", itemId, link)
        merc.SearchItemById(itemId)
    end
end

function merc.ThrottledSystemReady()
    if merc.currentScan ~= nil then
        C_Timer.After(1.0, merc.ScanNextItem)
    end
end
merc.SetEventHandler("AUCTION_HOUSE_THROTTLED_SYSTEM_READY", merc.ThrottledSystemReady)

function merc.AuctionHouseClosed()
    if merc.scanning then
        print("AH closed. Aborting ongoing scan.")
        merc.currentScan = nil
        merc.scanning = false
        -- Note that there may still be a call to merc.ScanNextItem queued up
        -- since those calls are delayed in the *_SYSTEM_READY handler
    end
end
merc.SetEventHandler("AUCTION_HOUSE_CLOSED", merc.AuctionHouseClosed)


-- Convenience function to search an item by id
function merc.SearchItemById(id)
    local key = C_AuctionHouse.MakeItemKey(id)
    C_AuctionHouse.SendSearchQuery(key, {}, false)
end

-- Given some price input results, calculate the mean cost of different item
-- quantities
function merc.ProcessPriceResults(results)
    local quantities = {1, 10, 100, 500, 1000, 5000, 10000}
    local means = {}
    for _, quantity in ipairs(quantities) do
        means[tostring(quantity)] = merc.MeanUnitPrice(results, quantity)
    end
    return means
end

-- Calculate the average unit price for n units
function merc.MeanUnitPrice(results, n)
    local quantity = 0
    local price = 0

    for _, result in ipairs(results) do
        local new = result.quantity
        if quantity + new > n then
            new = n - quantity
        end
        
        quantity = quantity + new
        price = price + new*result.price
        
        if quantity == n then
            return price/quantity
        end
    end

    return nil
end

-- Harvest commodity results
function merc.CommodityResultsEvent(itemId)
    local name, link = GetItemInfo(itemId)
    local numResults = C_AuctionHouse.GetNumCommoditySearchResults(itemId)

    -- Grab all the quantities and prices from AH
    local results = {}
    for i = 1, numResults do
        local result = C_AuctionHouse.GetCommoditySearchResultInfo(itemId, i)
        table.insert(results, {quantity=result.quantity, price=result.unitPrice})
    end
    
    -- Calculate the desired mean values, and update the recent & historic
    -- prices
    local means = merc.ProcessPriceResults(results)
    data.UpdateRecentPrice(itemId, means)
    data.AddPriceHistory(itemId, means)
end
merc.SetEventHandler("COMMODITY_SEARCH_RESULTS_UPDATED", merc.CommodityResultsEvent)
