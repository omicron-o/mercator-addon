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
local data = merc.data
local time = merc.util.time

function merc.AddTooltipPriceData(tooltip, itemid)
    local now = GetServerTime()
    local means, from, ts = data.GetRecentPrice(itemid)
    if not means then
        return
    end
    
    local age = now - ts

    tooltip:AddLine()
    tooltip:AddDoubleLine("Recent mean prices", time.FormatDuration(age))
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

function merc.AddTooltipItemCounts(tooltip, itemid)
    local counts = data.GetItemCountPerCharacter(itemid)
    local total = 0
    for character, count in pairs(counts) do
        total = total + count
    end

    tooltip:AddDoubleLine("All characters", tostring(total), nil, nil, nil, 1, 1, 1)
    for character, count in pairs(counts) do
        tooltip:AddDoubleLine(character, tostring(count), 1, 1, 1, 1, 1, 1)
    end
end

function merc.OnTooltipSetItem(tooltip, data)
    if tooltip == GameTooltip then
        merc.AddTooltipPriceData(tooltip, data.id)
        merc.AddTooltipItemCounts(tooltip, data.id)
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
