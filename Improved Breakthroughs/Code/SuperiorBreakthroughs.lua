local ADDITIONAL_DESCRIPTION = Untranslated("\nWill unlock another superior <em>breakthrough</em> upon research until all 2 Superior Breakthrough have been discovered.")

local function ModifyDescription(tech)
    if not tech.Tremualin_DiscoverFirstUndiscoveredSuperiorTech then
        tech.description = tech.description .. ADDITIONAL_DESCRIPTION
        tech.Tremualin_DiscoverFirstUndiscoveredSuperiorTech = true
    end
end

local function DiscoverFirstUndiscoveredSuperiorTech(self, colony, parent)
    local techs = {"SuperiorCables", "SuperiorPipes"}
    for _, tech in ipairs(techs) do
        if not colony:IsTechDiscovered(tech) then
            colony:SetTechDiscovered(tech)
            break
        end
    end
end

-- Researching one of these will eventually research them all
function ImproveSuperiorBreakthroughts()
    local superiorCables = Presets.TechPreset.Breakthroughs["SuperiorCables"]
    local superiorPipes = Presets.TechPreset.Breakthroughs["SuperiorPipes"]

    if not superiorCables[2] then
        table.insert(superiorCables, PlaceObj("Effect_Code", {
            OnApplyEffect = DiscoverFirstUndiscoveredSuperiorTech
        }))
    end

    if not superiorPipes[2] then
        table.insert(superiorPipes, PlaceObj("Effect_Code", {
            OnApplyEffect = DiscoverFirstUndiscoveredSuperiorTech
        }))
    end

    ModifyDescription(superiorCables)
    ModifyDescription(superiorPipes)
end

OnMsg.ClassesPostprocess = ImproveSuperiorBreakthroughts
