local AddonName, merc = ...

-- Iterator for checkig if all items are cached
merc.itemCacheCheckIdx = nil

-- TODO: Probably want to use a str: bool map with item_id: have_received data
-- instead of just a list
merc.uncachedItems = {}

function merc.StartItemCacheCheck(initialLogin, reloadUI)
    if not initialLogin and not reloadUI then
        return
    end
    merc.uncachedItems = {}
    print("Item cache check in 60 seconds.")
    C_Timer.After(60, function() 
        print("Starting item cache check now.")
        merc.CheckItemCache()
    end)
end
merc.SetEventHandler("PLAYER_ENTERING_WORLD", merc.StartItemCacheCheck)

-- Checks a few items to see if they are cached every frame until all items are
-- checked. Uncached items are added to a list to be requested later
function merc.CheckItemCache()
    local itemsPerFrame = 5
    for i = 1, 5 do
        merc.itemCacheCheckIdx = next(merc.commodities, merc.itemCacheCheckIdx)
        if merc.itemCacheCheckIdx == nil then
            -- Iteration is complete, end this loop early and start requesting
            -- item info
            merc.uncachedIdx = nil
            if not merc.RequestNextUncached() then
                print("No uncached items found. Cache check complete")
            else
                print(#merc.uncachedItems, "uncached items found. Requesting data...")
            end
            return
        elseif not C_Item.IsItemDataCachedByID(merc.itemCacheCheckIdx) then
            table.insert(merc.uncachedItems, merc.itemCacheCheckIdx)
        end
    end
    RunNextFrame(merc.CheckItemCache)
end

-- Iterator for uncached items requesting
merc.uncachedIdx = nil

-- Requests item info for the next uncached item. Returns false if no item was
-- requested, true otherwise.
function merc.RequestNextUncached()
    local itemId
    merc.uncachedIdx, itemId = next(merc.uncachedItems, merc.uncachedIdx)
    if merc.uncachedIdx == nil then
        merc.uncachedItems = {}
        return false
    end
    -- TODO: What happens if the item became cached recently? Will this prevent
    -- the event with new item info from firing? Should probably instantly
    -- request the next item if that happens
    GetItemInfo(tonumber(itemId))
    return true
end

function merc.ReceiveItemInfo(id, success)
    if not merc.uncachedIdx then
        return
    end

    local isCurrent = merc.uncachedItems[merc.uncachedIdx] == tostring(id)
    if not success then
        print("Item info fail for", id, success)
    end
    if isCurrent then
        if not merc.RequestNextUncached() then
            print("All items are cached.")
        end
    end
end
merc.SetEventHandler("GET_ITEM_INFO_RECEIVED", merc.ReceiveItemInfo)
