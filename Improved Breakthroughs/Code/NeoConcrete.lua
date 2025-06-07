local NEO_CONCRETE_UPDATED_DESCRIPTION = Untranslated(
[[Lowers <em>Concrete</em> costs for building construction by <param1>%.
 
<grey>Mixing recently discovered materials made from Martian polymers with the Martian regolith have unlocked the wonder material that is Neo-Concrete. It is vastly stronger, yet lighter than its predecessor.</grey>]])

local function ImproveNeoConcrete()
    local tech = Presets.TechPreset.Breakthroughs["NeoConcrete"]
    tech.description = NEO_CONCRETE_UPDATED_DESCRIPTION
    tech.param1 = 33
    -- Switch from dome concrete cost modifier, to concrete cost modifier
    tech[1].Prop = "Concrete_cost_modifier"
    -- And make sure that the percentage is 33%
    tech[1].Percent = -33
    tech[1].Label = "Consts"

    if not tech[2] then
        table.insert(tech, PlaceObj("Effect_Code", {
            OnApplyEffect = function(self, colony, parent)
                colony:ForEachLabelObject("ConstructionSite", "RefreshConstructionResources")
                colony:ForEachLabelObject("ConstructionSiteWithHeightSurfaces", "RefreshConstructionResources")
            end
        }))
    end
end

OnMsg.ClassesPostprocess = ImproveNeoConcrete
