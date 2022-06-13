local stat_scale = const.Scale.Stat
local AddParentToClass = Tremualin.Functions.AddParentToClass
local TraitsByCategory = Tremualin.Functions.TraitsByCategory
local TemporarilyModifyMorale = Tremualin.Functions.TemporarilyModifyMorale
local RAT_RACE_PENALTY = -10
local LOSING_FACE_QUIRK_PENALTY = -2
local LOSING_FACE_FLAW_PENALTY = -4

-- TODO: Add alternative Tai Chi garden description for Dynamic Fitness mod
local China_Description = [[Research per Sol: <research(SponsorResearch)>
Rare Metals price: $<ExportPricePreciousMetals> M
 
<green>RC Generator</green> - RC Commander that can generate power as a solar panel
<green>Tai-chi Garden</green> - Small exercising garden, visitors recover small amounts of Health and may become Fit
<green>Compact Rockets</green> - Passenger Rockets carry 10 additional Colonists</green>
<green>Fierce Competition</green> - Applicants are generated twice as fast</green>
<green>Reverse Engineering</green> -  Security Stations periodically "reverse engineer" technologies from Rivals.
<green>Personal Space Efficiency</green> - Residences house 50% more Colonists and Services have 50% more capacity.
<white>Social Credit System</white> - Colonists (except Renegades) exponentially gain/lose morale based on their perks/flaws/quirks.
<red>Losing Face</red> - Colonists (except Renegades) lose 4 sanity for each flaw and 2 sanity for each quirk they have. 
<red>Educational Rat Race</red> - Colonists lose 10 Sanity in Schools and Universities.  
<red>Academic Paper Mills</red> - Science output from Research Labs and Hawking Institutes is halved.
<red>Gambling Prohibition</red> - Casinos cannot be built.]]

local function IsChinaSponsor()
    return g_CurrentMissionParams.idMissionSponsor == "CNSA"
end

local function HideCasinoFromBuildMenu()
    BuildingTemplates.CasinoComplex.hide_from_build_menu = true
end

function OnMsg.ClassesPostprocess()
    local China = Presets.MissionSponsorPreset[1].CNSA
    if not China.Tremualin_QuirkySponsor then
        -- Personal Space Efficiency
        table.insert(China, PlaceObj('Effect_ModifyLabel', {
            Label = "Residence",
            Percent = 50,
            Prop = "capacity",
        }))

        -- Personal Space Efficiency
        table.insert(China, PlaceObj('Effect_ModifyLabel', {
            Label = "Service",
            Percent = 50,
            Prop = "max_visitors",
        }))

        -- Academic Paper Mills
        table.insert(China, PlaceObj('Effect_ModifyLabel', {
            Label = "ResearchBuilding",
            Amount = -50,
            Prop = "ResearchPointsPerDay",
        }))

        --Gambling Prohibition
        table.insert(China, PlaceObj('Effect_Code', {OnApplyEffect = HideCasinoFromBuildMenu}))

        China.effect = Untranslated(China_Description)
        China.challenge_mod = 170
        China.difficulty = T(574527829385, "Hard")
        China.Tremualin_QuirkySponsor = true
    end
end

AddParentToClass(SecurityStation, "ResearchStealer")

local Tremualin_Orig_Colonist_DailyUpdate = Colonist.DailyUpdate
function Colonist:DailyUpdate()
    Tremualin_Orig_Colonist_DailyUpdate(self)
    if IsChinaSponsor() and not self.traits.Tourist and not self.traits.Renegade and not self.traits.Child then
        local traits_by_category = TraitsByCategory(self.traits)
        -- Losing Face
        local losingFacePenalty = traits_by_category["Negative"] * LOSING_FACE_FLAW_PENALTY + (traits_by_category["other"] - 1) * LOSING_FACE_QUIRK_PENALTY
        self:ChangeSanity(losingFacePenalty * stat_scale, "Losing Face ")
        -- Social Credits System
        local moraleModifier = 3 ^ traits_by_category["Positive"] - 3 ^ traits_by_category["Negative"] - 2 ^ (traits_by_category["other"] - 1)
        TemporarilyModifyMorale(self, moraleModifier, 0, 2, "Tremualin_SocialCreditsSystem", "Social Credits System ")
        print(self.modifications)
    end
end

local Tremualin_Orig_ResearchBuilding_GetCollaborationLoss = ResearchBuilding.GetCollaborationLoss
function ResearchBuilding:GetCollaborationLoss()
    if IsChinaSponsor() then
        local blds = self.city.labels[self.template_name]
        local count = 1
        for i = 1, #blds do
            local bld = blds[i]
            if bld ~= self and (bld.working or (not bld:TechId() and not ElectricityConsumer.GetWorkNotPossibleReason(bld))) then
                count = count + 1
            end
        end
        return Min(g_Consts.MaxResearchCollaborationLoss, (count - 1) * 20)
    end
    return Tremualin_Orig_ResearchBuilding_GetCollaborationLoss(self)
end

local Orig_Tremualin_TrainingBuilding_OnChangeWorkshift = TrainingBuilding.OnChangeWorkshift
function TrainingBuilding:OnChangeWorkshift(old, new)
    if old and IsChinaSponsor() then
        for _, visitor in ipairs(self.visitors[old]) do
            visitor:ChangeSanity(RAT_RACE_PENALTY * stat_scale, "Educational Rat Race ")
        end
    end
    Orig_Tremualin_TrainingBuilding_OnChangeWorkshift(self, old, new)
end
