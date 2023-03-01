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
merc.weekly = {}
local weekly = merc.weekly
local data = merc.data
local skillIds = merc.enums.skillIds






weekly.quests = {
    {
        skillRequirement = {[skillIds.DragonInscription] = 25},
        category = "inscription",
        name = "treatise",
        reset = "weekly",
        questIds = {74105},
        needed = 1
    },
    {
        skillRequirement = {[skillIds.DragonInscription] = 25},
        category = "inscription",
        name = "craft quest",
        reset = "weekly",
        questIds = {70558, 70559, 70560, 70561},
        needed = 1
    },
    {
        skillRequirement = {[skillIds.DragonInscription] = 25},
        category = "inscription",
        name = "loot quest",
        reset = "weekly",
        questIds = {66943, 66944, 66945, 72438},
        needed = 1
    },
    {
        skillRequirement = {[skillIds.DragonInscription] = 25},
        category = "inscription",
        name = "order quest",
        reset = "weekly",
        questIds = {70592},
        needed = 1
    },
    {
        skillRequirement = {[skillIds.DragonInscription] = 25},
        category = "inscription",
        name = "dirt",
        reset = "weekly",
        questIds = {66375, 66376},
        needed = 2
    },
    {
        skillRequirement = {[skillIds.DragonInscription] = 25},
        category = "inscription",
        name = "Curious Djaradin Rune",
        reset = "weekly",
        questIds = {70518},
        needed = 1
    },
    {
        skillRequirement = {[skillIds.DragonInscription] = 25},
        category = "inscription",
        name = "Draconic Glamour",
        reset = "weekly",
        questIds = {70519},
        needed = 1
    },
    {
        skillRequirement = {[skillIds.DragonMining] = 25},
        category = "mining",
        name = "treatise",
        reset = "weekly",
        questIds = {74106},
        needed = 1
    },
    {
        skillRequirement = {[skillIds.DragonMining] = 25},
        category = "mining",
        name = "ore turnin",
        reset = "weekly",
        questIds = {70618},
        needed = 1
    },
    {
        skillRequirement = {[skillIds.DragonMining] = 25},
        category = "mining",
        name = "Iridescent Ore",
        reset = "weekly",
        questIds = {72160, 72161, 72162, 72163, 72164, 72165},
        needed = 6
    },
    {
        skillRequirement = {[skillIds.DragonHerbalism] = 25},
        category = "herbalism",
        name = "treatise",
        reset = "weekly",
        questIds = {74107},
        needed = 1
    },
    {
        skillRequirement = {[skillIds.DragonHerbalism] = 25},
        category = "herbalism",
        name = "herb turnin",
        reset = "weekly",
        questIds = {70613, 70614, 70615, 70616},
        needed = 1
    },
    {
        skillRequirement = {[skillIds.DragonHerbalism] = 25},
        category = "herbalism",
        name = "Dreambloom",
        reset = "weekly",
        questIds = {71857, 71858, 71859, 71860, 71861, 71864},
        needed = 6
    },
    {
        skillRequirement = {[skillIds.DragonAlchemy] = 25},
        category = "alchemy",
        name="treatise",
        reset = "weekly",
        questIds = {74108},
        needed = 1
    },
    {
        skillRequirement = {[skillIds.DragonAlchemy] = 25},
        category = "alchemy",
        name="craft quest",
        reset = "weekly",
        questIds = {70530, 70531, 70532, 70533},
        needed = 1
    },
    {
        skillRequirement = {[skillIds.DragonAlchemy] = 25},
        category = "alchemy",
        name="loot quest",
        reset = "weekly",
        questIds = {66937, 66938, 66940, 72427},
        needed = 1
    },
    {
        skillRequirement = {[skillIds.DragonAlchemy] = 25},
        category = "alchemy",
        name="dirt",
        reset = "weekly",
        questIds = {66373, 66374},
        needed = 2
    },
    {
        skillRequirement = {[skillIds.DragonAlchemy] = 25},
        category = "alchemy",
        name="Elementious Splinter",
        reset = "weekly",
        questIds = {70511},
        needed = 1
    },
    {
        skillRequirement = {[skillIds.DragonAlchemy] = 25},
        category = "alchemy",
        name="Decaying Phlegm",
        reset = "weekly",
        questIds = {70504},
        needed = 1
    },
    {
        skillRequirement = {[skillIds.DragonEnchanting] = 25},
        category = "enchanting",
        name="treatise",
        reset = "weekly",
        questIds = {74110},
        needed = 1
    },
    {
        skillRequirement = {[skillIds.DragonEnchanting] = 25},
        category = "enchanting",
        name="craft quest",
        reset = "weekly",
        questIds = {72155, 72172, 72173, 72175},
        needed = 1
    },
    {
        skillRequirement = {[skillIds.DragonEnchanting] = 25},
        category = "enchanting",
        name="loot quest",
        reset = "weekly",
        questIds = {66884, 66900, 66935, 72423},
        needed = 1
    },
    {
        skillRequirement = {[skillIds.DragonEnchanting] = 25},
        category = "enchanting",
        name = "dirt",
        reset = "weekly",
        questIds = {66377, 66378},
        needed = 2,
    },
    {
        skillRequirement = {[skillIds.DragonEnchanting] = 25},
        category = "enchanting",
        name = "Primordial Aether",
        reset = "weekly",
        questIds = {70514},
        needed = 1,
    },
    {
        skillRequirement = {[skillIds.DragonEnchanting] = 25},
        category = "enchanting",
        name = "Elementious Splinter",
        reset = "weekly",
        questIds = {70515},
        needed = 1,
    },
    {
        skillRequirement = {[skillIds.DragonEngineering] = 25},
        category = "engineering",
        name = "treatise",
        reset = "weekly",
        questIds = {74111},
        needed = 1
    },
    {
        skillRequirement = {[skillIds.DragonEngineering] = 25},
        category = "engineering",
        name = "craft quest",
        reset = "weekly",
        questIds = {70539, 70540, 70545, 70557},
        needed = 1
    },
    {
        skillRequirement = {[skillIds.DragonEngineering] = 25},
        category = "engineering",
        name = "loot quest",
        reset = "weekly",
        questIds = {66890, 66891, 66942, 72396},
        needed = 1
    },
    {
        skillRequirement = {[skillIds.DragonEngineering] = 25},
        category = "engineering",
        name = "order quest",
        reset = "weekly",
        questIds = {70591},
        needed = 1
    },
    {
        skillRequirement = {[skillIds.DragonEngineering] = 25},
        category = "engineering",
        name = "dirt",
        reset = "weekly",
        questIds = {66379, 66380},
        needed = 2
    },
    {
        skillRequirement = {[skillIds.DragonEngineering] = 25},
        category = "engineering",
        name = "Keeper's Mark",
        reset = "weekly",
        questIds = {70516},
        needed = 1
    },
    {
        skillRequirement = {[skillIds.DragonEngineering] = 25},
        category = "engineering",
        name = "Infinitely Attachable Pair o' Docks",
        reset = "weekly",
        questIds = {70517},
        needed = 1
    },
    {
        skillRequirement = {[skillIds.DragonJewelcrafting] = 25},
        category = "jewelcrafting",
        name = "treatise",
        reset = "weekly",
        questIds = {74112},
        needed = 1
    },
    {
        skillRequirement = {[skillIds.DragonJewelcrafting] = 25},
        category = "jewelcrafting",
        name = "craft quest",
        reset = "weekly",
        questIds = {70562, 70563, 70564, 70565},
        needed = 1
    },
    {
        skillRequirement = {[skillIds.DragonJewelcrafting] = 25},
        category = "jewelcrafting",
        name = "loot quest",
        reset = "weekly",
        questIds = {66516, 66949, 66950, 72428},
        needed = 1
    },
    {
        skillRequirement = {[skillIds.DragonJewelcrafting] = 25},
        category = "jewelcrafting",
        name = "order quest",
        reset = "weekly",
        questIds = {70593},
        needed = 1
    },
    {
        skillRequirement = {[skillIds.DragonJewelcrafting] = 25},
        category = "jewelcrafting",
        name = "dirt",
        reset = "weekly",
        questIds = {66388, 66389},
        needed = 2
    },
    {
        skillRequirement = {[skillIds.DragonJewelcrafting] = 25},
        category = "jewelcrafting",
        name = "Incandescent Curio",
        reset = "weekly",
        questIds = {70520},
        needed = 1
    },
    {
        skillRequirement = {[skillIds.DragonJewelcrafting] = 25},
        category = "jewelcrafting",
        name = "Elegantly Engraved Embellishment",
        reset = "weekly",
        questIds = {70521},
        needed = 1
    },
    {
        skillRequirement = {[skillIds.DragonLeatherworking] = 25},
        category = "leatherworking",
        name = "treatise",
        reset = "weekly",
        questIds = {74113},
        needed = 1
    },
    {
        skillRequirement = {[skillIds.DragonLeatherworking] = 25},
        category = "leatherworking",
        name = "craft quest",
        reset = "weekly",
        questIds = {70567, 70568, 70569, 70571},
        needed = 1
    },
    {
        skillRequirement = {[skillIds.DragonLeatherworking] = 25},
        category = "leatherworking",
        name = "loot quest",
        reset = "weekly",
        questIds = {66363, 66364, 66951, 72407},
        needed = 1
    },
    {
        skillRequirement = {[skillIds.DragonLeatherworking] = 25},
        category = "leatherworking",
        name = "order quest",
        reset = "weekly",
        questIds = {70594},
        needed = 1
    },
    {
        skillRequirement = {[skillIds.DragonLeatherworking] = 25},
        category = "leatherworking",
        name = "dirt",
        reset = "weekly",
        questIds = {66384, 66385},
        needed = 2
    },
    {
        skillRequirement = {[skillIds.DragonLeatherworking] = 25},
        category = "leatherworking",
        name = "Ossified Hide",
        reset = "weekly",
        questIds = {70522},
        needed = 1
    },
    {
        skillRequirement = {[skillIds.DragonLeatherworking] = 25},
        category = "leatherworking",
        name = "Exceedingly Soft Skin",
        reset = "weekly",
        questIds = {70523},
        needed = 1
    },
    {
        skillRequirement = {[skillIds.DragonSkinning] = 25},
        category = "skinning",
        name = "treatise",
        reset = "weekly",
        questIds = {74114},
        needed = 1
    },
    {
        skillRequirement = {[skillIds.DragonSkinning] = 25},
        category = "skinning",
        name = "skin turnin",
        reset = "weekly",
        questIds = {70619, 70620, 72158, 72159},
        needed = 1
    },
    {
        skillRequirement = {[skillIds.DragonSkinning] = 25},
        category = "skinning",
        name = "treatise",
        reset = "weekly",
        questIds = {70381, 70384, 70385, 70386, 70389},
        needed = 6
    },
    {
        skillRequirement = {[skillIds.DragonTailoring] = 25},
        category = "tailoring",
        name = "treatise",
        reset = "weekly",
        questIds = {74115},
        needed = 1
    },
    {
        skillRequirement = {[skillIds.DragonTailoring] = 25},
        category = "tailoring",
        name = "craft quest",
        reset = "weekly",
        questIds = {70572, 70582, 70586, 70587},
        needed = 1
    },
    {
        skillRequirement = {[skillIds.DragonTailoring] = 25},
        category = "tailoring",
        name = "loot quest",
        reset = "weekly",
        questIds = {66899, 66952, 66953, 72410},
        needed = 1
    },
    {
        skillRequirement = {[skillIds.DragonTailoring] = 25},
        category = "tailoring",
        name = "order quest",
        reset = "weekly",
        questIds = {70595},
        needed = 1
    },
    {
        skillRequirement = {[skillIds.DragonTailoring] = 25},
        category = "tailoring",
        name = "dirt",
        reset = "weekly",
        questIds = {66386, 66387},
        needed = 2
    },
    {
        skillRequirement = {[skillIds.DragonTailoring] = 25},
        category = "tailoring",
        name = "Ohn'arhan Weave",
        reset = "weekly",
        questIds = {70524},
        needed = 1
    },
    {
        skillRequirement = {[skillIds.DragonTailoring] = 25},
        category = "tailoring",
        name = "Studidly Effective Stitchery",
        reset = "weekly",
        questIds = {70525},
        needed = 1
    },
    {
        skillRequirement = {[skillIds.DragonBlacksmithing] = 25},
        category = "blacksmithing",
        name = "treatise",
        reset = "weekly",
        questIds = {74109},
        needed = 1
    },
    {
        skillRequirement = {[skillIds.DragonBlacksmithing] = 25},
        category = "blacksmithing",
        name = "craft quest",
        reset = "weekly",
        questIds = {70211, 70233, 70234, 70235},
        needed = 1
    },
    {
        skillRequirement = {[skillIds.DragonBlacksmithing] = 25},
        category = "blacksmithing",
        name = "loot quest",
        reset = "weekly",
        questIds = {66517, 66897, 66941, 72398},
        needed = 1
    },
    {
        skillRequirement = {[skillIds.DragonBlacksmithing] = 25},
        category = "blacksmithing",
        name = "order quest",
        reset = "weekly",
        questIds = {70589},
        needed = 1
    },
    {
        skillRequirement = {[skillIds.DragonBlacksmithing] = 25},
        category = "blacksmithing",
        name = "dirt",
        reset = "weekly",
        questIds = {66381, 66382},
        needed = 2
    },
    {
        skillRequirement = {[skillIds.DragonBlacksmithing] = 25},
        category = "blacksmithing",
        name = "Primeval Earth Fragment",
        reset = "weekly",
        questIds = {70512},
        needed = 1
    },
    {
        skillRequirement = {[skillIds.DragonBlacksmithing] = 25},
        category = "blacksmithing",
        name = "Molten Globule",
        reset = "weekly",
        questIds = {70513},
        needed = 1
    }
}

function weekly.ShouldComplete(questInfo, character)
    if questInfo.skillRequirement ~= nil then 
        for skillId, level in pairs(questInfo.skillRequirement) do
            if data.GetCharacterSkillById(skillId, character) < level then
                return false
            end
        end
    end
    return true
end

function weekly.CheckStatus(questInfo, character)
    local count = 0
    for _, questId in ipairs(questInfo.questIds) do
        if data.IsCharacterQuestCompleted(questId, character) then
            count = count + 1
        end
        if count == questInfo.needed then
            break
        end
    end
    return count, questInfo.needed
end

-- Helper function and variable for DebugQuestIds
local allCompleted = nil
local function IsNewlyCompletedQuest(id)
    for _, oldId in ipairs(allCompleted) do
        if oldId == id then
            return false
        end
    end
    return true
end

-- fetch all quest ids your character completed and prints new ones.
-- Time complexity is O(n^2) with n  the total number of quests a character has
-- (thousands)
local function DebugQuestIds()
    if allCompleted == nil then
        allCompleted = C_QuestLog.GetAllCompletedQuestIDs()
        merc.cli.Debugf("DebugQuestIds(): Initial quest list %d quests\n", #allCompleted)
        return
    end
    
    -- Hehe O(n^2) for kinda big n, not good =)
    local newCompleted = C_QuestLog.GetAllCompletedQuestIDs()
    for _, newId in ipairs(newCompleted) do
        if IsNewlyCompletedQuest(newId) then
            merc.cli.Debugf("DebugQuestIds(): |cFF00FF00!! newly completed quest %d|r\n", newId)
        end
    end
    allCompleted = newCompleted
end

-- This only saves completed quests and doesn't use any of the other structure
-- from above yet.
function weekly.CheckWeeklyQuests()
    --DebugQuestIds()
    for _, info in ipairs(weekly.quests) do
        for _, questId in ipairs(info.questIds) do
            local isComplete = C_QuestLog.IsQuestFlaggedCompleted(questId)
            if isComplete then
                data.SetCharacterQuestCompleted(questId, info.reset)
            end
        end
    end
end
merc.SetEventHandler("BAG_UPDATE_DELAYED", weekly.CheckWeeklyQuests)
merc.SetEventHandler("QUEST_TURNED_IN", weekly.CheckWeeklyQuests)
