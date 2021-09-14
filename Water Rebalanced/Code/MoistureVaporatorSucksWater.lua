local functions = Tremualin.Functions

local moisture_drainage_text = Untranslated("<em>Moisture Vaporators</em> reduce the level of Water <icon_WaterTP_alt> on Mars.<newline>")

functions.AddParentToClass(MoistureVaporator, "TerraformingBuildingBase")

function ModifyMoistureVaporators()
    local g_Classes = g_Classes

    local ct = ClassTemplates.Building
    local MoistureVaporatorBuildingTemplate = BuildingTemplates.MoistureVaporator

    MoistureVaporatorBuildingTemplate.terraforming_param = "Water"
    MoistureVaporatorBuildingTemplate.terraforming_boost_sol = -10

    ct.MoistureVaporator.terraforming_param = "Water"
    ct.MoistureVaporator.terraforming_boost_sol = -10

    local tech = Presets.TechPreset.Biotech["MoistureFarming"]
    local modified = tech.Tremualin_MoistureConsumption
    if not modified then
        tech.description = Untranslated(moisture_drainage_text) .. tech.description
        tech.Tremualin_MoistureConsumption = true
    end
end

OnMsg.LoadGame = ModifyMoistureVaporators
OnMsg.CityStart = ModifyMoistureVaporators

-- As water increases in the atmosphere, so does the sucking capability
function MoistureVaporator:GetTerraformingBoostSol()
    return self.terraforming_boost_sol + MulDivRound(self.terraforming_boost_sol, GetTerraformParam("Water"), 100 * const.TerraformingScale)
end
