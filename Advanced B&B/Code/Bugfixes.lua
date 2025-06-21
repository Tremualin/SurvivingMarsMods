-- Copied from the original
-- + LoadAndLaunch
local rocket_on_gnd_cmd = {
    LandOnMars = true,
    Unload = true,
    Refuel = true,
    LoadAndLaunch = true,
    WaitLaunchOrder = true,
    Countdown = true,
    Takeoff = true,
    ExpeditionRefuelAndLoad = true
}

-- Fixes a bug on the original, which doesn't think LaunchAndLoad is a valid command
-- Also uses self.city instead of UICity when checking AllRockets
function LandingPad:HasRocket()
    if self.rocket_construction then
        return self.rocket_construction
    end
    local rockets = self.city.labels.AllRockets or empty_table
    for _, rocket in ipairs(rockets) do
        if rocket.landing_site and rocket.landing_site.landing_pad == self and (rocket_on_gnd_cmd[rocket.command] or rocket:IsLandAutomated()) then
            return true, rocket
        end
    end
    return false
end
