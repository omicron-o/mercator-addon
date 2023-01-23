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
        frame:RegisterEvent(name)
    end
    frame:SetScript("OnEvent", merc.MainEventHandler)
end

function merc.OnAddonLoaded(name)
    if name ~= AddonName then
        return
    end
    if MercatorDB == nil then
        MercatorDB = merc.CreateDB()
    end
    merc.db = MercatorDB
    merc.UpdateDB()
    print("Loaded", AddonName)
end
merc.SetEventHandler("ADDON_LOADED", merc.OnAddonLoaded)

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
