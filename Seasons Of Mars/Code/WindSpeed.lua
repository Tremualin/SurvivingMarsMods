local ui_functions = Tremualin.UIFunctions

local function GetWindSpeedBoostWindTurbines(solarIrradiancePercent)
    return - (MulDivRound(floatfloor(solarIrradiancePercent), 75, 100))
end

-- Wind Speed increase or decreases the effect of Wind Turbines
-- And is calculated based on solar power
local function SetWindSpeedBoostWindTurbines(solarIrradiancePercent)
    SeasonsOfMars.WindSpeedBoost = GetWindSpeedBoostWindTurbines(solarIrradiancePercent)
end

-- Update Wind Speed anytime Solar Irradiance changes
function OnMsg.SolarIrrandianceChanged(solarIrradiancePercent)
    -- If dust storm, set to 0
    if HasDustStorm() then
        SetWindSpeedBoostWindTurbines(0)
    else
        -- Otherwise update, but only if the sun is shining
        -- To avoid setting WindPower to 0 at night
        if SunAboveHorizon then
            SetWindSpeedBoostWindTurbines(solarIrradiancePercent)
        end
    end
end

function OnMsg.SolarIrrandianceInitialized()
    local seasonsOfMars = SeasonsOfMars
    seasonsOfMars.FromWindSpeedSS = GetWindSpeedBoostWindTurbines(seasonsOfMars.FromSolarIrradianceSS)
    seasonsOfMars.ToWindSpeedSS = GetWindSpeedBoostWindTurbines(seasonsOfMars.ToSolarIrradianceSS)
    seasonsOfMars.FromWindSpeedAW = GetWindSpeedBoostWindTurbines(seasonsOfMars.FromSolarIrradianceAW)
    seasonsOfMars.ToWindSpeedAW = GetWindSpeedBoostWindTurbines(seasonsOfMars.ToSolarIrradianceAW)

    -- Export functions that will be used by notifications
    seasonsOfMars.GetWindSpeedBoostWindTurbines = GetWindSpeedBoostWindTurbines
end

local Tremualin_Origin_WindTurbine_GetEletricityUnderproduction = WindTurbine.GetEletricityUnderproduction
function WindTurbine:GetEletricityUnderproduction()
    local electricityUnderproduction = Tremualin_Origin_WindTurbine_GetEletricityUnderproduction(self)
    return Max(0, electricityUnderproduction + self:GetWindSpeed())
end

local Tremualin_Origin_WindTurbine_CalcProduction = WindTurbine.CalcProduction
function WindTurbine:CalcProduction()
    Tremualin_Origin_WindTurbine_CalcProduction(self)
    self:SetBase("electricity_production", MulDivRound(100 + self:GetWindSpeed(), self["base_electricity_production"], 100))
    self:UpdateWorking()
end

function WindTurbine:GetWindSpeed()
    return SeasonsOfMars.WindSpeedBoost
end

function OnMsg.ClassesPostprocess()
    -- Show how much Wind Speed is boosting Wind Power production this Season
    local SECTION_WIND_POWER_ID = "Tremualin_SectionWindSpeed"
    local sectionPowerProduction = XTemplates.sectionPowerProduction[1]
    ui_functions.RemoveXTemplateSections(sectionPowerProduction, SECTION_WIND_POWER_ID)
    local sectionWindPower = PlaceObj("XTemplateTemplate", {
        SECTION_WIND_POWER_ID, true,
        "__context_of_kind", "WindTurbine",
        '__template', "InfopanelText",
        'Text', Untranslated("Wind Speed boost <right><percent(WindSpeed)>"),
    })
    table.insert(sectionPowerProduction, #sectionPowerProduction + 1, sectionWindPower)
end
