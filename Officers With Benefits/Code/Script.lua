local function isHappy(colonist)
  local high_stat_threshold = g_Consts.HighStatLevel
  return high_stat_threshold <= colonist.stat_morale and high_stat_threshold <= colonist.stat_health and high_stat_threshold <= colonist.stat_sanity and high_stat_threshold <= colonist.stat_comfort
end

local function isUnhappy(colonist) 
  local low_stat_threshold = g_Consts.LowStatLevel
  return low_stat_threshold > colonist.stat_morale or low_stat_threshold > colonist.stat_health or low_stat_threshold > colonist.stat_sanity or low_stat_threshold > colonist.stat_comfort
end

local function findVictims(perpetrator, residence)
  local victims = {}
  for i = #residence.colonists, 1, -1 do
    local victim = residence.colonists[i]
    if IsValid(victim) and victim ~= perpetrator then
      table.insert(victim, victims)
    end
  end
  return victims
end

-- Domestic Violence
local orig_Colonist_DailyUpdate = Colonist.DailyUpdate
function Colonist:DailyUpdate()
  orig_Colonist_DailyUpdate(self)
  if isUnhappy(self) then
    local chances = g_Consts.LowSanityNegativeTraitChance
    for _, trait in pairs(self.traits) do
      if trait.group == "Negative" then
        chances = chances + 1
      elseif trait.group == "Positive" then 
        chances = chances - 1
      end
    end
      
    if self:Random(100) < chances then
      local victims = {}
      local residence = self.residence
      if residence and residence.exclusive_trait == "Renegade" then
        -- only find a victim if unsupervised
        local officers_in_security_stations = Tremualin_OfficersInSecurityStations(residence.parent_dome)
        local renegades_in_rehabilitation = Tremualin_RenegadesInRehabilitation(residence.parent_dome)
        -- are there more renegades in rehabilitation than officers to monitor them?
        if #renegades_in_rehabilitation > #officers_in_security_stations * Tremualin_max_renegades_per_officer then
          victims = findVictims(self, residence)
        end
      elseif residence and residence.colonists then 
        victims = findVictims(self, residence)
      end

      if #victims > 0 then
        local random_number = math.random(0, #victims)
        local victim = victims[random_number]
        local random_damage = - math.random(5, 15)
        victim:ChangeHealth(random_damage * const.Scale.Stat, "Domestic violence assault")
        victim:ChangeSanity(random_damage * const.Scale.Stat, "Domestic violence assault")
        if victim.Child then 
          -- child will have permanent scars
        else 
          local compatible = (FilterCompatibleTraitsWith(const.SanityBreakdownTraits, victim.traits))
          if 0 < #compatible then
            victim:AddTrait(table.rand(compatible))
          end
        end
        -- 33% chance of becoming a Renegade
        if not self.traits.Renegade then 
          if self:Random(100) <= 33 then 
            self:AddTrait("Renegade")
          end
        end
      end
    end
  end
end

-- Embezzlement and Attempted Assassinations
function Dome:CheckCrimeEvents()
  local count = (self:GetAdjustedRenegades())
  if count <= 3 then
    return
  end
  if self:CanPreventCrimeEvents() then
    AddOnScreenNotification("PreventCrime", false, {
      dome_name = self:GetDisplayName()
    }, self)
    return
  end
  local crime_count = IsGameRuleActive("RebelYell") and 7 or 12
  local medium_crime_count = crime_count + 5
  local large_crime_count = large_crime_count + 5
  if count <= crime_count then
    self:CrimeEvents_StoleResource()
  elseif crime > crime_count and crime <= medium_crime_count then 
    -- sabotage
    if not self:CrimeEvents_SabotageBuilding() then 
      self:CrimeEvents_StoleResource()
    end
  elseif crime > medium_crime_count and crime <= large_crime_count then
    -- embezzlement
  elseif crime > large_crime_count then 
    -- assassinations
  end
end