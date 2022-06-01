-- This entire file makes Vegetation required for Dust Storms to stop
-- 0% Atmosphere is required for Dust Storms to Stop.
local function ChangeDustStormStopForAtmosphere(preset)
    for key, threshold in ipairs(preset.Threshold or empty_table) do
        if threshold.Id == "DustStormStop" then
            threshold.Threshold = 0
            break
        end
    end
end

-- 30% Vegetation stops Dust Storms
local function ChangeDustStormStopForVegetation(preset)
    local dustStormStopDefined = false
    for key, threshold in ipairs(preset.Threshold or empty_table) do
        if threshold.Id == "DustStormStop" then
            dustStormStopDefined = true
            threshold.Threshold = 30
            break
        end
    end
    if not dustStormStopDefined then
        local newItem = PlaceObj("ThresholdItem", {
            "Id", "DustStormStop", "Threshold", 30, "Hysteresis", 2
        })
        table.insert(preset.Threshold, newItem)
    end
end

-- 50% Vegetation is required for Open Domes
local function ChangeAtmosphereBreathableForVegetation(preset)
    local atmosphereBreathableDefined = false
    for key, threshold in ipairs(preset.Threshold or empty_table) do
        if threshold.Id == "AtmosphereBreathable" then
            atmosphereBreathableDefined = true
            threshold.Threshold = 50
            break
        end
    end
    if not atmosphereBreathableDefined then
        local newItem = PlaceObj("ThresholdItem", {
            "Id", "AtmosphereBreathable", "Threshold", 50, "Hysteresis", 2
        })
        table.insert(preset.Threshold, newItem)
    end
end

local function DustStormsVegetationRequired()
    ChangeDustStormStopForAtmosphere(Presets.TerraformingParam.Default.Atmosphere)
    local vegetation = Presets.TerraformingParam.Default.Vegetation
    ChangeDustStormStopForVegetation(vegetation)
    ChangeAtmosphereBreathableForVegetation(vegetation)
end

OnMsg.LoadGame = DustStormsVegetationRequired
OnMsg.CityStart = DustStormsVegetationRequired

-- necessary because these settings are hard-coded in the game
-- and I needed to make MapSettings_DustStorm.param=Vegetation
-- and MapSettings_DustDevils.param=Vegetation
local disaster_terraforming_params = {
    MapSettings_Meteor = {
        param = "Atmosphere",
        threshold = "MeteorStormStop",
        filter = function(orig, x)
            return orig.storm_forbidden == x.storm_forbidden
        end
    },
    MapSettings_DustStorm = {
        param = "Vegetation",
        threshold = "DustStormStop"
    },
    MapSettings_DustDevils = {
        param = "Vegetation",
        threshold = "DustStormStop"
    },
    MapSettings_ColdWave = {
        param = "Temperature",
        threshold = "ColdWaveStop"
    };
}

-- Original function; the only change is disaster_terraforming_params
function OverrideDisasterDescriptor(original)
    if not original or original.forbidden then
        return original
    end
    local settings_type = original.class
    if not disaster_terraforming_params[settings_type] then
        return original
    end
    local param_name = disaster_terraforming_params[settings_type].param
    local param = GetTerraformParamPct(param_name)
    local threshold_name = disaster_terraforming_params[settings_type].threshold
    local threshold = GetTerraformingThreshold(param_name, threshold_name)
    if param > threshold then
        return
    end
    local orig_strength = original.strength
    local filter = disaster_terraforming_params[settings_type].filter
    local all_settings = DataInstances[settings_type]
    local min, max = 4, 1
    for _, settings in ipairs(all_settings) do
        if not settings.forbidden and orig_strength >= settings.strength and (not filter or filter(original, settings)) then
            local strength = settings.strength
            min = Min(min, strength)
            max = Max(max, strength)
        end
    end
    local new_strength = min + MulDivRound(threshold - param, max - min, threshold)
    if orig_strength == new_strength then
        return original
    end
    for _, settings in ipairs(all_settings) do
        if not settings.forbidden and settings.strength == new_strength and (not filter or filter(original, settings)) then
            return settings
        end
    end
end
