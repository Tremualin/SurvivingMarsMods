function ForestationPlant:GetTerraformingBoostSol()
    -- Add all of the terraforming progress so far to calculate the boost
    local terraforming_progress_boost = GetTerraformParam("Atmosphere") +
                                            GetTerraformParam("Temperature") +
                                            GetTerraformParam("Water") +
                                            GetTerraformParam("Vegetation")
    -- Multiply the original boost by the progress boost
    -- Divide by const.TerraformingScale to get the percentage, then divide by 100 to get the actual boost number
    local weightedBoost = MulDivRound(self.terraforming_boost_sol,
                                      terraforming_progress_boost,
                                      100 * const.TerraformingScale)
    return self.terraforming_boost_sol + weightedBoost
end

-- A vegetation of 30% is now necessary to stop dust storms
function OnMsg.ClassesPostprocess()
    for _, preset in ipairs(Presets.TerraformingParam.Default or empty_table) do
        if preset.id == "Vegetation" then
            local newItem = PlaceObj("ThresholdItem", {
                "Id", "DustStormStop", "Threshold", 30, "Hysteresis", 2
            })
            table.insert_unique(preset.Threshold, newItem)
        end
    end
end

function GetVegetationBoom()
    -- Vegetation boosts itself: (vegetation%)^2, i.e: 10% would boost by 0.01% per sol
    local vegetationSquared = MulDivRound(GetTerraformParam("Vegetation"),
                                          GetTerraformParam("Vegetation"),
                                          100 * 100 * const.TerraformingScale)

    -- Then Water, Temperature and Atmosphere boost it even further; 50% atmosphere, water and temperature would boost it by +150%
    local terraforming_progress_boost = GetTerraformParam("Atmosphere") +
                                            GetTerraformParam("Temperature") +
                                            GetTerraformParam("Water")
    local weightedBoost = MulDivRound(vegetationSquared,
                                      terraforming_progress_boost,
                                      100 * const.TerraformingScale)
    return vegetationSquared + weightedBoost
end

-- Passively boost vegetation
GlobalVar("VegetationBoomThread", false)
function OnMsg.LoadGame()
    if IsValidThread(VegetationBoomThread) then
        DeleteThread(VegetationBoomThread)
    end
    VegetationBoomThread = (CreateGameTimeThread(
                               function()
            local sleep = const.HourDuration / 5
            local sol = const.DayDuration
            while true do
                Sleep(sleep)
                local boom = (MulDivRound(GetVegetationBoom(), sleep, sol))
                if 0 < boom then
                    ChangeTerraformParam("Vegetation", boom)
                    Msg("VegetationBoom", boom)
                end
            end
        end))
end

-- Show the passive vegetation boost in the UI
function OnMsg.ClassesPostprocess()
    for _, preset in ipairs(Presets.TerraformingParam.Default or empty_table) do
        if preset.id == "Vegetation" then
            if not preset.Factors then preset.Factors = {} end
            local newFactor = PlaceObj("TerraformingFactorItem", {
                "Id", "VegetationBoom", "display_name", "Wild vegetation boom",
                "units", "PerSol", "GetFactorValue",
                function(self) return GetVegetationBoom() end
            })
            table.insert_unique(preset.Factors, newFactor)
        end
    end
end

