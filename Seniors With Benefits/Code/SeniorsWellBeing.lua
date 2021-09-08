Tremualin.Debugging.SeniorsWellBeing = false

local functions = Tremualin.Functions
local stat_scale = const.Scale.Stat

local seniorWellbeingNegativeMoraleChangePerAge = {Youth = 10, Adult = 20, ['Middle Aged'] = 30}
local seniorWellbeingPositiveMoraleChangePerAge = {Youth = 5, Adult = 5, ['Middle Aged'] = 15}

local function TableConcat(t1, t2)
    for i = 1, #t2 do
        t1[#t1 + 1] = t2[i]
    end
    return t1
end

-- How are our seniors doing across the city?
-- bad if at least 10% of senior are unhappy, good if at least 95% of seniors are happy, otherwise neutral
local function SeniorsWellbeing()
    local result = 'neutral'
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
            result = 'bad'
        elseif MulDivRound(happySeniors, 100, totalSeniors) > 0.95 then
            result = 'good'
        end
    end
    return result
end

-- Calculate the Seniors Well-being only once a day
GlobalVar("g_Tremualin_Seniors_Wellbeing_Result", 'neutral')
local orig_Colony_DailyUpdate = Colony.DailyUpdate
function Colony:DailyUpdate(day)
    orig_Colony_DailyUpdate(self, day)
    g_Tremualin_Seniors_Wellbeing_Result = SeniorsWellbeing()
    if Tremualin.Debugging.SeniorsWellBeing then print(string.format("Seniors are %s", g_Tremualin_Seniors_Wellbeing_Result)) end
end

-- Senior well being matters, morale update
-- If Seniors are doing good, everyone is a little happier
-- If Seniors are doing bad, everyone is a little unhappier
-- The closer one is to becoming a Senior, the more this matters
-- Unlike comfort, sanity and health, morale resets to base and recalculates from there
local orig_Colonist_UpdateMorale = Colonist.UpdateMorale
function Colonist:UpdateMorale()
    orig_Colonist_UpdateMorale(self)
    if self:IsDead() then
        return
    end
    local seniors_wellbeing_result = g_Tremualin_Seniors_Wellbeing_Result
    if self.traits.Renegade or self.traits.Child or self.traits.Senior then
        -- Renegades don't have morale you silly goose
        -- Children don't keep up with the news
        -- Seniors are already happy/unhappy
    else
        if seniors_wellbeing_result == "good" then
            local amount = seniorWellbeingPositiveMoraleChangePerAge[self.age_trait]
            self.stat_morale = self.stat_morale + amount * stat_scale
            Msg("MoraleChanged", self)
        elseif seniors_wellbeing_result == "bad" then
            local amount = seniorWellbeingNegativeMoraleChangePerAge[self.age_trait]
            self.stat_morale = self.stat_morale - amount * stat_scale
            Msg("MoraleChanged", self)
        end
    end
end

-- Senior well being matters, UI update
-- Since the Morale UI is pretty much hard-coded, I have to update the text
local orig_Colonist_UiStatUpdate = Colonist.UIStatUpdate
function Colonist:UIStatUpdate(win, stat)
    orig_Colonist_UiStatUpdate(self, win, stat)
    local orig_win_GetRolloverText = win.GetRolloverText
    win.GetRolloverText = function(self)
        local texts = orig_win_GetRolloverText(self)
        local colonist = self.context
        if colonist.traits.Renegade or colonist.traits.Child or colonist.traits.Senior then
            -- Renegades don't have morale you silly goose
            -- Children don't keep up with the news about Seniors
            -- Seniors are already happy/unhappy about their situation
        elseif stat == "Morale" then
            local seniorsWellbeingResult = g_Tremualin_Seniors_Wellbeing_Result
            if seniorsWellbeingResult ~= "neutral" then
                texts = texts .. "\n"
                if seniorsWellbeingResult == "good" then
                    local amount = seniorWellbeingPositiveMoraleChangePerAge[colonist.age_trait]
                    local clr = (TLookupTag("<green>"))
                    texts = texts .. (T({
                        6936,
                        "<clr><reason></color>",
                        reason = Untranslated("Most senior citizens seem to be happy +" .. amount),
                        clr = clr,
                    }))
                elseif seniorsWellbeingResult == "bad" then
                    local amount = seniorWellbeingNegativeMoraleChangePerAge[colonist.age_trait]
                    local clr = (TLookupTag("<red>"))
                    texts = texts .. (T({
                        6936,
                        "<clr><reason></color>",
                        reason = Untranslated("Too many senior citizens are miserable -" .. amount),
                        clr = clr,
                    }))
                end
            end
        end
        return texts .. "\n"
    end
end
