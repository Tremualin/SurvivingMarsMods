-- Smart Homes, Apartments, and Senior Residences have a chance of satisfying an advanced Luxury, Drinking, Gaming and/or Exercise. The higher the comfort level, the higher the chance.
local smart_residences = {SeniorsResidenceCCP1=true, SmartHome = true, SmartHome_Small = true, SmartApartmentsCCP1 = true}
local smart_interests = {interestExercise = true, interestGaming = true, interestLuxury = true, interestDrinking = true}
local smart_interest_message = {interestExercise = "<green>Smart home, smart exercise </color>", interestGaming = "<green>Smart home, smart gaming </color>", interestLuxury = "<green>Smart home, luxurious home </color>", interestDrinking = "<green>Smart home, smart drinking </color>"}
local orig_Colonist_DailyUpdate = Colonist.DailyUpdate
function Colonist:DailyUpdate() 
    orig_Colonist_DailyUpdate(self)
    local residence = self.residence
    local daily_interest = self.daily_interest
    if residence and daily_interest and smart_residences[residence.Id] and smart_interests[daily_interest] and self:Random(150) < residence:GetEffectiveServiceComfort() then
        self.daily_interest = ""
        local comfort_threshold = residence:GetEffectiveServiceComfort()
        if comfort_threshold > self.stat_comfort then
            local comfort_increase = residence.comfort_increase
            self:ChangeComfort(comfort_increase, smart_interest_message[daily_interest])
        end
    end
end
