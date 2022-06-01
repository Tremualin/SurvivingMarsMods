local GetSpaceMirrorsCount = Tremualin.Functions.GetSpaceMirrorsCount

-- Contains mostly modifications to the Tech Tree
local FindAllTemplatesForNames = Tremualin.Functions.FindAllTemplatesForNames
function OnMsg.ClassesPostprocess()
    -- Triple CoreHeatConvector Range
    CoreHeatConvector.UIRange = 90

    -- Magnetic Shields appear until you have 10; instead of until you have 100% Atmosphere
    local spaceSunshade = Presets.POI.Default.LaunchSpaceSunshade
    spaceSunshade.PrerequisiteToCreate = function(self, city, idx)
        city = city or MainCity
        return city.colony:IsTechResearched(self.activation_by_tech_research) and GetMagneticShieldsCount() < 10
    end
    -- You can launch 2 Magnetic Shields in parallel and they spawn faster
    spaceSunshade.max_projects_of_type = 2
    spaceSunshade.spawn_period = range(5, 15)

    local spaceMirrors = Presets.POI.Default.LaunchSpaceMirror
    -- Space Mirrors appear until you have 10; instead of until you have 100% Temperature
    spaceMirrors.PrerequisiteToCreate = function(self, city, idx)
        city = city or MainCity
        return city.colony:IsTechResearched(self.activation_by_tech_research) and GetSpaceMirrorsCount() < 10
    end
    -- You can launch 2 Space Mirrors in parallel and they spawn faster
    spaceMirrors.max_projects_of_type = 2
    spaceMirrors.spawn_period = range(5, 15)
    spaceMirrors.terraforming_changes = {}
    spaceMirrors.description = Untranslated("Launch a highly reflective surface to focus more sunlight on the surface of the planet, increasing the global Temperature by 0.3% per Sol and the power production of all Solar Panels by 10%")

    -- Cloud Seeding Spawns faster
    Presets.POI.Default.CloudSeeding.spawn_period = range(5, 15)

    -- Magnetic shields are much stronger now; needing only 10 to stop most of the Atmosphere loss
    const.Terraforming.Decay_AtmosphereSP_MagneticShield = 300

    -- Atmosphere Decay is doubled
    const.Terraforming.Decay_AtmosphereTP_Max = 4000

    -- You can launch 2 Capture Ice Asteroids Projects in Parallel
    Presets.POI.Default.CaptureIceAsteroids.max_projects_of_type = 2

    -- You can launch 2 Import Greenhouse Gases Projects in Parallel
    Presets.POI.Default.ImportGreenhouseGases.max_projects_of_type = 2

    -- Import Greenhouse Gases won't appear at the same location (causes a bug if not changed)
    Presets.POI.Default.ImportGreenhouseGases.max_projects_of_type = 2
    Presets.POI.Default.ImportGreenhouseGases.next_spawn_location = "random"

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
            3000
        });
    }

    -- Growth Stimulators improve Forestation Plants by 50%
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

    GrowthStimulatorsImproveForestationPlants()

    -- Carbonate Processors produce less Atmosphere
    local function HalveCarbonateProcessorAtmosphereProduction()
        local templates = FindAllTemplatesForNames({"CarbonateProcessor"})
        for _, template in ipairs(templates) do
            template.terraforming_boost_sol = 200
        end
    end

    HalveCarbonateProcessorAtmosphereProduction()

    -- Switch the positions of several techs in the Terraforming branch so it becomes easier to start Terraforming
    local terraformingPreset = Presets.TechPreset.Terraforming
    terraformingPreset.GreenhouseMars.position = range(1, 1)
    terraformingPreset.MartianVegetation.position = range(2, 5)
    terraformingPreset.InterplanetaryProjects.position = range(2, 5)
    terraformingPreset.GrowthStimulators.position = range(2, 5)
    terraformingPreset.TerraformingSubsidies.position = range(2, 5)
    terraformingPreset.TerraformingRover.position = range(6, 9)
    terraformingPreset.TopologyAI.position = range(6, 9)
    terraformingPreset.PlanetarySurvey.position = range(6, 9)
end

-- Begin Terraforming Subsidies gradually grants funding
local subsidiesAlreadyGranted = {}
local TERRAFORMING_SUBSIDIES_FUNDING = 300000000
function OnMsg.TerraformThresholdPassed(id, fully_passed)
    if UIColony:IsTechResearched("TerraformingSubsidies") and fully_passed and not subsidiesAlreadyGranted[id] then
        UIColony.funds:ChangeFunding(TERRAFORMING_SUBSIDIES_FUNDING, "Sponsor")
        subsidiesAlreadyGranted[id] = true
    end
end

function OnMsg.TechResearched(tech_id)
    if tech_id == "TerraformingSubsidies" then
        for key, value in pairs(TerraformingThresholds) do
            if value == 0 then
                UIColony.funds:ChangeFunding(TERRAFORMING_SUBSIDIES_FUNDING, "Sponsor")
                subsidiesAlreadyGranted[key] = true
            end
        end
    end
end

local function ModifyTerraformingSubsidies()
    local tech = Presets.TechPreset.Terraforming.TerraformingSubsidies
    tech.param1 = TERRAFORMING_SUBSIDIES_FUNDING
    tech.description = Untranslated([[
Get <em><funding(param1)></em> Funding from your sponsor once upon research, and once again every time you reach a Terraforming Threshold (and for any you have already reached)
 
<grey>"Wisdom outweighs any wealth." 
<right>Sophocles</grey><left>]])
    for key, value in ipairs(tech) do
        if value.Funding then
            value.Funding = 300
        end
    end
end
OnMsg.ClassesPostprocess = ModifyTerraformingSubsidies
-- End Terraforming Subsidies gradually grants money

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

-- Begin Open Domes have a wider Work Area
local BREATHABLE_MARS_WORK_AREA_MODIFIER_ID = "Tremualin_BreathableMarsWorkAreaModifider"
local function ApplyBreathableMarsWorkAreaModifier()
    g_Consts:UpdateModifier("add", Modifier:new({
        id = BREATHABLE_MARS_WORK_AREA_MODIFIER_ID,
        prop = "DefaultOutsideWorkplacesRadius",
        amount = 15,
        percent = 0
    }), 15, 0)
end

local function RemoveBreathableMarsWorkAreaModifier()
    local old_mod = table.find_value(g_Consts.modifications, "id", BREATHABLE_MARS_WORK_AREA_MODIFIER_ID)
    if old_mod then
        g_Consts:UpdateModifier("remove", old_mod, -old_mod.amount, -old_mod.percent)
    end
end

local function ConstructionComplete_ForEachFn(deposit, building)
    if deposit:CanAffectBuilding(building) then
        deposit:AffectBuilding(building)
    end
end

function OnMsg.BreathableAtmosphereChanged(breathable)
    if breathable then
        ApplyBreathableMarsWorkAreaModifier()
        -- Need to refresh all deposits once the work area is updated; otherwise they won't affect the building
        -- Copied from ConstructionComplete_ForEachFn
        for _, dome in pairs(MainCity.labels.Dome or empty_table) do
            local range = GetBuildingAffectRange(dome)
            local realm = GetRealm(dome)
            realm:MapForEach(dome, "hex", range, "EffectDeposit", ConstructionComplete_ForEachFn, dome)
        end
    else
        RemoveBreathableMarsWorkAreaModifier()
    end
end
-- End Open Domes have a wider Work Area

-- Begin Sort Terraforming Factors
local function SortTerraformingFactors()
    local comparator = function (k1, k2)
        if k1.display_name and k2.display_name then
            return _InternalTranslate(k1.display_name) < _InternalTranslate(k2.display_name)
        else
            -- Never actually called, but just in case
            return 0
        end
    end
    table.sort(Presets.TerraformingParam.Default.Atmosphere.Factors, comparator)
    table.sort(Presets.TerraformingParam.Default.Temperature.Factors, comparator)
    table.sort(Presets.TerraformingParam.Default.Water.Factors, comparator)
    table.sort(Presets.TerraformingParam.Default.Vegetation.Factors, comparator)
end
OnMsg.PostLoadGame = SortTerraformingFactors
OnMsg.PostNewGame = SortTerraformingFactors
-- Begin Sort Terraforming Factors
