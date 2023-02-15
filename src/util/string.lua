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
mercator.util.string = {}
local str = mercator.util.string

-- Given an integer value and a separator character (must be compatible with
-- third argument of string.gsub), format the integer with thousands separator
-- 
-- Courtesy of the lua-users wiki: http://lua-users.org/wiki/FormattingNumbers
function str.FormatInt(value, separator)
    if separator == nil then
        separator = " "
    end
    local formatted = tostring(value)
    while true do  
        formatted, k = string.gsub(formatted, "^(-?%d+)(%d%d%d)", '%1' .. separator .. '%2')
        if (k==0) then
            break
        end
    end
    return formatted
end

-- returns true if s has the given prefix, false otherwise
function str.HasPrefix(s, prefix)
    local n = prefix:len()
    return s:sub(1, n) == prefix
end

-- returns true if s has the given suffix, false otherwise
function str.HasSuffix(s, suffix)
    local n = suffix:len()
    return s:sub(-n, -1) == suffix
end

-- return the given string with the leading and trailing spaces stripped off
function str.Strip(s)
    return s:gsub("^%s+", ""):gsub("%s+$", "")
end

-- Format money
-- copper: the integer number of copper to format.
-- width: the minimum number of characters to output. This may be omitted)
function str.FormatMoney(copper, width)
    local gold = math.floor(copper / 10000)
    local silver = math.floor((copper - gold*10000)/100)
    local copper = copper - gold*10000 - silver*100

    local goldSep   = "|cFFFFD700G|r"
    local silverSep = "|cFFC9C0BBS|r"
    local copperSep = "|cFFDA8A67C|r"
    
    gold = str.FormatInt(gold)
    -- Len of gold + 3 separators + 4 digits + 2 spaces
    local len = string.len(gold) + 9
    local pad = ""
    if len < width then
        pad = string.rep(" ", width - len)
    end
    local fmt = "%s%s%s %02d%s %02d%s"
    return string.format(fmt, pad, gold, goldSep, silver, silverSep, copper, copperSep)
end
