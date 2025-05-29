local function MoveAdaptedProbesToStoryBits()
    local techPreset = Presets.TechPreset
    local adaptedProbes = techPreset.Physics["AdaptedProbes"]
    table.remove_entry(techPreset.Physics, adaptedProbes)
    adaptedProbes.group = "Storybits"
    table.insert(techPreset.Storybits, adaptedProbes)
end

OnMsg.ClassesPreprocess = MoveAdaptedProbesToStoryBits

local function ResearchAndHideAdaptedProbes()
    UIColony:SetTechResearched("AdaptedProbes", false)
    UIColony.tech_status.AdaptedProbes.discovered = false
end

function SavegameFixups.StoryBitStateMapID()
    -- Fix save games that don't have this change
    ResearchAndHideAdaptedProbes()
end

OnMsg.CityStart = ResearchAndHideAdaptedProbes
