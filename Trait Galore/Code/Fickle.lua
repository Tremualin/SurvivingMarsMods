local print_debug = false

-- Fickle colonists will randomly change interests when failing to satisfy them
local Tremualin_Orig_Colonist_Idle = Colonist.Idle
function Colonist:Idle(...)
    if self.traits.Fickle and (self.daily_interest ~= "") and (self.daily_interest_fail > 0) then
        if print_debug then print("Fickle colonist changing interest") end
        self.daily_interest = PickInterest(self) or ""
        self.daily_interest_fail = 0
    end -- if self
    return Tremualin_Orig_Colonist_Idle(self, ...)
end -- function Colonist:Idle
