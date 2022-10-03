-- Smart Homes, Apartments, and Senior Residences have a chance of satisfying Luxury, Drinking, Gaming and/or Exercise. The higher the comfort level, the higher the chance.
local smart_residences = {SeniorsResidenceCCP1 = true, SmartHome = true, SmartHome_Small = true, SmartApartmentsCCP1 = true}
local smart_interests = {interestExercise = true, interestGaming = true, interestLuxury = true, interestDrinking = true}
local smart_interest_message = {interestExercise = "<green>Smart home, smart exercise </color>", interestGaming = "<green>Smart home, smart gaming </color>", interestLuxury = "<green>Smart home, luxurious home </color>", interestDrinking = "<green>Smart home, smart drinking </color>"}
local Tremualin_Orig_Colonist_DailyUpdate = Colonist.DailyUpdate
function Colonist:DailyUpdate()
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
    Tremualin_Orig_Colonist_DailyUpdate(self)
end

local function ImproveSmartHomes()
    local tech = Presets.TechPreset.Engineering["SmartHome"]
    local modified = tech.Tremualin_AdvancedHome
    if not modified then
        tech.description = Untranslated("All new buildings have a chance of satisfying Luxury, Drinking, Gaming and/or Exercise. The higher the comfort level, the higher the chance.\n") .. tech.description
        tech.Tremualin_AdvancedHome = true
    end
end

function ImproveFuelCompression()
    local tech = Presets.TechPreset.Engineering["FuelCompression"]

    local alreadyDefined = false
    for _, effect in pairs(tech) do
        if effect and type(effect) == "table" and effect.IsKindOf and effect:IsKindOf("Effect_ModifyLabel") and effect.Label == "AllRockets" then
            alreadyDefined = true
            break
        end
    end
    if not alreadyDefined then
        -- Fuel Compression allows you to export 10 additional Rare Metals
        table.insert(tech, PlaceObj("Effect_ModifyLabel", {
            Amount = 10,
            Label = "AllRockets",
            Prop = "max_export_storage"
        }))

        tech.description = Untranslated("<em>Rocket</em> Rare Metal Export capacity increased by 10.\n") .. tech.description
    end
end

local function ImproveAdaptedProbes()
    local tech = Presets.TechPreset.Physics["AdaptedProbes"]
    local modified = tech.Tremualin_3Probes
    if not modified then
        tech.description = Untranslated("Immediately gain 3 <em>Probes</em>\n") .. tech.description
        tech.Tremualin_3Probes = true
    end
end

function OnMsg.TechResearched(tech_id)
    if tech_id == "AdaptedProbes" then
        local sponsor_id = GetMissionSponsor().id
        for i = 1, 3 do
            if sponsor_id == "NASA" then PlaceObject("AdvancedOrbitalProbe", {city = MainCity})
            else PlaceObject("OrbitalProbe", {city = MainCity}) end
        end
    end
end

local function ImproveResilientArchitecture()
    local tech = Presets.TechPreset.Engineering["ResilientArchitecture"]
    local modified = tech.Tremualin_AdditionalRefund
    if not modified then
        tech.description = Untranslated("Salvaging now yields back the <em>full cost</em> of a building\n") .. tech.description
        tech.Tremualin_AdditionalRefund = true
    end
end

local orig_CalcRefundAmount = Building.CalcRefundAmount
function Building:CalcRefundAmount(total_amount)
    if self.city.colony:IsTechResearched("ResilientArchitecture") then
        total_amount = total_amount * 2
    end
    return orig_CalcRefundAmount(self, total_amount)
end

local function ImproveMartianFestivals()
    local tech = Presets.TechPreset.Social["MartianFestivals"]
    local alreadyDefined = false
    for _, effect in pairs(tech) do
        if effect and type(effect) == "table" and effect.IsKindOf and effect:IsKindOf("Effect_ModifyLabel") and effect.Prop == "satisfaction_change" then
            alreadyDefined = true
            break
        end
    end
    if not alreadyDefined then
        -- Martian Festivals grants additional Satisfaction to tourists who use Decorations
        table.insert(tech, PlaceObj("Effect_ModifyLabel", {
            Amount = 2,
            Label = "Decorations",
            Prop = "satisfaction_change"
        }))

        tech.description = Untranslated("<em>Decorations</em> now grant 2 satisfaction to tourists\n") .. tech.description
    end
end

local function ImproveTechnologies()
    ImproveSmartHomes()
    ImproveFuelCompression()
    ImproveAdaptedProbes()
    ImproveResilientArchitecture()
    ImproveMartianFestivals()
end

OnMsg.LoadGame = ImproveTechnologies
OnMsg.CityStart = ImproveTechnologies
