local FindAllTemplatesForNames = Tremualin.Functions.FindAllTemplatesForNames

-- Begin Vegetation Bonuses and Penalties
-- Vegetation Bonuses are doubled once Trees are planted
GlobalVar("Tremualin_TreesPlanted", false)
function OnMsg.VegetationPlanted(vegetation)
    if vegetation == "Tree" then
        Tremualin_TreesPlanted = true
    end
end

local MAX_VEGETATION_BONUS = 1000
local MAX_VEGETATION_BONUS_TREES = 2000
function Tremualin_GetVegetationBonus()
    return MulDivRound(GetTerraformParamPct("Vegetation"), Tremualin_TreesPlanted and MAX_VEGETATION_BONUS_TREES or MAX_VEGETATION_BONUS, 100)
end

GlobalVar("Tremualin_VegetationBonusesThread", false)
function InitializeVegetationBonusesThread()
    if not IsValidThread(Tremualin_VegetationBonusesThread) then
        Tremualin_VegetationBonusesThread = (CreateGameTimeThread(function()
            local sleep = const.HourDuration / 5
            local sol = const.DayDuration
            while true do
                Sleep(sleep)
                local vegetationBonus = (MulDivRound(Tremualin_GetVegetationBonus(), sleep, sol))
                if vegetationBonus > 0 then
                    -- Reproduction bonus; increases Vegetation
                    ChangeTerraformParam("Vegetation", vegetationBonus)
                    -- Transpiration bonus; increases Water
                    ChangeTerraformParam("Water", vegetationBonus)
                    -- Photosynthesis  bonus; increases Atmosphere
                    ChangeTerraformParam("Atmosphere", vegetationBonus)
                    -- Cooling penalty; decreases Temperature
                    ChangeTerraformParam("Temperature", -vegetationBonus)
                end
            end
        end))
    end
end

OnMsg.CityStart = InitializeVegetationBonusesThread
OnMsg.LoadGame = InitializeVegetationBonusesThread

-- Show vegetation bonuses in the UI
local AddFactorToTerraformingPresetIfNotDefinedAlready = Tremualin.Functions.AddFactorToTerraformingPresetIfNotDefinedAlready
function OnMsg.ClassesPostprocess()
    AddFactorToTerraformingPresetIfNotDefinedAlready(Presets.TerraformingParam.Default.Vegetation, PlaceObj("TerraformingFactorItem", {
        "Id", "VegetativeReproduction",
        "display_name", "Vegetation Reproduction",
        "units", "PerSol",
        "GetFactorValue", function(self) return Tremualin_GetVegetationBonus() end
    }))
    AddFactorToTerraformingPresetIfNotDefinedAlready(Presets.TerraformingParam.Default.Water, PlaceObj("TerraformingFactorItem", {
        "Id", "VegetativeTranspiration",
        "display_name", "Vegetation Transpiration",
        "units", "PerSol",
        "GetFactorValue", function(self) return Tremualin_GetVegetationBonus() end
    }))
    AddFactorToTerraformingPresetIfNotDefinedAlready(Presets.TerraformingParam.Default.Atmosphere, PlaceObj("TerraformingFactorItem", {
        "Id", "VegetativeReproduction",
        "display_name", "Vegetation Photosynthesis",
        "units", "PerSol",
        "GetFactorValue", function(self) return Tremualin_GetVegetationBonus() end
    }))
    AddFactorToTerraformingPresetIfNotDefinedAlready(Presets.TerraformingParam.Default.Temperature, PlaceObj("TerraformingFactorItem", {
        "Id", "VegetativeReproduction",
        "display_name", "Vegetation Cooling Effect",
        "units", "PerSol",
        "GetFactorValue", function(self) return - Tremualin_GetVegetationBonus() end
    }))
end
-- End Vegetation Bonuses and Penalties

-- Begin Forestation Plants provide higher bonuses depending on what they're planting
local MultiplierPerVegetationType = {None = 1, Lichen = 1, Grass = 1.5, Bush = 2, Tree = 3, Broadleaf = 5}
local Tremualin_Orig_ForestationPlant_GetTerraformingBoostSol = ForestationPlant.GetTerraformingBoostSol
function ForestationPlant:GetTerraformingBoostSol()
    if self.harvest_type then
        local first = self.harvest_type[1]
        -- If soil quality is too low; we can't use it
        if not first or (first.min_soil_quality or 0) > self:GetHighestSoilQualityInRange() then
            first = "None"
        end
        local second = self.harvest_type[2]
        if not second or (second.min_soil_quality or 0) > self:GetHighestSoilQualityInRange() then
            second = "None"
        end
        local third = self.harvest_type[3]
        if not third or (third.min_soil_quality or 0) > self:GetHighestSoilQualityInRange() then
            third = "None"
        end
        local multiplier = Max(Max(MultiplierPerVegetationType[first], MultiplierPerVegetationType[second]), MultiplierPerVegetationType[third])
        return MulDivRound(self.terraforming_boost_sol, multiplier, 1)
    end
    return Tremualin_Orig_ForestationPlant_GetTerraformingBoostSol(self)
end
-- End Forestation Plants provide higher bonuses depending on what they're planting

-- Begin Forestation Plants Spawn Tech Anomalies
local function Tremualin_TrySpawnTechAnomalyNearObject(object, radius)
    local marker = PlaceObjectIn("SubsurfaceAnomalyMarker", object:GetMapID())
    marker.tech_action = "unlock"
    marker.revealed = true
    marker.sequence_list = "Anomalies"
    marker:SetPos(GetRandomPassableAroundOnMap(object:GetMapID(), object:GetPos(), radius))
    marker:PlaceDeposit()
end

function OnMsg.NewHour(hour)
    if GetTerraformParamPct("Vegetation") < 100 then
        for _, foresation_plant in ipairs(UIColony.city_labels.labels.ForestationPlant or empty_table) do
            if foresation_plant.working and 1 >= foresation_plant:Random(1000) then
                Tremualin_TrySpawnTechAnomalyNearObject(foresation_plant, foresation_plant.UIRange * const.GridSpacing)
            end
        end
    end
end
-- End Forestation Plants Spawn Tech Anomalies

-- Start Vegetation Produces Breakthroughs
local MUTATION_IDS = {VegetationMutates1 = true, VegetationMutates2 = true,
VegetationMutates3 = true, VegetationMutates4 = true, VegetationMutates5 = true}
local function AddVegetationBreakthroughs()
    local vegetation_mutates_defined = false
    local vegetation_thresholds = Presets.TerraformingParam.Default.Vegetation.Threshold or empty_table
    for key, threshold in ipairs(vegetation_thresholds or empty_table) do
        if threshold.Id == "VegetationMutates1" then
            vegetation_mutates_defined = true
        end
    end
    if not vegetation_mutates_defined then
        local new_items = {
            PlaceObj("ThresholdItem", {"Id", "VegetationMutates1", "Threshold", 20}),
            PlaceObj("ThresholdItem", {"Id", "VegetationMutates2", "Threshold", 40}),
            PlaceObj("ThresholdItem", {"Id", "VegetationMutates3", "Threshold", 60}),
            PlaceObj("ThresholdItem", {"Id", "VegetationMutates4", "Threshold", 80}),
            PlaceObj("ThresholdItem", {"Id", "VegetationMutates5", "Threshold", 100}),
        }
        for _, new_item in ipairs(new_items) do
            table.insert(vegetation_thresholds, new_item)
        end
    end
end
OnMsg.CityStart = AddVegetationBreakthroughs
OnMsg.LoadGame = AddVegetationBreakthroughs

function Tremualin_TrySpawnBreakthroughAnomaly()
    local marker = PlaceObjectIn("SubsurfaceAnomalyMarker", MainMapID)
    marker.tech_action = "breakthrough"
    marker.revealed = true
    marker.sequence_list = "Anomalies"
    marker.breakthrough_tech = table.rand(UIColony:GetUnregisteredBreakthroughs())
    marker:SetPos(GetRandomPassable(MainCity))
    marker:PlaceDeposit()
end

function OnMsg.TerraformThresholdPassed(id, fully_passed)
    if MUTATION_IDS[id] and fully_passed then
        Tremualin_TrySpawnBreakthroughAnomaly()
        -- TODO: fix exploit where you can get multiple breakthroughs
        MUTATION_IDS[id] = false
    end
end

local Orig_Tremualin_TerraformingParamsBarObj_GetTerraformingRollover = TerraformingParamsBarObj.GetTerraformingRollover
function TerraformingParamsBarObj:GetTerraformingRollover()
    local items = {}
    items[#items + 1] = Orig_Tremualin_TerraformingParamsBarObj_GetTerraformingRollover(self)
    items[#items + 1] = T({"<color_tag>Biological discovery</color><right><tp_threshold('VegetationMutates1', true, true)>",
        color_tag = TLookupTag(TerraformingThresholds.VegetationMutates1 == 0 and "<green>" or "<em>"),
    untranslated = true})
    items[#items + 1] = T({"<color_tag>Biological discovery</color><right><tp_threshold('VegetationMutates2', true, true)>",
        color_tag = TLookupTag(TerraformingThresholds.VegetationMutates2 == 0 and "<green>" or "<em>"),
    untranslated = true})
    items[#items + 1] = T({"<color_tag>Biological discovery</color><right><tp_threshold('VegetationMutates3', true, true)>",
        color_tag = TLookupTag(TerraformingThresholds.VegetationMutates3 == 0 and "<green>" or "<em>"),
    untranslated = true})
    items[#items + 1] = T({"<color_tag>Biological discovery</color><right><tp_threshold('VegetationMutates4', true, true)>",
        color_tag = TLookupTag(TerraformingThresholds.VegetationMutates4 == 0 and "<green>" or "<em>"),
    untranslated = true})
    items[#items + 1] = T({"<color_tag>Biological discovery</color><right><tp_threshold('VegetationMutates5', true, true)>",
        color_tag = TLookupTag(TerraformingThresholds.VegetationMutates5 == 0 and "<green>" or "<em>"),
    untranslated = true})
    items[#items + 1] = T({"<color_tag>Wildfires start</color><right><tp_threshold('Tremualin_WildfiresStart', true, true)>",
        color_tag = TLookupTag(TerraformingThresholds.Tremualin_WildfiresStart == 0 and "<green>" or "<em>"),
    untranslated = true})
    items[#items + 1] = T({"<color_tag>Wildfires stop</color><right><tp_threshold('Tremualin_WildfiresStop', true, true)>",
        color_tag = TLookupTag(TerraformingThresholds.Tremualin_WildfiresStop == 0 and "<green>" or "<em>"),
    untranslated = true})
    return table.concat(items, [[
 
<left>]])
end
-- End Vegetation Produces Breakthroughs

-- Begin Modify Forestation Plant Description
local function ModifyForestationPlant()
    local templates = FindAllTemplatesForNames({"ForestationPlant"})
    for _, template in ipairs(templates) do
        template.description = Untranslated("Consumes Seeds to plant wild vegetation, increasing local Soil Quality. Plants will wither or grow according to local Soil Quality and global Temperature<icon_TemperatureTP_alt> and Water <icon_WaterTP_alt>.\nImproves global Vegetation <icon_VegetationTP_alt> depending on the type of Vegetation it's planting (0.01% from Lichen, 0.015% from Grass, 0.02% from Bushes, 0.03% from Trees, and 0.5% from Mixed Trees, whichever is highest), but only if soil quality in its work area allows it. Has a 0.001% chance per hour of generating <em>Tech Anomalies</em> in its work area. Doesn\226\128\153t work during Dust Storms and Toxic Rains.")
    end
end
OnMsg.ClassesPostprocess = ModifyForestationPlant
-- End Modify Forestation Plant Description

-- Begin Wildfires will threaten Vegetation
GlobalVar("Tremualin_WildfiresThread", false)
function GetWildfires()
    local wildfires = {}
    for _, poi in ipairs(MarsScreenLandingSpots) do
        if poi.spot_type == "project" and poi.project_id == "Tremualin_WildfireDisaster" then
            wildfires[poi.id] = poi
        end
    end
    return wildfires
end
function Tremualin_GetWildfiresPenalty()
    -- Use the same value as the magnetic_shield, to keep things consistent
    local magnetic_shield = const.Terraforming.Decay_AtmosphereSP_MagneticShield
    return magnetic_shield * table.count(GetWildfires())
end
local function SetWildfirePenalty()
    if not IsValidThread(Tremualin_WildfiresThread) then
        Tremualin_WildfiresThread = CreateGameTimeThread(function()
            local sleep = const.HourDuration
            local sol = const.DayDuration
            while true do
                Sleep(sleep)
                local decay = MulDivRound(Tremualin_GetWildfiresPenalty(), sleep, sol)
                if 0 < decay then
                    ChangeTerraformParam("Vegetation", -decay)
                end
            end
        end)
    end

    AddFactorToTerraformingPresetIfNotDefinedAlready(Presets.TerraformingParam.Default.Vegetation, PlaceObj("TerraformingFactorItem", {
        "Id", "Tremualin_WildfiresPenalty",
        "display_name", Untranslated("From Wildfires"),
        "units", "PerSol",
        "GetFactorValue", function(self) return - Tremualin_GetWildfiresPenalty() end
    }))
end
OnMsg.LoadGame = SetWildfirePenalty
OnMsg.CityStart = SetWildfirePenalty
function AddWildfires()
    if not Presets.POI.Default.Tremualin_WildfireDisaster then
        PlaceObj("POI", {
            PrerequisiteToCreate = function(self)
                return GetTerraformParamPct("Atmosphere") > 50 and GetTerraformParamPct("Temperature") > 50 and GetTerraformParamPct("Water") < 120
            end,
            description = Untranslated("Wildfires consume 0.3% Vegetation per sol until put out. Our Rocket will drop concrete around the area to limit the spread of the fire."),
            display_icon = CurrentModPath .. "UI/wildfire.dds",
            display_name = Untranslated("Wildfire"),
            expedition_time = 1500000,
            group = "Default",
            id = "Tremualin_WildfireDisaster",
            is_orbital = false,
            is_terraforming = true,
            max_projects_of_type = 5,
            rocket_required_resources = {
                PlaceObj("ResourceAmount", {
                    "resource",
                    "Concrete",
                    "amount",
                    200000
                });
            },
            save_in = "armstrong",
            spawn_period = range(5, 20),
            terraforming_changes = {};
        })
    end
end
OnMsg.LoadGame = AddWildfires
OnMsg.NewDay = AddWildfires
function OnMsg.RainDisasterStart(map_id, rain_type)
    if rain_type == "normal" then
        for _, wildfire in pairs(GetWildfires()) do
            print("Stopping wildfire")
            MarsSpecialProject.OnCompletion(wildfire, MainCity)
        end
    end
end
local function AddWildfireStartThreshold(thresholds, hysteresis)
    local wildfire_thresholds_defined = false
    for key, threshold in pairs(thresholds or empty_table) do
        if threshold.Id == "Tremualin_WildfiresStart" then
            wildfire_thresholds_defined = true
        end
    end
    if not wildfire_thresholds_defined then
        if hysteresis then
            table.insert(thresholds, PlaceObj("ThresholdItem", {"Id", "Tremualin_WildfiresStart", "Threshold", 50, "Hysteresis", 2}))
        else
            table.insert(thresholds, PlaceObj("ThresholdItem", {"Id", "Tremualin_WildfiresStart", "Threshold", 50}))
        end
    end
end
local function AddWildfireStopsThreshold(thresholds)
    local wildfire_thresholds_defined = false
    for key, threshold in ipairs(thresholds or empty_table) do
        if threshold.Id == "Tremualin_WildfiresStop" then
            wildfire_thresholds_defined = true
        end
    end
    if not wildfire_thresholds_defined then
        table.insert(thresholds, PlaceObj("ThresholdItem", {"Id", "Tremualin_WildfiresStop", "Threshold", 80}))
    end
end
-- TODO: savegame fix for WildfireStop and WildfireStart remove
local function AddWildfireThresholds()
    AddWildfireStartThreshold(Presets.TerraformingParam.Default.Temperature.Threshold)
    AddWildfireStartThreshold(Presets.TerraformingParam.Default.Atmosphere.Threshold, 2)
    AddWildfireStopsThreshold(Presets.TerraformingParam.Default.Water.Threshold)
end
OnMsg.CityStart = AddWildfireThresholds
OnMsg.LoadGame = AddWildfireThresholds
local function AddWildfireNotificationPreset()
    if PopupNotificationPresets.CompletedTremualin_WildfireDisaster then
        return
    end
    PlaceObj("PopupNotificationPreset", {
        group = "POI",
        id = "CompletedTremualin_WildfireDisaster",
        image = CurrentModPath .. "UI/terraforming_01.dds",
        minimized_notification_priority = "CriticalBlue",
        save_in = "armstrong",
        text = Untranslated("While some species of plants rely on the occasional Wildfire to survive, uncontrolled Wildfires can devastate entire ecosystems. This time, we've managed to put it out, right on time."),
        title = Untranslated("Wildfire stopped");
    })
end
OnMsg.ClassesPostprocess = AddWildfireNotificationPreset
-- End Wildfires will threaten Vegetation

-- Begin Encyclopedia Changes
local VEGETATION_ENCYCLOPEDIA_ARTICLE = Untranslated([[
The <em>Vegetation</em> parameter represents the spreading and diversity of vegetation and bacterial life on a planetary scale. The higher this parameter is, the more Mars looks like the tundra biome back on Earth, with the ultimate goal to become a quite harsh, yet habitable second home for Humanity. The more vegetation there is, the faster the spreading will become.
 
Vegetation is <green>increased</green> by building <em>Forestation Plants</em> and completing the <em>Seed Vegetation</em> Special Project which becomes available when <em>Temperature</em> and <em>Water</em> levels are high enough to support primitive plant life. Vegetation is <red>decreased</red> by <em>Wildfires</em>, which appear when Atmosphere and Temperature are high, but Water is low.
 
<em>Forestation Plants</em> contribution to global Vegetation increases as more efficient types of Vegetation become available, with <em>Lichen</em> providing the least amount of Vegetation, and <em>Mixed Trees</em> providing the most, and they can sometimes produce anomalies.
 
Vegetation <green>contributes</green> to itself through <em>Reproduction</em>, to Water through <em>Transpiration</em> and to Atmosphere through <em>Photosynthesis</em>. However, its <em>Cooling Effect</em> <red>decreases</red> Temperature. These effects are stronger once Trees are planted.
 
Improving Vegetation unlocks new <em>Breakthroughs</em> and decreases the severity of recurring <em>Dust Storms</em> which later disappear entirely.
  
When <em>Temperature</em>, <em>Atmosphere</em> and <em>Vegetation</em> are all high enough, the atmosphere on Mars becomes breathable and <em>Domes</em> may become <em>open-air Domes</em>.]])

function OnMsg.ClassesPreprocess()
    Presets.TerraformingParam.Default.Vegetation.description = VEGETATION_ENCYCLOPEDIA_ARTICLE
    Presets.EncyclopediaArticle.GameMechanics.Terraforming_Vegetation.text = VEGETATION_ENCYCLOPEDIA_ARTICLE
end
-- End Encyclopedia Changes
