Tremualin_max_renegades_per_officer = 8
local vindication_points = 700
local vindication_points_per_shift = 70
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

local function GetPointsRolloverText(residence)
  local text = {}
  local colonists = residence.colonists
  for i = #colonists, 1, -1 do
    local colonist = colonists[i]
    colonist.training_points = colonist.training_points or {}
    local training_points = colonist.training_points[training_type] or 0

    text[i] = T(colonist:GetDisplayName()) .. "<right>"
      .. T{9766, "<percent(number)>",
        number = MulDivRound(training_points, 100, vindication_points),
      }
  end
  text[#text+1] = Untranslated("<newline>Lifetime cured: <right>" .. (residence.total_cured or 0))
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
          self:SetRolloverText("Renegade progress towards rehabilitation:<newline><newline>" .. GetPointsRolloverText(context))
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
        local gain_points = MulDivRound(vindication_points_per_shift * renegade.stat_sanity/(100*const.Scale.Stat) * renegade.stat_comfort/(100*const.Scale.Stat) * renegade.residence.service_comfort/(100*const.Scale.Stat), officer.performance, 100)
        renegade.training_points = renegade.training_points or {}
        renegade.training_points[training_type] = (renegade.training_points[training_type] or 0) + gain_points
        if renegade.training_points[training_type] >= vindication_points then
          renegade:RemoveTrait(remove_trait)
          local residence = renegade.residence
          residence.parent_dome.officers_with_benefits_rehabilitated = (residence.parent_dome.officers_with_benefits_rehabilitated or 0) + 1 
          residence:RemoveResident(renegade)
          residence.total_cured = (residence.total_cured or 0) + 1
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
  obj.upgrade2_id = securityStationCriminalPsychologists
  obj.upgrade2_description = Untranslated("Increases the performance of the Security building by 10 if there's a medical building in the Dome. Doubled if the medical building is a Spire or a Hospital.")
  obj.upgrade2_display_name = Untranslated("Criminal Psychologists")
  obj.upgrade2_icon = "UI/Icons/Upgrades/factory_ai_01.tga"
  obj.upgrade2_upgrade_cost_Polymers = 8000
end

local function AddVRTrainingUpgrade(obj, id)
  obj.upgrade3_id = securityStationVRTraining
  obj.upgrade3_description = Untranslated("Allows workers to practice with the latest that VR has to offer, which increases the performance of the building by 10 + 1 for each percentage of people working at Workshops.")
  obj.upgrade3_display_name = Untranslated("VR training")
  obj.upgrade3_icon = "UI/Icons/Upgrades/service_bots_01.tga"
  obj.upgrade3_upgrade_cost_Electronics = 8000
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
    local performanceBonus = 10 + UICity:GetWorkshopWorkersPercent()
    self:SetModifier("performance", "Tremualin_VRTraining", performanceBonus, 0, "<green>Access to high tech VR training +".. performanceBonus .. "</color>")
  end
  -- Law-Law Land: fire all Renegades from security stations
  if new then 
    for _, worker in ipairs(self.workers[new] or empty_table) do
      if not self:IsSuitable(worker) then
        self:FireWorker(worker)
      end
    end
  end
  RebuildInfopanel(self)
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

-- Law-Law Land: Renegades cannot work on security buildings anymore
function OnMsg.LoadGame()
  local ct = ClassTemplates.Building
  local BuildingTemplates = BuildingTemplates

  for id, buildingTemplate in pairs(BuildingTemplates) do
    if id == "SecurityStation" then
      AddBuilding(id, buildingTemplate, ct[id])
      -- Don't allow Renegades to work on Security Stations
      buildingTemplate.incompatible_traits = {"Renegade"}
      ct[id].incompatible_traits = {"Renegade"}
    end
  end
end

function StartupCode(...)
  local unlocked_upgrades = UICity.unlocked_upgrades
  if IsTechResearched("BehavioralMelding") then
    UnlockUpgrade(securityStationBehavioralMelding)
  end
   if IsTechResearched("SupportiveCommunity") then
    UnlockUpgrade(securityStationCriminalPsychologists)
  end 
  if IsTechResearched("CreativeRealities") then
    UnlockUpgrade(securityStationVRTraining)
  end

  ColonistPerformanceReasons["Vindicated"] = Untranslated("Vindicated in the eyes of society <amount>")
end

OnMsg.TechResearched = StartupCode
OnMsg.LoadGame = StartupCode

-- Renegades under rehabilitation are negated, if security stations are properly staffed
local origin_Dome_GetAdjustedRenegades = Dome.GetAdjustedRenegades
function Dome:GetAdjustedRenegades()
  local renegades_in_rehabilitation = Tremualin_RenegadesInRehabilitation(self)
  local officers_in_security_stations = Tremualin_OfficersInSecurityStations(self)
  local negatedRehabilitationOfficers = Max(0, #renegades_in_rehabilitation - #officers_in_security_stations * Tremualin_max_renegades_per_officer)
  return Max(0, origin_Dome_GetAdjustedRenegades(self) - negatedRehabilitationOfficers )
end

-- Renegades in rehabilitation don't count
function Dome:CanPreventCrimeEvents()
  local officers = #(self.labels.security or empty_table)
  local renegades = #(self.labels.Renegade or empty_table) - #Tremualin_RenegadesInRehabilitation(self)
  if officers <= renegades then
    return false
  end
  local stations = self.labels.SecurityStation or empty_table
  for _, station in ipairs(stations) do
    if station.working then
      local chance = 50
      if officers <= renegades * 3 then
        chance = (MulDivRound(officers, 100, 6 * renegades))
      end
      return chance >= Random(0, 100)
    end
  end
  return false
end

-- First responders
local orig_Dome_GetDomeComfort = Dome.GetDomeComfort
function Dome:GetDomeComfort()
  local securityStationComfort = 0
  if IsTechResearched("EmergencyTraining") then
    local officers_in_security_stations = Tremualin_OfficersInSecurityStations(self)
    for _, officer in pairs(officers_in_security_stations) do
      securityStationComfort = securityStationComfort + MulDivRound(officer.performance, 2, 100)
    end
  end
  return orig_Dome_GetDomeComfort(self) + securityStationComfort
end
