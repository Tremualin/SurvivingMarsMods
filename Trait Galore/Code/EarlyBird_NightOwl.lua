local print_debug = false

local comfort_increase = 5 * const.Scale.Stat
local comfort_decrease = -5 * const.Scale.Stat
local sanity_increase = 5 * const.Scale.Stat

local night_owl_love_message = "Love working in the dark hours (Night Owl) "
local night_owl_hate_message = "Hate working in the early hours (Night Owl) "
local early_bird_love_message = "Love working in the early hours (Early Bird) "
local early_bird_hate_message = "Hate working in the dark hours (Early Bird) "

function OnMsg.ClassesGenerate()
    -- EarlyBirds have a bonus in the morning and afternoon and a penalty at night
    -- NightOwls have a bonus in the night and afternoon and a penalty in the morning
    local Tremualin_Orig_Workplace_OnChangeWorkshift = Workplace.OnChangeWorkshift
    function Workplace:OnChangeWorkshift(old, new)
        if old then
            local dark_bonus = old == 3 or old == 2
            local early_bonus = old == 1 or old == 2
            if dark_bonus or early_bonus then
                for _, worker in ipairs(self.workers[old] or empty_table) do
                    if worker.traits.NightOwl then
                        if dark_bonus then
                            worker:ChangeSanity(sanity_increase, night_owl_love_message)
                            worker:ChangeComfort(comfort_increase, night_owl_love_message)
                        end
                        if not dark_bonus then
                            worker:ChangeComfort(comfort_decrease, night_owl_hate_message)
                        end
                    end
                    if worker.traits.EarlyBird then
                        if early_bonus then
                            worker:ChangeComfort(comfort_increase, early_bird_love_message)
                        end
                        if not early_bonus then
                            worker:ChangeComfort(comfort_decrease, early_bird_hate_message)
                        end
                    end
                end
            end
        end
        return Tremualin_Orig_Workplace_OnChangeWorkshift(self, old, new)
    end
end

