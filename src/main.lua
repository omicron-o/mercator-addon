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
merc.events = {} -- event (str) to list of handlers
merc.db = nil

function THT()
    return th
end

-- Adds a given function to the event handler list for a given event
-- This will later in the addon 
function merc.SetEventHandler(event, fn)
    if merc.events[event] == nil then
        merc.events[event] = {}
    end
    table.insert(merc.events[event], fn)
end

-- The main handler receives basically every single event we want to listen to
-- and dispatches them to more appropriate handlers
function merc.MainEventHandler(frame, event, ...)
    local handlers = merc.events[event]
    if handlers ~= nil and next(handlers) ~= nil then
        for i, handler in ipairs(handlers) do
            handler(...)
        end
    else
        error("Unhandled event", event)
    end
end

-- Create the event frame and register all desired events
function merc.SetupEvents()
    local frame = CreateFrame("Frame")
    for name, _ in pairs(merc.events) do
        if string.sub(name, 1, string.len("MERCATOR")) ~= "MERCATOR" then
            frame:RegisterEvent(name)
        end
    end
    frame:SetScript("OnEvent", merc.MainEventHandler)
end

function merc.OnAddonLoaded(name)
    if name ~= AddonName then
        return
    end
    if MercatorDB == nil then
        MercatorDB = merc.data.CreateDB()
    end
    merc.db = MercatorDB
    merc.data.UpdateDB()
    print("Loaded", AddonName)
end
merc.SetEventHandler("ADDON_LOADED", merc.OnAddonLoaded)

-- Fire custom event MERCATOR_FULLY_LOADED. This event is fired when the player
-- enters the world for the first time after logging in or reloading UI.
function merc.FireFullyLoadedEvent(initialLogin, reloadUI)
    if initialLogin or reloadUI then
        merc.MainEventHandler(nil, "MERCATOR_FULLY_LOADED")
    end
end
merc.SetEventHandler("PLAYER_ENTERING_WORLD", merc.FireFullyLoadedEvent)

function merc.SlashCommand(args)
    if args == "scan" then
        merc.AuctionScanCommand()
    else
        print("Mercator: unknown command")
    end
end

function merc.SetupSlashCommands()
    _G["SLASH_MERCATOR1"] = "/mercator"
    _G["SLASH_MERCATOR2"] = "/merc"
    SlashCmdList["MERCATOR"] = merc.SlashCommand
end
