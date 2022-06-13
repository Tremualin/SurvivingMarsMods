local SpaceY_Space_Race_Description = [[Research per Sol: <research(SponsorResearch)>
Rare Metals price: $<ExportPricePreciousMetals> M
 
<green>Dragon Rocket</green> - has smaller cargo capacity (<cargo>) but is faster and requires less fuel
<green>Solar Array</green> - a large cluster of solar panels that have lower maintenance cost but are vulnerable to dust storms
<green>Just Read the Instructions</green> - Drone Hubs start with additional Drones
<green>Governmental Supply Contracts</green> - 50% cheaper advanced resources
<green>Work-Life "Balance"</green> - Begin the game with <em>Interplanetary Learning</em>
<green>Imperator Of Mars</green> - Begin the game with <em>Cloning</em>. 
<white>Rocking Robin (Tweet Tweet Tweet)</white> - Every 10 Sols, randomly gain or lose 500M. For no particular reason
<red>Under Pressure</red> - <em>Overtime</em> is always on and cannot be turned off
<red>Ain't Nobody Got Time for That</red> - Colonists won't have children]]

local SpaceY_No_Space_Race_Description = [[Research per Sol: <research(SponsorResearch)>
Rare Metals price: $<ExportPricePreciousMetals> M
 
<green>Just Read the Instructions</green> - Drone Hubs start with additional Drones
<green>Governmental Supply Contracts</green> - 50% cheaper advanced resources
<green>Work-Life "Balance"</green> - Begin the game with <em>Interplanetary Learning</em>
<green>Imperator Of Mars</green> - Begin the game with <em>Cloning</em>. 
<white>Rocking Robin (Tweet Tweet Tweet)</white> - Every 10 Sols, randomly gain or lose 500M. For no particular reason
<red>Under Pressure</red> - <em>Overtime</em> is mandatory and cannot be turned off
<red>Ain't Nobody Got Time for That</red> - Colonists won't have children]]

local POSITIVE_FUNDING_FROM_TWEETS = 500000000
local NEGATIVE_FUNDING_FROM_TWEETS = -500000000
GlobalVar("Tremualin_SpaceYRockingRobinThread", false)
function Tremualin_SpaceYRockingRobin(...)
    if not IsValid(Tremualin_SpaceYRockingRobinThread) then
        DeleteThread(Tremualin_SpaceYRockingRobinThread)
    end
    Tremualin_SpaceYRockingRobinThread = CreateGameTimeThread(function()
        while true do
            local funding = POSITIVE_FUNDING_FROM_TWEETS
            if Random(1, 2) == 1 then
                funding = NEGATIVE_FUNDING_FROM_TWEETS
            end
            local ok, day = WaitMsg("NewDay")
            if ok and day and day % 10 == 0 then
                UIColony.funds:ChangeFunding(funding)
                print("Tweet Tweet Tweet")
            end
        end
    end)
end

function OnMsg.ClassesPostprocess()
    local SpaceY = Presets.MissionSponsorPreset[1].SpaceY
    if not SpaceY.Tremualin_QuirkySponsor then
        table.insert(SpaceY, PlaceObj('Effect_ModifyLabel', {
            Label = "Consts",
            Percent = 5000,
            Prop = "MinComfortBirth",
        }))

        table.insert(SpaceY, PlaceObj('Effect_GrantTech', {Field = "Breakthroughs", Research = "Cloning"}))

        table.insert(SpaceY, PlaceObj('Effect_GrantTech', {Field = "Breakthroughs", Research = "InterplanetaryLearning"}))

        table.insert(SpaceY, PlaceObj('Effect_Code', {OnApplyEffect = Tremualin_SpaceYRockingRobin}))

        -- If Space Race; add the unique buildings description
        local SpaceY_Description = SpaceY_No_Space_Race_Description
        if IsDlcAvailable("gagarin") then
            SpaceY_Description = Untranslated(SpaceY_Space_Race_Description)
        end
        SpaceY.effect = SpaceY_Description
        SpaceY.challenge_mod = 170
        SpaceY.difficulty = T(574527829385, "Hard")
        SpaceY.Tremualin_QuirkySponsor = true
    end
end

local function MandatoryOvertimeIfSpaceY()
    local function IsSpaceYSponsor()
        return g_CurrentMissionParams.idMissionSponsor == "SpaceY"
    end

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

OnMsg.ClassesGenerate = MandatoryOvertimeIfSpaceY
