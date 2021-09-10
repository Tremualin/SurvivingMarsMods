GlobalVar("SeasonsOfMars", {})
local function InitSeasonsOfMars()
    if not SeasonsOfMars.ActiveSeason then
        SeasonsOfMars.Spring = {Duration = 97, ShorterColdWaves = true, ShorterDustStorms = true, LessFrequentDustStorms = true, LessFrequentColdWaves = true, NextSeason = "Summer"}
        SeasonsOfMars.Summer = {Duration = 89, LongerDustStorms = true, NextSeason = "Autumn"}
        SeasonsOfMars.Autumn = {Duration = 71, MoreFrequentDustStorms = true, MoreFrequentColdWaves = true, NextSeason = "Winter"}
        SeasonsOfMars.Winter = {Duration = 77, LongerColdWaves = true, NextSeason = "Spring"}
        SeasonsOfMars.ActiveSeason = "Summer"
        SeasonsOfMars.ActiveSeasonDuration = 0
        SeasonsOfMars.MapSettings_DustStorms = {SpawntimePercentage = 100, DurationPercentage = 100}
        SeasonsOfMars.MapSettings_ColdWave = {SpawntimePercentage = 100, DurationPercentage = 100}
    end

    SeasonsOfMars.DurationDifficulty = 2
    SeasonsOfMars.FrequencyDifficulty = 1
end

OnMsg.LoadGame = InitSeasonsOfMars
OnMsg.CityStart = InitSeasonsOfMars

local orig_Colony_DailyUpdate = Colony.DailyUpdate
function Colony:DailyUpdate(day)
    orig_Colony_DailyUpdate(self, day)
    local seasonsOfMars = SeasonsOfMars
    local durationDifficulty = SeasonsOfMars.DurationDifficulty
    local frequencyDifficulty = SeasonsOfMars.FrequencyDifficulty
    local dustStormSettings = seasonsOfMars.MapSettings_DustStorms
    local coldWaveSettings = seasonsOfMars.MapSettings_ColdWave
    local activeSeason = seasonsOfMars[SeasonsOfMars.ActiveSeason]
    if seasonsOfMars.ActiveSeasonDuration >= activeSeason.Duration then
        seasonsOfMars.ActiveSeason = activeSeason.NextSeason
        seasonsOfMars.ActiveSeasonDuration = 1
        activeSeason = seasonsOfMars[SeasonsOfMars.ActiveSeason]
    else
        seasonsOfMars.ActiveSeasonDuration = seasonsOfMars.ActiveSeasonDuration + 1
    end

    -- Duration should go up when becoming more difficult
    if activeSeason.LongerDustStorms then
        dustStormSettings.DurationPercentage = dustStormSettings.DurationPercentage + difficultyModifier
    elseif activeSeason.ShorterDustStorms then
        dustStormSettings.DurationPercentage = Max(dustStormSettings.DurationPercentage - difficultyModifier, 100)
    end

    if activeSeason.LongerColdWaves then
        coldWaveSettings.DurationPercentage = coldWaveSettings.DurationPercentage + difficultyModifier
    elseif activeSeason.ShorterColdWaves then
        coldWaveSettings.DurationPercentage = Max(coldWaveSettings.DurationPercentage - difficultyModifier, 100)
    end

    -- Spawntime should go down then becoming more difficult
    if activeSeason.MoreFrequentDustStorms then
        dustStormSettings.SpawntimePercentage = Max(dustStormSettings.SpawntimePercentage - difficultyModifier, 10)
    elseif activeSeason.LessFrequentDustStorms then
        dustStormSettings.SpawntimePercentage = Min(dustStormSettings.SpawntimePercentage + difficultyModifier, 100)
    end

    if activeSeason.MoreFrequentColdWaves then
        coldWaveSettings.SpawntimePercentage = Max(coldWaveSettings.SpawntimePercentage - difficultyModifier, 10)
    elseif activeSeason.LessFrequentColdWaves then
        coldWaveSettings.SpawntimePercentage = Min(coldWaveSettings.SpawntimePercentage + difficultyModifier, 100)
    end

end

local orig_OverrideDisasterDescriptor = OverrideDisasterDescriptor
function OverrideDisasterDescriptor(original)
    local overriden = orig_OverrideDisasterDescriptor(original)

    local settings_type = original.class
    local seasonsOfMars = SeasonsOfMars[settings_type]
    if not seasonsOfMars or not overriden or original.overriden then
        return overriden
    end

    local spawnTimePercentage = seasonsOfMars.SpawntimePercentage
    if overriden.seasonal then
        dust_storm.seasonal_sols = MulDivRound(dust_storm.seasonal_sols, spawnTimePercentage, 100)
    else
        overriden.spawntime = MulDivRound(overriden.spawntime, spawnTimePercentage, 100)
        overriden.spawntime_random = MulDivRound(overriden.spawntime_random, spawnTimePercentage, 100)
    end

    local durationPercentage = seasonsOfMars.DurationPercentage
    overriden.min_duration = MulDivRound(overriden.min_duration, durationPercentage, 100)
    overriden.max_duration = MulDivRound(overriden.max_duration, durationPercentage, 100)
    return overriden
end
