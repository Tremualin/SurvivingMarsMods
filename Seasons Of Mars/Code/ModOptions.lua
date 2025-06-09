local functions = Tremualin.Functions

-- fired when settings are changed/init
local function ModOptions()
    local seasonsOfMars = SeasonsOfMars
    if seasonsOfMars then
        local options = CurrentModOptions
        seasonsOfMars.DurationDivider = options:GetProperty("DurationDivider")
        seasonsOfMars.FrequencyDifficulty = options:GetProperty("FrequencyDifficulty") / 10.0
        seasonsOfMars.DurationDifficulty = options:GetProperty("DurationDifficulty") / 10.0

        -- If change colors is disabled, go back to neutral colors (Spring)
        seasonsOfMars.ChangeColors = options:GetProperty("ChangeColors")
        if not seasonsOfMars.ChangeColors then
            Msg("Tremualin_SeasonsOfMars_ColorsDisabled")
        end

        if functions.IsSouthernHemisphere() then
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

        seasonsOfMars.BaseSolarIrradiance = options:GetProperty("BaseSolarIrradiance")
        seasonsOfMars.SolarIrradianceEnabled = options:GetProperty("SolarIrradianceEnabled")
        Msg("Tremualin_SeasonsOfMars_SolarIrradianceEnabled")
        seasonsOfMars.WindSpeedEnabled = options:GetProperty("WindSpeedEnabled")
        Msg("Tremualin_SeasonsOfMars_WindSpeedEnabled")
    end
end

-- fired when Mod Options>Apply button is clicked
function OnMsg.ApplyModOptions(id)
    if id == CurrentModId then
        ModOptions()
    end
end

OnMsg.ModsReloaded = ModOptions
OnMsg.LoadGame = ModOptions
OnMsg.CityStart = ModOptions
