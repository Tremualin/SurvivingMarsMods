Community.birth_policy = BirthPolicy.Limited

local function GetColonistsWithoutTraitsFilter(filter_traits)
    return function (id, colonist)
        if #table.union(colonist.traits, filter_traits) > 0 then
            return false
        end
        return true
    end
end

local function IsCityFull(city)
    local freeLivingSpaces = GatherFreeLivingSpaces(city.labels.Residence)
    -- filter out all homeless who live in exclusive homes like Children, Seniors and Tourists
    local numberOfHomelessInclusiveColonists = #table.filter(city.labels.Homeless or empty_table, GetColonistsWithoutTraitsFilter(freeLivingSpaces.traits))
    local numberOfChildren = #(city.labels.Child or empty_table)
    local freeInclusiveLivingSpaces = freeLivingSpaces.inclusive
    -- If there are inclusive homeless colonists, they must find a home too; remove them from the total number of homes
    -- Restrict births to the free number of inclusive living space after children and homeless
    return (freeInclusiveLivingSpaces - numberOfHomelessInclusiveColonists - numberOfChildren) <= 0
end

local Tremualin_Orig_Community_CalcBirth = Community.CalcBirth
function Community:CalcBirth()
    if self.birth_policy == BirthPolicy.Limited then
        if IsCityFull(self.city) then
            return
        end
    end
    return Tremualin_Orig_Community_CalcBirth(self)
end

-- Use classes post-process so it happens after Incubator
function OnMsg.ClassesGenerate()
    local Tremualin_Orig_CloningVats_BuildingUpdate = CloningVats.BuildingUpdate
    function CloningVats:BuildingUpdate(...)
        if self.parent_dome.birth_policy == BirthPolicy.Limited and IsCityFull(self.city) then
            return
        end
        return Tremualin_Orig_CloningVats_BuildingUpdate(self, ...)
    end
end
