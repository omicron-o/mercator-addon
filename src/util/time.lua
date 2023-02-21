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
local mercator = select(2, ...)
if mercator.util == nil then
    mercator.util = {}
end
mercator.util.time = {}
local time = mercator.util.time

--[[
local short_durations = {"s", "m", "h", "d", "w", "M", "Y"}
local long_durations = {"seconds", "minutes", "hours", "days", "weeks", "months", "years"}

function mercator.FormatDuration(t)
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

function time.FormatDuration(t)
    if t < 60 then
        return "now"
    elseif t < 3600 then
        return string.format("%dm ago", math.floor(t / 60))
    elseif t < 86400 then
        return string.format("%dh ago", math.floor(t / 3600))
    elseif t < 604800 then
        return string.format("%dd ago", math.floor(t / 86400))
    else
        return "long ago"
    end
end


-- Take a string like "1M" or "3w" or "30m" and turn it into a number of
-- seconds.
-- Allowed suffixes are:
-- M    Month  (60*60*24*30 seconds)
-- w    week   (60*60*24*7  seconds)
-- d    day    (60*60*24    seconds)
-- h    hour   (60*60       seconds)
-- h    minute (60          seconds)
-- s    second (1           seconds)
function time.ParseDuration(s)
    -- TODO: probably allow complex durations such as 1w4d6h
    local duration, unit = string.match(s, "^(%d+)([Mwdhms])$")
    if duration == nil or unit == nil then
        return nil
    end
    duration = tonumber(duration)
    if unit == "M" then
        -- all months are 30 days
        duration = duration * 3600 * 24 * 30
    elseif unit == "w" then
        duration = duration * 3600 * 24 * 7
    elseif unit == "d" then
        duration = duration * 3600 * 24
    elseif unit == "h" then
        duration = duration * 3600
    elseif unit == "m" then
        duration = duration * 60
    elseif unit == "s" then
        -- duration = duration
    else
        return nil
    end
    return duration
end
