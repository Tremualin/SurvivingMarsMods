local function ImproveLiveFromMarsDescription()
    local tech = Presets.TechPreset.Social["LiveFromMars"]
    local modified = tech.Tremualin_ImprovedLiveFromMars
    if not modified then
        tech.description = Untranslated("Gain <em>Applicants</em> for every new technology or milestone you get (1/500 Research Points, min 2)\n") .. tech.description
        tech.Tremualin_ImprovedLiveFromMars = true
    end
end

OnMsg.LoadGame = ImproveLiveFromMarsDescription
OnMsg.CityStart = ImproveLiveFromMarsDescription

GlobalVar("Tremualin_LiveFromMarsResearched", false)
local function AddBonusApplicantsBasedOnResearch(cost)
    local bonusApplicants = Max(2, MulDivRound(cost, 1, 500))
    for i = 1, bonusApplicants do
        GenerateApplicant()
    end
end

function OnMsg.TechResearched(tech_id, research, first_time)
    if tech_id == "LiveFromMars" then
        Tremualin_LiveFromMarsResearched = true
    end

    if Tremualin_LiveFromMarsResearched then
        AddBonusApplicantsBasedOnResearch(research.tech_status[tech_id].cost)
    end
end

function OnMsg.MilestoneCompleted(milestone_id)
    if Tremualin_LiveFromMarsResearched then
        local enactor = MilestoneEnactors[milestone_id]
        if enactor == MainCity then
            AddBonusApplicantsBasedOnResearch(Presets.Milestone.Default[milestone_id].reward_research)
        end
    end
end
