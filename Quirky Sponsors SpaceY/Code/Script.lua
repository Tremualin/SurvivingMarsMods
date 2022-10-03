local AddOnScreenNotification = AddOnScreenNotification

local SpaceY_Space_Race_Description = [[Research per Sol: <research(SponsorResearch)>
Rare Metals price: $<ExportPricePreciousMetals> M
 
<green>Dragon Rocket</green> - has smaller cargo capacity (<cargo>) but is faster and requires less fuel
<green>Solar Array</green> - a large cluster of solar panels that have lower maintenance cost but are vulnerable to dust storms
<green>Just Read the Instructions</green> - Drone Hubs start with additional Drones
<green>Governmental Supply Contracts</green> - 50% cheaper advanced resources
<green>Imperator of Mirihi</green> - Begin the game with <em>Interplanetary Learning</em>
<white>Acquirer of Companies</white> - Every 20th Sol, randomly gain or lose 500M
<white>Father of Mars</green> - Begin the game with <em>Cloning</em>. However, Colonists won't have Children
<red>Breaker of Unions</red> - <em>Heavy Workload</em> is mandatory and cannot be turned off]]

local SpaceY_No_Space_Race_Description = [[Research per Sol: <research(SponsorResearch)>
Rare Metals price: $<ExportPricePreciousMetals> M
 
<green>Just Read the Instructions</green> - Drone Hubs start with additional Drones
<green>Governmental Supply Contracts</green> - 50% cheaper advanced resources
<green>Imperator of Mirihi</green> - Begin the game with <em>Interplanetary Learning</em>
<white>Acquirer of Companies</white> - Every 20th Sol, randomly gain or lose 500M.
<white>Father of Mars</green> - Begin the game with <em>Cloning</em>. However, Colonists won't have Children
<red>Breaker of Unions</red> - <em>Heavy Workload</em> is mandatory and cannot be turned off]]

local EVERY_X_SOLS = 20
local POSITIVE_FUNDING_FROM_COMPANIES = 500000000
local NEGATIVE_FUNDING_FROM_COMPANIES = -500000000
GlobalVar("Tremualin_SpaceY_AcquirerOfCompaniesThread", false)
function Tremualin_SpaceY_AcquirerOfCompanies(...)
    if not IsValid(Tremualin_SpaceY_AcquirerOfCompaniesThread) then
        DeleteThread(Tremualin_SpaceY_AcquirerOfCompaniesThread)
    end
    Tremualin_SpaceY_AcquirerOfCompaniesThread = CreateGameTimeThread(function()
        while true do
            local funding = POSITIVE_FUNDING_FROM_COMPANIES
            if Random(2) == 0 then
                funding = NEGATIVE_FUNDING_FROM_COMPANIES
            end
            local ok, day = WaitMsg("NewDay")
            if ok and day and day % EVERY_X_SOLS == 0 then
                UIColony.funds:ChangeFunding(funding)
                if funding > 0 then
                    AddOnScreenNotification("Tremualin_SpaceY_CompanySold", nil, {
                        funding = funding
                    }, nil, city.map_id)
                else
                    AddOnScreenNotification("Tremualin_SpaceY_CompanyBought", nil, {
                        funding = funding
                    }, nil, city.map_id)
                end
            end
        end
    end)
end

function OnMsg.ClassesPostprocess()
    if OnScreenNotificationPresets.Tremualin_SpaceY_CompanySold then
        return
    end
    PlaceObj("OnScreenNotificationPreset", {
        group = "Default",
        id = "Tremualin_SpaceY_CompanySold",
        image = "UI/Icons/Notifications/New/funding.tga",
        text = Untranslated("Funding gained: <funding>"),
    title = Untranslated("Company Sold")})
end

function OnMsg.ClassesPostprocess()
    if OnScreenNotificationPresets.Tremualin_SpaceY_CompanyBought then
        return
    end
    PlaceObj("OnScreenNotificationPreset", {
        group = "Default",
        id = "Tremualin_SpaceY_CompanyBought",
        image = "UI/Icons/Notifications/New/funding_2.tga",
        text = Untranslated("Funding lost: <funding>"),
    title = Untranslated("Company Bought")})
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

        table.insert(SpaceY, PlaceObj('Effect_Code', {OnApplyEffect = Tremualin_SpaceY_AcquirerOfCompanies}))

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
