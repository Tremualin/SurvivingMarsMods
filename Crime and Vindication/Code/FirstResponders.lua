Tremualin.Debugging.FirstResponders = false
local functions = Tremualin.Functions
local debugging = Tremualin.Debugging

-- First responders
local orig_Dome_GetDomeComfort = Dome.GetDomeComfort
function Dome:GetDomeComfort()
    local securityStationComfort = 0
    if UIColony:IsTechResearched("EmergencyTraining") then
        local officers_in_security_stations = functions.OfficersInSecurityStations(self)
        for _, officer in pairs(officers_in_security_stations) do
            securityStationComfort = securityStationComfort + officer.performance * 2 / 100
        end
    end
    securityStationComfort = MulDivRound(securityStationComfort, const.Scale.Stat, 1)
    if debugging.FirstResponders then print(string.format("%.0f comfort gained from First Responders", securityStationComfort)) end
    return orig_Dome_GetDomeComfort(self) + securityStationComfort
end
