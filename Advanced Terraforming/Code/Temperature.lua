local GetSpaceMirrorsCount = Tremualin.Functions.GetSpaceMirrorsCount
-- Begin Temperature lowers electricity consumption
local TEMPERATURE_DISCOUNT_ID = "Tremualin_Temperature_Power_Discount"
GlobalVar("Tremualin_YesterdaysTemperature", false)
local function ApplyTemperaturePowerDiscount(...)
    MainCity:SetLabelModifier("OutsideBuildings", TEMPERATURE_DISCOUNT_ID, Modifier:new({
        prop = "electricity_consumption",
        amount = 0,
        percent = MulDivRound(-GetTerraformParamPct("Temperature"), 1, 2),
        id = TEMPERATURE_DISCOUNT_ID
    }))
end
OnMsg.NewDay = ApplyTemperaturePowerDiscount
-- End Temperature lowers electricity consumption
-- Begin Temperature boost Lakes
local TEMPERATURE_LAKE_EVAPORATION_ID = "Tremualin_Lake_Evaporation_Boost"
local function ApplyTemperatureLakeEvaporationBoost(...)
    MainCity:SetLabelModifier("LandscapeLake", TEMPERATURE_LAKE_EVAPORATION_ID, Modifier:new({
        prop = "terraforming_boost_sol",
        amount = 0,
        percent = Max(0, GetTerraformParamPct("Temperature") - 25),
        id = TEMPERATURE_LAKE_EVAPORATION_ID
    }))
end
OnMsg.NewDay = ApplyTemperatureLakeEvaporationBoost
-- End Temperature boosts Lakes
-- Begin Temperature decays without Atmosphere
local AddFactorToTerraformingPresetIfNotDefinedAlready = Tremualin.Functions.AddFactorToTerraformingPresetIfNotDefinedAlready
GlobalVar("Tremualin_GreenhouseEffectThread", false)
function Tremualin_GetSolGreenhouseEffect()
    local atmospherePct = GetTerraformParamPct("Atmosphere")
    local temperature = GetTerraformParam("Temperature")
    -- up to 3% of current Temperature will be lost while Atmosphere is less than 80%
    -- up to 1% of current Temperature will be retained while Atmosphere is over 80%
    if atmospherePct <= 80 then
        local temperatureLoss = MulDivRound(temperature, 3, 100)
        -- Atmosphere further reduces this
        return - MulDivRound(temperatureLoss, 80 - atmospherePct, 80)
    else
        local temperatureGain = MulDivRound(temperature, 1, 100)
        -- Atmosphere further improves this
        return MulDivRound(temperatureGain, atmospherePct, 100)
    end
end
local function SetGreenhouseEffect()
    if not IsValidThread(Tremualin_GreenhouseEffectThread) then
        Tremualin_GreenhouseEffectThread = CreateGameTimeThread(function()
            local sleep = const.HourDuration / 5
            local sol = const.DayDuration
            while true do
                Sleep(sleep)
                local greenhouseEffect = MulDivRound(Tremualin_GetSolGreenhouseEffect(), sleep, sol)
                if 0 ~= greenhouseEffect then
                    ChangeTerraformParam("Temperature", greenhouseEffect)
                end
            end
        end)
    end

    AddFactorToTerraformingPresetIfNotDefinedAlready(Presets.TerraformingParam.Default.Temperature, PlaceObj("TerraformingFactorItem", {
        "Id", "Tremualin_GreenhouseEffect",
        "display_name", Untranslated("Greenhouse Effect"),
        "units", "PerSol",
        "GetFactorValue", function(self) return Tremualin_GetSolGreenhouseEffect() end
    }))
end
OnMsg.LoadGame = SetGreenhouseEffect
OnMsg.CityStart = SetGreenhouseEffect
-- End Temperature Decay
function SavegameFixups.TremualinFixTemperatureDecayThread()
    if Tremualin_TemperatureDecayThread then
        DeleteThread(Tremualin_TemperatureDecayThread)
    end
    for _, factor in ipairs(Presets.TerraformingParam.Default.Temperature.Factors) do
        if factor.Id == "Tremualin_TemperatureDecay" then
            table.remove_entry(Presets.TerraformingParam.Default.Temperature.Factors, factor)
            break
        end
    end
end
-- Begin Space Mirrors produce Temperature
GlobalVar("Tremualin_SpaceMirrorsThread", false)
function Tremualin_GetSpaceMirrorBonus()
    -- Use the same value as the magnetic_shield, to keep things consistent
    local magnetic_shield = const.Terraforming.Decay_AtmosphereSP_MagneticShield
    return magnetic_shield * (g_SpecialProjectCompleted and GetSpaceMirrorsCount() or 0)
end
local function SetSpaceMirrorsBonus()
    if not IsValidThread(Tremualin_SpaceMirrorsThread) then
        Tremualin_SpaceMirrorsThread = CreateGameTimeThread(function()
            local sleep = const.HourDuration / 5
            local sol = const.DayDuration
            while true do
                Sleep(sleep)
                local bonus = MulDivRound(Tremualin_GetSpaceMirrorBonus(), sleep, sol)
                if 0 < bonus then
                    ChangeTerraformParam("Temperature", bonus)
                end
            end
        end)
    end

    AddFactorToTerraformingPresetIfNotDefinedAlready(Presets.TerraformingParam.Default.Temperature, PlaceObj("TerraformingFactorItem", {
        "Id", "Tremualin_SpaceMirrorsBonus",
        "display_name", Untranslated("From Space Mirrors"),
        "units", "PerSol",
        "GetFactorValue", function(self) return Tremualin_GetSpaceMirrorBonus() end
    }))
end
OnMsg.LoadGame = SetSpaceMirrorsBonus
OnMsg.CityStart = SetSpaceMirrorsBonus
-- End Space Mirrors produce Temperature

-- Begin Encyclopedia Changes
local TEMPERATURE_ENCYCLOPEDIA_ARTICLE = Untranslated([[
The <em>Temperature</em> parameter represents the global surface temperature on Mars. The higher this parameter is, the more favorable the conditions for liquid water, plant life and Earth-like Human life are. 
 
<em>Temperature</em> is increased by <em>GHG Factories</em>, <em>Lakes</em> and <em>Core Heat Convectors</em> as well as by completing the <em>Import Greenhouse Gases</em> and <em>Launch Space Mirror</em> Special Projects.
 
Its improvement decreases the severity of <em>Cold Waves</em>, before eliminating them altogether, is required for <em>Rains</em> to fall, reduces <em>electricity consumption</em> of <em>outside buildings</em> by up to 50%, and increases <em>Water</em> contributions from <em>Lakes</em> by up to 75%.
 
When Atmosphere is over 80%, 1% of Temperature will be <green>retained</green> by the <em>Greenhouse Effect</em>. But when Atmosphere is lower than 80%, up to 3% of Temperature will be <red>lost</red>, due to the lack of greenhouse gases in the Atmosphere.
 
When <em>Temperature</em> and <em>Atmosphere</em> are high enough, but Water is not at 80%, <red>Wildfires</red> could appear, <red>decreasing</red> <em>Vegetation</em> until either they're dealt with, or it <em>Rains</em>.
 
When <em>Temperature</em>, <em>Atmosphere</em> and <em>Vegetation</em> are all high enough, the atmosphere on Mars becomes breathable and <em>Domes</em> may become <em>open-air Domes</em>.]])

function OnMsg.ClassesPreprocess()
    Presets.TerraformingParam.Default.Temperature.description = TEMPERATURE_ENCYCLOPEDIA_ARTICLE
    Presets.EncyclopediaArticle.GameMechanics.Terraforming_Temperature.text = TEMPERATURE_ENCYCLOPEDIA_ARTICLE
end
-- End Encyclopedia Changes
