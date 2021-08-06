-- Security Station should negate 2 Renegades per Officer
function OnMsg.ClassesPostprocess()
	SecurityStation.negated_renegades = 6
end

-- Security Post should negate 1/3 the Renegades of Security Station
local origin_SecurityStation_GetNegatedRenegades = SecurityStation.GetNegatedRenegades
function SecurityStation:GetNegatedRenegades()
  local negated_renegades = origin_SecurityStation_GetNegatedRenegades(self)
  if self.max_workers == 1 then
  	return negated_renegades/3
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

-- School Spire has a 2% chance of producing Genius as opposed to a 10% chance 
function OnMsg.ClassesPostprocess()
	BuildingTemplates.SchoolSpireCCP1.GeniusChance = 2
end

-- 3 Medical Posts = 1.2 Infirmaries
function OnMsg.ClassesPostprocess()
	BuildingTemplates.MedicalPostCCP1.max_visitors = 2
end

-- Smart Apartments require more electricity and Maintenance
function OnMsg.ClassesPostprocess()
	BuildingTemplates.SmartApartmentsCCP1.electricity_consumption = 16000
	BuildingTemplates.SmartApartmentsCCP1.maintenance_resource_amount = 1000
end

-- Adds a random rare trait instead of Genius
function SchoolSpire:OnTrainingCompleted(unit)
  local chance = unit.training_points and unit.training_points[self.training_type] or 0
  local rand = (self:Random(150))
  if chance >= rand then
    local traits = {}
    for i = 1, self.max_traits do
      traits[#traits + 1] = self["trait" .. i]
    end
    if self.upgrades_built[self.genius_upgrade] and self.upgrade_on_off_state[self.genius_upgrade] then
      if self:Random(100) <= self.GeniusChance then
        local trait = (GetRandomTrait(unit.traits, {}, {}, "Rare", "base"))
        if trait then
          unit:AddTrait(trait)
        end
      end
    end
    local compatible = (FilterCompatibleTraitsWith(traits, unit.traits))
    if 0 < #compatible then
      unit:AddTrait(table.rand(compatible))
    end
  end
  if unit.training_points then
    unit.training_points[self.training_type] = nil
    if not next(unit.training_points) then
      unit.training_points = false
    end
  end
end

-- Security Posts don't count as Security Stations
function OnMsg.ClassesPostprocess()
  BuildingTemplates.SecurityPostCCP1.label2 = "SecurityStation"
end
