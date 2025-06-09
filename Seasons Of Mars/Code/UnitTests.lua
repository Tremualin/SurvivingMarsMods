-- Check if the disaster configuration progress according to the current season configuration and throw an error otherwise
local function VerifyDisasterProgression(season, disasterType, originalDisasterConfiguration, modifiedDisasterConfiguration)
    local seasonDuration = season.Duration
    local seasonalConfiguration = season[disasterType]
    -- If there are no changes to that disaster type on this season, do nothing
    if not seasonalConfiguration then return end
    if seasonalConfiguration.Shorter then
        assert(originalDisasterConfiguration.DurationPercentage == 100, "Modified disaster duration should be back to original")
    elseif seasonalConfiguration.Longer then
        assert(originalDisasterConfiguration.DurationPercentage + seasonDuration * SeasonsOfMars.DurationDifficulty == modifiedDisasterConfiguration.DurationPercentage, "Modified disaster duration should be equal to the original season duration percentage plus the season duration multiplied by the difficulty modifier")
    end

    if seasonalConfiguration.LessFrequent then
        assert(originalDisasterConfiguration.SpawntimePercentage == 100, "Modified disaster duration should be back to original")
    elseif seasonalConfiguration.MoreFrequent then
        assert(Max(0, originalDisasterConfiguration.SpawntimePercentage - seasonDuration * SeasonsOfMars.SpawntimePercentage) == modifiedDisasterConfiguration.DurationPercentage, "Modified disaster duration should be equal to the original spawntime percentage minus the season duration multiplied by the difficulty modifier")
    end
end

local deepCopy = Tremualin.Functions.DeepCopy

-- For each season, advance days for as many days as the season has; then check that the disasters have progressed according to configuration
local function TestSeasons()
    local seasonsOfMars = SeasonsOfMars
    local firstSeasonId = seasonsOfMars.ActiveSeason
    local activeSeasonId = nil
    while firstSeasonId ~= activeSeasonId do
        activeSeasonId = activeSeasonId or firstSeasonId
        local activeSeason = seasonsOfMars[activeSeasonId]
        local durationOfSeason = activeSeason.Duration
        local originalDustStormConfiguration = deepCopy(seasonsOfMars.MapSettings_DustStorm)
        local originalColdWaveConfiguration = deepCopy(seasonsOfMars.MapSettings_ColdWave)
        for i = 1, durationOfSeason do
            seasonsOfMars.DailyUpdate()
        end

        assert(seasonsOfMars.ActiveSeason == activeSeason.nextSeason, "Didn't move into next season")
        assert(seasonsOfMars.ActiveSeasonDuration == 1, "Didn't start the next season on the first day")

        VerifyDisasterProgression(activeSeason, MapSettings_DustStorm, originalDustStormConfiguration, seasonsOfMars.MapSettings_DustStorm)
        VerifyDisasterProgression(activeSeason, MapSettings_ColdWave, originalColdWaveConfiguration, seasonsOfMars.MapSettings_ColdWave)

        print(string.format("Successfully transitioned from %s to %s", activeSeasonId, activeSeason.NextSeason))
        activeSeasonId = activeSeason.NextSeason
    end
end

Tremualin.Tests.SeasonsOfMarsTests = TestSeasons
