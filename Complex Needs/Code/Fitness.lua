local ui_functions = Tremualin.UIFunctions
local functions = Tremualin.Functions

local stat_scale = const.Scale.Stat
local max_stat = const.Scale.Stat * 100
local cutoff_time = 3

local FITNESS_STAT_ID = "Tremualin_Fitness"
local FITNESS_DECAY_AMOUNT = const.Scale.Stat * -4
local FITNESS_DECAY_REASON = "Didn't workout today "
local NUTRITION_BONUS = "Good nutrition "
local NUTRITION_PENALTY = "Bad nutrition "
local FITNESS_NUTRITION_GAIN_REASON = "Good nutrition and proper work "
local FITNESS_RAW_FOOD_LOSS = const.Scale.Stat * -2
local FITNESS_RAW_FOOD_REASON = "Had an unprepared meal "
local FITNESS_FIT_SANITY_GAIN_REASON = "I love exercise (Fit) "
local FITNESS_UNFIT_SANITY_LOSS_REASON = "I hate exercise (Unfit) "
local FITNESS_FIT_SERVICE = const.Scale.Stat * 10
local FITNESS_DECORATION_SERVICE = const.Scale.Stat * 4
local FITNESS_OTHER_SERVICE = const.Scale.Stat * 7

function OnMsg.ClassesGenerate()
    table.insert_unique(ColonistStatList, FITNESS_STAT_ID)
    ColonistStat.Tremualin_Fitness = {
        value = FITNESS_STAT_ID, text = Untranslated("Fitness"), log = "Tremualin_log_fitness",
        description = Untranslated("Fitness is a measure of the body's ability to function efficiently and effectively in work and leisure activities. Gyms (and Tai Chi Gardens) provide +10 Fitness, Decorations provide +4 Fitness, while Hanging Gardens and Low-G Amusement Parks provide +7 Fitness.\n\nFitness decays (-4) any day that the colonist hasn't exercised, and when eating unprepared food (-2).\n\nColonists with a low level of Fitness will become Unfit. Unfit colonists lose Sanity each Sol, recover 50% less health from all sources, and lose sanity when visiting any service that provides exercise.\n\nColonists with a high level of Fitness will become Fit. Fit colonists can work with low health, recover more health (+5) each Sol and will recover sanity (+5) when visiting any service that provide exercise.\n\nFitness gains can be augmented by proper nutrition; Grocers and Diners will apply a multiplicative effect (based on their performance; could be negative) to the next exercise session.\n\nChildren gain +10 Fitness from playing.\nGyms no longer recover health on visit."),
        icon = "UI/Icons/Sections/workshifts.tga"
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
        Tremualin_Orig_Colonist_DailyUpdate(self)
    end

    local Tremualin_Orig_Colonist_VisitService = Colonist.VisitService
    function Colonist:VisitService(service, need)
        Tremualin_Orig_Colonist_VisitService(self, service, need)
        if service:IsOneOfInterests("interestExercise") or
            (self.traits.Children and service:IsOneOfInterests("interestPlaying")) then
            local fitness_gain = FITNESS_OTHER_SERVICE
            if (service:GetBuildMenuCategory() == "Decorations") then
                fitness_gain = FITNESS_DECORATION_SERVICE
            elseif (service:IsKindOf("FitService") or service:IsKindOf("Playground")) then
                fitness_gain = FITNESS_FIT_SERVICE
            end
            self:ChangeFitness(fitness_gain, service.template_name)
            local fitness_nutrition_bonus = MulDivRound(fitness_gain, self.Tremualin_Nutrition_Fitness_Bonus, 100)
            if fitness_nutrition_bonus > 0 then
                self:ChangeFitness(fitness_nutrition_bonus, NUTRITION_BONUS)
            elseif fitness_nutrition_bonus < 0 then
                self:ChangeFitness(fitness_nutrition_bonus, NUTRITION_PENALTY)
            end
            self.Tremualin_daily_exercise = true
        end
    end

    function FitService:Service(unit, duration)
        Service.Service(self, unit, duration)
        if unit.traits.Fit then
            unit:ChangeSanity(FITNESS_FIT_SERVICE / 2, FITNESS_FIT_SANITY_GAIN_REASON)
        end
        if unit.traits.Unfit then
            unit:ChangeSanity(-FITNESS_FIT_SERVICE / 2, FITNESS_UNFIT_SANITY_LOSS_REASON)
        end
    end

    local function RawFoodFitnessPenalty(unit)
        if unit.last_meal == DayStart then
            -- unit was able to ate today
            self:ChangeFitness(FITNESS_RAW_FOOD_LOSS, FITNESS_RAW_FOOD_REASON)
            unit.Tremualin_Nutrition_Fitness_Bonus = 0
        end
    end

    local function PreparedFoodFitnessBonus(performance, unit)
        unit.Tremualin_Nutrition_Fitness_Bonus = performance - 100
    end

    local Tremualin_Origin_Farm_Service = Farm.Service
    function Farm:Service(unit, duration)
        Tremualin_Origin_Farm_Service(self, unit, duration)
        RawFoodFitnessPenalty(unit)
    end
    local Tremualin_Origin_ResourceStockpileBase_Service = ResourceStockpileBase.Service
    function ResourceStockpileBase:Service(unit, duration)
        Tremualin_Origin_ResourceStockpileBase_Service(self, unit, duration)
        RawFoodFitnessPenalty(unit)
    end

    local Tremualin_Orig_StatsChange_Service = StatsChange.Service
    function StatsChange:Service(unit, duration, reason, comfort_threshold, interest)
        if self.consumption_resource_type == "Food" then
            local performance = self:GetEffectivePerformance()
            PreparedFoodFitnessBonus(performance, unit)
        end
        return Tremualin_Orig_StatsChange_Service(self, unit, duration, reason, comfort_threshold, interest)
    end

    function ModifyGyms()
        BuildingTemplates.OpenAirGym.health_change = 0
        ClassTemplates.Building.OpenAirGym.health_change = 0

        if IsDlcAvailable("gagarin") then
            BuildingTemplates.TaiChiGarden.health_change = 0
            ClassTemplates.Building.TaiChiGarden.health_change = 0
        end
    end

    ModifyGyms()

    local Tremualin_Orig_Colonist_GetStat = Colonist.GetStat
    function Colonist:GetStat(stat)
        if stat == FITNESS_STAT_ID then
            return self.Tremualin_stat_fitness
        end
        return Tremualin_Orig_Colonist_GetStat(self, stat)
    end

    function Community:GetAverageFitness() return GetAverageStat(self.labels.Colonist, FITNESS_STAT_ID) end
end

-- A panel that shows fitness averages on the UI
function OnMsg.ClassesPostprocess()
    ColonistStatReasons["-" .. FITNESS_STAT_ID] = Untranslated("<red>My body is an unholy temple <amount> (Fitness)</red>")
    ColonistStatReasons["+" .. FITNESS_STAT_ID] = Untranslated("My body is a holy temple <amount> (Fitness)")

    local template = XTemplates.sectionDome
    ui_functions.RemoveXTemplateSections(template, "Tremualin_AverageFitnessSection")
    local tremualin_AverageFitnessSection = PlaceObj("XTemplateTemplate", {
        "Tremualin_AverageFitnessSection", true,
        "__context_of_kind", "Dome",
        '__template', "InfopanelSection",
        'RolloverText', Untranslated("The average <em>Fitness</em> of all Colonists living in this Dome."),
        'RolloverTitle', Untranslated("Average Fitness <Stat(AverageFitness)>"),
        'Icon', "UI/Icons/Sections/workshifts.tga",
        }, {
        PlaceObj('XTemplateTemplate', {
            '__template', "InfopanelStat",
            'BindTo', "AverageFitness",
        }),
    })

    local possibleIndex1 = Tremualin.Functions.FindSectionIndexBeforeExistingIfPossible(XTemplates.sectionDome, "Tremualin_DomesticViolenceLifetime")
    local possibleIndex2 = functions.FindSectionIndexBeforeExistingIfPossible(template, "Tremualin_DomesticViolenceLifetime")
    table.insert(template, Min(possibleIndex1, possibleIndex2), tremualin_AverageFitnessSection)

end

local function AddTremualinStatFitness()
    for _, city in ipairs(Cities) do
        local colonists = city.labels.Colonist or empty_table
        for j = #colonists, 1, -1 do
            local colonist = colonists[j]
            colonist.Tremualin_stat_fitness = colonist.Tremualin_stat_fitness or max_stat / 2
            colonist.Tremualin_log_fitness = colonist.Tremualin_log_fitness or {}
            colonist.Tremualin_Nutrition_Fitness_Bonus = colonist.Tremualin_Nutrition_Fitness_Bonus
            colonist.Tremualin_daily_exercise = false
        end
    end
end

OnMsg.LoadGame = AddTremualinStatFitness
OnMsg.CityStart = AddTremualinStatFitness
