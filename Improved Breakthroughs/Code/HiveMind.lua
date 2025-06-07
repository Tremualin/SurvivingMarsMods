local HIVE_MIND_UPDATED_DESCRIPTION = Untranslated([[
Residents of any <em>Residence</em> get a bonus to work performance based on the number of unique traits (age, gender, specialization, perks, quirks) minus twice the number of unique flaws of colonists living in that residence.
 
<grey>"The tools that a society uses to create and maintain itself are as central to human life as a hive is to bee life. Though the hive is not part of any individual bee, it is part of the colony, both shaped by and shaping the lives of its inhabitants."<right>
Clay Shirky</grey><left>]])

local function UpdateHiveMindDescription()
    local tech = Presets.TechPreset.Breakthroughs.HiveMind
    tech.description = HIVE_MIND_UPDATED_DESCRIPTION
end
OnMsg.ClassesPostprocess = UpdateHiveMindDescription

-- HiveMind applied to Residences
-- Copied over all the Arcology functions and applied them to all residences
function Residence:BuildingUpdate()
    self:ApplyHiveMindBonus()
end

-- Diversity is good; specialization, age, gender, quirks, and so on.
-- Flaws are bad; they to reduce the effect of Hive Mind
function Residence:GetHiveMindBonus()
    local traits = {}
    local flaws = {}
    local trait_defs = TraitPresets
    for _, unit in ipairs(self.colonists) do
        for trait_id in pairs(unit.traits) do
            if trait_id ~= "none" then
                local trait_def = trait_defs[trait_id]
                local flaw = trait_def and trait_def.group and trait_def.group == "Negative"
                if flaw then
                    flaws[trait_id] = true
                else
                    traits[trait_id] = true
                end
            end
        end
    end
    return Max(0, table.count(traits) - table.count(flaws) * 2)
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

local Tremualin_Orig_Residence_AddResident = Residence.AddResident
function Residence:AddResident(unit)
    Tremualin_Orig_Residence_AddResident(self, unit)
    self:Notify("ApplyHiveMindBonus")

end
local Tremualin_Orig_Residence_RemoveResident = Residence.RemoveResident
function Residence:RemoveResident(unit)
    Tremualin_Orig_Residence_RemoveResident(self, unit)
    unit:SetModifier("performance", "hive mind", 0, 0)
    self:Notify("ApplyHiveMindBonus")
end
