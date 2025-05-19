local functions = Tremualin.Functions

local function GetSeasonDuration(season)
    local seasonsOfMars = SeasonsOfMars
    return MulDivRound(seasonsOfMars[season].Duration, 1, seasonsOfMars.DurationDivider)
end

function GetSeasonalEffectsText()
    -- Southern Hemisphere
    local seasonsOfMars = SeasonsOfMars

    local dustStormSettings = seasonsOfMars.MapSettings_DustStorm
    local dustStormModifiers = Untranslated(string.format("<em>Dust Storm</em> amplifiers: (Duration: %.1f%%, Cooldown: %.1f%%)", dustStormSettings.DurationPercentage, dustStormSettings.SpawntimePercentage))

    local coldWaveSettinngs = seasonsOfMars.MapSettings_ColdWave
    local coldWaveModifiers = Untranslated(string.format("<em>Cold Wave</em> amplifiers: (Duration: %.1f%%, Cooldown: %.1f%%)", coldWaveSettinngs.DurationPercentage, coldWaveSettinngs.SpawntimePercentage))

    local currentSolarIrradiance = seasonsOfMars.GetSolarIrradianceBonus(seasonsOfMars.ActivePhaseDuration)
    local nextSolarIrradiance = seasonsOfMars.GetSolarIrradianceBonus(seasonsOfMars.ActivePhaseDuration + 1)
    local solarIrradianceTrend = Untranslated(string.format("<em>Solar Irradiance</em>: (Current: %+.1f%%, Trend: %+.1f%%)", currentSolarIrradiance, nextSolarIrradiance - currentSolarIrradiance))
    local solarIrradianceSS = Untranslated(string.format("<em>Solar Irradiance</em> will vary from %+.1f%% to %+.1f%% (Spring, Summer)", seasonsOfMars.FromSolarIrradianceSS, seasonsOfMars.ToSolarIrradianceSS))
    local solarIrradianceAW = Untranslated(string.format("<em>Solar Irradiance</em> will vary from %+.1f%% to %+.1f%% (Autumn, Winter)", seasonsOfMars.FromSolarIrradianceAW, seasonsOfMars.ToSolarIrradianceAW))

    local currentWindSpeed = seasonsOfMars.GetWindSpeedBoostWindTurbines(currentSolarIrradiance)
    local nextWindSpeed = seasonsOfMars.GetWindSpeedBoostWindTurbines(nextSolarIrradiance)
    local windSpeedTrend = Untranslated(string.format("<em>Wind Speed</em>: (Current: %+.1f%%, Trend: %+.1f%%)", currentWindSpeed, nextWindSpeed - currentWindSpeed))
    local windSpeedSS = Untranslated(string.format("<em>Wind Speed</em> will vary from %+.1f%% to %+.1f%% (Spring, Summer)", seasonsOfMars.FromWindSpeedSS, seasonsOfMars.ToWindSpeedSS))
    local windSpeedAW = Untranslated(string.format("<em>Wind Speed</em> will vary from %+.1f%% to %+.1f%% (Autumn, Winter)", seasonsOfMars.FromWindSpeedAW, seasonsOfMars.ToWindSpeedAW))

    if functions.IsSouthernHemisphere() then
        return table.concat({
            dustStormModifiers,
            coldWaveModifiers,
            Untranslated("< newline >"),
            solarIrradianceTrend,
            solarIrradianceSS,
            solarIrradianceAW,
            Untranslated("< newline >"),
            windSpeedTrend,
            windSpeedSS,
            windSpeedAW,
            Untranslated("< newline >"),
            Untranslated(string.format("During <em>Spring</em> (%d sols), <em>Dust Storms</em> become %.1f%% longer each sol and <em>Cold Waves</em> slowly normalize.", GetSeasonDuration("Spring"), seasonsOfMars.DurationDifficulty)),
            Untranslated(string.format("During <em>Summer</em> (%d sols), <em>Dust Storms</em> appear %.1f%% faster each sol.", GetSeasonDuration("Summer"), seasonsOfMars.FrequencyDifficulty)),
            Untranslated(string.format("During <em>Autumn</em> (%d sols), <em>Cold Waves</em> become %.1f%% longer each sol and <em>Dust Storms</em> slowly normalize.", GetSeasonDuration("Autumn"), seasonsOfMars.DurationDifficulty)),
            Untranslated(string.format("During <em>Winter</em> (%d sols), <em>Cold Waves</em> appear %.1f%% faster each sol.", GetSeasonDuration("Winter"), seasonsOfMars.FrequencyDifficulty)),
            Untranslated("< newline >< newline >"),
        }, "< newline >")
    else
        return table.concat({
            dustStormModifiers,
            coldWaveModifiers,
            solarIrradianceTrend,
            Untranslated("< newline >"),
            solarIrradianceTrend,
            solarIrradianceSS,
            solarIrradianceAW,
            Untranslated("< newline >"),
            windSpeedTrend,
            windSpeedSS,
            windSpeedAW,
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

local orig_HUD_SetDayProgress = HUD.SetDayProgress
function HUD:SetDayProgress(value)
    orig_HUD_SetDayProgress(self, value)
    local seasonsOfMars = SeasonsOfMars
    local activeSeasonId = seasonsOfMars.ActiveSeason
    local daysLeft = GetSeasonDuration(activeSeasonId) - seasonsOfMars.ActiveSeasonDuration
    local currentSeasonDescription = Untranslated(string.format("<em>%s</em>. <white>%d sols</white> before <em>%s</em>< newline >< newline >", seasonsOfMars.ActiveSeason, daysLeft, seasonsOfMars[activeSeasonId].NextSeason))

    -- Appears over the progress bar
    self.idDayProgress:SetRolloverText(currentSeasonDescription .. GetSeasonalEffectsText() .. vanilla_id_day_rollover_progress_text)

    local dlg = GetHUD()
    -- Appears over the day bar
    if dlg then
        dlg.idSol:SetRolloverText(currentSeasonDescription .. GetSeasonalEffectsText() .. vanilla_id_sol_rollover_text)
    end

    local dlg = GetHUD()
    if dlg then
        local vanilla_id_sol_text = T({4031, "Sol <day>", day = UIColony.day})
        dlg.idSol:SetText(Untranslated(string.format("%s:", activeSeasonId)) .. vanilla_id_sol_text)
    end
end
