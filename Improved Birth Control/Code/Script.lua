Community.birth_policy = BirthPolicy.Limited

function GetColonistsWithoutTraitsFilter(filter_traits)
    return function (id, colonist)
        if #table.union(colonist.traits, filter_traits) > 0 then
            return false
        end
        return true
    end
end

local Tremualin_Orig_Community_CalcBirth = Community.CalcBirth
function Community:CalcBirth()
    if self.birth_policy == BirthPolicy.Limited then
        local freeLivingSpaces = GatherFreeLivingSpaces(self.city.labels.Residence)
        -- filter out all homeless who live in exclusive homes like Children, Seniors and Tourists
        local numberOfHomelessInclusiveColonists = #table.filter(self.city.labels.Homeless or empty_table, GetColonistsWithoutTraitsFilter(freeLivingSpaces.traits))
        local numberOfChildren = #(self.city.labels.Child or empty_table)
        local freeInclusiveLivingSpaces = freeLivingSpaces.inclusive
        -- If there are inclusive homeless colonists, they must find a home too; remove them from the total number of homes
        -- Restrict births to the free number of inclusive living space after children and homeless
        local disallowBirths = (freeInclusiveLivingSpaces - numberOfHomelessInclusiveColonists - numberOfChildren) <= 0
        if disallowBirths then
            return
        end
    end
    return Tremualin_Orig_Community_CalcBirth(self)
end
