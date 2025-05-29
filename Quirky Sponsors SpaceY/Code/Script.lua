local AddOnScreenNotification = AddOnScreenNotification

local SpaceY_Space_Race_Description = [[
Research per Sol: <research(SponsorResearch)>
Rare Metals price: $<ExportPricePreciousMetals> M
 
<green>Dragon Rocket</green> - has smaller cargo capacity (<cargo>) but is faster and requires less fuel
<green>Solar Array</green> - a large cluster of solar panels with higher production and lower maintenance cost, but vulnerable to dust storms
<green>Just Read the Instructions</green> - Drone Hubs start with additional Drones
<green>Governmental Supply Contracts</green> - 50% cheaper advanced resources
 
<em>Quirks:</em>
<green>Targeted Recruiting</green> - All applicants (except Tourists) are <em>Workaholic</em>
<green>Vocation Oriented</green> - Begin the game with <em>Vocation-Oriented Society</em>
<red>Unrealistic Deadlines</red> - Lose <em>$500M</em> any time a <em>Rival</em> obtains a <em>Milestone</em>
<red>Work-Work Balance</red> - <em>Birth Rate</em> halved
<red>Sixteen Tons</red> - <em>Heavy Workload</em> is always on
]]

local SpaceY_No_Space_Race_Description = [[
Research per Sol: <research(SponsorResearch)>
Rare Metals price: $<ExportPricePreciousMetals> M
 
<green>Just Read the Instructions</green> - Drone Hubs start with additional Drones
<green>Governmental Supply Contracts</green> - 50% cheaper advanced resources
 
<em>Quirks:</em>
<green>Targeted Recruiting</green> - All applicants (except Tourists) are <em>Workaholic</em>
<green>Vocation Oriented</green> - Begin the game with <em>Vocation-Oriented Society</em>
<red>Work-Work Balance</red> - <em>Birth Rate</em> halved
<red>Sixteen Tons</red> - <em>Heavy Workload</em> is always on
]]

local function IsSpaceYSponsor()
    return g_CurrentMissionParams.idMissionSponsor == "SpaceY"
end

-- Unrealistic Deadlines
function OnMsg.RivalMilestone(...)
    if IsSpaceYSponsor() then
        UIColony.funds.funding = UIColony.funds.funding - 500000000
        AddOnScreenNotification("Tremualin_QuirkySpaceY_UnrealisticDeadlines", false)
    end
end

function OnMsg.ClassesPostprocess()
    if OnScreenNotificationPresets.Tremualin_QuirkySpaceY_UnrealisticDeadlines then
        return
    end

    PlaceObj("OnScreenNotificationPreset", {
        ImagePreview = "UI/Icons/Notifications/New/funding_2.tga",
        SortKey = 1000200,
        VignetteImage = "UI/Onscreen/onscreen_gradient_red.tga",
        VignettePulseDuration = 2000,
        close_on_read = true,
        expiration = 150000,
        fx_action = "UINotificationResource",
        group = "Default",
        id = "Tremualin_QuirkySpaceY_UnrealisticDeadlines",
        image = "UI/Icons/Notifications/New/funding_2.tga",
        priority = "Important",
        text = Untranslated("We have lost $500M for failing to accomplish a milestone before a rival"),
    title = Untranslated("Unmet deadlines")})
end

local function QuirkySponsorPreset()
    local spaceY = Presets.MissionSponsorPreset[1].SpaceY
    -- Don't modify the sponsor twice
    if not spaceY.Tremualin_QuirkySponsor then
        -- Work-Work Balance - Birth rate is halved
        table.insert(spaceY, PlaceObj('Effect_ModifyLabel', {
            Label = "Consts",
            Percent = 50,
            Prop = "BirthThreshold",
        }))

        -- Vocation Oriented
        table.insert(spaceY, PlaceObj('Effect_GrantTech', {Field = "Breakthroughs", Research = "Vocation-Oriented Society"}))

        -- If Space Race is installed; add the unique buildings description
        local SpaceY_Description = SpaceY_No_Space_Race_Description
        if IsDlcAvailable("gagarin") then
            SpaceY_Description = Untranslated(SpaceY_Space_Race_Description)
        end
        spaceY.effect = SpaceY_Description

        -- Set the sponsor difficulty to hard and update the challenge rating
        spaceY.challenge_mod = 170
        spaceY.difficulty = T(574527829385, "Hard")

        -- Remember that we've already modified this sponsor so we don't do it again
        spaceY.Tremualin_QuirkySponsor = true
    end
end

OnMsg.ClassesPostprocess = QuirkySponsorPreset

-- Begin Lake Changes
function ImproveSolarArrays()
    if IsDlcAvailable("gagarin") then
        local templateNames = {"SolarArray"}
        local templates = {}
        for _, templateName in pairs(templateNames) do
            table.insert(templates, BuildingTemplates[templateName])
            table.insert(templates, ClassTemplates.Building[templateName])
        end
        for _, template in ipairs(templates) do
            template.electricity_production = 85000
        end
    end
end

OnMsg.ClassesPostprocess = ImproveSolarArrays

-- Sixteen Tons - SpaceY colonists always work overtime. Always
local function MandatoryOvertimeIfSpaceY()
    local Tremualin_Orig_ToggleOvertime = Workplace.ToggleOvertime
    function Workplace:ToggleOvertime(...)
        if not IsSpaceYSponsor() then
            Tremualin_Orig_ToggleOvertime(self, ...)
        end
    end

    local Tremualin_Orig_Workplace_Init = Workplace.Init
    function Workplace:Init()
        Tremualin_Orig_Workplace_Init(self)
        if IsSpaceYSponsor() then
            for i = 1, self.max_shifts do
                self.overtime[i] = true
            end
        end
    end
end

-- Targeted Recruiting
local function WorkaholicSpaceXApplicants()
    local Tremualin_Orig_GenerateApplicant = GenerateApplicant
    function GenerateApplicant(time, city)
        local colonist = Tremualin_Orig_GenerateApplicant(time, city)
        if IsSpaceYSponsor() and not colonist.Tourist then
            colonist.traits["Hippie"] = nil
            colonist.traits["Workaholic"] = true
        end
        return colonist
    end
end

OnMsg.ClassesGenerate = WorkaholicSpaceXApplicants()
