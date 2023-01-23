local merc = select(2, ...)

--[[
local short_durations = {"s", "m", "h", "d", "w", "M", "Y"}
local long_durations = {"seconds", "minutes", "hours", "days", "weeks", "months", "years"}

function merc.FormatDuration(t)
    if t < 60 then
        return string.format("%ds", math.floor(t / 60))
    elseif t < 3600 then
        return string.format("%dm", math.floor(t / 60))
    elseif t < 86400 then
        return string.format("%dh", math.floor(t / 3600))
    elseif t < 604800 then
        return string.format("%dh", math.floor(t / 86400))
    elseif t < 2592000 then
        return string.format("%dh", math.floor(t / 604800))
    else
        return "unreasonably long"
    end
end
]]--

function merc.FormatDuration(t)
    if t < 60 then
        return "now"
    elseif t < 3600 then
        return string.format("%dm ago", math.floor(t / 60))
    elseif t < 86400 then
        return string.format("%dh ago", math.floor(t / 3600))
    elseif t < 604800 then
        return string.format("%dh ago", math.floor(t / 86400))
    else
        return "long ago"
    end
end
