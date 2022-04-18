local disaster_terraforming_params
local mod_DustStorms_VegetationRequired

-- fired when settings are changed/init
local function ModOptions()
    mod_DustStorms_VegetationRequired = CurrentModOptions:GetProperty("DustStorms_VegetationRequired")
end

-- load default/saved settings
OnMsg.ModsReloaded = ModOptions

local function changeDustStormStopForAtmosphere(preset, vegetationRequired)
    for key, threshold in ipairs(preset.Threshold or empty_table) do
        if threshold.Id == "DustStormStop" then
            if vegetationRequired then
                threshold.Threshold = 0
            else
                threshold.Threshold = 50
            end
            break
        end
    end
end

local function changeDustStormStopForVegetation(preset, vegetationRequired)
    local dustStormStopDefined = false
    for key, threshold in ipairs(preset.Threshold or empty_table) do
        if threshold.Id == "DustStormStop" then
            dustStormStopDefined = true
            if vegetationRequired then
                threshold.Threshold = 30
            else
                threshold.Threshold = 0
            end
            break
        end
    end
    if vegetationRequired and not dustStormStopDefined then
        local newItem = PlaceObj("ThresholdItem", {
            "Id", "DustStormStop", "Threshold", 30, "Hysteresis", 2
        })
        table.insert(preset.Threshold, newItem)
    end
end

local function changeAtmosphereBreathableForVegetation(preset, vegetationRequired)
    local atmosphereBreathableDefined = false
    for key, threshold in ipairs(preset.Threshold or empty_table) do
        if threshold.Id == "AtmosphereBreathable" then
            atmosphereBreathableDefined = true
            if vegetationRequired then
                threshold.Threshold = 30
            else
                threshold.Threshold = 0
            end
            break
        end
    end
    if vegetationRequired and not atmosphereBreathableDefined then
        local newItem = PlaceObj("ThresholdItem", {
            "Id", "AtmosphereBreathable", "Threshold", 30, "Hysteresis", 2
        })
        table.insert(preset.Threshold, newItem)
    end
end

-- A vegetation of 30% is now necessary to stop dust storms
-- Also adds 30% to breathable atmosphere; we don't want dust storms on our open domes
local function DustStormsVegetationRequired()
    for _, preset in ipairs(Presets.TerraformingParam.Default or empty_table) do
        if preset.id == "Atmosphere" then
            changeDustStormStopForAtmosphere(preset, mod_DustStorms_VegetationRequired)
        end
        if preset.id == "Vegetation" then
            changeDustStormStopForVegetation(preset, mod_DustStorms_VegetationRequired)
            changeAtmosphereBreathableForVegetation(preset, mod_DustStorms_VegetationRequired)
        end
    end
end

local modified_disaster_terraforming_params = {
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

local original_disaster_terraforming_params = {
    MapSettings_Meteor = {
        param = "Atmosphere",
        threshold = "MeteorStormStop",
        filter = function(orig, x)
            return orig.storm_forbidden == x.storm_forbidden
        end
    },
    MapSettings_DustStorm = {
        param = "Atmosphere",
        threshold = "DustStormStop"
    },
    MapSettings_DustDevils = {
        param = "Atmosphere",
        threshold = "DustStormStop"
    },
    MapSettings_ColdWave = {
        param = "Temperature",
        threshold = "ColdWaveStop"
    };
}

local function InitializeDisasterTerraformingParams()
    if mod_DustStorms_VegetationRequired then
        disaster_terraforming_params = modified_disaster_terraforming_params
    else
        disaster_terraforming_params = original_disaster_terraforming_params
    end
end

-- fired when option is changed
function OnMsg.ApplyModOptions(id)
    if id == CurrentModId then
        ModOptions()
    end
    InitializeDisasterTerraformingParams()
    DustStormsVegetationRequired()
end

OnMsg.LoadGame = DustStormsVegetationRequired
OnMsg.CityStart = DustStormsVegetationRequired

OnMsg.LoadGame = InitializeDisasterTerraformingParams
OnMsg.CityStart = InitializeDisasterTerraformingParams

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
