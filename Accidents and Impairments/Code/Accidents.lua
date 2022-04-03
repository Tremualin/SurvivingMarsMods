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

local INJURY_BEST_HEALTH_LOSS = -5 * stat_scale
local INJURY_WORST_HEALTH_LOSS = -20 * stat_scale
local ACCIDENT_HEALTH_LOSS = -20 * stat_scale
local DEATH_CHANCES = 1

local UNHAPPY_WORKER_ACCIDENT_CHANCES = 5
local INDIFFERENT_WORKER_ACCIDENT_CHANCES = 1
local HAPPY_WORKER_ACCIDENT_CHANCES = -2

local function IncreaseAciddentsByType(worker, type)
    local dome = worker.dome
    dome.Tremualin_Accidents_Log[type] = dome.Tremualin_Accidents_Log[type] or 0
    if dome then
        dome.Tremualin_Accidents_Log[type] = dome.Tremualin_Accidents_Log[type] + 1
    end
end

-- Randomly applies (or not) an injury
local function TryGenerateInjury(worker, chances)
    local random_number = worker:Random(100)
    if random_number < chances then
        IncreaseAciddentsByType(worker, "Injuries")
        worker:ChangeHealth(worker:Random(INJURY_WORST_HEALTH_LOSS, INJURY_BEST_HEALTH_LOSS), "Got injured while working ")
    end -- random_number < chances
end -- function TryGenerateInjury

-- Randomly applies (or not) an accident
local function TryGenerateAccident(worker, chances)
    if chances > 0 then
        local random_number = worker:Random(1000)
        if random_number == DEATH_CHANCES then
            IncreaseAciddentsByType(worker, "Fatal")
            worker:SetCommand("Die", accident_death_reason_id)
            return
        end -- if random_number == 1

        if random_number < chances * 10 then
            local impairment = table.rand(impairments_list)
            worker:ChangeHealth(ACCIDENT_HEALTH_LOSS, "Had a terrible work accident ")
            if impairment ~= temporarily_impaired_status then
                IncreaseAciddentsByType(worker, impairment)
                worker:AddTrait(impairment)
            else
                IncreaseAciddentsByType(worker, temporarily_impaired_status)
            end -- if impairment ~= temporarily_impaired_status
            worker:Affect(temporarily_impaired_status, "start", false, "force")
        end -- random_number == 1
    end
end -- function TryGenerateAccident

function Colonist:GetTremualin_AccidentChances()
    local base_chances = debugging.AccidentBaseChances
    if self.workplace and self.workplace_shift and self.workplace.overtime and self.workplace.overtime[self.workplace_shift] then
        base_chances = base_chances + 2
    end -- if bld.overtime
    local chances = base_chances
    if functions.IsUnhappy(self) then
        chances = chances + UNHAPPY_WORKER_ACCIDENT_CHANCES
    elseif functions.IsHappy(self) then
        chances = chances + HAPPY_WORKER_ACCIDENT_CHANCES
    else
        chances = chances + INDIFFERENT_WORKER_ACCIDENT_CHANCES
    end -- if functions.IsUnhappy
    local traits_by_category = functions.TraitsByCategory(self.traits)
    return Max(0, chances + traits_by_category["Negative"] - traits_by_category["Positive"])
end

-- Randomly applies accidents and injuries to all workers
local function GenerateAccidentsAndInjuries(workshift)
    -- Sleep to prevent lag on large colonies
    Sleep(2000)
    for i, bld in ipairs(UIColony.city_labels.labels.Workplace or empty_table) do
        if IsValid(bld) then
            local AccidentOrInjuryFunction
            if bld.specialist or (bld.IsKindOf and (bld:IsKindOf("InsidePasture") or bld:IsKindOf("OpenPasture"))) then
                AccidentOrInjuryFunction = TryGenerateAccident
            else
                AccidentOrInjuryFunction = TryGenerateInjury
            end -- if bld.specialist

            local workers = bld:GetWorkingWorkers()
            for j, worker in ipairs(workers) do
                AccidentOrInjuryFunction(worker, worker:GetTremualin_AccidentChances())
            end -- for j, worker
        end -- if IsValid(bld)
    end -- for i, bld
end -- function GenerateAccidentsAndInjuries

GlobalVar("Tremualin_AccidentsThread", false)
function OnMsg.NewWorkshift(workshift)
    DeleteThread(Tremualin_AccidentsThread)
    Tremualin_AccidentsThread = CreateGameTimeThread(GenerateAccidentsAndInjuries, workshift)
end -- function OnMsg.NewWorkshift

local function InitializeAccidentsLog(dome)
    dome.Tremualin_Accidents_Log = {}
    for _, impairment in pairs(impairments_list) do
        dome.Tremualin_Accidents_Log[impairment] = 0
    end
    dome.Tremualin_Accidents_Log["Injuries"] = 0
    dome.Tremualin_Accidents_Log["Fatal"] = 0
end

-- Initialize the lifetime logs
function OnMsg.ClassesGenerate()
    local Tremualin_Orign_Dome_Init = Dome.Init
    function Dome:Init()
        Tremualin_Orign_Dome_Init(self)
        self.Tremualin_Accidents_Log = {}
    end
end

function SavegameFixups.InitializeAccidentsLog()
    MapForEach("map", "Dome", InitializeAccidentsLog)
end

-- Add the new death reason so it appears on the UI
function OnMsg.ClassesPostprocess()
    DeathReasons[accident_death_reason_id] = Untranslated("Fatal work accident")
end
