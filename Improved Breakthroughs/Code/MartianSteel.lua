local function ImproveMartialSteel()
    local tech = Presets.TechPreset.Breakthroughs["MartianSteel"]
    -- Make sure that the percentage is 33% instead of 25%
    tech[1].Percent = -33
    tech.param1 = 33

    if not tech[2] then
        table.insert(tech, PlaceObj("Effect_Code", {
            OnApplyEffect = function(self, colony, parent)
                colony:ForEachLabelObject("ConstructionSite", "RefreshConstructionResources")
                colony:ForEachLabelObject("ConstructionSiteWithHeightSurfaces", "RefreshConstructionResources")
            end
        }))
    end
end

OnMsg.ClassesPostprocess = ImproveMartialSteel
