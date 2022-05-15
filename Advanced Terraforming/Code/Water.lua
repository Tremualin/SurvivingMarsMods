local functions = Tremualin.Functions

-- Begin Lake Changes

function LakesProduceTemperature()
    functions.AddParentToClass(LandscapeLake, "SecondaryTerraformingParam")
    local templateNames = {"LandscapeLakeBig", "LandscapeLakeHuge", "LandscapeLakeMid", "LandscapeLakeSmall"}
    local templates = {}
    for _, templateName in pairs(templateNames) do
        table.insert(templates, BuildingTemplates[templateName])
        table.insert(templates, ClassTemplates.Building[templateName])
    end
    for _, template in ipairs(templates) do
        template.secondary_terraforming_param = "Temperature"
        template.secondary_terraforming_boost_sol = template.terraforming_boost_sol / 10
    end
end

function LakesProduceAtmosphere()
    functions.AddParentToClass(LandscapeLake, "TertiaryTerraformingParam")
    local templateNames = {"LandscapeLakeBig", "LandscapeLakeHuge", "LandscapeLakeMid", "LandscapeLakeSmall"}
    local templates = {}
    for _, templateName in pairs(templateNames) do
        table.insert(templates, BuildingTemplates[templateName])
        table.insert(templates, ClassTemplates.Building[templateName])
    end
    for _, template in ipairs(templates) do
        template.tertiary_terraforming_param = "Atmosphere"
        template.tertiary_terraforming_boost_sol = template.terraforming_boost_sol / 10
    end
end

LakesProduceTemperature()
LakesProduceAtmosphere()

-- Existing lakes will need to be fixed to apply the new temperature modifiers
function SavegameFixups.TremualinLakesProduceTemperature()
    for _, lake in ipairs(UIColony.city_labels.labels.LandscapeLake) do
        lake.secondary_terraforming_param = "Temperature"
        lake.secondary_terraforming_boost_sol = lake.terraforming_boost_sol / 10
        lake.city:AddToLabel("SecondaryTerraformingParam", lake)
    end
end

-- Existing lakes will need to be fixed to apply the new atmosphere modifiers
function SavegameFixups.TremualinLakesProduceAtmosphere()
    for _, lake in ipairs(UIColony.city_labels.labels.LandscapeLake) do
        lake.tertiary_terraforming_param = "Atmosphere"
        lake.tertiary_terraforming_boost_sol = lake.terraforming_boost_sol / 10
        lake.city:AddToLabel("TertiaryTerraformingParam", lake)
    end
end

local lake_crafting_text = Untranslated("<em>Artificial lakes</em> grant a stacking comfort bonus to any Dome up to 20 hexes away when full and unfrozen.<newline><em>Artificial Lakes</em> generate small amount of Atmosphere and Temperature<newline>")
-- Lakes grant comfort equal to their volume divided 50
-- 20 for Huge Lakes, 10 for Big Lakes, 5 for Lakes, and 2 for Small Lakes
local function GetLakeComfort(lake)
    return abs(lake.volume_max / 50)
end

local function GetLakeText(lake)
    return Untranslated(string.format("Grants <em>%d comfort</em> to any Dome up to 20 hexes away when full and unfrozen <newline>", GetLakeComfort(lake) / 1000))
end

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
-- Find all Lakes up to twice the work distance from the Dome and add their comfort to the Dome
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

local moisture_drainage_text = Untranslated("<em>Moisture Vaporators</em> reduce the level of Water <icon_WaterTP_alt> on Mars.<newline>")

function ModifyMoistureVaporators()
    functions.AddParentToClass(MoistureVaporator, "TerraformingBuildingBase")

    local ct = ClassTemplates.Building
    local MoistureVaporatorBuildingTemplate = BuildingTemplates.MoistureVaporator

    MoistureVaporatorBuildingTemplate.terraforming_param = "Water"
    MoistureVaporatorBuildingTemplate.terraforming_boost_sol = -5

    ct.MoistureVaporator.terraforming_param = "Water"
    ct.MoistureVaporator.terraforming_boost_sol = -5

    local tech = Presets.TechPreset.Biotech["MoistureFarming"]
    local modified = tech.Tremualin_MoistureConsumption
    if not modified then
        tech.description = Untranslated(moisture_drainage_text) .. tech.description
        tech.Tremualin_MoistureConsumption = true
    end
end

function OnMsg.ClassesGenerate()
    ModifyMoistureVaporators()
end -- function OnMsg.ClassesGenerate

-- End Moisture Vaporator Changes

-- Begin Water decays as Atmosphere Decays

function OnMsg.AtmosphereDecay(decay)
    local waterDecay = MulDivRound(decay, GetTerraformParamPct("Water"), 100)
    ChangeTerraformParam("Water", waterDecay)
    Msg("WaterDecay", waterDecay)
end

-- End Water decays as Atmosphere Decays

-- Begin Rainwater Collectors Upgrade
local RAINWATER_COLLECTOR_UPGRADE_ID = "Tremualin_RainWaterCollectors"
local RAINWATER_COLLECTOR_UPGRADE_DESCRIPTION = Untranslated("Gain <em>1% of max water capacity per hour</em> while it rains")
local function AddRainWaterCollectorsUpgrade()
    local function AddRainWaterCollectorsUpgradeToObject(obj)
        obj.upgrade1_id = RAINWATER_COLLECTOR_UPGRADE_ID
        obj.upgrade1_description = RAINWATER_COLLECTOR_UPGRADE_DESCRIPTION
        obj.upgrade1_display_name = Untranslated("Rainwater Collector")
        obj.upgrade1_icon = "UI/Icons/Upgrades/rainwater_collector_01.tga"
        obj.upgrade1_upgrade_cost_MachineParts = 5000
    end

    local templates = FindAllTemplatesForNames({"WaterTank", "LargeWaterTank"})
    for _, template in ipairs(templates) do
        AddRainWaterCollectorsUpgradeToObject(template)
    end

    local tech = Presets.TechPreset.Biotech.WaterCoservationSystem
    local modified = tech.Tremualin_RainwaterCollectors
    if not modified then
        tech.description = Untranslated("Unlocks <em>Rainwater Collectors (Upgrade)</em> for all <em>Water Tanks<em> - ") ..RAINWATER_COLLECTOR_UPGRADE_DESCRIPTION .. "\n" .. tech.description
        tech.Tremualin_RainwaterCollectors = true
        table.add(tech, #tech + 1, PlaceObj("Effect_UnlockUpgrade", {
            Upgrade = RAINWATER_COLLECTOR_UPGRADE_ID
        }))
    end
end

function OnMsg.NewHour(hour)
    if g_RainDisaster and g_RainDisaster == "normal" and UIColony:IsUpgradeUnlocked(RAINWATER_COLLECTOR_UPGRADE_ID) then
        for _, waterStorage in ipairs(MainCity.labels.WaterStorage) do
            if waterStorage:HasUpgrade(RAINWATER_COLLECTOR_UPGRADE_ID) then
                waterStorage.water:SetStoredAmount(waterStorage.current_storage + MulDivRound(waterStorage.water_capacity, 1, 100), "water")
            end
        end
    end
end

-- End Rainwater Collectors Upgrade

-- Begin Water Decay
local AddFactorToTerraformingPresetIfNotDefinedAlready = Tremualin.Functions.AddFactorToTerraformingPresetIfNotDefinedAlready
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
                    Msg("WaterDecay", -decay)
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

-- Begin Encyclopedia Changes
local WATER_ENCYCLOPEDIA_ARTICLE = Untranslated([[
The <em>Water</em> parameter represents the quality and volume of surface water on Mars. The higher this parameter is, the more and larger water bodies will appear on Mars: lakes, seas and oceans.
 
<em>Water</em> is <green>increased</green> by evaporating it from <em>Lakes</em>, by completing the <em>Capture Ice Asteroids</em> and <em>Melt the Polar Caps</em> Special Projects, and through Vegetation <em>Transpiration</em>. Water is slightly <red>decreased</red> by <em>Moisture Vaporators</em>.
 
Its improvement boosts the effectiveness of <em>Moisture Vaporators</em>, is required for <em>Rains</em> and local <em>Vegetation</em> growth, and allows <em>Water Tanks</em> to collect <em>Rain water</em>. <em>Rains</em> can be started by completing the <em>Cloud Seeding</em> Special Project.
 
<em>Water</em> is gradually lost over time until <em>Atmosphere</em> is at 100%.]])

function OnMsg.ClassesPreprocess()
    Presets.TerraformingParam.Default.Water.description = WATER_ENCYCLOPEDIA_ARTICLE
    Presets.EncyclopediaArticle.GameMechanics.Terraforming_Water.text = WATER_ENCYCLOPEDIA_ARTICLE
end
-- End Encyclopedia Changes
