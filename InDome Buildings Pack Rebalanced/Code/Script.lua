-- Security Station should negate 2 Renegades per Officer
function OnMsg.ClassesPostprocess()
    SecurityStation.negated_renegades = 6
end

-- Security Post should negate 1/3 the Renegades of Security Station
local origin_SecurityStation_GetNegatedRenegades = SecurityStation.GetNegatedRenegades
function SecurityStation:GetNegatedRenegades()
    local negated_renegades = origin_SecurityStation_GetNegatedRenegades(self)
    if self.max_workers == 1 then
        return negated_renegades / 3
    else
        return negated_renegades
    end
end

-- Small security stations reduce the damage from disasters by 1/3 of that of bigger security stations
function Dome:GetSecurityStationDamageDecrease()
    local ss = self.labels.SecurityStation
    if not ss or #ss == 0 then
        return 0
    end
    local best_ss = (table.max(self.labels.SecurityStation, function(ss)
        if ss.max_workers == 1 then
            return ss.working and DivRound(ss.performance, 3) or 0
        else
            return ss.working and ss.performance or 0
        end
    end))
    return Clamp(best_ss.performance / 2, 0, 80)
end

-- Security Posts don't count as Security Stations
function OnMsg.ClassesPostprocess()
    BuildingTemplates.SecurityPostCCP1.label2 = "SecurityStation"
end
