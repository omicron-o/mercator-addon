local merc = select(2, ...)
merc.cli = {}
local cli = merc.cli
local data = merc.data
local Strip = merc.util.string.Strip
local HasPrefix = merc.util.string.HasPrefix

-- Holds all commands that can be executed. Index is the command (string) and
-- the data is a table that contains the command. The table has the following:
--[[
{
    description="Short command description",
    command=function(...) end,      -- Function that takes command arguments
}

-- TODO: 
--  * Commands should have some way to assist in tab completing
--  * Some kind of piping of data from one command to another
--  * Some way for commands that have longer runtimes to lock cli until they are
--    done running
]]--

cli.commands = {}
local commands = cli.commands

function cli.RegisterCommand(name, command)
    if commands[name] ~= nil then
        error("Command already registered")
    end
    commands[name] = command
end

function cli.CreateUI()
    cli.frame = CreateFrame("Frame", "MercatorCLI", UIParent, "BackdropTemplate")
    cli.frame.backdropInfo = {
        bgFile = "Interface\\Tooltips\\UI-Tooltip-Background",
        edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border",
        tile = true,
        tileEdge = true,
        tileSize = 8,
        edgeSize = 8,
        insets = { left = 1, right = 1, top = 1, bottom = 1 },
    }

    -- Output wrap
    cli.frame:ApplyBackdrop()
    cli.frame:SetBackdropColor(0, 0, 0, 1)
    cli.frame:SetSize(640, 480)
    cli.frame:SetPoint("TOPRIGHT")
    cli.frame:SetFrameStrata("DIALOG")
    cli.frame:Hide()
    cli.frame:SetScript("OnShow", function(self)
        cli.OnShow()
    end)

    local scrollFrame = CreateFrame("ScrollFrame", nil, cli.frame, "UIPanelScrollFrameTemplate")
    scrollFrame:SetSize(640-16-20, 480-16)
    scrollFrame:SetPoint("TOPLEFT", cli.frame, "TOPLEFT", 8, -8)
    cli.scroll = scrollFrame
    
    cli.outText = CreateFrame("EditBox", nil, scrollFrame)
    cli.outText:SetFontObject(ChatFontNormal)
    cli.outText:SetWidth(640-16-20)
    cli.outText:SetMultiLine(true)
    cli.outText:SetAutoFocus(false)
    cli.outText:SetFont("Interface\\AddOns\\Mercator\\media\\InconsolataGo-Bold.ttf", 14, "OUTLINE")
    scrollFrame:SetScrollChild(cli.outText)


    -- Input Wrap
    local inputWrap = CreateFrame("Frame", nil, cli.frame, "BackdropTemplate")
    inputWrap.backdropInfo = cli.frame.backdropInfo
    inputWrap:ApplyBackdrop()
    inputWrap:SetBackdropColor(0, 0, 0, 1)
    inputWrap:SetPoint("TOPLEFT", cli.frame, "BOTTOMLEFT", 0, 0)
    inputWrap:SetPoint("TOPRIGHT", cli.frame, "BOTTOMRIGHT", 0, 0)
    inputWrap:SetHeight(24)

    -- input Text
    cli.inText = CreateFrame("EditBox", nil, inputWrap)
    cli.inText:SetFontObject(ChatFontNormal)
    cli.inText:SetPoint("TOPLEFT", inputWrap, "TOPLEFT", 8, -8)
    cli.inText:SetPoint("BOTTOMRIGHT", inputWrap, "BOTTOMRIGHT", -8, 8)
    cli.inText:SetMultiLine(false)
    cli.inText:SetFont("Interface\\AddOns\\Mercator\\media\\InconsolataGo-Bold.ttf", 14, "OUTLINE")
    cli.inText:SetAutoFocus(false)

    cli.inText:SetScript("OnEscapePressed", function(self) 
        cli.Hide()
    end)
    
    cli.inText:SetScript("OnEnterPressed", function(self)
        cli.HandleCLIEnter()
    end)
end
merc.SetEventHandler("MERCATOR_LOADING", cli.CreateUI)

function cli.HandleCLIEnter()
    local input = cli.inText:GetText()
    cli.PrintLn("|cFF009900>|r", input)
    cli.inText:SetText("") 
    input = Strip(input)
    if input ~= "" and not HasPrefix(input, '#') then
        cli.HandleCommand(input)
    end
end

function cli.PrintLn(...)
    local n = select('#', ...)
    if n > 0 then
        cli.outText:Insert(tostring(select(1, ...)))
        for i = 2, n do
            cli.outText:Insert(" ")
            cli.outText:Insert(tostring(select(2, ...)))
        end
    end
    cli.outText:Insert("\n")
end

function cli.Printf(fmt, ...)
    local s = string.format(fmt, ...)
    cli.outText:Insert(s)
end

function cli.AddLine(line)
    cli.outText(line)
end

function cli.SplitCommand(input)
    local command = nil
    local arguments = {}
    -- TODO: we probably want smarter splitting
    for word in input:gmatch("%S+") do
        if command then
            arguments.insert(word)
        else
            command = word
        end
    end
    return command, arguments
end

function cli.HandleCommand(input)
    local command, arguments = cli.SplitCommand(input)
    if commands[command] ~= nil then
        commands[command].command(unpack(arguments))
    else
        cli.outText:Insert("|cFFFF0000Error:|r unknown command\n")
    end
    -- Even next frame seems to not scroll it properly, this is hacky but it
    -- works for now (possibly this only happens when textures are involved)
    C_Timer.After(0.05, function()
        cli.scroll:SetVerticalScroll(cli.scroll:GetVerticalScrollRange())
    end)
end

function cli.OnShow()
    cli.inText:SetFocus()
end

function cli.Hide()
    cli.frame:Hide()
end

function cli.Show()
    cli.frame:Show()
end

function cli.ToggleShow()
    cli.frame:SetShown(not cli.frame:IsShown())
end
