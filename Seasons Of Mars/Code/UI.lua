local Tremualin = Tremualin
local functions = Tremualin.Functions
local ui_functions = Tremualin.UIFunctions

local function GetSeasonDuration(season)
    local seasonsOfMars = SeasonsOfMars
    return MulDivRound(seasonsOfMars[season].Duration, 1, seasonsOfMars.DurationDivider)
end

function GetSeasonalEffectsText()
    -- Southern Hemisphere
    local seasonsOfMars = SeasonsOfMars

    local activeSeasonId = seasonsOfMars.ActiveSeason
    local daysLeftUntilNextSeason = GetSeasonDuration(activeSeasonId) - seasonsOfMars.ActiveSeasonDuration
    local currentSeasonDescription = Untranslated(string.format("<em>%s</em>. <white>%d sols</white> before <em>%s</em><newline>", seasonsOfMars.ActiveSeason, daysLeftUntilNextSeason, seasonsOfMars[activeSeasonId].NextSeason))

    local dustStormSettings = seasonsOfMars.MapSettings_DustStorm
    local dustStormModifiers = Untranslated(string.format("<em>Dust Storm</em> amplifiers: (Duration: %.1f%%, Cooldown: %.1f%%)", dustStormSettings.DurationPercentage, dustStormSettings.SpawntimePercentage))
    if DustStormsDisabled then
        dustStormModifiers = Untranslated("<em>Dust Storms</em> disabled thanks to <em>Terraforming</em>")
    end

    local coldWaveSettinngs = seasonsOfMars.MapSettings_ColdWave
    local coldWaveModifiers = Untranslated(string.format("<em>Cold Wave</em> amplifiers: (Duration: %.1f%%, Cooldown: %.1f%%)", coldWaveSettinngs.DurationPercentage, coldWaveSettinngs.SpawntimePercentage))
    if ColdWavesDisabled then
        coldWaveModifiers = Untranslated("<em>Cold Waves</em> disabled thanks to <em>Terraforming</em>")
    end

    local sharedSeasonalEffects = table.concat({
        currentSeasonDescription,
        dustStormModifiers,
        coldWaveModifiers,
    }, "<newline>")

    local currentSolarIrradiance = seasonsOfMars.GetSolarIrradianceBonus(seasonsOfMars.ActivePhaseDuration)
    local nextSolarIrradiance = seasonsOfMars.GetSolarIrradianceBonus(seasonsOfMars.ActivePhaseDuration + 1)
    if seasonsOfMars.SolarIrradianceEnabled then
        local solarIrradianceTrend = Untranslated(string.format("<em>Solar Irradiance</em>: (Current: %+.1f%%, Trend: %+.1f%%)", currentSolarIrradiance, nextSolarIrradiance - currentSolarIrradiance))
        local solarIrradianceSS = Untranslated(string.format("<em>Solar Irradiance</em> will vary from %+.1f%% to %+.1f%% (Spring, Summer)", seasonsOfMars.FromSolarIrradianceSS, seasonsOfMars.ToSolarIrradianceSS))
        local solarIrradianceAW = Untranslated(string.format("<em>Solar Irradiance</em> will vary from %+.1f%% to %+.1f%% (Autumn, Winter)", seasonsOfMars.FromSolarIrradianceAW, seasonsOfMars.ToSolarIrradianceAW))

        sharedSeasonalEffects = table.concat({
            sharedSeasonalEffects,
            Untranslated("<newline>"),
            solarIrradianceTrend,
            solarIrradianceSS,
            solarIrradianceAW,
        }, "<newline>")
    end

    if seasonsOfMars.WindSpeedEnabled then
        local currentWindSpeed = seasonsOfMars.GetWindSpeedBoostWindTurbines(currentSolarIrradiance)
        local nextWindSpeed = seasonsOfMars.GetWindSpeedBoostWindTurbines(nextSolarIrradiance)
        local windSpeedTrend = Untranslated(string.format("<em>Wind Speed</em>: (Current: %+.1f%%, Trend: %+.1f%%)", currentWindSpeed, nextWindSpeed - currentWindSpeed))
        local windSpeedSS = Untranslated(string.format("<em>Wind Speed</em> will vary from %+.1f%% to %+.1f%% (Spring, Summer)", seasonsOfMars.FromWindSpeedSS, seasonsOfMars.ToWindSpeedSS))
        local windSpeedAW = Untranslated(string.format("<em>Wind Speed</em> will vary from %+.1f%% to %+.1f%% (Autumn, Winter)", seasonsOfMars.FromWindSpeedAW, seasonsOfMars.ToWindSpeedAW))

        sharedSeasonalEffects = table.concat({
            sharedSeasonalEffects,
            Untranslated("<newline>"),
            windSpeedTrend,
            windSpeedSS,
            windSpeedAW,
        }, "<newline>")
    end

    if DustStormsDisabled and ColdWavesDisabled then
        return table.concat({
            sharedSeasonalEffects,
            Untranslated("<newline>"),
            Untranslated("Seasonal <em>Dust Storm</em> and <em>Cold Wave</em> effects disabled thanks to <em>Terraforming</em>"),
            Untranslated("<newline><newline>"),
        }, "<newline>")
    end

    if functions.IsSouthernHemisphere() then
        return table.concat({
            sharedSeasonalEffects,
            Untranslated("<newline>"),
            Untranslated(string.format("During <em>Spring</em> (%d sols), <em>Dust Storms</em> become %.1f%% longer each sol and <em>Cold Waves</em> slowly normalize.", GetSeasonDuration("Spring"), seasonsOfMars.DurationDifficulty)),
            Untranslated(string.format("During <em>Summer</em> (%d sols), <em>Dust Storms</em> appear %.1f%% faster each sol.", GetSeasonDuration("Summer"), seasonsOfMars.FrequencyDifficulty)),
            Untranslated(string.format("During <em>Autumn</em> (%d sols), <em>Cold Waves</em> become %.1f%% longer each sol and <em>Dust Storms</em> slowly normalize.", GetSeasonDuration("Autumn"), seasonsOfMars.DurationDifficulty)),
            Untranslated(string.format("During <em>Winter</em> (%d sols), <em>Cold Waves</em> appear %.1f%% faster each sol.", GetSeasonDuration("Winter"), seasonsOfMars.FrequencyDifficulty)),
            Untranslated("<newline><newline>"),
        }, "<newline>")
    else
        return table.concat({
            sharedSeasonalEffects,
            Untranslated("<newline>"),
            Untranslated(string.format("During <em>Spring</em> (%d sols), <em>Dust Storms</em> and <em>Cold Waves</em> slowly normalize.", GetSeasonDuration("Spring"))),
            Untranslated(string.format("During <em>Summer</em> (%d sols), <em>Dust Storms</em> and <em>Cold Waves</em> slowly normalize", GetSeasonDuration("Summer"))),
            Untranslated(string.format("During <em>Autumn</em> (%d sols), <em>Dust Storms</em> and <em>Cold Waves</em> become %.1f%% longer each sol", GetSeasonDuration("Autumn"), seasonsOfMars.DurationDifficulty)),
            Untranslated(string.format("During <em>Winter</em> (%d sols), <em>Dust Storms</em> and <em>Cold Waves</em> appear %.1f%% faster each sol.", GetSeasonDuration("Winter"), seasonsOfMars.FrequencyDifficulty)),
            Untranslated("<newline><newline>"),
        }, "<newline>")
    end
end

local vanilla_id_day_rollover_progress_text = T(4027, "Hour <hour> of Sol <day>. Martian days consist of nearly 25 Earth hours.")
local vanilla_id_sol_rollover_text = T(8104, "Martian days consist of nearly 25 Earth hours.")

local function UpdateSeasonalRolloverText()
    local dlg = GetHUD()
    if dlg then
        local vanilla_id_sol_text = T({4031, "Sol <day>", day = UIColony.day})
        dlg.idSol:SetText(Untranslated(string.format("%s:", SeasonsOfMars.ActiveSeason)) .. vanilla_id_sol_text)
        dlg.idSol:SetRolloverText(GetSeasonalEffectsText() .. vanilla_id_sol_rollover_text)
        dlg.idDayProgress:SetRolloverText(GetSeasonalEffectsText() .. vanilla_id_day_rollover_progress_text)
    end
end

-- Update the HUD each new day and on every mod mod options event
OnMsg.NewDay = UpdateSeasonalRolloverText
OnMsg.Tremualin_SeasonsOfMars_SolarIrrandianceInitialized = UpdateSeasonalRolloverText
OnMsg.Tremualin_SeasonsOfMars_ExpectedSolarIrrandianceChanged = UpdateSeasonalRolloverText
OnMsg.Tremualin_SeasonsOfMars_SolarIrradianceEnabled = UpdateSeasonalRolloverText
OnMsg.Tremualin_SeasonsOfMars_WindSpeedEnabled = UpdateSeasonalRolloverText

-- Necessary override to call ApplyModOptions
-- Courtesy of Choggi
local Tremualin_Origin_GetDialogModeParam = GetDialogModeParam
function GetDialogModeParam(id_or_win, ...)
    -- Fake it till you make it
    local mod = Mods[id_or_win]
    if mod then
        return mod
    end

    return Tremualin_Origin_GetDialogModeParam(id_or_win, ...)
end

-- Let players know that there are changes to sun and wind so they can disable it if they don't want them
local function ShowSunAndWindUpdateMessage()
    if not CurrentModOptions:GetProperty("ReadSunAndWindUpdate") then
        CreateRealTimeThread(function()
            local params = {
                id = GetUUID(),
                title = Untranslated("Seasons of Mars - Sun and Wind Update"),
                text = Untranslated("Seasons of Mars has been updated with new effects. <newline><newline><em>Solar Irradiance</em> will modify <em>Solar Panel, Farm, Open Farm and Forestation Plants</em> performance depending on Season and the colony's Latitude.<newline><newline><em>Wind Speed</em> will modify <em>Wind Turbines</em> performance depending on Season and the colony's Latitude.<newline><newline>You can read more about how this works on the game's Encyclopedia, under Tremualin's Mods.<newline>You can also disable either of them in mod options"),
                minimized_notification_priority = "CriticalBlue",
                image = "UI/Messages/Events/03_discussion.tga",
                start_minimized = true,
                dismissable = false,
                choice1 = T(1000136, "OK"),
                choice2 = Untranslated("Show me the Encyclopedia"),
                choice3 = Untranslated("Do not show again"),
            }

            local choice = WaitPopupNotification(false, params)
            if choice == 2 then
                OpenEncyclopedia("SeasonsofMarsIntroduction")
            elseif choice == 3 then
                CurrentModOptions:SetProperty("ReadSunAndWindUpdate", true)
                ApplyModOptions(CurrentModId)
            end
        end) -- CreateRealTimeThread
    end
end

-- HUD doesn't immediately exist, thus we wait a little before updating it
function OnMsg.CityStart()
    CreateRealTimeThread(function()
        WaitMsg("MessageBoxClosed")
        Sleep(100)
        UpdateSeasonalRolloverText()
    end)
    ShowSunAndWindUpdateMessage()
end

function OnMsg.LoadGame()
    CreateRealTimeThread(function()
        Sleep(100)
        UpdateSeasonalRolloverText()
    end)
    ShowSunAndWindUpdateMessage()
end

-- Show how much Solar Irradiance is boosting Solar Power production this Season
function OnMsg.ClassesPostprocess()
    local SECTION_SOLAR_IRRADIANCE_ID = "Tremualin_SectionSolarIrradiance"
    local sectionPowerProduction = XTemplates.sectionPowerProduction[1]
    ui_functions.RemoveXTemplateSections(sectionPowerProduction, SECTION_SOLAR_IRRADIANCE_ID)
    local sectionSolarIrradiation = PlaceObj("XTemplateTemplate", {
        SECTION_SOLAR_IRRADIANCE_ID, true,
        "__context_of_kind", "SolarPanelBase",
        '__condition', function (parent, context) return SeasonsOfMars.SolarIrradianceEnabled end,
        '__template', "InfopanelText",
        'Text', Untranslated("Solar Irradiance <right><percent(SolarIrradianceBoost)>"),
    })
    table.insert(sectionPowerProduction, #sectionPowerProduction + 1, sectionSolarIrradiation)
end

-- Used to show Solar Irradiance on ForestationPlant and OpenFarm
function VegetationPlant:Tremualin_SolarIrradianceBoost()
    return DivRound(SeasonsOfMars.DaytimeSolarIrradiance, 1)
end

-- Used to show Solar Irradiance in either Green or Red
function VegetationPlant:Tremualin_SolarIrradianceBoostColorTag()
    if self:Tremualin_SolarIrradianceBoost() >= 0 then
        return TLookupTag("<green>")
    else
        return TLookupTag("<red>")
    end
end

-- Show Solar Irradiance on Forestation Plants and Open Farms
local SOLAR_IRRADIANCE_INFO_ID = "Tremualin_SolarIrradiance"
function OnMsg.ClassesPostprocess()
    local sectionVegetationPlant = XTemplates.sectionVegetationPlant
    ui_functions.RemoveXTemplateSections(sectionVegetationPlant, SOLAR_IRRADIANCE_INFO_ID)
    local tremualin_solarIrradianceInfo = PlaceObj("XTemplateTemplate", {
        SOLAR_IRRADIANCE_INFO_ID, true,
        "__context_of_kind", "VegetationPlant",
        "__template", "InfopanelSection",
        "RolloverText", Untranslated("Solar Irradiance depends on the colony's Latitude and the current Season. Solar Irradiance affects crop output and terraforming output."),
        "Title", Untranslated("Solar Irradiance"),
        "Icon", "UI/Icons/Sections/grid.tga"
    },
    {
        PlaceObj("XTemplateTemplate", {
            "__template", "InfopanelText",
            "Margins", box(0, 7, 0, 0),
            "Text", Untranslated("Solar Irradiance<right><Tremualin_SolarIrradianceBoostColorTag><percent(Tremualin_SolarIrradianceBoost)></color>"),
        }),
    })
    table.insert(sectionVegetationPlant, 5, tremualin_solarIrradianceInfo)
end
