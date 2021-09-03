Tremualin.Debugging.ColonistCuredBySeniors = false
Tremualin.Debugging.RareTraitChance = false
Tremualin.Debugging.SeniorsHelpOtherSeniors = false
Tremualin.Debugging.SeniorsRoleModelBonusForChildren = false
Tremualin.Debugging.SeniorsRoleModelBonusForYoundAndAdults = false

local functions = Tremualin.Functions
local stat_scale = const.Scale.Stat
local trait_defs = TraitPresets

-- Violent added for compatibility with Crime and Vindication
-- Anxious, Argumentative, Mean and Paranoid added for compatibility with Trait Galore
local flaws_removed_by_senior_perks = {Anxious = {'Composed'}, Argumentative = {'Listener'}, Paranoid = {'Composed'}, Mean = {'Kind'}, Violent = {'Vindicated'}, Coward = {'Composed', 'Survivor'}, Renegade = {'Empath', 'Saint'}, Melancholic = {'Enthusiast'}, Glutton = {'Fit'}, Gambler = {'Fickle', 'Gamer'}, Idiot = {'Mentor', 'Fixer', 'Genius'}, Hypochondriac = {'Nerd'}, Loner = {'Party Animal'}, Alcoholic = {'Religious'}, Whiner = {'Brawler', 'Rugged'}, Lazy = {'Thrifty', 'Workaholic'}}
local flaw_removed_chance_multipliers_per_age = {Youth = 4, Adult = 2, ['Middle Aged'] = 1}
local flaw_removed_max_change_per_age = {Youth = 16, Adult = 10, ['Middle Aged'] = 5}
local flaw_removed_message = "Senior citizen talked some sense into me (%s was removed) "
local flaw_removed_sanity_gain = 10 * stat_scale

local seniors_help_other_seniors_sanity_gain = 5 * stat_scale
local seniors_help_other_seniors_health_gain = 5 * stat_scale
local seniors_care_for_other_seniors_message = "Seniors care for other seniors "

local senior_role_models_performance_bonus_message = "<green>Inspired by senior role models %s </color>"
local senior_role_models_modifier_id = "SeniorRoleModels"

-- Seniors bring out the best in Children
-- Effectively boosting the rare trait chance based on the number of seniors
local org_GetRareTraitChance = GetRareTraitChance
function GetRareTraitChance(unit)
    local dome = unit.dome
    local senior_count = functions.GetSeniorCount(dome)
    local original_chance = org_GetRareTraitChance(unit) or 0
    if Tremualin.Debugging.RareTraitChance then
        print(string.format("Seniors increase rare trait chance by %.0f of original %.0f chance", senior_count, original_chance))
    end
    return original_chance + senior_count
end

-- Seniors cure a trait; the function logs it's removal in the Dome
-- In addition, it grants some sanity to the colonist who gets cured
local function ColonistCuredBySeniors(colonist, trait_to_cure)
    local dome = colonist.dome
    local message = string.format(flaw_removed_message, trait_to_cure)
    colonist:RemoveTrait(trait_to_cure)
    colonist:ChangeSanity(flaw_removed_sanity_gain, message)
    if Tremualin.Debugging.ColonistCuredBySeniors then print(message) end
    if dome then
        dome.tremualin_lifetime = (dome.tremualin_lifetime or 0) + 1
        if not dome.tremualin_removed_traits_log then
            dome.tremualin_removed_traits_log = {}
        end
        dome.tremualin_removed_traits_log[trait_to_cure] = (dome.tremualin_removed_traits_log[trait_to_cure] or 0) + 1
    end
end

-- Seniors share cautionary tales

local function ShareCautionaryTales(colonist)
    local dome = colonist.dome
    local traits = colonist.traits
    if not traits.Child and not traits.Senior and functions.GetSeniorCount(dome) > 0 then
        local ageTrait = colonist.age_trait
        local chanceMultiplier = flaw_removed_chance_multipliers_per_age[ageTrait]
        local maxChance = flaw_removed_max_change_per_age[ageTrait]
        for negativeTraitId, _ in pairs(traits) do
            local perks = flaws_removed_by_senior_perks[negativeTraitId]
            if perks then
                local seniorsWithTrait = functions.GetSeniorsWithAnyTraits(dome, perks)
                local chance = Min(maxChance, MulDivRound(seniorsWithTrait, chanceMultiplier, 1))
                if colonist:Random(100) <= chance then
                    ColonistCuredBySeniors(colonist, negativeTraitId)
                end
            end
        end
    end
end

-- Seniors help other seniors with friendly phone calls
-- Reminds other Seniors of the importance of taking their medication, which gives them health
-- And reminds them someone cares, which gives them sanity
local function SeniorsHelpOtherSeniors(colonist)
    local dome = colonist.dome
    if dome then
        local medicals = dome.labels.MedicalBuilding or empty_table
        if #medicals > 0 then
            if colonist.traits.Senior and functions.GetSeniorCount(dome) >= 10 then
                if Tremualin.Debugging.SeniorsHelpOtherSeniors then print(string.format("%s is getting helped by other seniors", colonist:GetRenameInitText())) end
                colonist:ChangeSanity(seniors_help_other_seniors_sanity_gain, seniors_care_for_other_seniors_message)
                colonist:ChangeHealth(seniors_help_other_seniors_health_gain, seniors_care_for_other_seniors_message)
            end
        end
    end
end

-- Useful so they don't have to constantly compute the trait category
local good_traits = {}
local bad_traits = {}
local ignore_traits = {}
-- Children get bonuses based on how diverse the Senior pool is
-- But flaws in Seniors are actually harmful to the young mind
-- Quirks are ignored
local function SeniorsRoleModelBonusForChild(colonist)
    local dome = colonist.dome
    local role_model_traits = {}
    local role_model_flaws = {}
    if dome then
        for _, senior in ipairs(functions.GetSeniors(dome)) do
            for trait_id in pairs(senior.traits) do
                -- I think "none" is a special trait which has no group or def; ignore it
                if not functions.IsNoneTrait(trait_id) then
                    if good_traits[trait_id] then
                        role_model_traits[trait_id] = true
                    elseif bad_traits[trait_id] then
                        role_model_flaws[trait_id] = true
                    elseif not ignore_traits[trait_id] then
                        -- If not in the list of ignored traits, and not good nor bad, then we need to initialize it
                        -- I could compute this on startup but I'm worried about possibly dynamic traits
                        local trait_def = trait_defs[trait_id]
                        local category = trait_def and trait_def.group
                        if category == "Positive" or category == "Specialization" then
                            role_model_traits[trait_id] = true
                            good_traits[trait_id] = true
                        elseif category == "Negative" then
                            role_model_flaws[trait_id] = true
                            bad_traits[trait_id] = true
                        else
                            ignore_traits[trait_id] = true
                        end
                    end

                end
            end
        end
    end
    local performance_bonus = Max(0, table.count(role_model_traits) - table.count(role_model_flaws))
    if Tremualin.Debugging.SeniorsRoleModelBonusForChildren then print(string.format("Senior performance bonus for children is %.0f", performance_bonus)) end
    return performance_bonus
end

-- Young and Adults get bonus performance based on how many traits they share with any Senior
-- Unlike with Children, flaws and quirks both count; sex and nationality also count
-- Young colonists get double the performance bonus of Adults
local function SeniorsRoleModelBonusForYoungAndAdults(colonist)
    local dome = colonist.dome
    local performance_bonus = 0
    local colonist_traits = colonist.traits
    local shared_unique_traits = {}
    if dome then
        for _, senior in pairs(functions.GetSeniors(dome)) do
            for trait_id in pairs(functions.IntersectTraits(colonist_traits, senior.traits)) do
                shared_unique_traits[trait_id] = true
            end
        end
    end
    performance_bonus = Max(0, table.count(shared_unique_traits))
    if colonist_traits.Youth then
        performance_bonus = performance_bonus * 2
    end
    if Tremualin.Debugging.SeniorsRoleModelBonusForYoundAndAdults then print(string.format("Senior performance bonus for young/adult is %.0f", performance_bonus)) end
    return performance_bonus
end

-- Seniors become role models for younger colonists
-- Giving them a bonus to performance as they emulate the steps of their heroes
local function SeniorsBecomeRoleModels(colonist)
    local performance_bonus = 0
    local colonist_traits = colonist.traits
    local dome = colonist.dome
    if dome and colonist_traits.Child or colonist_traits.Youth or colonist_traits.Adult then
        if colonist_traits.Child then
            performance_bonus = SeniorsRoleModelBonusForChild(colonist)
        else
            performance_bonus = SeniorsRoleModelBonusForYoungAndAdults(colonist)
        end
    end
    colonist:SetModifier("performance", senior_role_models_modifier_id, performance_bonus, 0, string.format(senior_role_models_performance_bonus_message, performance_bonus))
end

-- Activate all the senior effects during the colonist daily update
local orig_Colonist_DailyUpdate = Colonist.DailyUpdate
function Colonist:DailyUpdate()
    if self.traits.Tourist then
        -- tourists literally live in their own world, they don't care about Martian affairs
    else
        SeniorsBecomeRoleModels(self)
        SeniorsHelpOtherSeniors(self)
        ShareCautionaryTales(self)
    end
    orig_Colonist_DailyUpdate(self)
end
