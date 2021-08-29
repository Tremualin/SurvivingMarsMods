local functions = Tremualin.Functions

local anxious_sanity_loss = -2 * const.Scale.Stat
local anxious_sanity_loss_message = "Unable to immediately satisfy an interest (Anxious) "

function OnMsg.ClassesPostprocess()
    functions.AddTraitToSanityBreakdownTraits("Anxious")
end

-- Anxious colonists lose sanity whenever they try to visit some place and they can't
local orig_Colonist_TryVisit = Colonist.TryVisit
function Colonist:TryVisit(need, ...)
    local fail = orig_Colonist_TryVisit(self, need, ...)
    if fail and self.traits.Anxious then
        self:ChangeSanity(anxious_sanity_loss, anxious_sanity_loss_message)
    end
    return fail
end
