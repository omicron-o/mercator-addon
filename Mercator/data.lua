local merc = select(2, ...)


-- Addon data structure:
-- =====================
-- {
--      version: number (mostly unused for now?)
--      characters: table (see below)
--      prices: table (see below)
-- }
--
--
-- Characters data structure:
-- ==========================
-- {} empty for now
--
-- Prices data structure:
-- ======================
-- {
--      recent: {
--          itemid(str): {
--              time: number -- server time unix timestamp
--              from: string -- The character that gathered this data
--              means: table (see below)
--          }
--      },
--      history: table (see below)
-- }
--
-- Historical price data structure:
-- ================================
-- This is very similar to the recent data except that itemid is a sequence
-- (table) that contains the individual entries (also table). Each sequence
-- contains at most 288 entries (one every 5 minutes) bar some weirdness on DST
-- changes or leap seconds that I really don't want to worry about.
--
-- {
--      date(str): {
--          itemid(str): sequence {
--              time: number -- server time unix timestamp
--              from: string -- character that gathered this data
--              means: table (see below)
--          }
--      }
--  }
--
-- Some examples:
--     prices.recent["1234"]  is a table containing time, from and means for the
--     item with itemid 1234
--
--     prices.history["2023-02-01"]["1234"] is a table/sequence containing
--     anywhere from 0 to 96 table entries each containing time, from and means.
--
--
-- Means data structure:
-- =====================
-- means table is a quantity(str) to mean_unit_price(number) map. Generally it
-- will contain mean values for 1, 10, 100, 500, 1000, 5000 and 10000 quantity.
-- Some of these may be nil.

function merc.CreateDB()
    return {version = 1, characters={}}
end

-- Add a new character to the stored data
function merc.InitCharacterDB(name)
    if merc.db.characters[name] == nil then
        merc.db.characters[name] = {
            version = 1,
            characters={},
            prices={
                recent={},
                history={}
            }
        }
    end
end

-- Apply data updates
function merc.UpdateDB()
    if merc.db["characters"] == nil then
        merc.db.characters = {}
    end
    if merc.db["prices"] == nil then
        merc.db.prices = {
            recent={},
            history={}
        }
    end

    if merc.db.prices.recent == nil then
        merc.db.prices.recent = {}
    end
    if merc.db.prices.history == nil then
        merc.db.prices.history = {}
    end

    -- Temporary
    if merc.db.prices.historical ~= nil then
        merc.db.prices.historical = nil
    end
end


-- Adds newly updated means prices to the recent price list for
-- the given itemid.
--
-- If time is nil the current time is used.
-- If from is nil the current character and server are used.
--
-- This function will take (read only) ownership of the passed means table and
-- it should never be modified again.
function merc.UpdateRecentPrice(itemid, means, time, from)
    if from == nil then
        local name, server = UnitFullName("player")
        from = string.format("%s-%s", name, server)
    end

    if time == nil then
        time = GetServerTime()
    end
    
    itemid = tostring(itemid)
    local recent = merc.db.prices.recent
    if recent[itemid] == nil then
        recent[itemid] = {}
    end
    recent[itemid].time = time
    recent[itemid].from = from
    recent[itemid].means = means
end

-- Returns means(table), from(str), time(number)
function merc.GetRecentPrice(itemid)
    local data = merc.db.prices.recent[tostring(itemid)]
    if data then
        return data.means, data.from, data.time
    else
        return nil
    end
end

-- Adds a new entry into the historic data record. Entries can only be added
-- every 5 minutes. If a recent entry already exists the new one is ignored.
--
-- If time is nil the current time is used.
-- If from is nil the current character and server are used.
--
-- This function will take (read only) ownership of the passed means table and
-- it should never be modified again.
--
-- QUIRK: The 5 minute boundary actually breaks down on date changes but it's not
-- important. If you add an entry at 23:59 you can add another one at 00:01
-- since it'll be in an entirely new table and it won't check that.
--
-- QUIRK: When DST changes backwards you won't be able to add entries for 1
-- hour.
function merc.AddPriceHistory(itemid, means, time, from)
    if from == nil then
        local name, server = UnitFullName("player")
        from = string.format("%s-%s", name, server)
    end

    if time == nil then
        time = GetServerTime()
    end

    -- Ensure the date table for the current day and the current itemid exists
    local date = date("%Y-%m-%d", time)
    if merc.db.prices.history[date] == nil then
        merc.db.prices.history[date] = {}
    end
    local today = merc.db.prices.history[date]
    if today[tostring(itemid)] == nil then
        today[tostring(itemid)] = {}
    end
    local item = today[tostring(itemid)]

    -- Check if the previous data is old enough to append new data to
    local latest = item[#item]
    if latest ~= nil and (time - latest.time) < 300 then
        return
    end

    table.insert(item, {time=time, from=from, means=means})
end
