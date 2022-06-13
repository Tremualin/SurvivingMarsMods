local ProgressPointsPerResearchSteal = 1000000
local MaxResearchStealCollaborationLoss = 50

local function IsChinaSponsor()
    return g_CurrentMissionParams.idMissionSponsor == "CNSA"
end

DefineClass.ResearchStealer = {
    __parents = {
        "InitDone",
        "ElectricityConsumer",
        "Workplace"
    },
    properties = {
        {
            template = true,
            modifiable = true,
            id = "ResearchStealProgressPerDay",
            name = Untranslated("RS/Day"),
            editor = "number",
            category = "Other",
            default = 100000,
            help = "Research Steal Progress Generated Per Day",
            scale = 1000
        };
    },
    building_update_time = const.HourDuration,
    lifetime_research_steal_progress = 0
}
GlobalVar("g_ResearchStealProgress", 0)
function ResearchStealer:BuildingUpdate(dt, ...)
    if self.working and IsChinaSponsor() then
        self:AddResearchStealProgress(dt)
    end
end
function ResearchStealer:GetEstimatedDailyProduction()
    local total = 0
    local durations = const.DefaultWorkshiftDurations
    for i = 1, #durations do
        total = total + self:ModifyValue(self:GetWorkshiftPerformance(i), "performance") * durations[i] * self.ResearchStealProgressPerDay
    end
    local pts = total / (100 * const.HoursPerDay)
    local res = 0
    local collaboration_loss = 0
    if self.working then
        res = MulDivRound(pts, 100 - self:GetCollaborationLoss(), 100)
        collaboration_loss = pts - res
    end
    return res, collaboration_loss, pts
end
function ResearchStealer:GetEstimatedDailyLoss()
    local pts, loss, total = self:GetEstimatedDailyProduction()
    return loss
end
function ResearchStealer:GetEstimatedDailyTotal()
    local pts, loss, total = self:GetEstimatedDailyProduction()
    return total
end
function ResearchStealer:GetResearchStealProgress()
    return MulDivRound(100, g_ResearchStealProgress, ProgressPointsPerResearchSteal)
end
function ResearchStealer:AddResearchStealProgress(dt)
    if not self.working then
        return 0
    end
    local points_to_add = MulDivRound(self.performance * self.ResearchStealProgressPerDay, dt, const.DayDuration * 100)
    points_to_add = MulDivRound(points_to_add, 100 - self:GetCollaborationLoss(), 100)
    g_ResearchStealProgress = g_ResearchStealProgress + points_to_add
    self.lifetime_research_steal_progress = self.lifetime_research_steal_progress + points_to_add
    if g_ResearchStealProgress >= ProgressPointsPerResearchSteal then
        self:StealResearch()
    end
end
function ResearchStealer:StealResearch()
    g_ResearchStealProgress = 0
    if table.count(RivalAIs) > 0 then
        local city = MainCity
        local target_player = table.rand(table.values(RivalAIs))
        local researched = target_player.researched_techs
        if researched then
            local techs = {}
            for _, tech_id in ipairs(researched or empty_table) do
                if not UIColony:IsTechResearched(tech_id) then
                    table.insert(techs, tech_id)
                end
            end
            local tech = table.rand(techs)
            if tech then
                GrantTech(tech)
                AddOnScreenNotification("CovertOpSuccess_Tech", nil, {
                    tech_name = TechDef[tech].display_name
                }, nil, city.map_id)
            else
                local research = Max(1000, target_player.resources.research_production * 5)
                city.colony:AddResearchPoints(research)
                AddOnScreenNotification("CovertOpSuccess_Research", nil, {number = research}, nil, city.map_id)
            end
        end
    end
end
function ResearchStealer:GetCollaborationLoss()
    local blds = self.city.labels[self.template_name]
    local count = 1
    for i = 1, #blds do
        local bld = blds[i]
        if bld ~= self and bld.working then
            count = count + 1
        end
    end
    return Min(MaxResearchStealCollaborationLoss, (count - 1) * 10)
end
