
local orig_Colonist_ChangeSanity = Colonist.ChangeSanity
function Colonist:ChangeSanity(amount, reason)
    if self.traits.Cynical then
        amount = amount / 2
    end
    orig_Colonist_ChangeSanity(self, amount, reason)
end
