local TERRAFOMRING_SUBSIDIES_FUNDING = 1000
local subsidiesAlreadyGranted = {}

function OnMsg.TerraformThresholdPassed(id, fully_passed)
    if UIColony:IsTechResearched("TerraformingSubsidies") and fully_passed and not subsidiesAlreadyGranted[id] then
        UIColony.funds:ChangeFunding(500000000, "Sponsor")
        subsidiesAlreadyGranted[id] = true
    end
end
