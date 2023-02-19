local merc = select(2, ...)
local cli = merc.cli
local data = merc.data
local FormatMoney = merc.util.string.FormatMoney

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
