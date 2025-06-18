local functions = Tremualin.Functions

local physically_impaired = "PhysicallyImpaired"
local physically_impaired_forbidden = {"geologist", "engineer", "security"}
local intellectually_impaired = "IntellectuallyImpaired"
local intellectually_impaired_forbidden = {"scientist", "security", "medic"}
local all_specializations = {"geologist", "engineer", "scientist", "security", "medic", "botanist"}

local MEDICAL_EXPERTS_RECOVERY_CHANCE = 10
local FIT_RECOVERY_CHANCE = 10

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
    display_name = Untranslated("Recovering from an accident"),
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
        unit.Tremualin_impaired_recovery_chance = Max(100, unit.Tremualin_impaired_recovery_chance * 2)
        unit:ChangeSanity(self.temporarily_impaired_sanity_loss, self.temporarily_impaired_message)
    end -- unit:Random
end -- function StatusEffect_TemporarilyImpaired

function StatusEffect_TemporarilyImpaired:Start(unit, time)
    local spire_or_hospital = functions.HasMedicalSpireOrHospital(unit.dome)
    local recovery_chance = self.base_recovery_chance
    if spire_or_hospital then
        recovery_chance = recovery_chance + MEDICAL_EXPERTS_RECOVERY_CHANCE
    end -- if spire_or_hospital
    if unit.traits.Fit then
        recovery_chance = recovery_chance + FIT_RECOVERY_CHANCE
    end -- if unit.traits.Fit
    unit.Tremualin_impaired_recovery_chance = recovery_chance
    unit:SetWorkplace(false)
end -- function StatusEffect_TemporarilyImpaired

function StatusEffect_TemporarilyImpaired:Stop(unit)
    unit:UpdateEmploymentLabels()
    unit.Tremualin_impaired_recovery_chance = nil
end -- function StatusEffect_TemporarilyImpaired

-- Retrains a colonist's specialty based on that colonists impairments
function Colonist:RetrainBasedOnImpairments()
    if self.specialist ~= "none" then
        local allowed = table.copy(all_specializations)
        if self.traits.PhysicallyImpaired then
            allowed = table.subtraction(allowed, physically_impaired_forbidden)
        end
        if self.traits.IntellectuallyImpaired then
            allowed = table.subtraction(allowed, intellectually_impaired_forbidden)
        end
        if not table.find(allowed, self.specialist) then
            -- if the specialization is not allowed; find any other one among the allowed ones
            local selectedSpecialization = nil
            for _, specialization in pairs(allowed) do
                local needed = GetNeededSpecialistAround(self.dome, specialization)
                if needed > 0 then
                    selectedSpecialization = specialization
                end
            end
            -- if no specialization is needed; go with random among the allowed ones
            selectedSpecialization = table.rand(allowed)
            self.city:RemoveFromLabel(self.specialist, self)
            self:RemoveTrait(self.specialist)
            self.specialist = 'none'
            self.traits.none = true
            self:ChooseEntity()
            self:AddTrait(selectedSpecialization)
            self.city:AddToLabel(self.specialist, self)
            Msg("NewSpecialist", self)
        end
    end
    -- if the specialization is allowed, do nothing
end

-- Re-train impaired specialists after they go out of university so they become something compatible
function OnMsg.TrainingComplete(building, colonist)
    if building.training_type == "specialization" then
        colonist:RetrainBasedOnImpairments()
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
            return Untranslated("Still recovering<right>Chances tonight: " .. self.Tremualin_impaired_recovery_chance .. "%")
        end -- if self.status_effects.StatusEffect_TemporarilyImpaired
        return Tremualin_Orig_Colonist_GetUIWorkplaceLine(self)
    end --  function Colonist:GetUIWorkplaceLine

    -- Prevents the generation of impaired forbidden specialists
    local Tremualin_Orig_Colonist_Init = Colonist.Init
    function Colonist:Init()
        Tremualin_Orig_Colonist_Init(self)
        self:RetrainBasedOnImpairments()
    end
end -- function OnMsg.ClassesGenerate()
