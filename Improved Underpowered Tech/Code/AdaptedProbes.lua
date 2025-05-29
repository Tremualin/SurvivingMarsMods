local function ImproveAdaptedProbes()
    local tech = Presets.TechPreset.Physics["AdaptedProbes"]
    local modified = tech.Tremualin_3Probes
    if not modified then
        tech.description = Untranslated("Immediately gain 3-5 <em>Probes</em>\n") .. tech.description
        tech.Tremualin_3Probes = true
    end
end

function OnMsg.TechResearched(tech_id)
    if tech_id == "AdaptedProbes" then
        local sponsor_id = GetMissionSponsor().id
        for i = 1, table.rand({3, 4, 5}) do
            if sponsor_id == "NASA" then PlaceObject("AdvancedOrbitalProbe", {city = MainCity})
            else PlaceObject("OrbitalProbe", {city = MainCity}) end
        end
    end
end

OnMsg.LoadGame = ImproveAdaptedProbes
OnMsg.CityStart = ImproveAdaptedProbes
