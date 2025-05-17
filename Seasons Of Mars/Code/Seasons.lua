local ui_functions = Tremualin.UIFunctions

-- Holds and persists all configurations
GlobalVar("SeasonsOfMars", {})

-- Modifies a given disaster type (DustStorm, ColdWave), making it longer or shorter, and more frequent or less frequent
local function ModifyDisaster(disasterType, activeSeasonConfiguration, difficultyMultiplier)
    local seasonsOfMars = SeasonsOfMars

    -- Players can choose to make seasons more or less difficult by playing with these settings
    local durationDifficulty = seasonsOfMars.DurationDifficulty * difficultyMultiplier
    local frequencyDifficulty = seasonsOfMars.FrequencyDifficulty * difficultyMultiplier

    -- Holds the multipliers (DurationPercentage, and SpawntimePercentage) for current disaster type
    local disasterConfiguration = seasonsOfMars[disasterType]
    -- Holds the configuration (longer, shorter, moreFrequent, lessFrequent) for the current season
    local seasonalDisasterConfiguration = activeSeasonConfiguration[disasterType]

    local longer = seasonalDisasterConfiguration.Longer
    local shorter = seasonalDisasterConfiguration.Shorter
    -- Duration should go up when becoming more difficult
    if longer then
        disasterConfiguration.DurationPercentage = disasterConfiguration.DurationPercentage + durationDifficulty
    elseif shorter then
        disasterConfiguration.DurationPercentage = Max(disasterConfiguration.DurationPercentage - durationDifficulty, 100)
    end

    local moreFrequent = seasonalDisasterConfiguration.MoreFrequent
    local lessFrequent = seasonalDisasterConfiguration.LessFrequent
    -- Spawntime should go down when becoming more difficult
    if moreFrequent then
        disasterConfiguration.SpawntimePercentage = Max(disasterConfiguration.SpawntimePercentage - frequencyDifficulty, 0)
    elseif lessFrequent then
        disasterConfiguration.SpawntimePercentage = Min(disasterConfiguration.SpawntimePercentage + frequencyDifficulty, 100)
    end
end

local function IsSouthernHemisphere()
    return MarsScreenMapParams.latitude >= 0
end

local function SeasonalDailyUpdate()
    local seasonsOfMars = SeasonsOfMars
    local activeSeasonId = seasonsOfMars.ActiveSeason
    local activeSeasonConfiguration = seasonsOfMars[activeSeasonId]
    -- If the season has run it's course; change to the next one
    -- Otherwise, increase the ActiveSeasonDuration and ActivePhaseDuration
    -- Finally, update all disaster configurations
    if seasonsOfMars.ActiveSeasonDuration >= activeSeasonConfiguration.Duration / seasonsOfMars.DurationDivider then
        seasonsOfMars.ActiveSeason = activeSeasonConfiguration.NextSeason
        if seasonsOfMars.ActiveSeason == "Autumn" or seasonsOfMars.ActiveSeason == "Spring" then
            seasonsOfMars.ActivePhaseDuration = 1
        end
        seasonsOfMars.ActiveSeasonDuration = 1
        activeSeasonId = seasonsOfMars.ActiveSeason
        activeSeasonConfiguration = seasonsOfMars[activeSeasonId]
        Msg("SeasonsOfMars_SeasonChange", activeSeasonId)
    else
        seasonsOfMars.ActiveSeasonDuration = seasonsOfMars.ActiveSeasonDuration + 1
        seasonsOfMars.ActivePhaseDuration = seasonsOfMars.ActivePhaseDuration + 1
    end

    -- Update disaster settings for this moment of the season
    ModifyDisaster("MapSettings_DustStorm", activeSeasonConfiguration, 1)
    ModifyDisaster("MapSettings_ColdWave", activeSeasonConfiguration, 1)
end

-- Update seasons settings each Sol
OnMsg.NewDay = SeasonalDailyUpdate

-- fired when settings are changed/init
local function ModOptions()
    local seasonsOfMars = SeasonsOfMars
    if seasonsOfMars then
        local options = CurrentModOptions
        seasonsOfMars.DurationDivider = options:GetProperty("DurationDivider")
        seasonsOfMars.FrequencyDifficulty = options:GetProperty("FrequencyDifficulty") / 10.0
        seasonsOfMars.DurationDifficulty = options:GetProperty("DurationDifficulty") / 10.0
        seasonsOfMars.ChangeColors = options:GetProperty("ChangeColors")
        if not seasonsOfMars.ChangeColors and SeasonsOfMars_ChangeColors then
            SeasonsOfMars_ChangeColors(seasonsOfMars.ActiveSeason, true)
        end

        if IsSouthernHemisphere() then
            -- Aphelion is the farthest point from the sun
            seasonsOfMars.ClosestToAphelion = (seasonsOfMars.Autumn.Duration + seasonsOfMars.Winter.Duration) / seasonsOfMars.DurationDivider
            -- Perihelion is the closest point from the sun
            seasonsOfMars.ClosestToPerihelion = (seasonsOfMars.Spring.Duration + seasonsOfMars.Summer.Duration) / seasonsOfMars.DurationDivider
        else
            -- Aphelion is the farthest point from the sun
            seasonsOfMars.ClosestToAphelion = (seasonsOfMars.Summer.Duration + seasonsOfMars.Spring.Duration) / seasonsOfMars.DurationDivider
            -- Perihelion is the closest point from the sun
            seasonsOfMars.ClosestToPerihelion = (seasonsOfMars.Autumn.Duration + seasonsOfMars.Winter.Duration) / seasonsOfMars.DurationDivider
        end
    end
end

-- fired when Mod Options>Apply button is clicked
function OnMsg.ApplyModOptions(id)
    if id == CurrentModId then
        ModOptions()
    end
end

OnMsg.ModsReloaded = ModOptions

local function InitSeasonsOfMars()
    local seasonsOfMars = SeasonsOfMars
    -- Export functions that will be used by other modules
    seasonsOfMars.IsSouthernHemisphere = IsSouthernHemisphere
    if not seasonsOfMars.ActiveSeason then
        if IsSouthernHemisphere() then
            seasonsOfMars.Spring = {Duration = 142,
                MapSettings_ColdWave = {Shorter = true, LessFrequent = true},
                MapSettings_DustStorm = {Longer = true},
            NextSeason = "Summer"}
            seasonsOfMars.Summer = {Duration = 154,
                MapSettings_ColdWave = {Shorter = true, LessFrequent = true},
                MapSettings_DustStorm = {MoreFrequent = true},
            NextSeason = "Autumn"}
            seasonsOfMars.Autumn = {Duration = 194,
                MapSettings_DustStorm = {Shorter = true, LessFrequent = true},
                MapSettings_ColdWave = {Longer = true},
            NextSeason = "Winter"}
            seasonsOfMars.Winter = {Duration = 178,
                MapSettings_DustStorm = {Shorter = true, LessFrequent = true},
                MapSettings_ColdWave = {MoreFrequent = true},
            NextSeason = "Spring"}
        else
            seasonsOfMars.Spring = {Duration = 194,
                MapSettings_ColdWave = {Shorter = true, LessFrequent = true},
                MapSettings_DustStorm = {Shorter = true, LessFrequent = true},
            NextSeason = "Summer"}
            seasonsOfMars.Summer = {Duration = 178,
                MapSettings_ColdWave = {Shorter = true, LessFrequent = true},
                MapSettings_DustStorm = {Shorter = true, LessFrequent = true},
            NextSeason = "Autumn"}
            seasonsOfMars.Autumn = {Duration = 142,
                MapSettings_DustStorm = {Longer = true},
                MapSettings_ColdWave = {Longer = true},
            NextSeason = "Winter"}
            seasonsOfMars.Winter = {Duration = 154,
                MapSettings_DustStorm = {MoreFrequent = true},
                MapSettings_ColdWave = {MoreFrequent = true},
            NextSeason = "Spring"}
        end
        seasonsOfMars.ActiveSeason = "Spring"
        seasonsOfMars.ActiveSeasonDuration = 0
        seasonsOfMars.MapSettings_DustStorm = {SpawntimePercentage = 100, DurationPercentage = 100}
        seasonsOfMars.MapSettings_ColdWave = {SpawntimePercentage = 100, DurationPercentage = 100}
    end
    ModOptions()
    -- Helper used during Unit Tests
    seasonsOfMars.DailyUpdate = SeasonalDailyUpdate
end

OnMsg.LoadGame = InitSeasonsOfMars
OnMsg.CityStart = InitSeasonsOfMars

function OnMsg.ClassesPostprocess()
    -- Need to override the disaster descriptors so we can inject Seasons Of Mars
    local orig_OverrideDisasterDescriptor = OverrideDisasterDescriptor
    function OverrideDisasterDescriptor(original)
        if not original or original.forbidden then
            return original
        end

        local overriden = orig_OverrideDisasterDescriptor(original)
        if not overriden then
            return
        end
        local settings_type = original.class
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
end
