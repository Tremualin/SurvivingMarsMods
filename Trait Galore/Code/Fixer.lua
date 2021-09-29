local print_debug = false

-- Fixer fixes buildings by this percentage
local fixer_percentage = 5

local function Fix_Building(building)
    if IsValid(building) and IsKindOfClasses(building, "RequiresMaintenance") and building:DoesRequireMaintenance() then
        if print_debug then print (string.format("%s is being fixed by fixer", building:GossipName())) end
        local maintenance = MulDivRound(building.maintenance_threshold_base, fixer_percentage, 100)
        building:AccumulateMaintenancePoints(-maintenance)
    end
end

function OnMsg.ClassesGenerate()
    -- Fixer fixes any service it visits
    local Treorig__Colonist_VisitService = Colonist.VisitService
    function Colonist:VisitService(service, need)
        if self.traits.Fixer then
            Fix_Building(service)
        end -- if self.traits
        return Treorig__Colonist_VisitService(self, service, need)
    end -- function Colonist:VisitService

    -- Fixer fixes it's residence
    local Treorig_Residence_Service = Residence.Service
    function Residence:Service(unit, duration)
        if unit.traits.Fixer then
            Fix_Building(self)
        end -- if unit.traits
        return Treorig_Residence_Service(self, unit, duration)
    end -- Residence:Service

    -- Fixer fixes it's workplace
    local Treorig_Colonist_WorkCycle = Colonist.WorkCycle
    function Colonist:WorkCycle()
        if self.traits.Fixer then
            Fix_Building(self.workplace)
        end -- if self.traits
        return Treorig_Colonist_WorkCycle(self)
    end -- function Colonist:WorkCycle
end -- function OnMsg.ClassesGenerate()
