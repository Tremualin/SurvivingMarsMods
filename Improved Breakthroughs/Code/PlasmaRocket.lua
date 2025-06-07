local PLASMA_ROCKET_UPDATED_DESCRIPTION = Untranslated(
[[Rocket <em>travel time</em> reduced by 50% and <em>fuel consumption</em> reduced by 20
 
<grey>Plasma engines have numerous advantages over chemical rockets. All that is left to do is make sure they don't explode on launch.</grey>
]])

local function ImprovePlasmaRockets()
    local tech = Presets.TechPreset.Breakthroughs["PlasmaRocket"]
    tech.description = PLASMA_ROCKET_UPDATED_DESCRIPTION
    if not tech[4] then

        -- Plasma Rocket now offers a discount of 20 fuel to rockets
        -- Which means SpaceY rockets require no fuel at all
        table.insert(tech, PlaceObj("Effect_ModifyLabel", {
            Amount = -20,
            Label = "AllRockets",
            Prop = "launch_fuel"
        }))
    end
    if not tech[5] and GameRulesMap["LongRide"] then
        table.insert(tech, PlaceObj('Effect_ModifyLabel', {
            Label = "Consts",
            Percent = -100,
            Prop = "TravelTimeEarthMars",
        }))
    end
    if not tech[6] and GameRulesMap["LongRide"] then
        table.insert(tech, PlaceObj('Effect_ModifyLabel', {
            Label = "Consts",
            Percent = -100,
            Prop = "TravelTimeMarsEarth",
        }))
    end
end

OnMsg.ClassesPostprocess = ImprovePlasmaRockets

