function ImproveMartianDiet()
    local tech = Presets.TechPreset.Breakthroughs["MartianDiet"]

    if tech.Tremualin_MartianDietFitness then
        return
    end

    tech.description = Untranslated("<em>Good nutrition</em> bonuses from prepared food provides 25% more <em>Fitness</em>\n") .. tech.description
    tech.Tremualin_MartianDietFitness = true
end

local function ImproveTechnologies()
    ImproveMartianDiet()
end

OnMsg.ClassesPostprocess = ImproveTechnologies
