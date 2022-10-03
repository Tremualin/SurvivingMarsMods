local functions = Tremualin.Functions
local stat_scale = const.Scale.Stat

local SENIOR_WELLBEING_ID = "Tremualin_SeniorWellbeing_"
local seniorWellbeingAges = {'Youth', 'Adult', 'Middle Aged'}
local seniorWellbeingNegativeMoraleChangePerAge = {Youth = -10, Adult = -20, ['Middle Aged'] = -30}
local seniorWellbeingPositiveMoraleChangePerAge = {Youth = 5, Adult = 10, ['Middle Aged'] = 15}

local function TableConcat(t1, t2)
    for i = 1, #t2 do
        t1[#t1 + 1] = t2[i]
    end
    return t1
end

-- How are our seniors doing across the city?
-- -1 = bad, 0 = neutral, 1 = good
-- bad if at least 10% of senior are unhappy, good if at least 95% of seniors are happy, otherwise neutral
local function CalculateSeniorsWellbeingAcrossAllCities()
    local result = 0
    local seniors = {}
    for _, city in ipairs(Cities) do
        seniors = TableConcat(seniors, functions.GetSeniors(city))
    end
    local totalSeniors = #seniors
    if totalSeniors > 0 then
        local happySeniors = 0
        local unhappySeniors = 0
        for _, senior in pairs(seniors) do
            if functions.IsHappy(senior) then
                happySeniors = happySeniors + 1
            elseif functions.IsUnhappy(senior) then
                unhappySeniors = unhappySeniors + 1
            end
        end
        if MulDivRound(unhappySeniors, 100, totalSeniors) > 0.1 then
            result = -1
        elseif MulDivRound(happySeniors, 100, totalSeniors) > 0.95 then
            result = 1
        end
    end
    return result
end

-- Senior well being matters, morale update
-- If Seniors are doing good, everyone is a little happier
-- If Seniors are doing bad, everyone is a little unhappier
-- The closer one is to becoming a Senior, the more they care
local function SeniorsWellbeing()
    local seniors_wellbeing_result = CalculateSeniorsWellbeingAcrossAllCities()
    for _, age in pairs(seniorWellbeingAges) do
        local id = SENIOR_WELLBEING_ID .. age
        if seniors_wellbeing_result == 0 then
            for _, community in pairs(UIColony.city_labels.labels.Community or empty_table) do
                -- Remove the label modifier
                local old_mod = table.find_value(community.modifications, "id", id)
                if old_mod then
                    community:UpdateModifier("remove", old_mod, 0, 0)
                end
            end
        else
            local amount = seniorWellbeingNegativeMoraleChangePerAge[age] * stat_scale
            local display_text = Untranslated("<red>Too many senior citizens are miserable <amount></color>")
            if seniors_wellbeing_result > 0 then
                amount = seniorWellbeingPositiveMoraleChangePerAge[age] * stat_scale
                display_text = Untranslated("<green>Most senior citizens seem to be happy +<amount></color>")
            end
            for _, community in pairs(UIColony.city_labels.labels.Community) do
                community:SetLabelModifier(age, id, Modifier:new({
                    prop = "base_morale",
                    amount = amount,
                    id = id,
                    display_text = display_text,
                }))
            end
        end
    end
end

function OnMsg.NewDay()
    SeniorsWellbeing()
end
