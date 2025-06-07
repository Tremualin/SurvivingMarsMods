local DOME_STREAMLINING_UPDATED_DESCRIPTION = Untranslated(
[[<em>Domes</em> cost <param1>% less resources (<em>Polymers</em> <if_all(has_dlc('picard'))>and </em>Exotic Minerals</em></if> included)
 
<grey>Mastering of certain techniques, singled out to be crucial to the entire construction process, will result in the drop of Dome construction costs.</grey>]])

local function ImproveDomeStreamlining()
    local tech = Presets.TechPreset.Breakthroughs["DomeStreamlining"]
    tech.description = DOME_STREAMLINING_UPDATED_DESCRIPTION
    if not tech[5] then
        table.insert(tech, PlaceObj('Effect_ModifyConstructionCost', {
            Building = "GeoscapeDome",
            Percent = -50,
            Resource = "Polymers",
        }))
    end

    if not tech[6] then
        table.insert(tech, PlaceObj('Effect_ModifyLabel', {
            Label = "Domes_Construction",
            Percent = -50,
            Prop = "construction_cost_Polymers",
        }))
    end

    if not tech[7] then
        table.insert(tech, PlaceObj('Effect_ModifyLabel', {
            Label = "Domes_Construction",
            Percent = -50,
            Prop = "construction_cost_PreciousMinerals",
        }))
    end

    if not tech[8] then
        table.insert(tech, PlaceObj("Effect_Code", {
            OnApplyEffect = function(self, colony, parent)
                colony:ForEachLabelObject("ConstructionSiteWithHeightSurfaces", "RefreshConstructionResources")
            end
        }))
    end

end

OnMsg.ClassesPostprocess = ImproveDomeStreamlining
