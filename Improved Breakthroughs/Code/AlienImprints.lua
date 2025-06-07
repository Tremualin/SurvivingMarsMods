function ImproveAlienImprints()
    local tech = Presets.TechPreset.Breakthroughs["AlienImprints"]
    -- Alien Imprints always spawns 10 anomalies instead of a random number between 3 and 10
    tech.param1 = 10
end

OnMsg.ClassesPostprocess = ImproveAlienImprints
