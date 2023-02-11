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
local AddonName, merc = ...


local items = {
    cloth = {
        192095,
        192096,
        192097,
        193929,
        193930,
        193931,
        193932,
        193933,
        193934,
        193922
    },
    leather = {
        193213,
        193214,
        193215,
        193208,
        193210,
        193211
    }
}


function merc.StartItemCacheCheck()
    print("Item cache check in 60 seconds.")

    local toScan = {}
    for itemId, _ in pairs(merc.commodities) do
        table.insert(toScan, tonumber(itemId))
    end
    
    C_Timer.After(60, function() 
        merc.StartCacheUpdate(toScan)
    end)
end
merc.SetEventHandler("MERCATOR_FULLY_LOADED", merc.StartItemCacheCheck)

merc.ItemCacheState = {
    nextScan = 1,
    currentScan = nil,
    runningScans = {}
}

-- Gets the current scan
local function GetCurrentScan()
    local state = merc.ItemCacheState
    if state.currentScan then
        return state.runningScans[state.currentScan], state.currentScan
    else
        return nil, nil
    end
end

-- Ensures a set of itemids (str or number) are cached by the client. The
-- callback function will be called with the table of requested item ids once
-- all the requested items are in the cache.
function merc.StartCacheUpdate(itemIds, cb)
    if type(itemIds) ~= 'table' then
        error("itemIds must be a table")
    end
    
    local state = merc.ItemCacheState
    local scanId = tostring(state.nextScan)
    state.nextScan = state.nextScan + 1
    
    state.runningScans[scanId] = {
        stage = "new",
        itemIds = itemIds,
        updates = {},       -- itemid(str) to boolean map, whether an item is cached or not
        it = nil,           -- current iterator progress into itemIds
        requested = 0,      -- # of items requested
        failed = 0,         -- # of failed requests
        received = 0,       -- # of items received
        invalid = 0,        -- # of invalid item ids
        total = #itemIds,
        cb = cb,
        created = GetServerTime(),
        completed = nil
    }
    
    -- If no current scan is running we start this new scan
    if state.currentScan == nil then
        state.currentScan = scanId
        GetCurrentScan().stage = "local"
        merc.LocalCacheScan()
    end

    return scanId
end

-- Helper function to ensure a scan is in the correct stage, also returns the
-- current scan table
local function EnsureCacheScanStage(stage)
    local scan, scanId = GetCurrentScan()
    if scan == nil then
        error("A Cache Update must be running")
    end
    if scan.stage ~= stage then
        local errfmt = "Current scan should be in stage %s but we are in stage %s"
        error(string.format(errfmt, stage, scan.stage))
    end
    return scan, scanId
end

-- The first step of a cache update scan. Any item id is checked to see if it is
-- in the local cache. This runs only a few items per game frame.
function merc.LocalCacheScan()
    local scan = EnsureCacheScanStage("local")
    for i = 1, 5 do
        local itemId = nil
        scan.it, itemId = next(scan.itemIds, scan.it)
        if scan.it == nil then
            -- done iterating. Go to the next stage
            scan.stage = "remote"
            merc.RemoteCacheScan()
            return
        end
        local isCached = C_Item.IsItemDataCachedByID(itemId)
        scan.updates[tostring(itemId)] = isCached
    end
    RunNextFrame(merc.LocalCacheScan)
end


-- Get the next uncached item id in the current scan (must be in remote stage)
function GetNextUncached(scan)
    repeat 
        local itemIdStr, isCached = next(scan.updates, scan.it)
        scan.it = itemIdStr
    until(not isCached)
    return tonumber(scan.it)
end

-- Step two of a cache scan. This will send out requests for item info for each
-- item that isn't already cached
function merc.RemoteCacheScan()
    local scan = EnsureCacheScanStage("remote")
    
    -- Send a request for 1 uncached item.
    repeat
        local itemId = GetNextUncached(scan)
        
        -- All items are scanned
        if itemId == nil then
            break
        end

        local itemName = GetItemInfo(itemId)
        local sentScan = (itemName == nil)
        if not sentScan then
            -- This item already became known to us after it was added for
            -- scanning
            scan.updates[tostring(itemId)] = true
        end
        scan.requested = scan.requested + 1
    until(scan.it == nil or sentScan)
    
    if scan.it == nil then
        -- Done move to the next stage
        scan.stage = "finishing"
        merc.FinishCacheScan()
    end
end

-- Step three of a cache scan. Will receive item updates
function merc.ReceiveCacheScan(itemId, success)
    -- Abort early if we have no scan
    local scan, scanId = GetCurrentScan()
    if scan == nil then
        return
    end
    
    -- Abort early if received item isn't in scan
    local itemId = tostring(itemId)
    if scan.updates[itemId] == nil then
        return
    end
    
    if success == true then
        scan.received = scan.received + 1
        scan.updates[itemId] = true
    elseif success == false then
        scan.failed = scan.failed + 1
    elseif success == nil then
        scan.invalid = scan.invalid + 1
    end

    -- Queue next item
    C_Timer.After(0.04, merc.RemoteCacheScan)
end
merc.SetEventHandler("GET_ITEM_INFO_RECEIVED", merc.ReceiveCacheScan)

-- Final stage of the scan, starts a new scan if more scans are waiting
function merc.FinishCacheScan()
    local scan, scanId = EnsureCacheScanStage("finishing")
    scan.completed = GetServerTime()

    print("Completed scan with id", scanId, "after", scan.completed - scan.created)
    print(" All ids:", #scan.itemIds)
    print(" Requested:", scan.requested)
    print(" Received:", scan.received)
    print(" failed:", scan.failed)
    print(" invalid:", scan.invalid)

    -- TODO: deal with failed/invalid items
    
    if scan.cb ~= nil then
        RunNextFrame(function()
            scan.cb(scan)
            scan.stage = "ended"
        end)
    else
        scan.stage = "ended"
    end
    
    -- Start next scan
    local nextScan = tostring(tonumber(scanId) + 1)
    local state = merc.ItemCacheState
    if state.runningScans[nextScan] == nil then
        state.currentScan = nil
    else
        state.currentScan = nextScan
        GetCurrentScan().stage = "local"
        merc.LocalCacheScan()
    end
end
