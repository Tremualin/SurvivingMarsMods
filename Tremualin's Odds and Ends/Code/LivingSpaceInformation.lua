function GatherLivingSpaces(residences)
    local total_inclusive = 0
    local total_exclusive = 0
    local total_traits = {}
    for _, home in ipairs(residences or empty_table) do
        if not home.destroyed then
            local total_space = home.capacity
            if home.children_only then
                local trait_base = total_traits.Child or 0
                total_traits.Child = trait_base + total_space
                total_exclusive = total_exclusive + total_space
            elseif home.exclusive_trait then
                local trait_base = total_traits[home.exclusive_trait] or 0
                total_traits[home.exclusive_trait] = trait_base + total_space
                total_exclusive = total_exclusive + total_space
            else
                total_inclusive = total_inclusive + total_space
            end
        end
    end
    return {
        inclusive = total_inclusive,
        exclusive = total_exclusive,
        traits = total_traits
    }
end

-- Returns the max number of work slots on the dome
function GetTotalWorkSlots(workplace, shift)
    shift = shift or workplace.active_shift or 0
    local max = workplace.max_workers
    local closed = workplace.closed_workplaces or empty_table
    local sum = 0
    local from, to = 0 < shift and shift or 1, 0 < shift and shift or workplace.max_shifts
    for i = from, to do
        sum = sum + max - (closed[i] or 0)
    end
    return sum
end

-- Returns the max number of non-children training slots on the dome
function GetTotalNonChildrenTrainingSlots(trainingBuilding, shift)
    shift = shift or trainingBuilding.active_shift or 0
    local max = trainingBuilding.max_visitors
    local closed = trainingBuilding.closed_visitor_slots or empty_table
    local sum = 0
    local from, to = 0 < shift and shift or 1, 0 < shift and shift or trainingBuilding.max_shifts
    for i = from, to do
        sum = sum + max - (closed[i] or 0)
    end
    return sum
end

function GetTotalWorkplacesAround(dome)
    local sum = 0
    for _, b in ipairs(dome.labels.Workplace or empty_table) do
        if not b.destroyed and not b.demolishing then
            sum = sum + GetTotalWorkSlots(b)
        end
    end
    for _, b in ipairs(dome.labels.TrainingBuilding or empty_table) do
        if not b.destroyed and not b.demolishing and not b.children_only then
            sum = sum + GetTotalNonChildrenTrainingSlots(b)
        end
    end
    return sum
end

local Orig_Tremualin_Dome_GetEmploymentMessage = Dome.GetEmploymentMessage
function Dome:GetEmploymentMessage()
    local totalWorkplaces = GetTotalWorkplacesAround(self)
    local inclusiveLivingSpaces = GatherLivingSpaces(self.labels.Residence or empty_table).inclusive
    local workplacesWarning = false
    if totalWorkplaces > inclusiveLivingSpaces then
        workplacesWarning = Untranslated(T{
            "Workplaces > inclusive living spaces <right><work(workplaces)> > <home(livingSpaces)>",
            workplaces = totalWorkplaces,
            livingSpaces = inclusiveLivingSpaces
        })
    elseif totalWorkplaces < inclusiveLivingSpaces then
        workplacesWarning = Untranslated(T{
            "Inclusive living spaces > workplaces <right><home(livingSpaces)> > <work(workplaces)>",
            livingSpaces = inclusiveLivingSpaces,
            workplaces = totalWorkplaces,
        })
    end

    local original = Orig_Tremualin_Dome_GetEmploymentMessage(self)
    if workplacesWarning then
        return table.concat({workplacesWarning, original}, "<newline><left>")
    end
    return original
end
