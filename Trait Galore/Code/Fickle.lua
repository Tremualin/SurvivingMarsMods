local debug_fickle = false

-- Fickle colonists will randomly change interests when failing to satisfy them
local orig_Colonist_Idle = Colonist.Idle
function Colonist:Idle()
    orig_Colonist_Idle(self)
    if self.traits.Fickle and self.daily_interest ~= "" and 0 < self.daily_interest_fail then
        if debug_fickle then print("Fickle colonist changing interest") end
        self.daily_interest = PickInterest(self) or ""
    end
end
