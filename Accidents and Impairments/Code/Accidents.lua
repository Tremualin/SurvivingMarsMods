Tremualin.Debugging.AccidentBaseChances = 0

-- more performant this way
local Sleep = Sleep
local IsValid = IsValid
local DeleteThread = DeleteThread

local accident_death_reason_id = "Tremualin_Accident"

local functions = Tremualin.Functions
local debugging = Tremualin.Debugging
local stat_scale = const.Scale.Stat

local temporarily_impaired_status = "StatusEffect_TemporarilyImpaired"
local impairments_list = {temporarily_impaired_status, "IntellectuallyImpaired", "PhysicallyImpaired", "SensoryImpaired"}

-- Randomly applies (or not) an injury
local function TryGenerateInjury(worker, chances)
    local random_number = worker:Random(100)
    if random_number < chances then
        worker:ChangeHealth(worker:Random(5, 20), "Got injured while working ")
    end -- random_number < chances
end -- function TryGenerateInjury

-- Randomly applies (or not) an accident
local function TryGenerateAccident(worker, chances)
    if chances > 0 then
        local random_number = worker:Random(1000)
        if random_number == 1 then
            worker:SetCommand("Die", accident_death_reason_id)
            return
        end -- if random_number == 1

        if random_number < chances * 10 then
            local impairment = table.rand(impairments_list)
            worker:ChangeHealth(-20 * stat_scale, "Had a terrible work accident ")
            if impairment ~= temporarily_impaired_status then
                worker:AddTrait(impairment)
            end -- if impairment ~= temporarily_impaired_status
            worker:Affect(temporarily_impaired_status, "start", false, "force")
        end -- random_number == 1
    end
end -- function TryGenerateAccident

-- Randomly applies accidents and injuries to all workers
local function GenerateAccidentsAndInjuries(workshift)
    Sleep(2000)
    for i, bld in ipairs(UIColony.city_labels.labels.Workplace or empty_table) do
        if IsValid(bld) then
            local base_chances = debugging.AccidentBaseChances
            if bld.overtime and bld.overtime[workshift] then
                base_chances = base_chances + 2
            end -- if bld.overtime
            local AccidentOrInjuryFunction
            if bld.specialist or (bld.IsKindOf and (bld:IsKindOf("InsidePasture") or bld:IsKindOf("OpenPasture"))) then
                AccidentOrInjuryFunction = TryGenerateAccident
            else
                AccidentOrInjuryFunction = TryGenerateInjury
            end -- if bld.specialist

            local workers = bld:GetWorkingWorkers()
            for j, worker in ipairs(workers) do
                local chances = base_chances
                if functions.IsUnhappy(worker) then
                    chances = chances + 3
                elseif functions.IsHappy(worker) then
                    chances = chances - 1
                else
                    chances = chances + 1
                end -- if functions.IsUnhappy
                local traits_by_category = functions.TraitsByCategory(worker.traits)
                chances = chances + traits_by_category["Negative"] - traits_by_category["Positive"]
                AccidentOrInjuryFunction(worker, chances)
            end -- for j, worker
        end -- if IsValid(bld)
    end -- for i, bld
end -- function GenerateAccidentsAndInjuries

GlobalVar("Tremualin_AccidentsThread", false)
function OnMsg.NewWorkshift(workshift)
    DeleteThread(Tremualin_AccidentsThread)
    Tremualin_AccidentsThread = CreateGameTimeThread(GenerateAccidentsAndInjuries, workshift)
end -- function OnMsg.NewWorkshift

-- Add the new death reason so it appears on the UI
function OnMsg.ClassesPostprocess()
    DeathReasons[accident_death_reason_id] = Untranslated("Fatal work accident")
end