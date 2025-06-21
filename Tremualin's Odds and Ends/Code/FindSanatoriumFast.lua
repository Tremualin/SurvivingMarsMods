function OnMsg.ClassesGenerate()
    local function HasFreeLivingSpaceFor(community, traits)
        community:RefreshFreeLivingSpaces()
        if community.free_spaces.inclusive > 0 then
            return true
        elseif 0 < community.free_spaces.exclusive then
            for trait, space in pairs(community.free_spaces.traits) do
                if traits[trait] and 0 < space then
                    return true
                end
            end
        end
        return false
    end

    function Community:HasFreeLivingSpaceFor(traits)
        return HasFreeLivingSpaceFor(self, traits)
    end

    function Dome:HasFreeLivingSpaceFor(traits)
        return HasFreeLivingSpaceFor(self, traits)
    end
end

function FindSanatoriumNow(colonist)
    local workplace = nil
    local shift = nil
    if colonist.dome then
        workplace, shift = ChooseTraining(colonist, colonist.dome.labels.Sanatorium or empty_table)
    end
    if not workplace then
        workplace, shift = ChooseTraining(colonist, colonist.city.labels.Sanatorium or empty_table)
    end
    if workplace and shift and workplace.dome then
        --SafeColonistInteract(workplace, colonist)
        colonist:SetWorkplace(workplace, shift)
        colonist:TryToEmigrate(workplace.dome)
    end
    return workplace, shift
end

local Orig_Tremualin_Colonist_DailyUpdate = Colonist.DailyUpdate
function Colonist:DailyUpdate()
    Orig_Tremualin_Colonist_DailyUpdate(self)
    FindSanatoriumNow(self)
end
