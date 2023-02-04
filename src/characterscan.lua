local merc = select(2, ...)

-- TODO: Explore when to do these scans. Seems a scan takes about 0.002 seconds
-- so it's not terrible for performance but maybe we don't want to run this that
-- often anyway.
-- Possible options to explore:
--  * Only scan on BAG_UPDATE_DELAYED events if bags/profession windows are currently open
--  * Only scan out of combat
--
--  For now a full bag scan happens every time your items change and a full bank
--  scan is also included if the bank frame is open
function merc.BagsUpdated()
    local start = GetTimePreciseSec()
    local inventory = merc.ScanBags()
    merc.UpdateCharacterInventory(inventory)
    if BankFrame:IsShown() then
        local bank = merc.ScanBank()
        merc.UpdateCharacterBank(bank)
    end
    local stop = GetTimePreciseSec()
end
merc.SetEventHandler("BAG_UPDATE_DELAYED", merc.BagsUpdated)

function merc.BankOpened(frameType)
    if frameType == 8 then
        local bank = merc.ScanBank()
        merc.UpdateCharacterBank(bank)
    end
end
merc.SetEventHandler("PLAYER_INTERACTION_MANAGER_FRAME_SHOW", merc.BankOpened)

function merc.ScanBags()
    local items = {}
    for i = BACKPACK_CONTAINER, NUM_BAG_SLOTS + 1 do
        merc.ScanBagById(i, items)
    end
    return items
end

function merc.ScanBank()
    assert(BankFrame:IsShown(), "bank frame must be open")
    local items = {}
    merc.ScanBagById(BANK_CONTAINER, items)
    local bankBagStart = NUM_TOTAL_EQUIPPED_BAG_SLOTS + 1
    local bankBagEnd = NUM_TOTAL_EQUIPPED_BAG_SLOTS + NUM_BANKBAGSLOTS
    for i = bankBagStart, bankBagEnd do
        merc.ScanBagById(i, items)
    end
    merc.ScanBagById(REAGENTBANK_CONTAINER, items)
    return items
end

function merc.ScanBagById(bagId, items)
    local n = C_Container.GetContainerNumSlots(bagId)
    for i = 1, n do
        local info = C_Container.GetContainerItemInfo(bagId, i)
        if info ~= nil then
            local itemId = tostring(info.itemID)
            if items[itemId] == nil then
                items[itemId] = 0
            end
            items[itemId] = items[itemId] + info.stackCount
        end
    end
end
