local print_debug = false

local FindAllOtherColonistsInSameResidence = Tremualin.Functions.FindAllOtherColonistsInSameResidence

local comfort_increase = 5
local comfort_decrease = -5
local sanity_increase = 5

local night_owl_love_message = "Love working in the dark hours (Night Owl) "
local night_owl_hate_message = "Hate working in the early hours (Night Owl) "
local early_bird_love_message = "Love working in the early hours (Early Bird) "
local early_bird_hate_message = "Hate working in the dark hours (Early Bird) "

-- EarlyBirds have a bonus in the morning and a penalty at night
-- NightOwls have a bonus that is opposite to the usual one
local orig_Workplace_OnChangeWorkshift = Workplace.OnChangeWorkshift
function Workplace:OnChangeWorkshift(old, new)
    if old then
        local dark_bonus = old == 3
        local early_bonus = old == 1
        if dark_bonus or early_bonus then
            for _, worker in ipairs(self.workers[old] or empty_table) do
                if dark_bonus then
                    if worker.traits.NightOwl then
                        worker:ChangeSanity(sanity_increase, night_owl_love_message)
                        worker:ChangeComfort(comfort_increase, night_owl_love_message)
                    end
                    if worker.traits.EarlyBird then
                        worker:ChangeComfort(comfort_decrease, early_bird_hate_message)
                    end
                end
                if early_bonus then
                    if worker.traits.EarlyBird then
                        worker:ChangeComfort(comfort_increase, early_bird_love_message)
                    end
                    if worker.traits.NightOwl then
                        worker:ChangeComfort(comfort_decrease, night_owl_hate_message)
                    end
                end

            end
        end
    end
    orig_Workplace_OnChangeWorkshift(self, old, new)
end

local function tryToTakeFreeWorkSlot(colonist, desired_workshift, workplace)
    -- If there are free slots at desired_workshift, take them
    if print_debug then print (string.format("%s finding a shift in %s", colonist:GetRenameInitText(), workplace:GossipName())) end
    if workplace.HasFreeWorkSlots and workplace:HasFreeWorkSlots(desired_workshift) then
        workplace:RemoveWorker(colonist)
        workplace:AddWorker(colonist, desired_workshift)
        RebuildInfopanel(workplace)
        return true
    end
    return false
end

local function tryToSwitchWorkshiftsWithAnotherColonist(colonist, current_workshift, desired_workshift, workplace, ignore_trait)
    if workplace.workers then
        -- Switch with a worker who hasn't got ignore_trait
        local filter_function = function(another, same) return not another.traits[ignore_trait] end
        local no_ignore_trait_desired_workshift_workers = FindAllOtherColonistsInSameResidence(colonist, filter_function)
        local desired_workshift_workers = workplace.workers[desired_workshift]

        if #no_ignore_trait_desired_workshift_workers > 0 then
            local worker_to_switch_with = table.rand(no_ignore_trait_desired_workshift_workers)
            if print_debug then print (string.format("%s switching shifts with %s", colonist:GetRenameInitText(), worker_to_switch_with:GetRenameInitText())) end
            workplace:RemoveWorker(colonist)
            workplace:RemoveWorker(worker_to_switch_with)
            workplace:AddWorker(colonist, desired_workshift)
            workplace:AddWorker(worker_to_switch_with, current_workshift)
            RebuildInfopanel(workplace)
            return true
        end
    end
    return false
end

-- Used for NightOwls and EarlyBirds to find more comfortable work
function Tremualin_SwitchWithDesiredWorkshift(colonist, desired_workshift, ignore_trait)
    local workplace = colonist.workplace
    local current_workshift = colonist.workplace_shift
    if workplace and current_workshift ~= desired_workshift then
        if not tryToTakeFreeWorkSlot(colonist, desired_workshift, workplace) then
            tryToSwitchWorkshiftsWithAnotherColonist(colonist, current_workshift, desired_workshift, workplace, ignore_trait)
        end
    end
end
