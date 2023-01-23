local AddonName, merc = ...

function merc.AddTooltipPriceData(tooltip, itemid)
    local now = GetServerTime()
    local means, from, time = merc.GetRecentPrice(itemid)
    if not means then
        return
    end
    
    local age = now - time

    tooltip:AddLine()
    tooltip:AddDoubleLine("Recent mean prices", merc.FormatDuration(age))
    local quantities = {"1", "10", "100", "1000"}
    for _, qty in ipairs(quantities) do
        local mean = means[qty]
        if mean then
            mean = GetCoinTextureString(mean)
        else
            mean = "n/a"
        end
        tooltip:AddDoubleLine(qty, mean, 1, 1, 1, 1, 1, 1)
    end
end

function merc.AddTooltipItemId(tooltip, itemid)
        tooltip:AddDoubleLine("id", tostring(itemid), nil, nil, nil, 1, 1, 1)
end

function merc.OnTooltipSetItem(tooltip, data)
    if tooltip == GameTooltip then
        merc.AddTooltipPriceData(tooltip, data.id)
        merc.AddTooltipItemId(tooltip, data.id)
    end
end

-- Replace 'Enum.TooltipDataType.Item' with an appropriate type for the tooltip
-- data you are wanting to process; eg. use 'Enum.TooltipDataType.Spell' for
-- replacing usage of OnTooltipSetSpell.
--
-- If you wish to respond to all tooltip data updates, you can instead replace
-- the enum with 'TooltipDataProcessor.AllTypes' (or the string "ALL").

TooltipDataProcessor.AddTooltipPostCall(Enum.TooltipDataType.Item, merc.OnTooltipSetItem)

