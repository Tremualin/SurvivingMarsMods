local mod_DustStorms_VegetationRequired

-- fired when settings are changed/init
local function ModOptions()
    mod_DustStorms_VegetationRequired = CurrentModOptions:GetProperty("DustStorms_VegetationRequired")
end

-- load default/saved settings
OnMsg.ModsReloaded = ModOptions

-- fired when option is changed
function OnMsg.ApplyModOptions(id)
    if id == CurrentModId then
        ModOptions()
    end
    dustStormsVegetationRequired()
end

-- A vegetation of 30% is now necessary to stop dust storms
-- Also adds 30% to breathable atmosphere; we don't want dust storms on our open domes
function dustStormsVegetationRequired()
    for _, preset in ipairs(Presets.TerraformingParam.Default or empty_table) do
        if preset.id == "Vegetation" then
            local dustStomStopDefined = false
            -- change DustStormStop requirements
            for key, threshold in ipairs(preset.Threshold or empty_table) do
                if threshold.Id == "DustStormStop" then 
                    dustStomStopDefined = true
                    if not mod_DustStorms_VegetationRequired then
                        preset.Threshold[key] = nil
                    end
                    break
                end
            end
            if mod_DustStorms_VegetationRequired and not dustStomStopDefined then
                local newItem = PlaceObj("ThresholdItem", {
                    "Id", "DustStormStop", "Threshold", 30, "Hysteresis", 2
                })
                table.insert(preset.Threshold, newItem)
            end

            local atmosphereBreathableDefined = false
            -- change AtmosphereBreathable requirements
            for key, threshold in ipairs(preset.Threshold or empty_table) do
                if threshold.Id == "AtmosphereBreathable" then 
                    atmosphereBreathableDefined = true
                    if not mod_DustStorms_VegetationRequired then
                        preset.Threshold[key] = nil
                    end
                    break
                end
            end
            if mod_DustStorms_VegetationRequired and not atmosphereBreathableDefined then
                local newItem = PlaceObj("ThresholdItem", {
                    "Id", "AtmosphereBreathable", "Threshold", 30, "Hysteresis", 2
                })
                table.insert(preset.Threshold, newItem)
            end
            break
        end
    end
end

function OnMsg.ClassesPostprocess()
    dustStormsVegetationRequired()
end

function Tremualin_ForestationPlant_GetTerraformingBoostSol(self)
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
            local alreadyDefined = false
            for _, factor in ipairs(preset.Factors or empty_table) do
                if factor.Id == "VegetationBoom" then 
                    alreadyDefined = true 
                    break
                end
            end
            if not alreadyDefined then
                local newFactor = PlaceObj("TerraformingFactorItem", {
                    "Id", "VegetationBoom", "display_name", "Wild vegetation boom",
                    "units", "PerSol", "GetFactorValue",
                    function(self) return GetVegetationBoom() end
                })
                table.insert(preset.Factors, newFactor)
            end
            break
        end
    end
end

function OnMsg.ClassesPostprocess()
    ForestationPlant.GetTerraformingBoostSol = function (self)
        -- Plays nice with Forestation Goes to 11
        return Tremualin_ForestationPlant_GetTerraformingBoostSol(self)
    end
end
