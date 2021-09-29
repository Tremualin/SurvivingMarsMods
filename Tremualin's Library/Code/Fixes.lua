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
