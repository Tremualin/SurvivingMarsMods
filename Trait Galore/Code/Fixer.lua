local print_debug = false

-- Fixer fixes buildings by this percentage
local fixer_percentage = 5

local function fix_building(building)
    if IsValid(building) and IsKindOfClasses(building, "RequiresMaintenance") and building:DoesRequireMaintenance() then
        if print_debug then print (string.format("%s is being fixed by fixer", building:GossipName())) end
        local maintenance = MulDivRound(building.maintenance_threshold_base, fixer_percentage, 100)
        building:AccumulateMaintenancePoints(-maintenance)
    end
end

-- Fixer fixes any service it visits
local orig_Colonist_VisitService = Colonist.VisitService
function Colonist:VisitService(service, need)
    if self.traits.Fixer then
        fix_building(service)
    end
    orig_Colonist_VisitService(self, service, need)
end

-- Fixer fixes it's residence
local orig_Residence_Service = Residence.Service
function Residence:Service(unit, duration)
    if unit.traits.Fixer then
        fix_building(self)
    end
    orig_Residence_Service(self, unit, duration)
end

-- Fixer fixes it's workplace
local orig_Colonist_WorkCycle = Colonist.WorkCycle
function Colonist:WorkCycle()
    if self.traits.Fixer then
        fix_building(self.workplace)
    end
    orig_Colonist_WorkCycle(self)
end
