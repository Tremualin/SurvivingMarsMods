-- HiveMind applied to Residences
-- Copied over all the Arcology functions and applied them to all residences
function Residence:BuildingUpdate()
  self:ApplyHiveMindBonus()
end
function Residence:GetHiveMindBonus()
  local traits = {}
  -- Added flaws to reduce the effect of Hive Mind
  local flaws = {}
  local trait_defs = TraitPresets
  for _, unit in ipairs(self.colonists) do
    for trait_id in pairs(unit.traits) do
      if trait_id ~= "none" then
        local trait_def = trait_defs[trait_id]
        local cat = trait_def and trait_def.group
        if cat == "Positive" or cat == "Specialization" then
          traits[trait_id] = true
        elseif cat == "Negative" then
          flaws[trait_id] = true
        end
      end
    end
  end
  return Max(0, table.count(traits) - table.count(flaws))
end
Arcology.GetHiveMindBonus = Residence.GetHiveMindBonus
function Residence:ApplyHiveMindBonus()
  if not self.city:IsTechResearched("HiveMind") then
    return
  end
  local bonus = (self:GetHiveMindBonus())
  local display_name = TechDef.HiveMind.display_name
  for _, unit in ipairs(self.colonists) do
    unit:SetModifier("performance", "hive mind", bonus, 0, T(8570, "<green>Hive Mind <FormatSignInt(amount)></color>"))
  end
end
local org_Residence_AddResident = Residence.AddResident
function Residence:AddResident(unit)
  org_Residence_AddResident(self, unit)
  self:Notify("ApplyHiveMindBonus")
end
local org_Residence_RemoveResident = Residence.RemoveResident
function Residence:RemoveResident(unit)
  org_Residence_RemoveResident(self, unit)
  unit:SetModifier("performance", "hive mind", 0, 0)
  self:Notify("ApplyHiveMindBonus")
end

-- Modifies all the breakthroughs that are easy to modify
function OnMsg.ClassesPostprocess()
  for _, techPresets in pairs(Presets.TechPreset) do
      for key, value in pairs(techPresets) do
        if key == "AlienImprints" and not value.Tremualin_ImprovedBreakthrough then
          -- Alien Imprints always spawns 30 anomalies instead of a random number between 3 and 10
          value.param1 = 10
          value.Tremualin_ImprovedBreakthrough=true
          break
        end
        if key == "Vocation-Oriented Society" and not value.Tremualin_ImprovedBreakthrough then
          -- Vocation-Oriented Society gives more 15 performance instead of 10
          value.param1 = 15
          value.Tremualin_ImprovedBreakthrough=true
          break
        end
        if key == "PlasmaRocket" and not value.Tremualin_ImprovedBreakthrough then
          -- Plasma Rocket now offers a discount of 20 fuel to rockets
          -- Which means SpaceY rockets require no fuel at all
          table.insert(value, PlaceObj("Effect_ModifyLabel", {
            Amount = -20,
            Label = "AllRockets",
            Prop = "launch_fuel"
          }))
          value.Tremualin_ImprovedBreakthrough=true
          break
        end
        if key == "SpaceRehabilitation" and not value.Tremualin_ImprovedBreakthrough then
          -- SpaceRehabilitation chance of removing flaws increased to 100%
          value.param1 = 100
          value.Tremualin_ImprovedBreakthrough=true
          break
        end
      end
  end
end

-- Allows good vibrations to restore health
local orig_Colonist_Rest = Colonist.Rest
function Colonist:Rest()
  local residence = self.residence
  if residence and residence.working then
    local is_good_vibrations = (self.city:IsTechResearched("GoodVibrations"))
    if is_good_vibrations then 
      self:ChangeHealth(5000, "dome")
    end
  end
  orig_Colonist_Rest(self) 
end