local DUST_REPULSION_UPDATED_DESCRIPTION = Untranslated([[
<em>Solar Panels</em> (and special ones) no longer require maintenance.
 
<grey>Solar Panels are inherently vulnerable to dust, more so than any other equipment used on Mars. Thus automatic dust repulsion systems are put in place to eliminate maintenance periods.</grey>]])

local function ImproveDustRepulsion()
    local tech = Presets.TechPreset.Physics.DustRepulsion
    local modified = tech.Tremualin_ImprovedDustRepulsion
    if not modified then
        tech.description = DUST_REPULSION_UPDATED_DESCRIPTION
        -- Solar Panels no longer require maintenance
        table.insert(tech, #tech + 1, PlaceObj('Effect_ModifyLabel', {
            Amount = 1,
            Label = "SolarPanelBuilding",
            Prop = "disable_maintenance",
        }))
        -- And no longer accumulate dust
        table.insert(tech, #tech + 1, PlaceObj('Effect_ModifyLabel', {
            Amount = 0,
            Label = "SolarPanelBuilding",
            Prop = "accumulate_dust",
        }))
        tech.Tremualin_ImprovedDustRepulsion = true
    end
end

-- If a Solar Panel fails due to Story Bits; it will once again start requesting maintenance.
-- This will fix it upon loading a new game
local function FixExceptionalCircumstances()
    if UIColony:IsTechResearched("DustRepulsion") then
        MapForEach(true, "SolarPanelBuilding", function(o)
            o:DisableMaintenance()
        end)
    end
end

OnMsg.ClassesPostprocess = ImproveDustRepulsion
OnMsg.LoadGame = FixExceptionalCircumstances

local Tremualin_Orig_SolarPanelBuilding_OnChangeState = SolarPanelBuilding.OnChangeState
function SolarPanelBuilding:OnChangeState()
    Tremualin_Orig_SolarPanelBuilding_OnChangeState(self)
    if g_DustRepulsion then
        self:ResetMaintenanceState()
        self.accumulate_dust = false
        self.accumulate_maintenance_points = false
        self.accumulated_maintenance_points = 0
        self.disable_maintenance = true
        self.show_dust_visuals = false
    end
end
