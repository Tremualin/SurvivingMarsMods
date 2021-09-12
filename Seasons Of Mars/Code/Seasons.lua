GlobalVar("SeasonsOfMars", {})
local function ModifyDisaster(disasterType, activeSeason, difficultyMultiplier)
    local durationDifficulty = SeasonsOfMars.DurationDifficulty * difficultyMultiplier
    local frequencyDifficulty = SeasonsOfMars.FrequencyDifficulty * difficultyMultiplier

    local disasterConfiguration = SeasonsOfMars[disasterType]
    local seasonalDisasterConfiguration = activeSeason[disasterType]
    if seasonalDisasterConfiguration then
        local longer = seasonalDisasterConfiguration.Longer
        local shorter = seasonalDisasterConfiguration.Shorter
        local moreFrequent = seasonalDisasterConfiguration.MoreFrequent
        local lessFrequent = seasonalDisasterConfiguration.LessFrequent
        -- Duration should go up when becoming more difficult
        if longer then
            disasterConfiguration.DurationPercentage = disasterConfiguration.DurationPercentage + durationDifficulty
        elseif shorter then
            disasterConfiguration.DurationPercentage = Max(disasterConfiguration.DurationPercentage - durationDifficulty, 100)
        end

        -- Spawntime should go down then becoming more difficult
        if moreFrequent then
            disasterConfiguration.SpawntimePercentage = Max(disasterConfiguration.SpawntimePercentage - frequencyDifficulty, 0)
        elseif lessFrequent then
            disasterConfiguration.SpawntimePercentage = Min(disasterConfiguration.SpawntimePercentage + frequencyDifficulty, 100)
        end
    end
end

local function SeasonalDailyUpdate()
    local seasonsOfMars = SeasonsOfMars
    local activeSeasonId = SeasonsOfMars.ActiveSeason
    local activeSeason = seasonsOfMars[activeSeasonId]
    if seasonsOfMars.ActiveSeasonDuration >= activeSeason.Duration then
        seasonsOfMars.ActiveSeason = activeSeason.NextSeason
        seasonsOfMars.ActiveSeasonDuration = 1
        activeSeason = seasonsOfMars[activeSeasonId]
    else
        seasonsOfMars.ActiveSeasonDuration = seasonsOfMars.ActiveSeasonDuration + 1
    end

    ModifyDisaster("MapSettings_DustStorm", activeSeason, 1)
    ModifyDisaster("MapSettings_ColdWave", activeSeason, 1)
end

local orig_Colony_DailyUpdate = Colony.DailyUpdate
function Colony:DailyUpdate(day)
    orig_Colony_DailyUpdate(self, day)
    SeasonalDailyUpdate()
end

local shallowCopy = Tremualin.Functions.ShallowCopy

local orig_OverrideDisasterDescriptor = OverrideDisasterDescriptor
function OverrideDisasterDescriptor(original)
    if not original or original.forbidden then
        return original
    end

    local settings_type = original.class
    local overriden = orig_OverrideDisasterDescriptor(original)
    local seasonsOfMarsDisasterSettings = SeasonsOfMars[settings_type]
    if not seasonsOfMarsDisasterSettings then
        return overriden
    end

    if not seasonsOfMarsDisasterSettings.OriginalSettings then
        seasonsOfMarsDisasterSettings.OriginalSettings = {
            spawntime = overriden.spawntime,
            spawntime_random = overriden.spawntime_random,
            min_duration = overriden.min_duration,
            max_duration = overriden.max_duration
        }
        if overriden.seasonal and overriden.seasonal_sols then
            seasonsOfMarsDisasterSettings.OriginalSettings.seasonal_sols = overriden.seasonal_sols
        end
    end

    local originalSettings = seasonsOfMarsDisasterSettings.OriginalSettings
    local spawnTimePercentage = seasonsOfMarsDisasterSettings.SpawntimePercentage
    if overriden.seasonal and overriden.seasonal_sols then
        overriden.seasonal_sols = MulDivRound(originalSettings.seasonal_sols, spawnTimePercentage, 100)
    else
        overriden.spawntime = MulDivRound(originalSettings.spawntime, spawnTimePercentage, 100)
        overriden.spawntime_random = MulDivRound(originalSettings.spawntime_random, spawnTimePercentage, 100)
    end

    local durationPercentage = seasonsOfMarsDisasterSettings.DurationPercentage
    overriden.min_duration = MulDivRound(originalSettings.min_duration, durationPercentage, 100)
    overriden.max_duration = MulDivRound(originalSettings.max_duration, durationPercentage, 100)
    return overriden
end

local function InitSeasonsOfMars()
    if not SeasonsOfMars.ActiveSeason then
        SeasonsOfMars.Spring = {Duration = 97, MapSettings_ColdWave = {Shorter = true, LessFrequent = true}, MapSettings_DustStorm = {Longer = true}, NextSeason = "Summer"}
        SeasonsOfMars.Summer = {Duration = 89, MapSettings_ColdWave = {Shorter = true, LessFrequent = true}, MapSettings_DustStorm = {MoreFrequent = true}, NextSeason = "Autumn"}
        SeasonsOfMars.Autumn = {Duration = 71, MapSettings_DustStorm = {Shorter = true, LessFrequent = true}, MapSettings_ColdWave = {Longer = true}, NextSeason = "Winter"}
        SeasonsOfMars.Winter = {Duration = 77, MapSettings_DustStorm = {Shorter = true, LessFrequent = true}, MapSettings_ColdWave = {MoreFrequent = true}, NextSeason = "Spring"}
        SeasonsOfMars.ActiveSeason = "Spring"
        SeasonsOfMars.ActiveSeasonDuration = 0
        SeasonsOfMars.MapSettings_DustStorm = {SpawntimePercentage = 100, DurationPercentage = 100}
        SeasonsOfMars.MapSettings_ColdWave = {SpawntimePercentage = 100, DurationPercentage = 100}
    end

    SeasonsOfMars.DurationDifficulty = 2.5
    SeasonsOfMars.FrequencyDifficulty = 0.5
    SeasonsOfMars.DailyUpdate = SeasonalDailyUpdate
end

OnMsg.LoadGame = InitSeasonsOfMars
OnMsg.CityStart = InitSeasonsOfMars
