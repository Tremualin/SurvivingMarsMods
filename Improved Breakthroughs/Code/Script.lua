local breakthroughs = Presets.TechPreset.Breakthroughs

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
    if not UIColony:IsTechResearched("HiveMind") then
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
function modifyBreakthroughs()
    local breakthrough = breakthroughs["AlienImprints"]
    -- Alien Imprints always spawns 10 anomalies instead of a random number between 3 and 10
    breakthrough.param1 = 10

    breakthrough = breakthroughs["Vocation-Oriented Society"]
    -- Vocation-Oriented Society gives more 15 performance instead of 10
    breakthrough.param1 = 15

    breakthrough = breakthroughs["PlasmaRocket"]
    local alreadyDefined = false
    for _, effect in pairs(breakthrough) do
        if effect and type(effect) == "table" and effect:IsKindOf("Effect_ModifyLabel") and effect.Label == "AllRockets" then
            alreadyDefined = true
            break
        end
    end
    if not alreadyDefined then
        -- Plasma Rocket now offers a discount of 20 fuel to rockets
        -- Which means SpaceY rockets require no fuel at all
        table.insert(breakthrough, PlaceObj("Effect_ModifyLabel", {
            Amount = -20,
            Label = "AllRockets",
            Prop = "launch_fuel"
        }))
    end

    breakthrough = breakthroughs["SpaceRehabilitation"]
    -- SpaceRehabilitation chance of removing flaws increased to 100%
    breakthrough.param1 = 100

    BuildingTemplates.FungalFarm.upgrade1_mul_value_2 = 50
    ClassTemplates.Building.FungalFarm.upgrade1_mul_value_2 = 50
end

OnMsg.LoadGame = modifyBreakthroughs
OnMsg.CityStart = modifyBreakthroughs

-- Allows good vibrations to restore health
local orig_Colonist_Rest = Colonist.Rest
function Colonist:Rest()
    local residence = self.residence
    if residence and residence.working then
        local is_good_vibrations = (UIColony:IsTechResearched("GoodVibrations"))
        if is_good_vibrations then
            self:ChangeHealth(2500, "dome")
        end
    end
    orig_Colonist_Rest(self)
end

function OnMsg.ColonistDied(colonist, ...)
    local realm = GetRealm(colonist)
    local pt = realm:GetPassablePointNearby(colonist) or colonist:GetNavigationPos()
    if colonist.city.colony:IsTechResearched("SoylentGreen") then
        PlaceResourcePile(pt, "Food", 4 * const.ResourceScale, map_id)
    end
end
