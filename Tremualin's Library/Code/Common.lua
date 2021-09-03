Tremualin = {}
Tremualin.Debugging = {}
Tremualin.Functions = {}
Tremualin.UIDebugging = Tremualin.UIDebugging or {}
Tremualin.UIFunctions = Tremualin.UIFunctions or {}

Tremualin.Debugging.FindAllOtherColonistsInSameResidence = false

-- Finds all other colonists in the same residence, optionally filtering them by a function:
-- filter(another colonist, original colonist)
-- If the colonist has no residence, it will find all other homeless colonists
local function FindAllOtherColonistsInSameResidence(colonist, filter)
    -- if no filter is provided, return all colonists
    local none_filter = function(another, same) return true end
    if not filter then filter = none_filter end
    local colonists_in_same_residence = {}
    local filtered_colonists = {}
    local residence = colonist.residence
    local dome = colonist.dome
    if residence and residence.colonists then
        colonists_in_same_residence = residence.colonists
    elseif dome and dome.labels.Homeless then
        colonists_in_same_residence = dome.labels.Homeless
    end
    for i = #colonists_in_same_residence, 1, -1 do
        local another = colonists_in_same_residence[i]
        if IsValid(another) and another ~= colonist and
            filter(another, colonist) then
            table.insert(filtered_colonists, another)
        end
    end
    if Tremualin.Debugging.FindAllOtherColonistsInSameResidence then
        print(string.format("%d filtered colonists found in same residence", #filtered_colonists))
    end
    return filtered_colonists
end

-- Adds a trait to SanityBreakdownTraits (if not already there)
local function AddTraitToSanityBreakdownTraits(trait)
    if not const.SanityBreakdownTraits[trait] then
        table.insert(const.SanityBreakdownTraits, trait)
    end
end

-- Tells you if a colonists stats are all above 70
local function IsHappy(colonist)
    local high_stat_threshold = g_Consts.HighStatLevel
    return high_stat_threshold <= colonist.stat_morale and high_stat_threshold <= colonist.stat_health and high_stat_threshold <= colonist.stat_sanity and high_stat_threshold <= colonist.stat_comfort
end

-- Tells you if any colonists stat is below 30
local function IsUnhappy(colonist)
    local low_stat_threshold = g_Consts.LowStatLevel
    return low_stat_threshold > colonist.stat_morale or low_stat_threshold > colonist.stat_health or low_stat_threshold > colonist.stat_sanity or low_stat_threshold > colonist.stat_comfort
end

local function GetSeniors(city_or_dome)
    local seniors = {}
    if city_or_dome and city_or_dome.labels.Senior then
        seniors = city_or_dome.labels.Senior
    end
    return seniors
end

local function GetSeniorCount(city_or_dome)
    return #GetSeniors(city_or_dome)
end

local function GetSeniorsWithAnyTraits(city_or_dome, traits)
    local seniorsWithTraitCount = 0
    for _, colonist in pairs(GetSeniors(city_or_dome)) do
        for key, value in pairs(traits) do
            if colonist.traits[value] then
                seniorsWithTraitCount = seniorsWithTraitCount + 1
            end
        end
    end
    return seniorsWithTraitCount
end

local function IsNoneTrait(trait_id)
    return trait_id == "none"
end

local function IntersectTraits(list1, list2)
    local shared_traits = {}
    for trait_id in pairs(list1) do
        if not IsNoneTrait(trait_id) and list2[trait_id] then
            shared_traits[trait_id] = true
            break
        end
    end
    return shared_traits
end

Tremualin.Functions.FindAllOtherColonistsInSameResidence = FindAllOtherColonistsInSameResidence
Tremualin.Functions.AddTraitToSanityBreakdownTraits = AddTraitToSanityBreakdownTraits
Tremualin.Functions.IsUnhappy = IsUnhappy
Tremualin.Functions.IsHappy = IsHappy
Tremualin.Functions.GetSeniors = GetSeniors
Tremualin.Functions.GetSeniorCount = GetSeniorCount
Tremualin.Functions.GetSeniorsWithAnyTraits = GetSeniorsWithAnyTraits
Tremualin.Functions.IntersectTraits = IntersectTraits
Tremualin.Functions.IsNoneTrait = IsNoneTrait
