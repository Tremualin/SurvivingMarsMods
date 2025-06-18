local FITNESS_ICON = CurrentModPath .. "UI/fitness.png"
local FITNESS_STAT_ID = "Tremualin_Fitness"

local ui_functions = Tremualin.UIFunctions
local functions = Tremualin.Functions

local stat_scale = const.Scale.Stat
local max_stat = const.Scale.Stat * 100
local cutoff_time = 3

local FITNESS_DECAY_AMOUNT = const.Scale.Stat * -3
local FITNESS_DECAY_REASON = "Didn't exercise today "
local NUTRITION_BONUS = "Good nutrition "
local NUTRITION_PENALTY = "Bad nutrition "
local FITNESS_NUTRITION_GAIN_REASON = "Good nutrition and proper work "
local FITNESS_RAW_FOOD_LOSS = const.Scale.Stat * -2
local FITNESS_RAW_FOOD_REASON = "Had an unprepared meal "
local FITNESS_FIT_SANITY_GAIN_REASON = "Exercise feels natural (Fit) "
local FITNESS_UNFIT_SANITY_LOSS_REASON = "Exercise is a curse (Unfit) "
local FITNESS_FIT_SERVICE = const.Scale.Stat * 7
local FITNESS_SANITY_GAIN_OR_LOSS = const.Scale.Stat * 5
local FITNESS_DECORATION_SERVICE = const.Scale.Stat * 3
local FITNESS_OTHER_SERVICE = const.Scale.Stat * 5
local FITNESS_COACH_ICON = CurrentModPath .. "UI/fitness_coaches_01.tga"

-- Allows gyms to have multiple fitness coaches
-- They will no longer recover health, however
function ModifyGyms()
    functions.AddParentToClass(OpenAirGym, "ServiceWorkplace")
    templates = {BuildingTemplates.OpenAirGym, ClassTemplates.Building.OpenAirGym}
    BuildingTemplates.OpenAirGym.description = Untranslated("Allows visitors to gain Fitness points. Unfit visitors lose sanity while Fit visitors gain Sanity. Colonists become Fit if they visit it regularly.")
    if IsDlcAvailable("gagarin") then
        functions.AddParentToClass(TaiChiGarden, "ServiceWorkplace")
        table.insert(templates, BuildingTemplates.TaiChiGarden)
        table.insert(templates, ClassTemplates.Building.TaiChiGarden)
        BuildingTemplates.TaiChiGarden.description = Untranslated("The health benefits of martial arts are unquestionable. Allows visitors to gain Fitness points. Unfit visitors lose sanity while Fit visitors gain Sanity. Colonists become Fit if they visit it regularly.")
    end
    for _, template in ipairs(templates) do
        template.health_change = 0
        template.maintenance_resource_type = "Polymers"
        template.on_off_button = true
        template.prio_button = true
        template.automation = 1
        template.auto_performance = 100
        template.max_workers = 0
        template.incompatible_traits = {"Unfit"}
        template.upgrade1_id = "Fitness_Coaches"
        template.upgrade1_display_name = Untranslated("Fitness Coaches")
        template.upgrade1_description = Untranslated("Allows this building to employ two Fitness Coaches per shift, which can increase <em>Fitness</em>, <em>Comfort</em> and <em>Sanity</em> gained from visiting the building.\n<em>Unfit</em> colonists cannot become Fitness Coaches.\nUnstaffed shifts will still provide 100% performance.")
        template.upgrade1_icon = FITNESS_COACH_ICON
        template.upgrade1_mod_prop_id_1 = "service_comfort"
        template.upgrade1_add_value_1 = 10
        template.upgrade1_mod_prop_id_2 = "comfort_increase"
        template.upgrade1_add_value_2 = 5
        template.upgrade1_mod_prop_id_3 = "max_workers"
        template.upgrade1_add_value_3 = 2
    end
    -- Fit will no longer appear randomly as a trait - it must be earned
    TraitPresets.Fit.weight = 0
    TraitPresets.Fit.description = Untranslated("+5 health recovered while resting. Can work when health is low. Recovers +5 sanity when exercising.")
end

OnMsg.ClassesPreprocess = ModifyGyms

function OnMsg.ClassesGenerate()
    table.insert_unique(ColonistStatList, FITNESS_STAT_ID)
    ColonistStat.Tremualin_Fitness = {
        value = FITNESS_STAT_ID, text = Untranslated("Fitness"), log = "Tremualin_log_fitness",
        description = Untranslated("<em>Fitness</em> is a measure of the body's ability to function efficiently and effectively in work and leisure activities. Gyms (and Tai Chi Gardens) provide +7 base Fitness, Decorations provide +3 Fitness, while Hanging Gardens, Low-G Amusement Parks and Playgrounds provide +5 Fitness.\n\nFitness decays (-3) any day that the colonist hasn't exercised, and when eating unprepared food (-2).\n\nColonists with a low level of Fitness will become Unfit. <em>Unfit</em> colonists recover 50% less health from all sources, and lose (-5) sanity when visiting any service that provides exercise.\n\nColonists with a high level of Fitness will become Fit. <em>Fit</em> colonists can work with low health, recover more health (+5) each Sol and will recover sanity (+5) when visiting any service that provides exercise.\n\nFitness gains can be augmented by <em>proper nutrition</em>; Grocers and Diners will apply a multiplicative effect (based on their performance; could be negative) to the next exercise session.\nGyms no longer recover health on visit."),
        icon = FITNESS_ICON
    }

    function StatCombo()
        return function()
            return {
                ColonistStat
            }
        end
    end

    table.insert_unique(BaseInterests, "interestExercise")

    local Tremualin_Orig_Colonist_Init = Colonist.Init
    function Colonist:Init()
        Tremualin_Orig_Colonist_Init(self)
        self.Tremualin_stat_fitness = max_stat / 2
        self.Tremualin_log_fitness = {}
        self.Tremualin_Nutrition_Fitness_Bonus = 0
        self.Tremualin_daily_exercise = false
    end

    function Colonist:ChangeFitness(amount, reason)
        if amount == 0 then return end
        local old_value = self.Tremualin_stat_fitness
        local new_value = Clamp(old_value + amount, 0, max_stat)
        self.Tremualin_stat_fitness = new_value
        self:AddToLog(self.Tremualin_log_fitness, amount, reason)
        self:UpdateMorale()
    end

    function Colonist:GetTremualin_Fitness()
        return self.Tremualin_stat_fitness / stat_scale
    end

    local Tremualin_Orig_Colonist_DailyUpdate = Colonist.DailyUpdate
    function Colonist:DailyUpdate()
        if not self.Tremualin_daily_exercise then
            self:ChangeFitness(FITNESS_DECAY_AMOUNT, FITNESS_DECAY_REASON)
        end
        self.Tremualin_daily_exercise = false
        local time = UIColony.day - cutoff_time
        self:LogStatClear(self.Tremualin_log_fitness, time)
        if self.traits.Fit and self.Tremualin_stat_fitness < g_Consts.HighStatLevel then
            self:RemoveTrait("Fit")
        end
        if self.traits.Unfit and self.Tremualin_stat_fitness >= g_Consts.LowStatLevel then
            self:RemoveTrait("Unfit")
        end
        if self.Tremualin_stat_fitness < g_Consts.LowStatLevel and not self.traits.Unfit then
            self:AddTrait("Unfit")
        end
        if self.Tremualin_stat_fitness > g_Consts.HighStatLevel and not self.traits.Fit then
            self:AddTrait("Fit")
        end
        Tremualin_Orig_Colonist_DailyUpdate(self)
    end

    local Tremualin_Orig_Colonist_ChangeHealth = Colonist.ChangeHealth
    function Colonist:ChangeHealth(amount, reason)
        if self.traits.Unfit and amount > 0 then
            amount = amount / 2
        end
        Tremualin_Orig_Colonist_ChangeHealth(self, amount, reason)
    end

    local Tremualin_Orig_Colonist_VisitService = Colonist.VisitService
    function Colonist:VisitService(service, need)
        Tremualin_Orig_Colonist_VisitService(self, service, need)
        if service:IsOneOfInterests("interestExercise") or
            (self.traits.Child and service:IsOneOfInterests("interestPlaying")) then
            local fitness_gain = FITNESS_OTHER_SERVICE
            if service:GetBuildMenuCategory() == "Decorations" then
                fitness_gain = FITNESS_DECORATION_SERVICE
            elseif service:IsKindOf("FitService") then
                fitness_gain = MulDivRound(FITNESS_FIT_SERVICE, service.performance, 100)
            end
            self:ChangeFitness(fitness_gain, service.template_name)
            local fitness_nutrition_bonus = MulDivRound(fitness_gain, self.Tremualin_Nutrition_Fitness_Bonus, 100)
            if fitness_nutrition_bonus >= const.Scale.Stat then
                self:ChangeFitness(fitness_nutrition_bonus, NUTRITION_BONUS)
            elseif fitness_nutrition_bonus <= -const.Scale.Stat then
                self:ChangeFitness(fitness_nutrition_bonus, NUTRITION_PENALTY)
            end
            self.Tremualin_daily_exercise = true
        end
    end

    function FitService:Service(unit, duration)
        Service.Service(self, unit, duration)
        if unit.traits.Fit then
            unit:ChangeSanity(FITNESS_SANITY_GAIN_OR_LOSS, FITNESS_FIT_SANITY_GAIN_REASON)
        end
        if unit.traits.Unfit then
            unit:ChangeSanity(-FITNESS_SANITY_GAIN_OR_LOSS, FITNESS_UNFIT_SANITY_LOSS_REASON)
        end
    end

    local function SetRawFoodFitnessPenalty(unit)
        if unit.last_meal == DayStart then
            -- unit was able to ate today
            unit:ChangeFitness(FITNESS_RAW_FOOD_LOSS, FITNESS_RAW_FOOD_REASON)
            unit.Tremualin_Nutrition_Fitness_Bonus = 0
        end
    end

    local function SetPreparedFoodFitnessBonus(performance, unit)
        local nutrition_bonus = performance - 100
        if UIColony:IsTechResearched("MartianDiet") then
            nutrition_bonus = nutrition_bonus + 25
        end
        unit.Tremualin_Nutrition_Fitness_Bonus = nutrition_bonus
    end

    local Tremualin_Origin_Farm_Service = Farm.Service
    function Farm:Service(unit, duration)
        Tremualin_Origin_Farm_Service(self, unit, duration)
        SetRawFoodFitnessPenalty(unit)
    end
    local Tremualin_Origin_ResourceStockpileBase_Service = ResourceStockpileBase.Service
    function ResourceStockpileBase:Service(unit, duration)
        Tremualin_Origin_ResourceStockpileBase_Service(self, unit, duration)
        SetRawFoodFitnessPenalty(unit)
    end

    local Tremualin_Origin_ConsumptionResourceStockpile_Service = ConsumptionResourceStockpile.Service
    function ConsumptionResourceStockpile:Service(unit)
        Tremualin_Origin_ConsumptionResourceStockpile_Service(self, unit)
        SetRawFoodFitnessPenalty(unit)
    end

    local Tremualin_Orig_StatsChange_Service = StatsChange.Service
    function StatsChange:Service(unit, duration, reason, comfort_threshold, interest)
        if self.consumption_resource_type == "Food" then
            SetPreparedFoodFitnessBonus(self:GetEffectivePerformance(), unit)
        end
        return Tremualin_Orig_StatsChange_Service(self, unit, duration, reason, comfort_threshold, interest)
    end

    local Tremualin_Orig_Colonist_GetStat = Colonist.GetStat
    function Colonist:GetStat(stat)
        if stat == FITNESS_STAT_ID then
            return self.Tremualin_stat_fitness
        end
        return Tremualin_Orig_Colonist_GetStat(self, stat)
    end

    function Community:GetAverageFitness() return GetAverageStat(self.labels.Colonist, FITNESS_STAT_ID) end
end

local function InitMod()
    -- Initializes all colonist fitness variables
    for _, colonist in ipairs(UIColony.city_labels.labels.Colonist or empty_table) do
        colonist.Tremualin_stat_fitness = colonist.Tremualin_stat_fitness or max_stat / 2
        colonist.Tremualin_log_fitness = colonist.Tremualin_log_fitness or {}
        colonist.Tremualin_Nutrition_Fitness_Bonus = colonist.Tremualin_Nutrition_Fitness_Bonus or 0
        colonist.Tremualin_daily_exercise = colonist.Tremualin_daily_exercise or false
    end

    -- Unlocks the free upgrade "Fitness Coaches" which allows Gyms to work at enhanced performance while requiring workers
    UnlockUpgrade("Fitness_Coaches", MainCity)
end

OnMsg.LoadGame = InitMod
OnMsg.CityStart = InitMod

-- Workaround to make existing save games work
-- Gyms will have to be recreated for Fitness Coaches to work, however
function SavegameFixups.ReinitializeGyms()
    local initializeGym = function(o)
        ShiftsBuilding.Init(o)
        Workplace.Init(o)
        ShiftsBuilding.GameInit(o)
        Workplace.GameInit(o)
    end
    MapForEach("map", "OpenAirGym", initializeGym)
    if IsDlcAvailable("gagarin") then
        MapForEach("map", "TaiChiGarden", initializeGym)
    end
end
