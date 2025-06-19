local ORIG_MAX_TUNNEL_RANGE_2D = TunnelConstructionController.max_range * const.GridSpacing
-- Make Tunnels as large as you want!
TunnelConstructionController.max_range = 2000

local Orig_Tremualin_ConstructionSite_GetConstructionCost = ConstructionSite.GetConstructionCost
function ConstructionSite:GetConstructionCost(resource, mod_o)
    local original_cost = Orig_Tremualin_ConstructionSite_GetConstructionCost(self, resource, mod_o)
    if self and self.building_class
        and self.building_class == "Tunnel" then
        if self:GetConstructionGroupLeader() == self then
            local distance = self.construction_group[2]:GetDist2D(self.construction_group[3])
            local modified_cost = MulDivRound(original_cost, distance, ORIG_MAX_TUNNEL_RANGE_2D)
            return modified_cost
        end
    end
    return original_cost
end

function TunnelConstructionController:GetConstructionCostAmounts()
    if not self:HasConstructionCost() then
        return
    end

    local placed_obj = self.placed_obj
    local cursor_obj = self.cursor_obj
    local costs = {}
    local mod_o = GetModifierObject(self.template_obj.template_name)
    for _, resource in ipairs(ConstructionResourceList) do
        local amount = UIColony.construction_cost:GetConstructionCost(self.template_obj, resource, mod_o)
        if amount > 0 then
            local modified_amount = amount
            if placed_obj and cursor_obj then
                local distance = self.placed_obj:GetDist2D(self.cursor_obj)
                modified_amount = MulDivRound(amount, distance, ORIG_MAX_TUNNEL_RANGE_2D)
            end
            costs[resource] = modified_amount
        end
    end

    return costs
end
