local FindAllTemplatesForNames = Tremualin.Functions.FindAllTemplatesForNames
function OnMsg.ClassesPostprocess()
    -- Triple CoreHeatConvector Range
    CoreHeatConvector.UIRange = 90

    -- Magnetic Shields appear until you have 10; instead of until you have 100% Atmosphere
    Presets.POI.Default.LaunchSpaceSunshade.PrerequisiteToCreate = function(self, city, idx)
        city = city or MainCity
        return city.colony:IsTechResearched(self.activation_by_tech_research) and GetMagneticShieldsCount < 10
    end
    -- You can launch 2 Magnetic Shields in parallel
    Presets.POI.Default.LaunchSpaceSunshade.max_projects_of_type = 2
    -- Magnetic shields apply 4x the effect.
    const.Terraforming.Decay_AtmosphereSP_MagneticShield = 200

    -- You can launch 2 Capture Ice Asteroids Projects in Parallel
    Presets.POI.Default.CaptureIceAsteroids.max_projects_of_type = 2

    -- You can launch 2 Import Greenhouse Gases Projects in Parallel
    Presets.POI.Default.ImportGreenhouseGases.max_projects_of_type = 2

    -- Import Greenhouse Gases Projects are stronger
    Presets.POI.Default.ImportGreenhouseGases.terraforming_changes = {
        PlaceObj("TerraformingParamAmount", {
            "param",
            "Atmosphere",
            "amount",
            4000
        }),
        PlaceObj("TerraformingParamAmount", {
            "param",
            "Temperature",
            "amount",
            2000
        });
    }

    local function GrowthStimulatorsImproveForestationPlants()
        local tech = Presets.TechPreset.Terraforming.GrowthStimulators
        local modified = tech.Tremualin_GrowthStimulatorsImproveForestationPlants
        if not modified then
            tech.description = Untranslated("<em>Forestation Plants</em> are 50% more effective at improving Vegetation<icon_VegetationTP_alt>\n") .. tech.description
            table.insert(tech, #tech + 1, PlaceObj("Effect_ModifyLabel", {
                Label = "ForestationPlant",
                Percent = 50,
                Prop = "terraforming_boost_sol"
            }))
            tech.Tremualin_GrowthStimulatorsImproveForestationPlants = true
        end
    end

    local function HalveCarbonateProcessorAtmosphereProduction()
        local templates = FindAllTemplatesForNames({"CarbonateProcessor"})
        for _, template in ipairs(templates) do
            template.terraforming_boost_sol = 200
        end
    end

    HalveCarbonateProcessorAtmosphereProduction()
end

-- Begin Show the Secondary and Tertiary Terraforming Buildings in the UI
local function GetParamDescription(name)
    local param = Presets.TerraformingParam.Default[name]
    if not param then
        return ""
    end
    local res = name .. "TP"
    local tmp = {}
    for template_name, template in sorted_pairs(BuildingTemplates) do
        local classdef = g_Classes[template.template_class]
        if IsKindOf(classdef, "TerraformingBuildingBase") and template.terraforming_param == name then
            local sum = 0
            for _, building in ipairs(MainCity.labels.TerraformingBuilding or empty_table) do
                if building.terraforming_param == name and building.template_name == template_name then
                    sum = sum + building:GetTerraformingBoost()
                end
            end
            local display_name = template.display_name_pl
            tmp[#tmp + 1] = {
                text = display_name,
                value = T({
                    12553,
                    "From <building> <right><resource(sum, res)> per Sol<newline><left>",
                    building = display_name,
                    sum = sum,
                    res = res
                });
            }
        end
        if IsKindOf(classdef, "SecondaryTerraformingParam") and template.secondary_terraforming_param == name then
            local sum = 0
            for _, building in ipairs(MainCity.labels.SecondaryTerraformingParam or empty_table) do
                if building.secondary_terraforming_param == name and building.template_name == template_name then
                    sum = sum + building:GetSecondaryTerraformingBoost()
                end
            end
            local display_name = template.display_name_pl
            tmp[#tmp + 1] = {
                text = display_name,
                value = T({
                    12553,
                    "From <building> <right><resource(sum, res)> per Sol<newline><left>",
                    building = display_name,
                    sum = sum,
                    res = res
                });
            }
        end
        if IsKindOf(classdef, "TertiaryTerraformingParam") and template.tertiary_terraforming_param == name then
            local sum = 0
            for _, building in ipairs(MainCity.labels.TertiaryTerraformingParam or empty_table) do
                if building.tertiary_terraforming_param == name and building.template_name == template_name then
                    sum = sum + building:GetTertiaryTerraformingBoost()
                end
            end
            local display_name = template.display_name_pl
            tmp[#tmp + 1] = {
                text = display_name,
                value = T({
                    12553,
                    "From <building> <right><resource(sum, res)> per Sol<newline><left>",
                    building = display_name,
                    sum = sum,
                    res = res
                });
            }
        end
    end
    TSort(tmp, "text")
    local description = {}
    for i = 1, #tmp do
        description[#description + 1] = tmp[i].value
    end
    for _, factor in ipairs(param.Factors or empty_table) do
        local name = factor.display_name
        local value = factor:GetFactorValue()
        local units = factor.units
        local str
        if units == "PerSol" then
            str = T({
                12554,
                "<name><right><resource(value,res)> per Sol<newline><left>",
                name = name,
                value = value,
                res = res
            })
        else
            str = T({
                12555,
                "<name><right><value><newline><left>",
                name = name,
                value = value
            })
        end
        description[#description + 1] = str
    end
    if param.description then
        description[#description + 1] = T(316, "<newline>")
        description[#description + 1] = param.description or nil
    end
    return table.concat(description, "")
end
function TerraformingParamsBarObj:GetAtmosphereRollover()
    return GetParamDescription("Atmosphere")
end
function TerraformingParamsBarObj:GetTemperatureRollover()
    return GetParamDescription("Temperature")
end
function TerraformingParamsBarObj:GetWaterRollover()
    return GetParamDescription("Water")
end
function TerraformingParamsBarObj:GetVegetationRollover()
    return GetParamDescription("Vegetation")
end
-- End Show the Secondary and Tertiary Terraforming Buildings in the UI

