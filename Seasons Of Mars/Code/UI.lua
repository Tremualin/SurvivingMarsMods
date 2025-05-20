local functions = Tremualin.Functions

local function GetSeasonDuration(season)
    local seasonsOfMars = SeasonsOfMars
    return MulDivRound(seasonsOfMars[season].Duration, 1, seasonsOfMars.DurationDivider)
end

function GetSeasonalEffectsText()
    -- Southern Hemisphere
    local seasonsOfMars = SeasonsOfMars

    local activeSeasonId = seasonsOfMars.ActiveSeason
    local daysLeftUntilNextSeason = GetSeasonDuration(activeSeasonId) - seasonsOfMars.ActiveSeasonDuration
    local currentSeasonDescription = Untranslated(string.format("<em>%s</em>. <white>%d sols</white> before <em>%s</em>< newline >", seasonsOfMars.ActiveSeason, daysLeftUntilNextSeason, seasonsOfMars[activeSeasonId].NextSeason))

    local dustStormSettings = seasonsOfMars.MapSettings_DustStorm
    local dustStormModifiers = Untranslated(string.format("<em>Dust Storm</em> amplifiers: (Duration: %.1f%%, Cooldown: %.1f%%)", dustStormSettings.DurationPercentage, dustStormSettings.SpawntimePercentage))

    local coldWaveSettinngs = seasonsOfMars.MapSettings_ColdWave
    local coldWaveModifiers = Untranslated(string.format("<em>Cold Wave</em> amplifiers: (Duration: %.1f%%, Cooldown: %.1f%%)", coldWaveSettinngs.DurationPercentage, coldWaveSettinngs.SpawntimePercentage))

    local sharedSeasonalEffects = table.concat({
        currentSeasonDescription,
        dustStormModifiers,
        coldWaveModifiers,
    }, "< newline >")

    local currentSolarIrradiance = seasonsOfMars.GetSolarIrradianceBonus(seasonsOfMars.ActivePhaseDuration)
    local nextSolarIrradiance = seasonsOfMars.GetSolarIrradianceBonus(seasonsOfMars.ActivePhaseDuration + 1)
    if seasonsOfMars.SolarIrradianceEnabled then
        local solarIrradianceTrend = Untranslated(string.format("<em>Solar Irradiance</em>: (Current: %+.1f%%, Trend: %+.1f%%)", currentSolarIrradiance, nextSolarIrradiance - currentSolarIrradiance))
        local solarIrradianceSS = Untranslated(string.format("<em>Solar Irradiance</em> will vary from %+.1f%% to %+.1f%% (Spring, Summer)", seasonsOfMars.FromSolarIrradianceSS, seasonsOfMars.ToSolarIrradianceSS))
        local solarIrradianceAW = Untranslated(string.format("<em>Solar Irradiance</em> will vary from %+.1f%% to %+.1f%% (Autumn, Winter)", seasonsOfMars.FromSolarIrradianceAW, seasonsOfMars.ToSolarIrradianceAW))

        sharedSeasonalEffects = table.concat({
            sharedSeasonalEffects,
            Untranslated("< newline >"),
            solarIrradianceTrend,
            solarIrradianceSS,
            solarIrradianceAW,
        }, "< newline >")
    end

    if seasonsOfMars.WindSpeedEnabled then
        local currentWindSpeed = seasonsOfMars.GetWindSpeedBoostWindTurbines(currentSolarIrradiance)
        local nextWindSpeed = seasonsOfMars.GetWindSpeedBoostWindTurbines(nextSolarIrradiance)
        local windSpeedTrend = Untranslated(string.format("<em>Wind Speed</em>: (Current: %+.1f%%, Trend: %+.1f%%)", currentWindSpeed, nextWindSpeed - currentWindSpeed))
        local windSpeedSS = Untranslated(string.format("<em>Wind Speed</em> will vary from %+.1f%% to %+.1f%% (Spring, Summer)", seasonsOfMars.FromWindSpeedSS, seasonsOfMars.ToWindSpeedSS))
        local windSpeedAW = Untranslated(string.format("<em>Wind Speed</em> will vary from %+.1f%% to %+.1f%% (Autumn, Winter)", seasonsOfMars.FromWindSpeedAW, seasonsOfMars.ToWindSpeedAW))

        sharedSeasonalEffects = table.concat({
            sharedSeasonalEffects,
            Untranslated("< newline >"),
            windSpeedTrend,
            windSpeedSS,
            windSpeedAW,
        }, "< newline >")
    end

    if functions.IsSouthernHemisphere() then
        return table.concat({
            sharedSeasonalEffects,
            Untranslated("< newline >"),
            Untranslated(string.format("During <em>Spring</em> (%d sols), <em>Dust Storms</em> become %.1f%% longer each sol and <em>Cold Waves</em> slowly normalize.", GetSeasonDuration("Spring"), seasonsOfMars.DurationDifficulty)),
            Untranslated(string.format("During <em>Summer</em> (%d sols), <em>Dust Storms</em> appear %.1f%% faster each sol.", GetSeasonDuration("Summer"), seasonsOfMars.FrequencyDifficulty)),
            Untranslated(string.format("During <em>Autumn</em> (%d sols), <em>Cold Waves</em> become %.1f%% longer each sol and <em>Dust Storms</em> slowly normalize.", GetSeasonDuration("Autumn"), seasonsOfMars.DurationDifficulty)),
            Untranslated(string.format("During <em>Winter</em> (%d sols), <em>Cold Waves</em> appear %.1f%% faster each sol.", GetSeasonDuration("Winter"), seasonsOfMars.FrequencyDifficulty)),
            Untranslated("< newline >< newline >"),
        }, "< newline >")
    else
        return table.concat({
            sharedSeasonalEffects,
            Untranslated("< newline >"),
            Untranslated(string.format("During <em>Spring</em> (%d sols), <em>Dust Storms</em> and <em>Cold Waves</em> slowly normalize.", GetSeasonDuration("Spring"))),
            Untranslated(string.format("During <em>Summer</em> (%d sols), <em>Dust Storms</em> and <em>Cold Waves</em> slowly normalize", GetSeasonDuration("Summer"))),
            Untranslated(string.format("During <em>Autumn</em> (%d sols), <em>Dust Storms</em> and <em>Cold Waves</em> become %.1f%% longer each sol", GetSeasonDuration("Autumn"), seasonsOfMars.DurationDifficulty)),
            Untranslated(string.format("During <em>Winter</em> (%d sols), <em>Dust Storms</em> and <em>Cold Waves</em> appear %.1f%% faster each sol.", GetSeasonDuration("Winter"), seasonsOfMars.FrequencyDifficulty)),
            Untranslated("< newline >< newline >"),
        }, "< newline >")
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

-- Update the HUD each new day
OnMsg.NewDay = UpdateSeasonalRolloverText

-- Let players know that there are changes to sun and wind so they can disable it if they don't want them
local function ShowSunAndWindUpdateMessage()
    if not CurrentModOptions:GetProperty("ReadSunAndWindUpdate") then
        CreateRealTimeThread(function()
            local params = {
                id = GetUUID(),
                title = Untranslated("Seasons of Mars - Sun and Wind Update"),
                text = Untranslated("Seasons of Mars has been updated with new effects. <newline><newline><em>Solar Irradiance</em> will modify <em>Solar Panel, Farm and Forestation Plants</em> performance depending on Season and the colony's Latitude.<newline><newline><em>Wind Speed</em> will modify <em>Wind Turbines</em> performance depending on Season and the colony's Latitude.<newline><newline>You can read more about how this works on the game's Encyclopedia, under Tremualin's Mods.<newline>You can also disable either of them in mod options"),
                minimized_notification_priority = "CriticalBlue",
                image = "UI/Messages/Events/03_discussion.tga",
                start_minimized = true,
                dismissable = false,
                choice1 = T(1000136, "OK"),
                choice2 = Untranslated("Do not show again"),
            }

            local choice = WaitPopupNotification(false, params)
            if choice == 2 then
                CurrentModOptions:SetProperty("ReadSunAndWindUpdate", true)
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

