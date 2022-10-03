-- constants
local RAT_RACE_PENALTY = -10
local LOSING_FACE_FLAW_PENALTY = -4

-- TODO: Add alternative Tai Chi garden description for Dynamic Fitness mod
local China_Description = [[Research per Sol: <research(SponsorResearch)>
Rare Metals price: $<ExportPricePreciousMetals> M
 
<green>RC Generator</green> - RC Commander that can generate power as a solar panel
<green>Tai-chi Garden</green> - Small exercising garden where visitors may become Fit
<green>Compact Rockets</green> - Passenger Rockets carry 10 additional Colonists
<green>Most Populous Country</green> - Applicants are generated twice as fast
<green>Reverse Engineering</green> -  Security Stations generate Science through <em>Reverse Engineering</em> operations on Rivals
<green>Personal Space Efficiency</green> - Residences house 50% more Colonists and Services have 50% more capacity
<white>Social Credit System</white> - Colonists (except Renegades) exponentially gain/lose morale based on their perks/flaws
<red>Losing Face</red> - Colonists (except Renegades) lose 4 sanity for each flaw and 2 sanity for each quirk they have.
<red>Educational Rat Race</red> - Students lose 10 Health and Sanity in Schools and Universities each Sol
<red>Academic Paper Mills</red> - Research Labs and Hawking Institutes work at 30% performance
<red>Electronic Drugs Prohibition</red> - Casinos and Electronic Stores cannot be built]]
-- imports
local stat_scale = const.Scale.Stat
local AddParentToClass = Tremualin.Functions.AddParentToClass
local TraitsByCategory = Tremualin.Functions.TraitsByCategory
local TemporarilyModifyMorale = Tremualin.Functions.TemporarilyModifyMorale

-- Begin Electronic Drugs Prohibition
local function IsChinaSponsor()
    return g_CurrentMissionParams.idMissionSponsor == "CNSA"
end

local function HideCasinoFromBuildMenuIfChina()
    if IsChinaSponsor() then
        BuildingTemplates.CasinoComplex.hide_from_build_menu = true
        BuildingTemplates.ShopsElectronics.hide_from_build_menu = true
    end
end

OnMsg.LoadGame = HideCasinoFromBuildMenuIfChina
OnMsg.CityStart = HideCasinoFromBuildMenuIfChina
-- End Electronic Drugs Prohibition

-- Begin General Changes
function OnMsg.ClassesPostprocess()
    local China = Presets.MissionSponsorPreset[1].CNSA
    if not China.Tremualin_QuirkySponsor then
        -- Personal Space Efficiency - Residence Capacity
        table.insert(China, PlaceObj('Effect_ModifyLabel', {
            Label = "Residence",
            Percent = 50,
            Prop = "capacity",
        }))

        -- Personal Space Efficiency - Service Max Visitors
        table.insert(China, PlaceObj('Effect_ModifyLabel', {
            Label = "Service",
            Percent = 50,
            Prop = "max_visitors",
        }))

        -- Academic Paper Mills - Research Loss
        table.insert(China, PlaceObj('Effect_ModifyLabel', {
            Label = "ResearchBuilding",
            Amount = -70,
            Prop = "ResearchPointsPerDay",
        }))

        China.effect = Untranslated(China_Description)
        China.challenge_mod = 170
        China.difficulty = T(574527829385, "Hard")
        China.Tremualin_QuirkySponsor = true
    end
end
-- End General Changes

-- Begin Security Reverse Engineering
AddParentToClass(SecurityStation, "ResearchStealer")
function OnMsg.ClassesPostprocess()
    local Tremualin_Orig_Colonist_DailyUpdate = Colonist.DailyUpdate
    function Colonist:DailyUpdate()
        Tremualin_Orig_Colonist_DailyUpdate(self)
        if IsChinaSponsor() and not self.traits.Tourist and not self.traits.Renegade and not self.traits.Child then
            local traits_by_category = TraitsByCategory(self.traits)
            -- Losing Face
            local losingFacePenalty = traits_by_category["Negative"] * LOSING_FACE_FLAW_PENALTY
            self:ChangeSanity(losingFacePenalty * stat_scale, "Losing Face ")
            -- Social Credits System
            local moraleModifier = 2 ^ traits_by_category["Positive"] - 3 ^ traits_by_category["Negative"]
            TemporarilyModifyMorale(self, moraleModifier, 0, 2, "Tremualin_SocialCreditsSystem", "Social Credits System")
        end
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
-- End Security Reverse Engineering

-- Begin Educational Rat Race
local Tremualin_Orig_TrainingBuilding_OnChangeWorkshift = TrainingBuilding.OnChangeWorkshift
function TrainingBuilding:OnChangeWorkshift(old, new)
    if old and IsChinaSponsor() then
        for _, visitor in ipairs(self.visitors[old]) do
            visitor:ChangeHealth(RAT_RACE_PENALTY * stat_scale, "Educational Rat Race ")
            visitor:ChangeSanity(RAT_RACE_PENALTY * stat_scale, "Educational Rat Race ")
        end
    end
    Tremualin_Orig_TrainingBuilding_OnChangeWorkshift(self, old, new)
end
-- End Educational Rat Race

-- Begin Changes to Sponsor Goals
local function CompleteSpecialProjects()
    PlaceObj('SponsorGoals', {
        Completed = function (self, state, param1, param2, param3)
            state.target = tonumber(param1)
            state.progress = 0
            local completedProjects = 0
            for type, numberOfCompletedSpecialProjectsOfType in pairs(g_SpecialProjectCompleted or empty_table) do
                completedProjects = completedProjects + numberOfCompletedSpecialProjectsOfType
            end
            while state.progress < state.target do
                local ok = WaitMsg("SpecialProjectCompleted")
                completedProjects = completedProjects + 1
                state.progress = completedProjects
            end
            return true
        end,
        description = Untranslated("Complete <param1> special projects"),
        group = "Default",
        id = "Tremualin_CompleteSpecialProjects",
    })

    local sponsor = GetMissionSponsor()
    if sponsor.id == "CNSA" then
        sponsor.sponsor_goal_1 = "Tremualin_CompleteSpecialProjects"
        sponsor.goal_image_1 = "UI/Messages/Goals/mission_goal_02.tga"
        sponsor.goal_1_param_1 = 2
    end
end

OnMsg.LoadGame = CompleteSpecialProjects
OnMsg.NewGame = CompleteSpecialProjects
-- End Changes to Sponsor Goals
