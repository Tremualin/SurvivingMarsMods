
local Orig_Tremualin_Colonist_ChangeSanity = Colonist.ChangeSanity
function Colonist:ChangeSanity(amount, reason)
    if self.traits.Cynical then
        amount = amount / 2
    end
    Orig_Tremualin_Colonist_ChangeSanity(self, amount, reason)
end
