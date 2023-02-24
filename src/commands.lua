local merc = select(2, ...)
local cli = merc.cli
local data = merc.data
local FormatMoney = merc.util.string.FormatMoney
local FormatInt = merc.util.string.FormatInt
local ParseDuration = merc.util.time.ParseDuration

cli.RegisterCommand("reload", {
    description="reloads the ui",
    command=(function(...)
        ReloadUI()
    end)
})

cli.RegisterCommand("clear", {
    description="clears the output window",
    command=(function(...)
        cli.outText:SetText("")
    end)
})

cli.RegisterCommand("exit", {
    description="exit the cli",
    command=(function(...)
        cli.Hide()
    end)
})

cli.RegisterCommand("professions", {
    description="show all professions for all characters",
    command=(function(...)
        local chars = data.GetKnownCharacters()
        for _, name in ipairs(chars) do
            local skills = data.GetCharacterSkills(name)
            if next(skills) ~= nil then
                cli.PrintLn(name)
            end
            for skillId, level in pairs(skills) do
                local info = C_TradeSkillUI.GetProfessionInfoBySkillLineID(skillId)
                cli.Printf(" - %3d %s\n", level, info.professionName)
            end
        end
    end)
})

-- Finds the nearest point in the past that is aligned to a boundary
-- the boundary depends on the interval time unit
local function GetAlignedTime(interval)
    local now = GetServerTime()
    local duration, unit = string.match(interval, "^(%d+)([Mwdhms])$")
    
    if unit == "w" then
        local dayOfTheWeek = tonumber(date("%u", now))
        -- Remove some 24 hour periods from now to land on the start of the week
        -- this may be a little jank in some edge cases
        now = now - (dayOfTheWeek - 1)*24*3600
    end
    
    local dt = {
        year    = tonumber(date("%Y", now)),
        month   = tonumber(date("%m", now)),
        day     = tonumber(date("%d", now)),
        hour    = tonumber(date("%H", now)),
        min     = tonumber(date("%M", now)),
        sec     = 0
    }

    if unit == "y" then
        dt.month = 1
        dt.day = 1
        dt.min = 0
        dt.hour = 0
    elseif unit == "M" then
        dt.day = 1
        dt.min = 0
        dt.hour = 0
    elseif unit == "w" or unit == "d" then
        dt.min = 0
        dt.hour = 0
    elseif unit == "h" then
        dt.min = 0
    end
    return time(dt)
end


cli.RegisterCommand("gold-history", {
    description="print gold history",
    command=(function(interval, count)
        local intervalSec
        if interval ~= nil then
            intervalSec = ParseDuration(interval)
        end
        if count == nil then
            count = 1
        else
            count = tonumber(count)
        end
        if intervalSec == nil or count == nil then
            cli.PrintLn("Usage: gold-history <interval> [count]")
            cli.PrintLn("   interval: a duration like 1M (1 month) or 1w (1 week) or 3d (3 days)")
            cli.PrintLn("   count:    how many intervals are printed")
            return
        end
        
        local now = GetServerTime()
        local start = GetAlignedTime(interval)
        local previous = nil
        local timestamps = {}
        for i = count, 0, -1 do
            local ts = start - intervalSec*i
            table.insert(timestamps, ts)
        end
        table.insert(timestamps, now)

        for _, ts in ipairs(timestamps) do
            local copper = data.GetCopperHistory(ts)
            local diff = ""
            if previous ~= nil then
                diff = FormatMoney(copper - previous, 10, true, true)
            end
            local timeStr = date("%Y-%m-%d %H:%M", ts)
            cli.Printf("%-20s %s %s\n", timeStr, FormatMoney(copper, 10, true), diff)
            previous = copper
        end
    end)
})


cli.RegisterCommand("font", {
    description="change the cli font",
    command=(function(font, variant, size)
        if font == nil then
            cli.PrintLn("The following fonts and variants are available:")
            for font, variants in pairs(cli.fontFiles) do
                for variant, _ in pairs(variants) do
                    cli.Printf(" - %s %s\n", font, variant)
                end
            end
            cli.PrintLn("to set a font run: font <font> <variant> [size]")
            return
        end

        if variant == nil then
            cli.PrintLn("|cFFFF0000Error:|r font variant missing")
            cli.PrintLn("to set a font run: font <font> <variant> [size]")
            return
        end

        local fontVars = cli.fontFiles[font]
        if fontVars == nil then
            cli.PrintLn("|cFFFF0000Error:|r Unknown font")
            cli.PrintLn("To see a list of fonts run: font")
            return
        end
        local fontFile = fontVars[variant]
        if fontFile == nil then
            cli.PrintLn("|cFFFF0000Error:|r Unknown variant")
            cli.PrintLn("To see a list of fonts run: font")
            return
        end

        if size ~= nil and tonumber(size) == nil then
            cli.PrintLn("|cFFFF0000Error:|r size must be a number")
            return
        end

        local size = tonumber(size) or data.GetOption("cli.font.size", 14)
        local rval = cli.SetFont(font, variant, size)
        data.SetOption("cli.font.name", font)
        data.SetOption("cli.font.variant", variant)
        data.SetOption("cli.font.size", size)
        if not rval then
            cli.PrintLn("|cFFFF0000Error:|r invalid font file. This is likely bug in the addon.")
        end
    end)
})

cli.RegisterCommand("commands", {
    description="lists all commands",
    command=(function(...)
        for name, command in pairs(cli.commands) do
            cli.Printf("%-15s %s\n", name, command.description)
        end
    end)
})

cli.RegisterCommand("history", {
    description="print the command history",
    command = (function()
        for i=#cli.history, 1, -1 do
            cli.Printf("%2i: %s\n", i, cli.history[i])
        end
    end)
})

local gold = {description="display gold for all characters"}
function gold.command()
    local copperPerChar = data.GetCopperPerCharacter()

    -- Get longest charactername
    local nameWidth = 0
    for character, copper in pairs(copperPerChar) do
        if string.len(character) > nameWidth then
            nameWidth = string.len(character)
        end
    end
    nameWidth = tostring(nameWidth)

    -- Print gold amounts
    local total = 0
    for character, copper in pairs(copperPerChar) do
        total = total + copper
        cli.Printf("%-" .. nameWidth .. "s %s\n", character, FormatMoney(copper, 19))
    end
    cli.Printf("%-" .. nameWidth .. "s %s\n", "total:", FormatMoney(total, 19))
end

cli.RegisterCommand("gold", gold)
