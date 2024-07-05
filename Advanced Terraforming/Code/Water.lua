local AddParentToClass = Tremualin.Functions.AddParentToClass
local FindAllTemplatesForNames = Tremualin.Functions.FindAllTemplatesForNames
local AddFactorToTerraformingPresetIfNotDefinedAlready = Tremualin.Functions.AddFactorToTerraformingPresetIfNotDefinedAlready

-- Begin Lake Changes
function LakesContributeTwiceTheAmountOfWater()
    local templateNames = {"LandscapeLakeBig", "LandscapeLakeHuge", "LandscapeLakeMid", "LandscapeLakeSmall"}
    local templates = {}
    for _, templateName in pairs(templateNames) do
        table.insert(templates, BuildingTemplates[templateName])
        table.insert(templates, ClassTemplates.Building[templateName])
    end
    for _, template in ipairs(templates) do
        if not template.Tremualin_LakesContributeTwiceTheAmountOfWater then
            template.terraforming_boost_sol = template.terraforming_boost_sol * 2
            template.Tremualin_LakesContributeTwiceTheAmountOfWater = true
        end
    end
end
function LakesProduceTemperature()
    AddParentToClass(LandscapeLake, "SecondaryTerraformingParam")
    local templateNames = {"LandscapeLakeBig", "LandscapeLakeHuge", "LandscapeLakeMid", "LandscapeLakeSmall"}
    local templates = {}
    for _, templateName in pairs(templateNames) do
        table.insert(templates, BuildingTemplates[templateName])
        table.insert(templates, ClassTemplates.Building[templateName])
    end
    for _, template in ipairs(templates) do
        template.secondary_terraforming_param = "Temperature"
    end

    function LandscapeLake:GetSecondaryTerraformingBoostSol()
        return self.terraforming_boost_sol / 3
    end
end
function LakesProduceAtmosphere()
    AddParentToClass(LandscapeLake, "TertiaryTerraformingParam")
    local templates = FindAllTemplatesForNames({"LandscapeLakeBig", "LandscapeLakeHuge", "LandscapeLakeMid", "LandscapeLakeSmall"})
    for _, template in ipairs(templates) do
        template.tertiary_terraforming_param = "Atmosphere"
    end

    function LandscapeLake:GetTertiaryTerraformingBoostSol()
        return self.terraforming_boost_sol / 3
    end
end
LakesContributeTwiceTheAmountOfWater()
LakesProduceTemperature()
LakesProduceAtmosphere()
-- Existing lakes will need to be fixed to produce twice the amount of temperature
function SavegameFixups.TremualinLakesProduceDoubleWater()
    for _, lake in ipairs(UIColony.city_labels.labels.LandscapeLake or empty_table) do
        lake.terraforming_boost_sol = lake.terraforming_boost_sol * 2
    end
end
-- Existing lakes will need to be fixed to apply the new temperature modifiers
function SavegameFixups.TremualinLakesProduceTemperature2()
    for _, lake in ipairs(UIColony.city_labels.labels.LandscapeLake or empty_table) do
        lake.secondary_terraforming_param = "Temperature"
        lake.city:AddToLabel("SecondaryTerraformingParam", lake)
    end
end
-- Existing lakes will need to be fixed to apply the new atmosphere modifiers
function SavegameFixups.TremualinLakesProduceAtmosphere2()
    for _, lake in ipairs(UIColony.city_labels.labels.LandscapeLake or empty_table) do
        lake.tertiary_terraforming_param = "Atmosphere"
        lake.city:AddToLabel("TertiaryTerraformingParam", lake)
    end
end
-- Lakes grant comfort equal to their volume divided 50
-- 20 for Huge Lakes, 10 for Big Lakes, 5 for Lakes, and 2 for Small Lakes
local function GetLakeComfort(lake)
    return abs(lake.volume_max / 50)
end
-- Text shown when building a lake
local function GetLakeText(lake)
    return Untranslated(string.format("Grants <em>%d comfort</em> to nearby Domes (twice the usual dome distance) when full and not frozen <newline>One third of their Water per sol value is generates Atmosphere and Temperature each sol<newline>", GetLakeComfort(lake) / 1000))
end
-- Text shown when unlock the Lake Crafting technologies, which unlocks Lakes
local lake_crafting_text = Untranslated("<em>Artificial lakes</em> grant a stacking comfort bonus to nearby Domes (twice the usual dome distance) when full and not frozen.<newline>One third of their Water per sol value generates Atmosphere and Temperature each sol<newline>")
function ImproveLakes()
    local tech = Presets.TechPreset.Terraforming.LakeCrafting
    local modified = tech.Tremualin_LakeComfort
    if not modified then
        tech.description = lake_crafting_text .. tech.description
        tech.Tremualin_LakeComfort = true

        local buildingTemplates = BuildingTemplates
        local lakeBuildingTemplates = {buildingTemplates.LandscapeLakeSmall, buildingTemplates.LandscapeLakeMid, buildingTemplates.LandscapeLakeBig, buildingTemplates.LandscapeLakeHuge}
        for _, lakeTemplate in pairs(lakeBuildingTemplates) do
            lakeTemplate.description = GetLakeText(lakeTemplate) .. lakeTemplate.description
        end
    end
end
ImproveLakes()
-- When calculating dome comfort, find all Lakes up to twice the work distance from the Dome and add their comfort to the Dome
local Tremualin_Orig_Dome_GetDomeComfort = Dome.GetDomeComfort
function Dome:GetDomeComfort()
    local lake_comfort = 0
    GetRealm(self):MapForEach(self, "hex", self:GetOutsideWorkplacesDist() * 2, "LandscapeLake", function(lake, self)
        if not (not lake.working or lake.destroyed or lake:IsFrozen()) and lake.volume >= lake.volume_max then
            lake_comfort = lake_comfort + GetLakeComfort(lake)
        end
    end, self)
    return Tremualin_Orig_Dome_GetDomeComfort(self) + lake_comfort
end
-- End Lake Changes

-- Begin Moisture Vaporator Changes
-- Vaporators now drain a small percentage of water - reflect this on the technology
local moisture_drainage_text = Untranslated("<em>Moisture Vaporators</em> reduce the level of Water <icon_WaterTP_alt> on Mars.<newline>")
function ModifyMoistureVaporators()
    AddParentToClass(MoistureVaporator, "TerraformingBuildingBase")

    local ct = ClassTemplates.Building
    local MoistureVaporatorBuildingTemplate = BuildingTemplates.MoistureVaporator

    MoistureVaporatorBuildingTemplate.terraforming_param = "Water"
    MoistureVaporatorBuildingTemplate.terraforming_boost_sol = -20

    ct.MoistureVaporator.terraforming_param = "Water"
    ct.MoistureVaporator.terraforming_boost_sol = -20

    local tech = Presets.TechPreset.Biotech["MoistureFarming"]
    local modified = tech.Tremualin_MoistureConsumption
    if not modified then
        tech.description = Untranslated(moisture_drainage_text) .. tech.description
        tech.Tremualin_MoistureConsumption = true
    end
end

function OnMsg.ClassesGenerate()
    ModifyMoistureVaporators()
end
-- End Moisture Vaporator Changes

-- Begin Rainwater Collectors Upgrade
-- Rainwater collectors is an upgrade which makes Water Tanks recover 1% of their max water every hour while it rains
local RAINWATER_COLLECTOR_UPGRADE_ID = "Tremualin_RainWaterCollectors"
local RAINWATER_COLLECTOR_UPGRADE_DESCRIPTION = Untranslated("Gain <em>1% of max water capacity per hour</em> while it rains")
local function AddRainWaterCollectorsUpgrade()
    local function AddRainWaterCollectorsUpgradeToObject(obj)
        obj.upgrade1_id = RAINWATER_COLLECTOR_UPGRADE_ID
        obj.upgrade1_description = RAINWATER_COLLECTOR_UPGRADE_DESCRIPTION
        obj.upgrade1_display_name = Untranslated("Rainwater Collector")
        obj.upgrade1_icon = CurrentModPath .. "UI/rainwater_collector_01.tga"
        obj.upgrade1_upgrade_cost_MachineParts = 5000
    end

    local templates = FindAllTemplatesForNames({"WaterTank", "LargeWaterTank"})
    for _, template in ipairs(templates) do
        AddRainWaterCollectorsUpgradeToObject(template)
    end

    local tech = Presets.TechPreset.Biotech.WaterCoservationSystem
    local modified = tech.Tremualin_RainwaterCollectors
    if not modified then
        tech.description = Untranslated("Unlocks <em>Rainwater Collectors (Upgrade)</em> for all <em>Water Tanks</em> - ") ..RAINWATER_COLLECTOR_UPGRADE_DESCRIPTION .. "\n" .. tech.description
        tech.Tremualin_RainwaterCollectors = true
        table.insert(tech, #tech + 1, PlaceObj("Effect_UnlockUpgrade", {
            Upgrade = RAINWATER_COLLECTOR_UPGRADE_ID
        }))
    end
end
OnMsg.ClassesPostprocess = AddRainWaterCollectorsUpgrade

function CollectRainwaterIfUpgraded(waterStorage)
    if waterStorage:HasUpgrade(RAINWATER_COLLECTOR_UPGRADE_ID) then
        local water = waterStorage.water
        water:SetStoredAmount(water.current_storage + MulDivRound(waterStorage.water_capacity, 1, 100), "water")
    end
end
function OnMsg.NewHour(hour)
    if g_RainDisaster and g_RainDisaster == "normal" and UIColony:IsUpgradeUnlocked(RAINWATER_COLLECTOR_UPGRADE_ID) then
        for _, waterStorage in ipairs(MainCity.labels.WaterTank) do
            CollectRainwaterIfUpgraded(waterStorage)
        end
        for _, waterStorage in ipairs(MainCity.labels.WaterTankLarge) do
            CollectRainwaterIfUpgraded(waterStorage)
        end
    end
end
-- End Rainwater Collectors Upgrade

-- Begin Water Decay
-- Up to 2% of Water will decay every sol while the Atmosphere is too thin
GlobalVar("Tremualin_WaterDecayThread", false)
function Tremualin_GetSolWaterDecay()
    local atmospherePct = GetTerraformParamPct("Atmosphere")
    local water = GetTerraformParam("Water")
    -- 2% of Water will be lost
    local waterLoss = MulDivRound(water, 2, 100)
    -- Atmosphere further reduces this
    local waterLossWithAtmosphereReduction = MulDivRound(waterLoss, 100 - atmospherePct, 100)
    return waterLossWithAtmosphereReduction
end
local function SetWaterDecay()
    if not IsValidThread(Tremualin_WaterDecayThread) then
        Tremualin_WaterDecayThread = CreateGameTimeThread(function()
            local sleep = const.HourDuration / 5
            local sol = const.DayDuration
            while true do
                Sleep(sleep)
                local decay = MulDivRound(Tremualin_GetSolWaterDecay(), sleep, sol)
                if 0 < decay then
                    ChangeTerraformParam("Water", -decay)
                end
            end
        end)
    end

    AddFactorToTerraformingPresetIfNotDefinedAlready(Presets.TerraformingParam.Default.Water, PlaceObj("TerraformingFactorItem", {
        "Id", "Tremualin_WaterDecay",
        "display_name", Untranslated("Loss of water"),
        "units", "PerSol",
        "GetFactorValue", function(self) return Tremualin_GetSolWaterDecay() end
    }))
end
OnMsg.LoadGame = SetWaterDecay
OnMsg.CityStart = SetWaterDecay
-- End Water Decay
-- Begin Low Clouds Effect
-- Up to 2% of Temperature will decay every sol, based on Water %
GlobalVar("Tremualin_HighCloudsThread", false)
function Tremualin_GetHighCloudsEffect()
    local temperature = GetTerraformParam("Temperature")
    local waterPct = GetTerraformParamPct("Water")
    -- 2% of Temperature will be lost
    local temperatureLoss = MulDivRound(temperature, 2, 100)
    -- Water further improves this
    return MulDivRound(temperatureLoss, waterPct, 100)
end
local function SetHighCloudsEffect()
    if not IsValidThread(Tremualin_HighCloudsThread) then
        Tremualin_HighCloudsThread = CreateGameTimeThread(function()
            local sleep = const.HourDuration / 5
            local sol = const.DayDuration
            while true do
                Sleep(sleep)
                local decay = MulDivRound(Tremualin_GetHighCloudsEffect(), sleep, sol)
                if 0 < decay then
                    ChangeTerraformParam("Water", -decay)
                end
            end
        end)
    end

    AddFactorToTerraformingPresetIfNotDefinedAlready(Presets.TerraformingParam.Default.Temperature, PlaceObj("TerraformingFactorItem", {
        "Id", "Tremualin_HighCloudsEffect",
        "display_name", Untranslated("Low Clouds Effect"),
        "units", "PerSol",
        "GetFactorValue", function(self) return - Tremualin_GetHighCloudsEffect() end
    }))
end
OnMsg.LoadGame = SetHighCloudsEffect
OnMsg.CityStart = SetHighCloudsEffect
-- End Low Clouds Effect

-- Begin Encyclopedia Changes
local WATER_ENCYCLOPEDIA_ARTICLE = Untranslated([[
The <em>Water</em> parameter represents the quality and volume of surface water on Mars. The higher this parameter is, the more and larger water bodies will appear on Mars: lakes, seas and oceans.
 
<em>Water</em> is <green>increased</green> by evaporating it from <em>Lakes</em>, by completing the <em>Capture Ice Asteroids</em> and <em>Melt the Polar Caps</em> Special Projects, and through Vegetation <em>Transpiration</em>. Water is slightly <red>decreased</red> by <em>Moisture Vaporators</em>.
 
Its improvement boosts the effectiveness of <em>Moisture Vaporators</em>, is required for <em>Rains</em> and local <em>Vegetation</em> growth and eliminates <em>Wildfires</em> at 80%.
 
<em>Rains</em> can be started by completing the <em>Cloud Seeding</em> Special Project; they increase <em>Soil Quality</em> and fill <em>Lakes</em> and <em>Water Tanks</em> upgraded with <em>Rainwater Collectors</em> with Water every hour, and they stop <em>Wildfires</em> that <red>decreases</red> Vegetation if left unchecked.
 
As <em>Water</em> grows, so do the number of <em>Low Clouds</em>, which reflect sunlight, therefore <red>cooling</red> Mars by up to 2%.
 
Up to 2% of <em>Water</em> is <red>destroyed</red> each Sol until <em>Atmosphere</em> is at 100%.]])

function OnMsg.ClassesPreprocess()
    Presets.TerraformingParam.Default.Water.description = WATER_ENCYCLOPEDIA_ARTICLE
    Presets.EncyclopediaArticle.GameMechanics.Terraforming_Water.text = WATER_ENCYCLOPEDIA_ARTICLE
end
-- End Encyclopedia Changes
