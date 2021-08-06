local function isHappy(colonist)
  local high_stat_threshold = g_Consts.HighStatLevel
  return high_stat_threshold <= colonist.stat_morale and high_stat_threshold <= colonist.stat_health and high_stat_threshold <= colonist.stat_sanity and high_stat_threshold <= colonist.stat_comfort
end

local function isUnhappy(colonist) 
  local low_stat_threshold = g_Consts.LowStatLevel
  return low_stat_threshold > colonist.stat_morale or low_stat_threshold > colonist.stat_health or low_stat_threshold > colonist.stat_sanity or low_stat_threshold > colonist.stat_comfort
end

local function findVictims(perpetrator, colonists)
  local victims = {}
  for i = #colonists, 1, -1 do
    local victim = colonists[i]
    if IsValid(victim) and victim ~= perpetrator then
      table.insert(victims, victim)
    end
  end
  return victims
end

local function traitBasedChances(traits)
  local chances = 0
  for trait_id, _ in pairs(traits) do
    local trait = TraitPresets[trait_id]
    if trait then
      if trait.group == "Negative" then
        chances = chances + 1
      elseif trait.group == "Positive" then 
        chances = chances - 1
      end
    end
  end
  return chances
end

local function addSanityBreakdownFlaw(victim)
  local compatible = (FilterCompatibleTraitsWith(const.SanityBreakdownTraits, victim.traits))
  if 0 < #compatible then
    local dome = victim.dome
    if dome then
      dome.Tremualin_DomesticViolenceFlaws = dome.Tremualin_DomesticViolenceFlaws or 0
      dome.Tremualin_DomesticViolenceFlaws = dome.Tremualin_DomesticViolenceFlaws + 1
    end
    victim:AddTrait(table.rand(compatible))
  end
end

local function reportDomesticAssault(perpetrator)
  local dome = perpetrator.dome
  if dome then
    dome.Tremualin_DomesticViolenceReports = dome.Tremualin_DomesticViolenceReports or 0
    dome.Tremualin_DomesticViolenceReports = dome.Tremualin_DomesticViolenceReports + 1
  end
  perpetrator:AddTrait("Renegade")
  AddOnScreenNotification("Tremualin_Domestic_Violence_Report", false, {
    dome_name = perpetrator.dome:GetDisplayName(),
    perpetrator_name = perpetrator.name
  }, {
    perpetrator
  })
end

-- Domestic Violence
local report_chances = 33
local report_violent_chances = 11
local orig_Colonist_DailyUpdate = Colonist.DailyUpdate
function Colonist:DailyUpdate()
  local unhappy = isUnhappy(self)
  local traits = self.traits
  local dome = self.dome
  orig_Colonist_DailyUpdate(self)
  if dome and unhappy or traits.Renegade or traits.Violent then
    local chances = g_Consts.LowSanityNegativeTraitChance
    if traits.Violent and unhappy then 
      chances = 100
    else
      chances = traitBasedChances(traits) + chances
    end

    if self:Random(1, 100) <= chances then
      local victims = {}
      local residence = self.residence
      if residence and residence.exclusive_trait == "Renegade" then
        -- only find a victim if unsupervised
        local officers_in_security_stations = Tremualin_OfficersInSecurityStations(residence.parent_dome)
        local renegades_in_rehabilitation = Tremualin_RenegadesInRehabilitation(residence.parent_dome)
        -- are there more renegades in rehabilitation than officers to monitor them?
        if #renegades_in_rehabilitation > #officers_in_security_stations * Tremualin_max_renegades_per_officer then
          victims = findVictims(self, residence.colonists)
        end
      elseif residence and residence.colonists then 
        -- find victims in the same residence
        victims = findVictims(self, residence.colonists)
      elseif not residence then
        -- Homeless will find victims among other homeless
        victims = findVictims(self, dome.labels.Homeless)
      end

      if #victims > 0 then
        local victim = table.rand(victims)
        
        -- collect statistics 
        dome.Tremualin_DomesticViolenceAssaults = dome.Tremualin_DomesticViolenceAssaults or 0
        dome.Tremualin_DomesticViolenceAssaults = dome.Tremualin_DomesticViolenceAssaults + 1

        -- apply damage, reduced by security stations
        local damageDecrease = dome:GetSecurityStationDamageDecrease()
        local random_health_damage = - MulDivRound(self:Random(1, 15), const.Scale.Stat * (100 - damageDecrease), 100) 
        local random_sanity_damage = - MulDivRound(self:Random(1, 15), const.Scale.Stat * (100 - damageDecrease), 100) 
        victim:ChangeHealth(random_health_damage, "Domestic violence assault ")
        victim:ChangeSanity(random_sanity_damage, "Domestic violence assault ")

        if victim.traits.Child then
          -- child will have permanent scars
          victim.domestic_violence = true
        elseif self:Random(1, 100) <= g_Consts.LowSanityNegativeTraitChance then
          addSanityBreakdownFlaw(victim)
        end
        if self.traits.Child then
          -- violence is carried over to adulthood
          self.domestic_violence = true
        end
        -- Violent victims retaliate
        if victim.traits.Violent then
          dome.Tremualin_DomesticViolenceRetalations = dome.Tremualin_DomesticViolenceRetalations or 0
          dome.Tremualin_DomesticViolenceRetalations = dome.Tremualin_DomesticViolenceRetalations + 1
          self:ChangeHealth(random_health_damage, "Domestic violence retaliation ")
          self:ChangeSanity(random_sanity_damage, "Domestic violence retaliation ")
          if self:Random(1, 100) <= g_Consts.LowSanityNegativeTraitChance then
            addSanityBreakdownFlaw(self)
          end
          -- report the victim's retaliation
          if self:Random(1, 100) <= report_violent_chances then 
            reportDomesticAssault(victim)
          end
        end
        -- 33% chance of being reported and becoming a Renegade
        if not self.traits.Renegade and not self.traits.Child then 
          -- Violent people have lower chances of being reported to authorities
          if (self.traits.Violent and self:Random(1, 100) <= report_violent_chances) or (self:Random(1, 100) <= report_chances) then 
            reportDomesticAssault(self)
          end
        end
      end
    end
  end
end

-- Children who are victims of domestic violence get flaws 
function OnMsg.ColonistBecameYouth(colonist) 
  if colonist.domestic_violence then
    addSanityBreakdownFlaw(colonist)
  end
end

-- Shows stats on domestic violence in the Dome UI
function Dome:GetUISectionTremualinDomesticViolenceRollover()
  local domesticViolenceFlaws = self.Tremualin_DomesticViolenceFlaws or 0
  local domesticViolenceRetalations = self.Tremualin_DomesticViolenceRetalations or 0
  local domesticViolenceAssaults = self.Tremualin_DomesticViolenceAssaults or 0
  local domesticViolenceReports = self.Tremualin_DomesticViolenceReports or 0
  local items = {
    Untranslated("Domestic violence assaults: <right>" .. domesticViolenceAssaults),
    Untranslated("Renegades reported for domestic violence: <right>" .. domesticViolenceReports),
    Untranslated("Flaws gained due to domestic violence: <right>" .. domesticViolenceFlaws),
    Untranslated("Violent retaliations: <right>" .. domesticViolenceRetalations),
  }
  return table.concat(items, "<newline><left>")
end

local function RemoveXTemplateSections(list, name)
  local idx = table.find(list, name, true)
  if idx then
    list[idx]:delete()
    table.remove(list, idx)
  end
end

-- A panel that shows domestic violence in the Dome UI
function OnMsg.ClassesPostprocess()
  local template = XTemplates.sectionDome
  RemoveXTemplateSections(template, "Tremualin_DomesticViolenceLifetime")
  local tremualin_DomesticViolenceLifetime = PlaceObj("XTemplateTemplate", {
    "Tremualin_DomesticViolenceLifetime", true,
    "__context_of_kind", "Dome",
    "__template", "InfopanelSection",
    "RolloverText", Untranslated("<UISectionTremualinDomesticViolenceRollover>"),
    "Title", Untranslated("Information about domestic violence in the dome"),
    "Icon", "UI/Icons/Notifications/renegade.tga"
  })

  table.insert(template, #template, tremualin_DomesticViolenceLifetime)
end

local protests_text = {
  "Bring back the McRib",
  "I really really want a haircut",
  "Monorail! Monorail! Monorail! Monorail!",
  "Hustle culture is a lie, no more overtime",
  "Another day, another sanity breakdown",
  "Stop sending people to murder domes",
  "We live inside a simulation",
  "I'm just here for the violence",
  "I actually wanted to colonize the Moon",
  "I don't want to live on this planet anymore",
  "We are being coerced into making babies",
  "Soylent Green is people",
  "Stop breaking the 4th wall",
  "You should have chosen a different Sponsor",
  "Why bother Terraforming? I like dirt",
  "Growing older is getting murdered"
}

local function temporarilyModifyProperty(prop_to_modify, object_to_modify, unscaled_amount, percent, duration_in_sols, modifier_id, reason)
  local scale = ModifiablePropScale[prop_to_modify]
  local amount = unscaled_amount * scale
  -- Prevents the same thread from being assigned to the same modifier id again
  object_to_modify.Tremualin_Threads = object_to_modify.Tremualin_Threads or empty_table
  if IsValidThread(object_to_modify.Tremualin_Threads[modifier_id]) then
    DeleteThread(temporarilyModifyMorale.Tremualin_Threads[modifier_id])
  end
  object_to_modify:SetModifier(prop_to_modify, modifier_id, amount, percent, T({
    11887,
    "<color_tag><reason></color>",
    color_tag = 0 <= amount and 0 <= percent and TLookupTag("<green>") or TLookupTag("<red>"),
    reason = T({
      Untranslated(reason .. " <opt_amount(amount)> <opt_percent(percent)>"),
      amount = unscaled_amount,
      percent = percent
    })
  }))
  if (amount ~= 0 or percent ~= 0) and 0 < duration_in_sols then
    object_to_modify.Tremualin_Threads[modifier_id] = CreateGameTimeThread(function()
      -- 1 sol = 720000
      Sleep(duration_in_sols * 720000)
      -- If the colonist died; Let it go! Let it go! You'll never see me cry 
      if IsValid(object_to_modify) then 
        object_to_modify:SetModifier(prop_to_modify, modifier_id, 0, 0)
      end
    end)
  end
end

local function temporarilyModifyMorale(object_to_modify, unscaled_amount, percent, duration_in_sols, modifier_id, reason)
  return temporarilyModifyProperty("base_morale", object_to_modify, unscaled_amount, percent, duration_in_sols, modifier_id, reason)
end

-- Protests lower the morale of all non-renegades in the Dome for 1 sol
function Dome:Tremualin_CrimeEvents_Protest()
  for _, colonist in pairs(self.labels.Colonist or empty_table) do
    if not colonist.traits.Renegade then
      temporarilyModifyMorale(colonist, -self:GetAdjustedRenegades(), 0, 3, "Tremualin_CrimeEvents_Protest", "Annoying protesters ")
    end
  end

  AddOnScreenNotification("Tremualin_CrimeEvents_Protest", false, {
    dome_name = self:GetDisplayName(),
    protest_text = table.rand(protests_text)
  }, {
    self:GetPos()
  })
end

-- Vandalism fills the maintenance bar of a random building
function Dome:Tremualin_CrimeEvents_Vandalism()
  local buildings = (table.ifilter(self.labels.Building or empty_table, function(i, b)
    return IsValid(b) and b:CanDemolish() and b:UseDemolishedState()
  end))
  if #buildings == 0 then
    return
  end
  local vandalized_buildings = {}
  for i=1, self:GetAdjustedRenegades() do
    local building = self.city:TableRand(buildings)
    if building and building:DoesRequireMaintenance() then
      local maintenance = MulDivRound(building.maintenance_threshold_base, 4, 100)
      building:AccumulateMaintenancePoints(maintenance)
      table.insert(vandalized_buildings, building)
    end
  end
  if #buildings > 0 then
    AddOnScreenNotification("Tremualin_CrimeEvents_Vandalism", false, {
      dome_name = self:GetDisplayName(),
    }, vandalized_buildings)
  end
end

-- Stolen resources scale with the number of Renegades
function Dome:CrimeEvents_StoleResource()
  local res_filter = function(o, dome)
    if IsKindOfClasses(o, "SharedStorageBaseVisualOnly", "CargoShuttle") then
      return false
    end
    if "BlackCube" == o.resource or "WasteRock" == o.resource then
      return false
    end
    if IsKindOf(o, "ResourcePile") then
      return o:GetTargetAmount() >= const.ResourceScale
    else
      return o:GetStoredAmount() >= const.ResourceScale
    end
  end
  local resources_stockpile = (MapGet(self, self:GetOutsideWorkplacesDist() * const.HexHeight, "ResourceStockpileBase", res_filter, self))
  local count = #resources_stockpile
  if count <= 0 then
    return false
  end
  local rand_stockpile = 1 + self:Random(count)
  local stockpile = resources_stockpile[rand_stockpile]
  if IsKindOf(stockpile, "ResourcePile") then
    local stored_amount = (stockpile:GetTargetAmount())
    -- Modified by my mod (1 replace with self:GetAdjustedRenegades())
    local rand_res_amount = Min(stored_amount / const.ResourceScale, self:GetAdjustedRenegades()) * const.ResourceScale
    stockpile:AddResource(-rand_res_amount, stockpile.resource)
    AddOnScreenNotification("RenegadesStoleResources", false, {
      dome_name = self:GetDisplayName(),
      resource = FormatResource(self, rand_res_amount, stockpile.resource)
    }, {
      IsValid(stockpile) and stockpile
    })
    return true
  elseif IsKindOf(stockpile, "ResourceStockpile") then
    local storable_resource = stockpile.resource
    local stored_amount = (stockpile:GetStoredAmount())
    -- Modified by my mod (1 replace with self:GetAdjustedRenegades())
    local rand_res_amount = Min(stored_amount / const.ResourceScale, self:GetAdjustedRenegades()) * const.ResourceScale
    stockpile:AddResource(-rand_res_amount, storable_resource)
    AddOnScreenNotification("RenegadesStoleResources", false, {
      dome_name = self:GetDisplayName(),
      resource = FormatResource(self, rand_res_amount, storable_resource)
    }, {
      IsValid(stockpile) and stockpile
    })
    return true
  else
    local storable_resources = stockpile.storable_resources
    local resource_count = #storable_resources
    local stored_amount = {}
    local is_mech_depot = (IsKindOf(stockpile, "MechanizedDepot"))
    for i = 1, resource_count do
      local resource = storable_resources[i]
      local amount = is_mech_depot and stockpile:GetIOStockpileStoredAmount() or stockpile:GetStoredAmount(resource)
      if amount >= const.ResourceScale then
        stored_amount[#stored_amount + 1] = {resource, amount}
      end
    end
    local rand_type = 1 + self:Random(#stored_amount)
    local resorce_type = stored_amount[rand_type]
    -- Modified by my mod (1 replace with self:GetAdjustedRenegades())
    local rand_res_amount = Min(resorce_type[2] / const.ResourceScale, self:GetAdjustedRenegades()) * const.ResourceScale
    stockpile:AddResource(-rand_res_amount, resorce_type[1])
    AddOnScreenNotification("RenegadesStoleResources", false, {
      dome_name = self:GetDisplayName(),
      resource = FormatResource(self, rand_res_amount, resorce_type[1])
    }, {
      IsValid(stockpile) and stockpile
    })
    return true
  end
end

local renegadesPerSabotage=8
-- Buildings sabotaged now scales with the number of Renegades
function Dome:CrimeEvents_SabotageBuilding()
  local buildings = (table.ifilter(self.labels.Building or empty_table, function(i, b)
    return IsValid(b) and b:CanDemolish() and b:UseDemolishedState()
  end))
  if #buildings == 0 then
    return
  end
  local sabotaged_buildings = {}
  for i = 1, Max(1, self:GetAdjustedRenegades()/renegadesPerSabotage) do
    local building, idx = self.city:TableRand(buildings)
    if not building then
      return
    end
    table.remove(buildings, idx)
    if DestroyBuildingImmediate(building, false) then
      table.insert(sabotaged_buildings, building)
    end
  end
  if 0 < #sabotaged_buildings then
      AddOnScreenNotification("Tremualin_Renegades_Sabotage_Buildings", false, {
        dome_name = self:GetDisplayName(),
      }, sabotaged_buildings)
  end
  return 0 < #sabotaged_buildings
end

-- Colonists steal some money; no one knows how
function Dome:Tremualin_CrimeEvents_Embezzlement()
  local stolen_amount = MulDivRound(UICity.funding, self:GetAdjustedRenegades(), 100)
  UICity:ChangeFunding(-stolen_amount)

  AddOnScreenNotification("Tremualin_CrimeEvents_Embezzlement", false, {
    dome_name = self:GetDisplayName(),
    stolen_amount = stolen_amount
  }, {
    self:GetPos()
  })
end


-- RebelYell lowers min by 2
local crime_trigger = 4
local rebelYellMinus = 2
local crime_table = {
  Protest={ min=4, weight=24, event_function=Dome.Tremualin_CrimeEvents_Protest},
  Vandalism={ min=4, weight=24, event_function=Dome.Tremualin_CrimeEvents_Vandalism},
  Steal={ min=8, weight=18, event_function=Dome.CrimeEvents_StoleResource},
  Embezzlement={ min=8, weight=18, event_function=Dome.Tremualin_CrimeEvents_Embezzlement},
  Sabotage={ min=12, weight=12, event_function=Dome.CrimeEvents_SabotageBuilding}
}

-- Adding new types of crime
function Dome:CheckCrimeEvents()
  local is_rebel_rule = (IsGameRuleActive("RebelYell"))
  local count = (self:GetAdjustedRenegades())

  -- No crime if nothing can be triggered
  if (is_rebel_rule and count <= crime_trigger - rebelYellMinus) or count <= crime_trigger then
    return
  end

  if self:CanPreventCrimeEvents() then
    AddOnScreenNotification("PreventCrime", false, {
      dome_name = self:GetDisplayName()
    }, {
      self:GetPos()
    })
    return
  end
  local total_weight = 0
  local weighted_crimes = {}
  for crime_id, crime in pairs(crime_table) do
    local min = crime.min
    if is_rebel_rule then
      crime.min = crime.min - rebelYellMinus
    end

    if min <= count then
      total_weight = total_weight + crime.weight
      local weighted_crime = { weight=total_weight, event_function=crime.event_function}
      weighted_crimes[#weighted_crimes+1]=weighted_crime
    end
  end

  if total_weight > 0 then
    local random_number = self:Random(total_weight)
    for i=1, #weighted_crimes do
      local crime = weighted_crimes[i]
      if random_number <= crime.weight then
        crime.event_function(self)
        break
      end
    end
  end
end


-- Off-Duty Hero
local orig_Colonist_Suicide = Colonist.Suicide
function Colonist:Suicide()
  local saved = false
  local dome = self.dome
  if dome then 
    local supportive_community = IsTechResearched("SupportiveCommunity")
    local security_in_proximity = {}
    local security = dome.labels.security or empty_table
    for i = 1, #security do
      local unit = security[i]
      if self:Random(100) <= 5 then
        table.insert(security_in_proximity, unit)
      end
    end
    for i = 1, #security_in_proximity do
      local random = self:Random(100)
      print(random)
      local unit = security_in_proximity[i]
      if unit ~= self then 
        if supportive_community and random <= 10 or random <= 5 then
          temporarilyModifyMorale(unit, 10, 0, 3, "Tremualin_Suicide_Hero", "I saved a life ")
          unit:AddTrait("Celebrity")
          saved = true
          AddOnScreenNotification("Tremualin_Suicide_Hero", false, {
            dome_name = dome:GetDisplayName(),
            officer_name = unit.name,
            colonist_name = self.name
          }, {
            unit
          })
          break
        elseif supportive_community and random >= 99 or random>=95 then
          temporarilyModifyMorale(unit, -20, 0, 3, "Tremualin_Suicide_Failure", "They're dead... because of me ")
          AddOnScreenNotification("Tremualin_Suicide_Failure", false, {
            dome_name = dome:GetDisplayName(),
            officer_name = unit.name,
            colonist_name = self.name
          }, {
            unit
          })
          break
        end
      end
    end
  end
  if not saved then 
    orig_Colonist_Suicide(self)
  end
end