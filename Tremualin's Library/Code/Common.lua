-- Create the object which holds the functions
Tremualin = {
    Debugging = {FindAllOtherColonistsInSameResidence = false},
    -- Will dynamically add them as they're defined
    Functions = {},
}

-- The original code ignores modded traits daily functions
local function fixTraitsWithDailyUpdates()
    TraitsWithDailyUpdates = TraitsWithDailyUpdates or {}
    local alreadyDefinedTraits = {}
    for _, trait_id in ipairs(TraitsWithDailyUpdates) do
        alreadyDefinedTraits[trait_id] = true
    end
    ForEachPreset(ModItemTraitPreset, function(trait, group_list)
        if trait.daily_update_func and not alreadyDefinedTraits[trait.id] then
            TraitsWithDailyUpdates[1 + #TraitsWithDailyUpdates] = trait.id
        end
    end)
end
OnMsg.CityStart = fixTraitsWithDailyUpdates
OnMsg.LoadGame = fixTraitsWithDailyUpdates

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

Tremualin.Functions.FindAllOtherColonistsInSameResidence = FindAllOtherColonistsInSameResidence

-- Adds a trait to SanityBreakdownTraits (if not already there)
local function AddTraitToSanityBreakdownTraits(trait)
    if not const.SanityBreakdownTraits[trait] then
        table.insert(const.SanityBreakdownTraits, trait)
    end
end
Tremualin.Functions.AddTraitToSanityBreakdownTraits = AddTraitToSanityBreakdownTraits
