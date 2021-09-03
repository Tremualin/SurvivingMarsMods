-- The original code ignores modded traits daily functions
local function FixTraitsWithDailyUpdates()
    TraitsWithDailyUpdates = TraitsWithDailyUpdates or {}
    local alreadyDefinedTraits = {}
    for _, trait_id in ipairs(TraitsWithDailyUpdates) do
        alreadyDefinedTraits[trait_id] = true
    end
    ForEachPreset(ModItemTraitPreset, function(trait, group_list)
        if trait.daily_update_func and not alreadyDefinedTraits[trait.id] then
            TraitsWithDailyUpdates[1 + #TraitsWithDailyUpdates] = trait.id
        end
    end)
end
OnMsg.CityStart = FixTraitsWithDailyUpdates
OnMsg.LoadGame = FixTraitsWithDailyUpdates
