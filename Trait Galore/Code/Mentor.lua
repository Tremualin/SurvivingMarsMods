local print_debug = false

local modifier_id = "Tremualin_Mentor_Bonus"
local mentee_performance_gain = 20
local mentoring_message = "<green>Being mentored +<amount></color>"

-- Mentors improve the performance of all other colonists in the same workplace
local Tremualin_Orig_Workplace_OnChangeWorkshift = Workplace.OnChangeWorkshift
function Workplace:OnChangeWorkshift(old, new)
    local working = self.working
    if new and working then
        local mentors = {}
        local workers = self.workers[new] or empty_table
        for _, worker in ipairs(workers) do
            worker:SetModifier("performance", modifier_id, 0, 0)
            if worker.traits.Mentor then
                table.insert(mentors, worker)
            end
        end
        -- No effect if the Mentor is the only worker
        if #mentors > 0 and #workers > 1 then
            -- Each Mentor mentors all other workers (including other mentors) once
            for _, mentor in ipairs(mentors) do
                for _, worker in ipairs(workers) do
                    if worker ~= mentor then
                        if worker.traits.Idiot and not mentor.traits.Idiot and worker:Random(100) <= mentor:Random(150) then
                            worker:RemoveTrait(worker.traits.Idiot)
                        end
                        local bonus = mentee_performance_gain
                        -- if the modifier already exists (most likely due to multiple mentors) then add them
                        local modifier = worker:FindModifier(modifier_id, "performance")
                        if modifier then
                            bonus = bonus + modifier.amount
                        end
                        if print_debug then print (string.format("Inspired by a Mentor : %s", worker:GetRenameInitText())) end
                        worker:SetModifier("performance", modifier_id, bonus, 0, mentoring_message)
                    end
                end
            end
        end
    end
    Tremualin_Orig_Workplace_OnChangeWorkshift(self, old, new)
end
