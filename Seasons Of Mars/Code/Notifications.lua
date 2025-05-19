local functions = Tremualin.Functions

local function GetSeasonDuration(season)
    local seasonsOfMars = SeasonsOfMars
    return MulDivRound(seasonsOfMars[season].Duration, 1, seasonsOfMars.DurationDivider)
end

function GetSeasonalEffectsText()
    -- Southern Hemisphere
    local seasonsOfMars = SeasonsOfMars
    local dustStormModifiers = Untranslated(string.format("<em>Dust Storm</em> amplifiers: (Duration: %.1f%%, Cooldown: %.1f%%)", seasonsOfMars.MapSettings_DustStorm.DurationPercentage, seasonsOfMars.MapSettings_DustStorm.SpawntimePercentage))
    local coldWaveModifiers = Untranslated(string.format("<em>Cold Wave</em> amplifiers: (Duration: %.1f%%, Cooldown: %.1f%%)", seasonsOfMars.MapSettings_ColdWave.DurationPercentage, seasonsOfMars.MapSettings_ColdWave.SpawntimePercentage))
    local solarIrradianceTrend = Untranslated(string.format("<em>Solar Irradiance</em>: (Current: %+.1f%%, Trend: %+.1f%%)", seasonsOfMars.GetSolarIrrandianceBonus(seasonsOfMars.ActivePhaseDuration), seasonsOfMars.GetSolarIrrandianceBonus(seasonsOfMars.ActivePhaseDuration + 1) - seasonsOfMars.GetSolarIrrandianceBonus(seasonsOfMars.ActivePhaseDuration)))

    if functions.IsSouthernHemisphere() then
        return table.concat({
            dustStormModifiers,
            coldWaveModifiers,
            solarIrradianceTrend,
            Untranslated("< newline >"),
            Untranslated(string.format("<em>Solar Irradiance</em> will vary from %.1f%% to %.1f%% (Spring, Summer)", seasonsOfMars.GetSolarIrradianceBonusCloseToMars(0, 1), seasonsOfMars.GetSolarIrradianceBonusCloseToMars(seasonsOfMars.ClosestToPerihelion / 2, 1))),
            Untranslated(string.format("<em>Solar Irradiance</em> will vary from %.1f%% to %.1f%% (Autumn, Winter)", seasonsOfMars.GetSolarIrradianceBonusFarFromMars(0, -1), seasonsOfMars.GetSolarIrradianceBonusFarFromMars(seasonsOfMars.ClosestToAphelion / 2, -1))),
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
            Untranslated(string.format("<em>Solar Irradiance</em> will vary from %.1f%% to %.1f%% (Spring, Summer)", seasonsOfMars.GetSolarIrradianceBonusFarFromMars(0, 1), seasonsOfMars.GetSolarIrradianceBonusFarFromMars(seasonsOfMars.ClosestToAphelion / 2, 1))),
            Untranslated(string.format("<em>Solar Irradiance</em> will vary from %.1f%% to %.1f%% (Autumn, Winter)", seasonsOfMars.GetSolarIrradianceBonusCloseToMars(0, -1), seasonsOfMars.GetSolarIrradianceBonusCloseToMars(seasonsOfMars.ClosestToPerihelion / 2, -1))),
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
