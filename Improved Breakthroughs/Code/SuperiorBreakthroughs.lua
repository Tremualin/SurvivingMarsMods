local SUPERIOR_PIPES_ADDITIONAL_DESCRIPTION = Untranslated("\n\nWill unlock <em>Superior Cables</em> upon research if not already unlocked.")
local SUPERIOR_CABLES_ADDITIONAL_DESCRIPTION = Untranslated("\n\nWill unlock <em>Superior Pipes</em> upon research if not already unlocked.")

local function ModifyDescription(tech, additional_description)
    if not tech.Tremualin_DiscoverFirstUndiscoveredSuperiorTech then
        tech.description = tech.description .. additional_description
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

    ModifyDescription(superiorCables, SUPERIOR_CABLES_ADDITIONAL_DESCRIPTION)
    ModifyDescription(superiorPipes, SUPERIOR_PIPES_ADDITIONAL_DESCRIPTION)
end

OnMsg.ClassesPostprocess = ImproveSuperiorBreakthroughts
