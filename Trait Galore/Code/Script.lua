function OnMsg.ClassesPostprocess()
    -- Depression can be gained through Sanity Breakdown
    if not const.SanityBreakdownTraits.Depressed then
        table.insert(const.SanityBreakdownTraits, "Depressed")
    end
end

-- Anxious colonists lose sanity whenever they try to visit some place and can't
local orig_Colonist_TryVisit = Colonist.TryVisit
function Colonist:TryVisit(need, ...)
    local fail = orig_Colonist_TryVisit(self, need, ...)
    if fail and self.traits.Anxious then
        self:ChangeSanity(-2* const.Scale.Stat , "Anxiety time (unable to immediately satisfy an interest) ")
    end
    return fail
end

-- Crafty colonists improve resources produced
local orig_Workplace_OnChangeWorkshift = Workplace.OnChangeWorkshift
function Workplace:OnChangeWorkshift(old, new)
    if self.production_per_day1 then 
        local working = self.working
        self:SetModifier("production_per_day1", "crafty_colonists", 0, 0)
        if new and working then
            local frugal_workers = 0
            local workers = self.workers[new]
            for _, worker in ipairs(workers) do
                if worker.traits.Crafty then
                    frugal_workers = frugal_workers + 1
                end
            end
            self:SetModifier("production_per_day1", "crafty_colonists", 0, 5 * frugal_workers, "<green>Crafty colonists find ways to make more with less</color>")
        end
    end
    orig_Workplace_OnChangeWorkshift(self, old, new)
end