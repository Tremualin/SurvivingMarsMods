Tremualin_max_renegades_per_officer = 8
local vindication_points = 700
local training_type = 'vindication'
local securityStationBehavioralMelding = "Tremualin_SecurityStation_BehavioralMelding"
local securityStationCriminalPsychologists = "Tremualin_SecurityStation_CriminalPsychologists"
local securityStationVRTraining = "Tremualin_SecurityStation_VRTraining"

function Tremualin_RenegadesInRehabilitation(dome) 
  -- determine how many Renegades are in Rehabilitation
  local renegades_in_rehabilitation = {}
  for _, renegade in pairs(dome.labels.Renegade or empty_table) do
    if renegade.residence and renegade.residence.exclusive_trait == "Renegade" then
      table.insert(renegades_in_rehabilitation, renegade)
    end
  end
  return renegades_in_rehabilitation
end

function Tremualin_OfficersInSecurityStations(dome) 
  -- determine how many officers are working in security stations during this shift
  local officers_in_security_stations = {}
  for _, securityStation in pairs(dome.labels.SecurityStation or empty_table) do
    if securityStation.working then
      for _, officer in pairs(securityStation:GetWorkingWorkers()) do
        table.insert(officers_in_security_stations, officer)
      end
    end
  end
  return officers_in_security_stations
end

local function RemoveXTemplateSections(list, name)
  local idx = table.find(list, name, true)
  if idx then
    list[idx]:delete()
    table.remove(list, idx)
  end
end

local function GetPointsRolloverText(colonists)
  local text = {}
  for i = #colonists, 1, -1 do
    local colonist = colonists[i]
    colonist.training_points = colonist.training_points or {}
    local training_points = colonist.training_points[training_type] or 0

    text[i] = T(colonist:GetDisplayName()) .. "<right>"
      .. T{9766, "<percent(number)>",
        number = MulDivRound(training_points, 100, vindication_points),
      }
  end
  return table.concat(text, "<newline><left>")
end

-- A button that turns a residence into a rehabilitation center
function OnMsg.ClassesPostprocess()
  local template = XTemplates.sectionResidence
  RemoveXTemplateSections(template, "Tremualin_RehabilitationCenter")
  local rehabilitationInfo = PlaceObj("XTemplateTemplate", {
    "Tremualin_RehabilitationCenter", true,
    "__template", "InfopanelSection",
    "__context_of_kind", "Residence",
    "OnContextUpdate", function(self, context)
      if IsTechResearched("BehavioralShaping") then
       if context.exclusive_trait == "Renegade" then 
          self:SetRolloverText("Renegade progress towards rehabilitation:<newline>" .. GetPointsRolloverText(context.colonists))
          self:SetTitle("Rehabilitation Center")
          self:SetIcon("UI/Icons/Upgrades/behavioral_melding_01.tga")
        elseif context.exclusive_trait then
          self:SetVisible(false)
        else
          self:SetRolloverText("Not a rehabilitation center")
          self:SetTitle("Regular Residence")
          self:SetIcon("UI/Icons/Upgrades/behavioral_melding_02.tga")
        end
      else
        self:SetVisible(false)
      end
    end,
  },
  {
    PlaceObj("XTemplateFunc", {
      "name", "OnActivate(self, context)",
      "parent", function(self)
        return self.parent
      end,
      "func", function(self, context)
        -- we remove the trait if present, and reduce capacity
        if context.exclusive_trait == "Renegade" then
          context.exclusive_trait = nil
          context:CheckHomeForHomeless()
        elseif context.exclusive_trait then
          -- do nothing
        else
          context.exclusive_trait = "Renegade"
          -- first we process all colonists within the residence and kick out non-renegades
          for i = #context.colonists, 1, -1 do
            local colonist = context.colonists[i]
            if IsValid(colonist) then
              colonist:UpdateResidence()
            end
          end
          -- then we process all colonists within the dome to make sure all renegades move into rehabilitation centers
          -- we will process some colonists twice but I'm too lazy to care
          for i = #(context.parent_dome.labels.Colonist or empty_table), 1, -1 do
            local colonist = context.parent_dome.labels.Colonist[i]
            if IsValid(colonist) then
              colonist:UpdateResidence()
            end
          end 
        end
        -- If you modified a value then use this, if not remove
        ObjModified(context)
        RebuildInfopanel(context)
        ---
      end
    }),
  })

  table.insert(template, #template, rehabilitationInfo)
end

-- Gain rehabilitation points at the end of every shift
function OnMsg.NewWorkshift(shift)
  local remove_trait = "Renegade"
  local add_trait = "Vindicated"
  local domes = UICity.labels.Dome or empty_table
  for j = #domes, 1, -1 do
    local dome = domes[j]

    -- determine how many Renegades are in Rehabilitation
    local renegades_in_rehabilitation = Tremualin_RenegadesInRehabilitation(dome)

    -- determine how many officers are working in security stations during this shift
    local officers_in_security_stations = Tremualin_OfficersInSecurityStations(dome)

    -- split renegades on groups of Tremualin_max_renegades_per_officer
    -- so they can be treated by a security officer
    local table_key=1
    local renegades_per_officer_table = {}
    for i = #renegades_in_rehabilitation, 1, -1 do
      renegades_per_officer_table[table_key] = renegades_per_officer_table[table_key] or {}
      table.insert(renegades_per_officer_table[table_key], renegades_in_rehabilitation[i])
      if #renegades_per_officer_table[table_key] >= Tremualin_max_renegades_per_officer then
        table_key = table_key + 1
      end
    end

    -- for each officer; treat up to Tremualin_max_renegades_per_officer renegades
    table_key=1
    for _, officer in pairs(officers_in_security_stations) do
      for _, renegade in pairs(renegades_per_officer_table[table_key] or empty_table) do
        local gain_points = MulDivRound(5000 * renegade.stat_sanity/(100*const.Scale.Stat) * renegade.stat_comfort/(100*const.Scale.Stat) * renegade.residence.service_comfort/(100*const.Scale.Stat), officer.performance, 100)
        renegade.training_points = renegade.training_points or {}
        renegade.training_points[training_type] = (renegade.training_points[training_type] or 0) + gain_points
        if renegade.training_points[training_type] >= vindication_points then
          print("Removing renegade")
          renegade:RemoveTrait(remove_trait)
          local residence = renegade.residence
          residence.parent_dome.officers_with_benefits_rehabilitated = (residence.parent_dome.officers_with_benefits_rehabilitated or 0) + 1 
          residence:RemoveResident(renegade)
          if officer.workplace:HasUpgrade(securityStationBehavioralMelding) then
            renegade:AddTrait(add_trait)
            Msg("ColonistCured", renegade, residence, remove_trait, add_trait)
          else
            Msg("ColonistCured", renegade, residence, remove_trait, nil)
          end
        end
      end
      table_key = table_key + 1
    end
  end
end

local function AddBehavioralMeldingUpgrade(obj, id)
  obj.upgrade1_id = securityStationBehavioralMelding
  obj.upgrade1_description = Untranslated("Allows Renegades to become Vindicated")
  obj.upgrade1_display_name = T(5243, "Behavioral Melding")
  obj.upgrade1_icon = "UI/Icons/Upgrades/behavioral_melding_01.tga"
  obj.upgrade1_upgrade_cost_Polymers = 10000
  obj.upgrade1_upgrade_cost_Electronics = 10000
end

local function AddCriminalPsychologistsUpgrade(obj, id)
  obj.upgrade1_id = securityStationCriminalPsychologists
  obj.upgrade1_description = Untranslated("Increases the performance of the Security building by 10 if there's a medical building in the Dome. Doubled if the medical building is a Spire or a Hospital.")
  obj.upgrade1_display_name = T(5243, "Criminal Psychologists")
  obj.upgrade1_icon = "UI/Icons/Upgrades/factory_ai_01.tga"
  obj.upgrade1_upgrade_cost_Polymers = 8000
end

local function AddVRTrainingUpgrade(obj, id)
  obj.upgrade1_id = securityStationVRTraining
  obj.upgrade1_description = Untranslated("Allows workers to practice with the latest that VR has to offer, which increases the performance of the building by 10 + 1 for each percentage of people working at Workshops.")
  obj.upgrade1_display_name = T(5243, "Behavioral Melding")
  obj.upgrade1_icon = "UI/Icons/Upgrades/service_bots_01.tga"
  obj.upgrade1_upgrade_cost_Electronics = 8000
end

function SecurityStation:OnChangeWorkshift(old, new)
  Workplace.OnChangeWorkshift(self, old, new)
  if self:HasUpgrade(securityStationCriminalPsychologists) then
    local performanceBonus = 10
    local spire_or_hospital = false
    local dome = self.parent_dome
    for _, spire in ipairs(dome.labels.Spire or empty_table) do
      if spire.working and spire:IsKindOf("MedicalCenter") then
        spire_or_hospital = true
      end
    end
    if spire_or_hospital then
      performanceBonus = performanceBonus + 10
    end
    self:SetModifier("performance", "Tremualin_CriminalPsychologists", performanceBonus, 0, "<green>Access to criminal psychologists +".. performanceBonus .. "</color>")
  end
  if self:HasUpgrade(securityStationVRTraining) then
    local performanceBonus = 10 + city:GetWorkshopWorkersPercent()
    self:SetModifier("performance", "Tremualin_VRTraining", performanceBonus, 0, "<green>Access to high tech VR training +".. performanceBonus .. "</color>")
  end
end

local function AddBuilding(id, obj, obj_ct)
  -- If the template doesn't have the prop, check the class obj
  local template_id = obj.template_class
  if template_id == "" then
    template_id = obj.template_name
  end
 
  AddBehavioralMeldingUpgrade(obj, id)
  AddBehavioralMeldingUpgrade(obj_ct, id)
  AddCriminalPsychologistsUpgrade(obj, id)
  AddCriminalPsychologistsUpgrade(obj_ct, id)
  AddVRTrainingUpgrade(obj, id)
  AddVRTrainingUpgrade(obj_ct, id)
end

function OnMsg.ModsReloaded()
  local ct = ClassTemplates.Building
  local BuildingTemplates = BuildingTemplates

  for id, buildingTemplate in pairs(BuildingTemplates) do
    if id == "SecurityStation" then
      AddBuilding(id, buildingTemplate, ct[id])
    end
  end
end

function OnMsg.TechResearched(tech_id)
  if tech_id == "BehavioralMelding" then
    UnlockUpgrade(securityStationBehavioralMelding)
  end
  if tech_id == "SupportiveCommunity" then
    UnlockUpgrade(securityStationCriminalPsychologists)
  end
  if tech_id == "CreativeRealities" then
    UnlockUpgrade(securityStationVRTraining)
  end
end

-- Unlock BehavioralMelding upgrade for Security Stations
function StartupCode()
  local unlocked_upgrades = UICity.unlocked_upgrades
  if IsTechResearched("BehavioralMelding") then
    unlocked_upgrades[securityStationBehavioralMelding]=true
  end
   if IsTechResearched("SupportiveCommunity") then
    unlocked_upgrades[securityStationCriminalPsychologists]=true
  end 
  if IsTechResearched("CreativeRealities") then
    unlocked_upgrades[securityStationVRTraining]=true
  end 
end

OnMsg.LoadGame = StartupCode

-- Renegades under rehabilitation are negated, if security stations are properly staffed
local origin_Dome_GetAdjustedRenegades = Dome.GetAdjustedRenegades
function Dome:GetAdjustedRenegades()
  local renegades_in_rehabilitation = Tremualin_RenegadesInRehabilitation(dome)
  local officers_in_security_stations = Tremualin_OfficersInSecurityStations(dome)
  local negatedRehabilitationOfficers = Max(0, #renegades_in_rehabilitation - #officers_in_security_stations * Tremualin_max_renegades_per_officer)
  return Max(0, origin_Dome_GetAdjustedRenegades(self) - negatedRehabilitationOfficers )
end
