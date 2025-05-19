local ui_functions = Tremualin.UIFunctions
local functions = Tremualin.Functions
local pi = 3.14159265358979323846264338327950288419716939937510582097494459230781640628620899862803482534211706798214

-- Game sin function must be converted from radiasn to degrees
-- And then from game units (multiples of 60) (-4096 to 4096)
local function d_sin(radians)
    local degrees = radians * 180 / pi
    return sin(60.0 * degrees) / 4096.0
end

-- This approximate function is for the graphs seen here:
-- https://www.reddit.com/r/Colonizemars/comments/5gj2st/i_simulated_solar_irradiance_on_mars_at_various/
-- Which can be approximated to 2 sinusoidal graphs; one for Autumn+Winter (AW), and one Spring+Summer (SS)
-- And they are different for Northern Hemisphere and Southern Hemisphere (for a total of 4 sinusoidal graphs)
-- You can read about sinusoidal graphs here: https://www.math.net/sinusoidal
--
-- y = A*sin(B(x - C)) + D
-- A (Amplitude) can be calculated as the distance from min/max to the midrange
-- B = 2π  / Period, where Period is how often the graph repeats itself
-- Which is 2 * the duration of the seasons (2*(AW) or 2*(SS))
-- Duration which I will call "Max Phase Duration"
-- Thus B = 2π / 2 (Max Phase Duration) = π/(Max Phase Duration)
-- C is the horizontal shift (which will be 0, because we start the graph at the horizontal shift)
-- D is the vertical shift (depends on latitude)s
--
-- So the final formula is
-- y = (-/+)A * sin (π * x/(Max Phase Duration)) + D
-- Where X is the duration of the phase (days since Spring, or days since Autumn)
-- Where A is positive when closer to the sun, and negative when farthest from the sun
--
-- A and D can be calculated by plotting the values from the Reddit graph
-- and approximating to a lineal function
--
-- For the southern hemisphere:
-- A = latitude + 35, D = -0.725*latitude + 137
-- For the northern hemisphere:
-- A = 0.675*latitude + 26, D = -1.12*latitude + 138
--
-- TODO: Make the base irradiance A configurable mod option
-- The bonuses are calculated from/to the base irradiance
local function GetApproximateSolarIrradianceBonus(activePhaseDuration, maxPhaseDuration, aSign)
    local seasonsOfMars = SeasonsOfMars
    -- Don't forget about the tilt sign
    -- The minimum bonus is -100%
    return Max(-100, aSign * seasonsOfMars.AConst * d_sin(pi * activePhaseDuration / maxPhaseDuration) + seasonsOfMars.DConst - 52)
end

local function GetSolarIrradianceBonusCloseToMars(activePhaseDuration, aSign)
    return GetApproximateSolarIrradianceBonus(activePhaseDuration, SeasonsOfMars.ClosestToPerihelion, aSign)
end

local function GetSolarIrradianceBonusFarFromMars(activePhaseDuration, aSign)
    return GetApproximateSolarIrradianceBonus(activePhaseDuration, SeasonsOfMars.ClosestToAphelion, aSign)
end

-- Southern Hemisphere is close to Mars on Spring/Summer
-- Northern Hemisphere is close to Mars on Autumn/Winter
local function GetSolarIrrandianceBonus(activePhaseDuration)
    local seasonsOfMars = SeasonsOfMars
    if seasonsOfMars.ActiveSeason == "Spring" or seasonsOfMars.ActiveSeason == "Summer" then
        -- Sun grows during Spring and Summer
        if functions.IsSouthernHemisphere() then
            return GetSolarIrradianceBonusCloseToMars(activePhaseDuration, 1)
        else
            return GetSolarIrradianceBonusFarFromMars(activePhaseDuration, 1)
        end
    else
        -- Sun shrinks during Autumn and Winter
        if functions.IsSouthernHemisphere() then
            return GetSolarIrradianceBonusFarFromMars(activePhaseDuration, -1)
        else
            return GetSolarIrradianceBonusCloseToMars(activePhaseDuration, -1)
        end
    end
end

-- Solar Irradiance modifies the output of Forestation Plants
local SOLAR_IRRADIANCE_FORESTATION_PLANTS_MODIFIER_ID = "Tremualin_SolarIrradiance_ForestationPlants"
local function SolarIrradianceBoostsForestationPlants(solarIrradiancePercent)
    local solarIrrandianceDisplayText
    if floatfloor(solarIrradiancePercent) >= 0 then
        solarIrrandianceDisplayText = Untranslated("<green>Solar Irradiance +<percent(percent)></green>")
    else
        solarIrrandianceDisplayText = Untranslated("<red>Solar Irradiance <percent(percent)></red>")
    end

    -- Modify all solar panels production
    MainCity:SetLabelModifier("ForestationPlant", SOLAR_IRRADIANCE_FORESTATION_PLANTS_MODIFIER_ID, Modifier:new({
        prop = "electricity_production",
        percent = floatfloor(solarIrradiancePercent),
        id = SOLAR_IRRADIANCE_FORESTATION_PLANTS_MODIFIER_ID,
        display_text = solarIrrandianceDisplayText,
    }))
end

-- Solar Irradiance modifies the output of of Farms and Open Farms
local SOLAR_IRRADIANCE_FARMS_MODIFIER_ID = "Tremualin_SolarIrradiance_Farms"
local SOLAR_IRRADIANCE_OPEN_FARMS_MODIFIER_ID = "Tremualin_SolarIrradiance_OpenFarms"
local function SolarIrradianceBoostsFarms(solarIrradiancePercent)
    local solarIrrandianceDisplayText
    if floatfloor(solarIrradiancePercent) >= 0 then
        solarIrrandianceDisplayText = Untranslated("<green>Solar Irradiance +<percent(percent)></green>")
    else
        solarIrrandianceDisplayText = Untranslated("<red>Solar Irradiance <percent(percent)></red>")
    end

    -- Modify all farms production
    MainCity:SetLabelModifier("Farm", SOLAR_IRRADIANCE_FARMS_MODIFIER_ID, Modifier:new({
        prop = "performance",
        percent = floatfloor(solarIrradiancePercent),
        id = SOLAR_IRRADIANCE_FARMS_MODIFIER_ID,
        display_text = solarIrrandianceDisplayText,
    }))

    -- TODO: figure out how to do this
    -- Modify all open farm's vegetable production
end

-- Solar Irradiance improves the effect of Solar Panels
local SOLAR_IRRADIANCE_SOLAR_PANELS_MODIFIER_ID = "Tremualin_SolarIrradiance_SolarPanels"
local function SolarIrradianceBoostsSolarPanels(solarIrradiancePercent)
    local solarIrrandianceDisplayText
    if floatfloor(solarIrradiancePercent) >= 0 then
        solarIrrandianceDisplayText = Untranslated("<green>Solar Irradiance +<percent(percent)></green>")
    else
        solarIrrandianceDisplayText = Untranslated("<red>Solar Irradiance <percent(percent)></red>")
    end

    -- Modify all solar panels production
    MainCity:SetLabelModifier("SolarPanelBase", SOLAR_IRRADIANCE_SOLAR_PANELS_MODIFIER_ID, Modifier:new({
        prop = "electricity_production",
        percent = floatfloor(solarIrradiancePercent),
        id = SOLAR_IRRADIANCE_SOLAR_PANELS_MODIFIER_ID,
        display_text = solarIrrandianceDisplayText,
    }))
end

local function ApplySolarIrradianceBoosts(solarIrradiancePercent)
    SolarIrradianceBoostsSolarPanels(solarIrradiancePercent)
    SolarIrradianceBoostsForestationPlants(solarIrradiancePercent / 2)
    SolarIrradianceBoostsFarms(solarIrradiancePercent / 2)
end

local function SolarIrradianceDailyUpdate(activePhaseDuration)
    ApplySolarIrradianceBoosts(GetSolarIrrandianceBonus(activePhaseDuration))
end

function OnMsg.DustStorm(...)
    -- Dust Storms completely disable Solar Irradiance
    ApplySolarIrradianceBoosts(0)
end

function OnMsg.SunChange(...)
    -- Update solar irradiance if the sun is out
    -- Unless we are in the middle of a dust storm
    if SunAboveHorizon and not HasDustStorm() then
        SolarIrradianceDailyUpdate(SeasonsOfMars.ActivePhaseDuration)
    else
        ApplySolarIrradianceBoosts(0)
    end
end

function OnMsg.DustStormEnded(...)
    -- Re-enable Solar Irradiance after the end of the dust storm
    -- But only if the Sun is out
    if SunAboveHorizon then
        SolarIrradianceDailyUpdate(SeasonsOfMars.ActivePhaseDuration)
    end
end

local function InitSolarIrradiance()
    local seasonsOfMars = SeasonsOfMars
    -- Export functions that will be used by notifications
    seasonsOfMars.GetSolarIrrandianceBonus = GetSolarIrrandianceBonus
    seasonsOfMars.GetSolarIrradianceBonusCloseToMars = GetSolarIrradianceBonusCloseToMars
    seasonsOfMars.GetSolarIrradianceBonusFarFromMars = GetSolarIrradianceBonusFarFromMars

    if not seasonsOfMars.ActivePhaseDuration then
        -- Make sure the current tilt is set to 0
        seasonsOfMars.ActivePhaseDuration = 0
    end

    local latitude = g_CurrentMapParams.latitude
    if functions.IsSouthernHemisphere() then
        seasonsOfMars.AConst = latitude + 35
        seasonsOfMars.DConst = MulDivRound(latitude, -725, 1000) + 137
    else
        -- latitude is negative on the north
        seasonsOfMars.AConst = MulDivRound(-latitude, 675, 1000) + 26
        seasonsOfMars.DConst = MulDivRound(latitude, 1120, 1000) + 138
    end

    -- Make sure Solar Irradiance is there from the start
    SolarIrradianceDailyUpdate(seasonsOfMars.ActivePhaseDuration)

end

OnMsg.LoadGame = InitSolarIrradiance
OnMsg.CityStart = InitSolarIrradiance

function OnMsg.ClassesPostprocess()
    -- Show how much Solar Irradiance is boosting Solar Power production this Season
    local SECTION_SOLAR_IRRADIANCE_ID = "Tremualin_SectionSolarIrradiance"
    local sectionPowerProduction = XTemplates.sectionPowerProduction[1]
    ui_functions.RemoveXTemplateSections(sectionPowerProduction, SECTION_SOLAR_IRRADIANCE_ID)
    local sectionSolarIrradation = PlaceObj("XTemplateTemplate", {
        SECTION_SOLAR_IRRADIANCE_ID, true,
        "__context_of_kind", "SolarPanelBase",
        '__template', "InfopanelText",
        'Text', Untranslated("Solar Irradiance: <right><modifier_percent('electricity_production', '" .. SOLAR_IRRADIANCE_SOLAR_PANELS_MODIFIER_ID .. "')>"),
    })
    table.insert(sectionPowerProduction, #sectionPowerProduction + 1, sectionSolarIrradation)
end
