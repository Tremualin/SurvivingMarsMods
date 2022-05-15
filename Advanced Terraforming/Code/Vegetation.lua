-- Begin Terraforming Subsidies gradually grants money
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
Get <em><funding(param1)></em> Funding from your sponsor once upon research, and once again every time you reach a Terraforming Threshold (and for any you've already reached)
 
<grey>"Wisdom outweighs any wealth." 
<right>Sophocles</grey><left>]])
end
-- End Terraforming Subsidies gradually grants money

-- Start Vegetation Bonuses and Penalties
GlobalVar("Tremualin_TreesPlanted", false)
function OnMsg.VegetationPlanted(vegetation)
    if vegetation == "Tree" then
        Tremualin_TreesPlanted = true
    end
end

local MAX_VEGETATION_BONUS = 500
local MAX_VEGETATION_BONUS_TREES = 1000
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
local BoostPerVegetationType = {None = 10, Lichen = 10, Grass = 20, Bush = 40, Tree = 60, Broadleaf = 100}
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
        local maxFirstSecond = Max(BoostPerVegetationType[first], BoostPerVegetationType[second])
        local maxVegetationBoost = Max(maxFirstSecond, third)
        return Max(Max(BoostPerVegetationType[first], BoostPerVegetationType[second]), BoostPerVegetationType[third])
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
    local x, y, unobstructed, obstructed = FindUnobstructedDepositPos(marker)
    if not obstructed and unobstructed then
        marker:SetPos(x, y, const.InvalidZ)
        marker:PlaceDeposit()
    else
        marker:Done()
    end
end

function OnMsg.NewHour(hour)
    for _, foresation_plant in ipairs(UIColony.city_labels.labels.ForestationPlant or empty_table) do
        if foresation_plant.working and 2 >= foresation_plant:Random(10000) then
            Tremualin_TrySpawnTechAnomalyNearObject(foresation_plant, foresation_plant.UIRange * const.GridSpacing)
        end
    end
end

-- End Forestation Plants Spawn Tech Anomalies

-- Start Vegetation Produces Breakthroughs
local function AddVegetationBreakthroughs()
    local vegetation_mutates_defined = false
    local vegetation_thresholds = Presets.TerraformingParam.Default.Vegetation.Threshold or empty_table
    for key, threshold in ipairs(vegetation_thresholds or empty_table) do
        if threshold.Id == "VegetationMutates1" then
            vegetation_mutates_defined = true
        end
    end
    if not vegetation_mutates_defined then
        local new_item = PlaceObj("ThresholdItem", {
            "Id",
            "VegetationMutates1",
            "Threshold",
            20
        })
        table.insert(vegetation_thresholds, new_item)
        new_item = PlaceObj("ThresholdItem", {
            "Id",
            "VegetationMutates2",
            "Threshold",
            40
        })
        table.insert(vegetation_thresholds, new_item)
        new_item = PlaceObj("ThresholdItem", {
            "Id",
            "VegetationMutates3",
            "Threshold",
            60
        })
        table.insert(vegetation_thresholds, new_item)
        new_item = PlaceObj("ThresholdItem", {
            "Id",
            "VegetationMutates4",
            "Threshold",
            80
        })
        table.insert(vegetation_thresholds, new_item)
        new_item = PlaceObj("ThresholdItem", {
            "Id",
            "VegetationMutates5",
            "Threshold",
            10
        })
    end
end
OnMsg.CityStart = AddVegetationBreakthroughs
OnMsg.LoadGame = AddVegetationBreakthroughs
-- End Vegetation Produces Breakthroughs

-- Begin Encyclopedia Changes
local VEGETATION_ENCYCLOPEDIA_ARTICLE = Untranslated([[
The <em>Vegetation</em> parameter represents the spreading and diversity of vegetation and bacterial life on a planetary scale. The higher this parameter is, the more Mars looks like the tundra biome back on Earth, with the ultimate goal to become a quite harsh, yet habitable second home for Humanity. The more vegetation there is, the faster the spreading will become.
 
Vegetation is increased by building <em>Forestation Plants</em> and completing the <em>Seed Vegetation</em> Special Project which becomes available when <em>Temperature</em> and <em>Water</em> levels are high enough to support primitive plant life. Once the <em>Martian Vegetation</em> tech has been researched, <em>Seeds</em> - used to spread Vegetation both locally and on the planetary scale - may be imported from Earth or grown on farms.
 
<em>Forestation Plants</em> contribution to global Vegetation increases as more efficient types of Vegetation become available, with <em>Lichen</em> providing the least amount of Vegetation, and <em>Mixed Trees</em> providing the most. 
 
Vegetation <green>contributes</green> to Vegetation through <em>Reproduction</em>, to Water through <em>Transpiration</em> and to Atmosphere through <em>Photosynthesis</em>. However, its <em>Cooling Effect</em> <red>decreases</red> Temperature. These effects are stronger once Trees are planted.
 
Recurring <em>Dust Storms</em> decrease in severity with the improving of <em>Vegetation</em> and later disappear entirely.
 
Vegetation will sometimes mutate, producing new <em>Tech</em> anomalies and even <em>Breakthrough</em> anomalies. 
 
When <em>Temperature</em>, <em>Atmosphere</em> and <em>Vegetation</em> are all high enough, the atmosphere on Mars becomes breathable and <em>Domes</em> may become <em>open-air Domes</em>.]])

function OnMsg.ClassesPreprocess()
    Presets.TerraformingParam.Default.Vegetation.description = VEGETATION_ENCYCLOPEDIA_ARTICLE
    Presets.EncyclopediaArticle.GameMechanics.Terraforming_Vegetation.text = VEGETATION_ENCYCLOPEDIA_ARTICLE
end
-- End Encyclopedia Changes
