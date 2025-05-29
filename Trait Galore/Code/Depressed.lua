local functions = Tremualin.Functions

function OnMsg.ClassesPostprocess()
    functions.AddTraitToSanityBreakdownTraits("Depressed")
end

-- Depressed colonists have 0 morale
local Orig_Tremualin_Colonist_GetMorale = Colonist.GetMorale
function Colonist:GetMorale()
    if self.traits.Depressed then
        return 0
    end
    return Orig_Tremualin_Colonist_GetMorale(self)
end
