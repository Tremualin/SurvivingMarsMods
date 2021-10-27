Tremualin = {}
Tremualin.Configuration = {}
Tremualin.Debugging = {}
Tremualin.Functions = {}
Tremualin.Utilities = {}
Tremualin.Tests = {}

Tremualin.Debugging.FindAllOtherColonistsInSameResidence = false

-- Finds all other colonists in the same residence, optionally filtering them by a function:
-- filter(another colonist, original colonist)
-- If the colonist has no residence, it will find all other homeless colonists
local function FindAllOtherColonistsInSameResidence(colonist, filter)
    -- if no filter is provided, return all colonists
    local none_filter = function(another, same) return true end
    if not filter then filter = none_filter end

    local dome = colonist.dome
    local residence = colonist.residence
    local colonists_in_same_residence = {}
    if residence and residence.colonists then
        colonists_in_same_residence = residence.colonists
    elseif dome and dome.labels.Homeless then
        colonists_in_same_residence = dome.labels.Homeless
    end
    local filtered_colonists = {}
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

local function IsNoneTrait(trait_id)
    return trait_id == "none"
end

local function TraitsByCategory(traits)
    local traits_by_category = {
        Positive = 0,
        Negative = 0
    }
    for trait_id, _ in pairs(traits) do
        if not IsNoneTrait(trait_id) then
            local trait = TraitPresets[trait_id]
            if trait and trait.group then
                traits_by_category[trait.group] = (traits_by_category[trait.group] or 0) + 1
            end
        end
    end
    return traits_by_category
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

local function PairsByKeys(t, f)
    local a = {}
    for n in pairs(t) do
        table.insert(a, n)
    end
    table.sort(a, f)
    local i = 0 -- iterator variable
    local iter = function () -- iterator function
        i = i + 1
        if a[i] == nil then return nil
        else return a[i], t[a[i]]
        end
    end
    return iter
end

local function AddSanityBreakdownFlaw(victim)
    local compatible = (FilterCompatibleTraitsWith(const.SanityBreakdownTraits, victim.traits))
    if 0 < #compatible then
        local dome = victim.dome
        if dome then
            dome.Tremualin_DomesticViolenceFlaws = dome.Tremualin_DomesticViolenceFlaws or 0
            dome.Tremualin_DomesticViolenceFlaws = dome.Tremualin_DomesticViolenceFlaws + 1
        end
        victim:AddTrait(table.rand(compatible))
    end
end

local function AddTraitIfCompatible(victim, trait)
    local compatible = (FilterCompatibleTraitsWith({trait}, victim.traits))
    if 0 < #compatible then
        victim:AddTrait(trait)
    end
end

local function TemporarilyModifyProperty(prop_to_modify, object_to_modify, unscaled_amount, percent, duration_in_sols, modifier_id, reason)
    local scale = ModifiablePropScale[prop_to_modify]
    local amount = unscaled_amount * scale
    -- Prevents the same thread from being assigned to the same modifier id again
    object_to_modify.Tremualin_Threads = object_to_modify.Tremualin_Threads or empty_table
    if IsValidThread(object_to_modify.Tremualin_Threads[modifier_id]) then
        DeleteThread(temporarilyModifyMorale.Tremualin_Threads[modifier_id])
    end
    object_to_modify:SetModifier(prop_to_modify, modifier_id, amount, percent, T({
        11887,
        "<color_tag><reason></color>",
        color_tag = 0 <= amount and 0 <= percent and TLookupTag("<green>") or TLookupTag("<red>"),
        reason = T({
            Untranslated(reason .. " <opt_amount(amount)> <opt_percent(percent)>"),
            amount = unscaled_amount,
            percent = percent
        });
    }))
    if (amount ~= 0 or percent ~= 0) and 0 < duration_in_sols then
        object_to_modify.Tremualin_Threads[modifier_id] = CreateGameTimeThread(function()
            -- 1 sol = 720000
            Sleep(duration_in_sols * 720000)
            -- If the colonist died; Let it go! Let it go! You'll never see me cry
            if IsValid(object_to_modify) then
                object_to_modify:SetModifier(prop_to_modify, modifier_id, 0, 0)
            end
        end)
    end
end

local function TemporarilyModifyMorale(object_to_modify, unscaled_amount, percent, duration_in_sols, modifier_id, reason)
    return TemporarilyModifyProperty("base_morale", object_to_modify, unscaled_amount, percent, duration_in_sols, modifier_id, reason)
end

local function OfficersInSecurityStations(dome)
    -- determine how many officers are working in security stations during this shift
    local officers_in_security_stations = {}
    for _, securityStation in pairs(dome.labels.SecurityStation or empty_table) do
        if securityStation.working then
            for _, officer in pairs(securityStation:GetWorkingWorkers()) do
                table.insert(officers_in_security_stations, officer)
            end
        end
    end
    return officers_in_security_stations
end

local function RenegadesInRehabilitation(dome)
    -- determine how many Renegades are in Rehabilitation
    local renegades_in_rehabilitation = {}
    for _, renegade in pairs(dome.labels.Renegade or empty_table) do
        if renegade.residence and renegade.residence.exclusive_trait == "Renegade" then
            table.insert(renegades_in_rehabilitation, renegade)
        end
    end
    return renegades_in_rehabilitation
end

local function ShallowCopy(original)
    local copy = {}
    for key, value in pairs(original) do
        copy[key] = value
    end
    return copy
end

local function DeepCopy(original)
    local copy = {}
    for k, v in pairs(original) do
        if type(v) == "table" then
            v = DeepCopy(v)
        end
        copy[k] = v
    end
    return copy
end

local function AddParentToClass(class_obj, parent_name)
    local p = class_obj.__parents
    if not table.find(p, parent_name) then
        p[#p + 1] = parent_name
    end
end

local function PrintVisitDurations(uncommon_only)
    for _, bt in pairs(BuildingTemplates) do
        if bt.visit_duration and bt.max_visitors and (not uncommon_only or bt.visit_duration ~= 5) then
            print(string.format("Colonists spend %d hours inside %s which has a max capacity of %d for a total of %.1f max visits per Sol", bt.visit_duration, _InternalTranslate(bt.display_name), bt.max_visitors, bt.max_visitors * const.HoursPerDay / bt.visit_duration))
        end
    end
end

local function HasMedicalSpireOrHospital(dome)
    local spire_or_hospital = false
    if dome then
        for _, spire in ipairs(dome.labels.Spire or empty_table) do
            if spire.working and spire:IsKindOf("MedicalCenter") then
                spire_or_hospital = true
            end
        end
        if not spire_or_hospital then
            for _, medical_building in ipairs(dome.labels.MedicalBuilding or empty_table) do
                if medical_building.working and medical_building:IsKindOf("Hospital") then
                    spire_or_hospital = true
                end
            end
        end
    end
    return spire_or_hospital
end

local function HasWorkingMedicalBuilding(dome)
    if dome then
        for _, medical_building in ipairs(dome.labels.MedicalBuilding or empty_table) do
            if medical_building.working then
                return true
            end
        end
    end
    return false
end

local function AddIncompatibleTraits(bt, ct, trait)
    if bt.incompatible_traits == empty_table then bt.incompatible_traits = {} end
    if ct.incompatible_traits == empty_table then ct.incompatible_traits = {} end
    table.insert_unique(bt.incompatible_traits, trait)
    table.insert_unique(ct.incompatible_traits, trait)
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
Tremualin.Functions.PairsByKeys = PairsByKeys
Tremualin.Functions.TraitsByCategory = TraitsByCategory
Tremualin.Functions.AddSanityBreakdownFlaw = AddSanityBreakdownFlaw
Tremualin.Functions.AddTraitIfCompatible = AddTraitIfCompatible
Tremualin.Functions.TemporarilyModifyProperty = TemporarilyModifyProperty
Tremualin.Functions.TemporarilyModifyMorale = TemporarilyModifyMorale
Tremualin.Functions.OfficersInSecurityStations = OfficersInSecurityStations
Tremualin.Functions.RenegadesInRehabilitation = RenegadesInRehabilitation
Tremualin.Functions.ShallowCopy = ShallowCopy
Tremualin.Functions.DeepCopy = DeepCopy
Tremualin.Functions.AddParentToClass = AddParentToClass
Tremualin.Functions.HasMedicalSpireOrHospital = HasMedicalSpireOrHospital
Tremualin.Functions.HasWorkingMedicalBuilding = HasWorkingMedicalBuilding
Tremualin.Functions.AddIncompatibleTraits = AddIncompatibleTraits

Tremualin.Utilities.PrintVisitDurations = PrintVisitDurations
