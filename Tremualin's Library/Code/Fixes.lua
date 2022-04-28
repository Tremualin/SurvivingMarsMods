-- The original code ignores modded traits daily functions
local function FixTraitsWithDailyUpdates()
    TraitsWithDailyUpdates = TraitsWithDailyUpdates or {}
    ForEachPreset(ModItemTraitPreset, function(trait, group_list)
        if trait.daily_update_func then
            table.insert_unique(TraitsWithDailyUpdates, trait.id)
        else
            table.remove_entry(TraitsWithDailyUpdates, trait.id)
        end
    end)
end
OnMsg.CityStart = FixTraitsWithDailyUpdates
OnMsg.LoadGame = FixTraitsWithDailyUpdates
OnMsg.ModsReloaded = FixTraitsWithDailyUpdates

local function FixColonistsWithoutAWorkplaceAppearingInWorkplaces()
    for _, city in ipairs(Cities) do
        local domes = city.labels.Dome or empty_table
        for j = #domes, 1, -1 do
            local dome = domes[j]
            for _, workplace in pairs(dome.labels.Workplace) do
                if workplace.workers then
                    for shift = 1, 3 do
                        local workers = {}
                        for _, worker in pairs(workplace.workers[shift]) do
                            if worker.workplace == workplace then
                                table.insert(workers, worker)
                            end
                        end
                        workplace.workers[shift] = workers
                    end
                end
            end
        end
    end
end
OnMsg.LoadGame = FixColonistsWithoutAWorkplaceAppearingInWorkplaces

local function FixSchoolAndSanatoriumTraits()
    ForEachPreset(ModItemTraitPreset, function(trait, category)
        if g_SchoolTraits and trait.school_trait then
            table.insert_unique(g_SchoolTraits, trait.id)
        end
        if g_SanatoriumTraits and trait.sanatorium_trait then
            table.insert_unique(g_SanatoriumTraits, trait.id)
        end
    end)
    if g_SchoolTraits then table.sort(g_SchoolTraits) end
    if g_SanatoriumTraits then table.sort(g_SanatoriumTraits) end
end
OnMsg.LoadGame = FixSchoolAndSanatoriumTraits
OnMsg.ModsReloaded = FixSchoolAndSanatoriumTraits

local function FixDisasterGameRules()
    if IsGameRuleActive("WinterIsComing") then
        ActiveMaps[MainMapID].MapSettings_ColdWave = "ColdWave_GameRule"
    end

    if IsGameRuleActive("Armageddon") then
        ActiveMaps[MainMapID].MapSettings_Meteor = "Meteor_GameRule"
    end

    if IsGameRuleActive("DustInTheWind") then
        ActiveMaps[MainMapID].MapSettings_DustStorm = "DustStorm_GameRule"
    end

    if IsGameRuleActive("Twister") then
        ActiveMaps[MainMapID].MapSettings_DustDevils = "DustDevils_GameRule"
    end
end
OnMsg.CityStart = FixDisasterGameRules
OnMsg.LoadGame = FixDisasterGameRules

local function FixSpawnColonistDescription()
    SpawnColonist.Description = Untranslated("Receive <Count> <opt(display_name('TraitPresets',Trait1), '', ' ')><opt(display_name('TraitPresets',Trait2), '', ' ')><opt(display_name('TraitPresets',Trait3), '', ' ')><opt(display_name('TraitPresets',Specialization), '', ' ')><opt(display_name('TraitPresets',Age), '', ' ')>")
end
OnMsg.ClassesPostprocess = FixSpawnColonistDescription

function FixNilAddTrait()
    -- Prevents nil traits from causing errors
    local Tremualin_Orig_Colonist_AddTrait = Colonist.AddTrait
    function Colonist:AddTrait(trait_id, init)
        if trait_id then
            return Tremualin_Orig_Colonist_AddTrait(self, trait_id, init)
        end -- if trait_id
    end
end -- function FixAddNilTrait

OnMsg.ClassesGenerate = FixNilAddTrait()

local Orig_Tremualin_Colonist_DetachFromRealm = Colonist.DetachFromRealm
function Colonist:DetachFromRealm()
    Orig_Tremualin_Colonist_DetachFromRealm(self)
    Unit.DetachFromRealm(self)
end
