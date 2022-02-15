local stat_scale = const.Scale.Stat
local functions = Tremualin.Functions
local configuration = Tremualin.Configuration
configuration.TouristGeodomeSatisfaction = 3000
configuration.ProjectMorphiousPositiveTraitChance = 4
configuration.ProjectMorphiousMaxTraits = 7

local ProjectMorphiousPositiveTraitsKey = "Tremualin_ProjectMorphiousPositiveTraits"
local TouristGeodomeSatisfactionReasonId = "Tremualin_GeoscapeDome"
local TouristGeodomeSatisfactionReason = "Like Earth. On Mars! (Geoscape Dome) <amount>"
local GeodomeHealthBoost = 5 * stat_scale
local GeodomeMoraleBoost = 10
local GeodomeMoraleBoostId = "Tremualin_GeoscapeDome_MoraleBoost"
local GeodomeMoraleBoostReason = "Like Earth. On Mars! (Geoscape Dome)"

function OnMsg.ClassesPostprocess()
    ColonistStatReasons[TouristGeodomeSatisfactionReasonId] = TouristGeodomeSatisfactionReason

    local Tremualin_Orig_Colonist_Rest = Colonist.Rest
    function Colonist:Rest()
        local orig = Tremualin_Orig_Colonist_Rest(self)
        -- ProjectMorpheus grants even more positive traits
        local wonder = self.city.labels.ProjectMorpheus or empty_table
        if not self.traits.Child and #wonder > 0 and wonder[1].working then
            local count = 0
            for id, _ in pairs(self.traits) do
                local trait = TraitPresets[id]
                -- only counts positive traits
                if trait and trait.category and trait.category == "Positive" then
                    count = count + 1
                end -- if trait
            end -- for id, _
            if count < configuration.ProjectMorphiousMaxTraits and self:Random(100) <= configuration.ProjectMorphiousPositiveTraitChance then
                -- add positive trait
                wonder[1]:AddTrait(self)
                -- Tourists will pay more money for additional perks; remember it
                if self.traits.Tourist then
                    self[ProjectMorphiousPositiveTraitsKey] = (self[ProjectMorphiousPositiveTraitsKey] or 0) + 1
                end -- self.traits.Tourist
            end -- if count < configuration.ProjectMorphiousMaxTraits
        end -- if not self.traits.Child
        -- end ProjectMorpheus
        -- GeoscapeDome
        local dome = self.dome
        if dome and dome:IsKindOf("GeoscapeDome") then
            if self.traits.Tourist then
                self:ChangeSatisfaction(configuration.TouristGeodomeSatisfaction, TouristGeodomeSatisfactionReasonId)
            end -- if self.traits.Tourist
            functions.TemporarilyModifyMorale(self, GeodomeMoraleBoost, 0, 2, GeodomeMoraleBoostId, GeodomeMoraleBoostReason)
            self:ChangeHealth(GeodomeHealthBoost, "dome")
        end -- if dome
        -- end GeoscapeDome
        return orig
    end -- function Colonist:Rest
end -- function OnMsg.ClassesPostprocess()

local Tremualin_Orig_Holday_Rating_Reward_Money = HolidayRating.RewardMoney
function HolidayRating:RewardMoney(rating, tourist)
    local originalRewardMoney = Tremualin_Orig_Holday_Rating_Reward_Money(self, rating, tourist)
    return originalRewardMoney + MulDivRound(originalRewardMoney, tourist[ProjectMorphiousPositiveTraitsKey] or 0, 10)
end
