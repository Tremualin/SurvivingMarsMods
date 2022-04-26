local DUST_REPULSION_UPDATED_DESCRIPTION = Untranslated([[
<em>Solar Panels</em> are gradually cleaned from dust, completely eliminating maintenance (unless in range of a dust producer).
 
<grey>Solar Panels are inherently vulnerable to dust, more so than any other equipment used on Mars. Thus automatic dust repulsion systems are put in place to eliminate maintenance periods.</grey>]])

-- Dust Repulsion slowly removes dust all the time, instead of only at night
local Orig_Tremualin_SolarPanelBuilding_OnChangeState = SolarPanelBuilding.OnChangeState
function SolarPanelBuilding:OnChangeState()
    Orig_Tremualin_SolarPanelBuilding_OnChangeState(self)
    if g_DustRepulsion then
        local percent = -(100 + g_DustRepulsion)
        self:SetModifier("maintenance_build_up_per_hr", "DustRepulsion", 0, percent)
    end
end

local function ModifyDustRepulsionDescription()
    local tech = Presets.TechPreset.Physics.DustRepulsion
    local modified = tech.Tremualin_ImprovedDustRepulsion
    if not modified then
        tech.description = DUST_REPULSION_UPDATED_DESCRIPTION
        tech.Tremualin_ImprovedDustRepulsion = true
    end
end

OnMsg.ClassesPostprocess = ModifyDustRepulsionDescription
