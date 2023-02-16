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

cli.RegisterCommand("commands", {
    description="lists all commands",
    command=(function(...)
        for name, command in pairs(cli.commands) do
            cli.Printf("%-15s %s\n", name, command.description)
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
