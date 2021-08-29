local print_debug = false

local modifier_id = "Tremualin_Thrifty_Workers"
local thrifty_percentage = 5
local thrifty_bonus_message = "<green>Thrifty colonists find ways to make more with less</color>"

-- Changes the resource consumption of most workplaces
local orig_Workplace_OnChangeWorkshift = Workplace.OnChangeWorkshift
function Workplace:OnChangeWorkshift(old, new)
    if new then
        local thrifty_workers = 0
        local workers = self.workers[new]
        for _, worker in ipairs(workers) do
            if worker.traits.Thrifty then
                thrifty_workers = thrifty_workers + 1
            end
        end
        local consumption_amount_bonus = thrifty_percentage * thrifty_workers
        if HasConsumption.DoesHaveConsumption(self) then
            if print_debug then print (string.format("Thrifty workers changing resource consumption amount of %s by percentage : %d", self:GossipName(), consumption_amount_bonus)) end
            self:SetModifier("consumption_amount", modifier_id, 0, -consumption_amount_bonus, thrifty_bonus_message)
        elseif self.electricity_consumption then
            if print_debug then print (string.format("Thrifty workers changing electricity consumption amount of %s by percentage : %d", self:GossipName(), consumption_amount_bonus)) end
            self:SetModifier("electricity_consumption", modifier_id, 0, -consumption_amount_bonus, thrifty_bonus_message)
        end
    end
    orig_Workplace_OnChangeWorkshift(self, old, new)
end

-- Debugging Thrifty Workers
local orig_HasConsumption_Consume_Internal = HasConsumption.Consume_Internal
function HasConsumption:Consume_Internal(input_amount_to_consume)
    local amount = orig_HasConsumption_Consume_Internal(self, input_amount_to_consume)
    if print_debug then print (string.format("%s consuming %d resources", self:GossipName(), amount)) end
    return amount
end

-- Incompatible with other mods who change the same method
-- Changes the food consumption (which is hard-coded)
function HasConsumption:Consume_Visit(unit)
    if self.consumption_resource_type == "Food" then
        if GameTime() - unit.last_meal >= const.DayDuration then
            local max = self.consumption_stored_resources
            if unit.assigned_to_service_with_amount then
                max = (Min(max, unit.assigned_to_service_with_amount))
            end
            local use = (unit:Eat(max))
            if self.consumption_amount > 0 then
                use = (Min(use, self.consumption_amount))
            end
            return self:Consume_Internal(use)
        end
    else
        return self:Consume_Internal(self.consumption_amount)
    end
end
