local functions = Tremualin.Functions

local physically_impaired = "PhysicallyImpaired"
local physically_impaired_forbidden = {"botanist", "geologist", "engineer"}
local intellectually_impaired = "IntellectuallyImpaired"
local intellectually_impaired_forbidden = {"scientist", "security", "medic"}

-- Add incompatible traits to all buildings where impaired colonists can't work
function OnMsg.ClassesPostprocess()
    local ct = ClassTemplates.Building
    local BuildingTemplates = BuildingTemplates
    for id, buildingTemplate in pairs(BuildingTemplates) do
        if buildingTemplate.specialist and buildingTemplate.specialist ~= "none" then
            if table.find(physically_impaired_forbidden, buildingTemplate.specialist) then
                functions.AddIncompatibleTraits(buildingTemplate, ct[id], physically_impaired)
            elseif table.find(intellectually_impaired_forbidden, buildingTemplate.specialist) then
                functions.AddIncompatibleTraits(buildingTemplate, ct[id], intellectually_impaired)
            end -- if table.find
        elseif id == "InsidePasture" or id == "OpenPasture" then
            functions.AddIncompatibleTraits(buildingTemplate, ct[id], physically_impaired)
        end -- if buildingTemplate.specialist
    end -- for id, buildingTemplate
end -- function OnMsg.ClassesPostprocess

DefineClass.StatusEffect_TemporarilyImpaired = {
    __parents = {
        "StatusEffect"
    },
    display_name = Untranslated("Temporarily Impaired"),
    sign = "UnitSignAccidented",
    selection_arrow = "UnitArrowAccidented",
    priority = 70,
    popup_on_first = "FirstStatusEffect_Tremualin_Accident",
    popup_group = "FirstStatusEffect",
    base_recovery_chance = 10,
    temporarily_impaired_sanity_loss = -8 * const.Scale.Stat,
    temporarily_impaired_message = Untranslated("Still recovering from my accident "),
} -- DefineClass.StatusEffect_TemporarilyImpaired

function StatusEffect_TemporarilyImpaired:DailyUpdate(unit, start, hours)
    if unit:Random(100) < unit.Tremualin_impaired_recovery_chance then
        -- if the effect fades, remove it
        unit:Affect(self.class, false)
        unit:UpdateEmploymentLabels()
    else
        -- if the effect persists, double chances of recovery next time
        unit.Tremualin_impaired_recovery_chance = unit.Tremualin_impaired_recovery_chance * 2
        unit:ChangeSanity(self.temporarily_impaired_sanity_loss, self.temporarily_impaired_message)
    end -- unit:Random
end -- function StatusEffect_TemporarilyImpaired

function StatusEffect_TemporarilyImpaired:Start(unit, time)
    local spire_or_hospital = functions.HasMedicalSpireOrHospital(unit.dome)
    local recovery_chance = self.base_recovery_chance
    if spire_or_hospital then
        recovery_chance = recovery_chance + 10
    end -- if spire_or_hospital
    if unit.traits.Fit then
        recovery_chance = recovery_chance + 10
    end -- if unit.traits.Fit
    unit.Tremualin_impaired_recovery_chance = recovery_chance
    unit:SetWorkplace(false)
end -- function StatusEffect_TemporarilyImpaired

function StatusEffect_TemporarilyImpaired:Stop(unit)
    unit:UpdateEmploymentLabels()
    unit.Tremualin_impaired_recovery_chance = nil
end -- function StatusEffect_TemporarilyImpaired

-- Retrains a colonist's specialty based on that colonists impairments
local function RetrainColonistBasedOnImpairments(colonist)
    if colonist.specialist ~= "none" then
        local allowed = table.append(physically_impaired_forbidden, intellectually_impaired_forbidden)
        if colonist.PhysicallyImpaired then
            table.substraction(allowed, physically_impaired_forbidden)
        end
        if colonist.IntellectuallyImpaired then
            table.substraction(allowed, intellectually_impaired_forbidden)
        end
        if #allowed == 0 then
            -- should never execute; but just in case; if nothing is allowed, remove the specialization
            unit:RemoveTrait(colonist.specialist)
        elseif not table.find(allowed, colonist.specialist) then
            -- if the specialization is not allowed; find any other one among the allowed ones
            unit:RemoveTrait(colonist.specialist)
            for _, specialization in pairs(allowed) do
                local needed = GetNeededSpecialistAround(colonist.dome, specialization)
                if #needed > 0 then
                    unit:AddTrait(specialization)
                end
            end
            -- if no specialization is needed; go with random among the allowed ones
            if not colonist.specialist then
                unit:AddTrait(table.rand(allowed))
            end
        end
    end
    -- if the specialization is allowed, do nothing
end

-- Re-train impaired specialists after they go out of university so they become something compatible
function OnMsg.TrainingComplete(building, colonist)
    if building.training_type == "specialization" then
        RetrainColonistBasedOnImpairments(colonist)
    end
end

function OnMsg.ClassesGenerate()
    -- Temporarily impaired colonists can't work
    local Tremualin_Orig_Colonist_CanWork = Colonist.CanWork
    function Colonist:CanWork()
        return not self.status_effects.StatusEffect_TemporarilyImpaired and Tremualin_Orig_Colonist_CanWork(self)
    end --  function Colonist:CanWork

    -- Temporarily impaired colonists can't be assigned to workplaces
    local Tremualin_Orig_Workplace_ColonistCanInteract = Workplace.ColonistCanInteract
    function Workplace:ColonistCanInteract(col)
        if col.status_effects.StatusEffect_TemporarilyImpaired then
            return false, Untranslated("<red>Colonist is recovering from an accident</red>")
        else
            return Tremualin_Orig_Workplace_ColonistCanInteract(self, col)
        end -- if col.status_effects.StatusEffect_TemporarilyImpaired
    end -- function Workplace:ColonistCanInteract

    -- Temporarily impaired colonists should appear as such in the UI
    local Tremualin_Orig_Colonist_GetUIWorkplaceLine = Colonist.GetUIWorkplaceLine
    function Colonist:GetUIWorkplaceLine()
        if self.status_effects.StatusEffect_TemporarilyImpaired and self.Tremualin_impaired_recovery_chance then
            return Untranslated("Temporarily impaired<right>Chances of recovery: " .. self.Tremualin_impaired_recovery_chance .. "%")
        end -- if self.status_effects.StatusEffect_TemporarilyImpaired
        return Tremualin_Orig_Colonist_GetUIWorkplaceLine(self)
    end --  function Colonist:GetUIWorkplaceLine

    -- If both physically and intellectually impaired, they can't attend college
    local Tremualin_Orig_MartianUniversity_CanTrain = MartianUniversity.CanTrain
    function MartianUniversity:CanTrain(unit)
        if unit.traits.PhysicallyImpaired and unit.traits.IntellectuallyImpaired then
            return
        end -- end unit.traits.PhysicallyImpaired
        return Tremualin_Orig_MartianUniversity_CanTrain(self, unit)
    end -- end function MartianUniversity:CanTrain

    -- Prevents the generation of impaired forbidden specialists
    local Tremualin_Orig_GenerateColonistData = GenerateColonistData
    function GenerateColonistData(city, age_trait, martianborn, params)
        local colonist = Tremualin_Orig_GenerateColonistData(city, age_trait, martianborn, params)
        RetrainColonistBasedOnImpairments(colonist)
        return colonist
    end
end -- function OnMsg.ClassesGenerate()
