local functions = Tremualin.Functions

local TEMPERATURE_DISCOUNT_ID = "Tremualin_Temperature_Power_Discount"
local TEMPERATURE_LAKE_EVAPORATION_ID = "Tremualin_Lake_Evaporation_Boost"

-- TODO: Show discount on UI somehow
local function ApplyTemperaturePowerDiscount(...)
    MainCity:SetLabelModifier("OutsideBuilding", TEMPERATURE_DISCOUNT_ID, Modifier:new({
        prop = "electricity_consumption",
        amount = 0,
        percent = -GetTerraformParamPct("Temperature"),
        id = "OpenDome"
    }))
end

OnMsg.NewDay = ApplyTemperaturePowerDiscount

local function ApplyTemperatureLakeEvaporationBoost(...)
    MainCity:SetLabelModifier("LandscapeLake", TEMPERATURE_LAKE_EVAPORATION_ID, Modifier:new({
        prop = "terraforming_boost_sol",
        amount = 0,
        percent = GetTerraformParamPct("Temperature"),
        id = "OpenDome"
    }))
end

OnMsg.NewDay = ApplyTemperatureLakeEvaporationBoost

-- Begin Temperature Decay
local AddFactorToTerraformingPresetIfNotDefinedAlready = Tremualin.Functions.AddFactorToTerraformingPresetIfNotDefinedAlready
GlobalVar("Tremualin_TemperatureDecayThread", false)
function Tremualin_GetSolTemperatureDecay()
    local atmospherePct = GetTerraformParamPct("Atmosphere")
    local temperature = GetTerraformParam("Temperature")
    -- 2% of Temperature will be lost
    local temperatureLoss = MulDivRound(temperature, 2, 100)
    -- Atmosphere further reduces this
    local temperatureLossWithAtmosphereReduction = MulDivRound(temperatureLoss, 100 - atmospherePct, 100)
    return temperatureLossWithAtmosphereReduction
end
local function SetTemperatureDecay()
    if not IsValidThread(Tremualin_TemperatureDecayThread) then
        Tremualin_TemperatureDecayThread = CreateGameTimeThread(function()
            local sleep = const.HourDuration / 5
            local sol = const.DayDuration
            while true do
                Sleep(sleep)
                local decay = MulDivRound(Tremualin_GetSolTemperatureDecay(), sleep, sol)
                if 0 < decay then
                    ChangeTerraformParam("Temperature", -decay)
                    Msg("TemperatureDecay", -decay)
                end
            end
        end)
    end

    AddFactorToTerraformingPresetIfNotDefinedAlready(Presets.TerraformingParam.Default.Temperature, PlaceObj("TerraformingFactorItem", {
        "Id", "Tremualin_TemperatureDecay",
        "display_name", Untranslated("Loss of temperature"),
        "units", "PerSol",
        "GetFactorValue", function(self) return Tremualin_GetSolTemperatureDecay() end
    }))
end
OnMsg.LoadGame = SetTemperatureDecay
OnMsg.CityStart = SetTemperatureDecay
-- End Temperature Decay

-- Begin Encyclopedia Changes
local TEMPERATURE_ENCYCLOPEDIA_ARTICLE = Untranslated([[
The <em>Temperature</em> parameter represents the global surface temperature on Mars. The higher this parameter is, the more favorable the conditions for liquid water and Earth-like life are.
 
<em>Temperature</em> is increased by <em>GHG Factories</em>, <em>Lakes</em> and <em>Core Heat Convectors</em> as well as by completing the <em>Launch Space Mirror</em> Special Project.
 
Its improvement decreases the severity of <em>Cold Waves</em>, before eliminating them altogether, is required for <em>Rains</em> to fall, reduces <em>Electricity</em> consumption of <em>Outside Buildings</em> by up to 50%, and increases <em>Water</em> contributions from <em>Lakes</em> by up to 50%.
 
<em>Temperature</em> is gradually lost over time until <em>Atmosphere</em> is at 100%.
 
When <em>Temperature</em>, <em>Atmosphere</em> and <em>Vegetation</em> are all high enough, the atmosphere on Mars becomes breathable and <em>Domes</em> may become <em>open-air Domes</em>.]])

function OnMsg.ClassesPreprocess()
    Presets.TerraformingParam.Default.Temperature.description = TEMPERATURE_ENCYCLOPEDIA_ARTICLE
    Presets.EncyclopediaArticle.GameMechanics.Terraforming_Temperature.text = TEMPERATURE_ENCYCLOPEDIA_ARTICLE
end
-- End Encyclopedia Changes
