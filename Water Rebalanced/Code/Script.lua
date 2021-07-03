local function AddParentToClass(class_obj, parent_name)
	local p = class_obj.__parents
	if not table.find(p, parent_name) then
		p[#p+1] = parent_name
	end
end

AddParentToClass(MoistureVaporator, "TerraformingBuildingBase")

function modifyMoistureVaporators()
	local g_Classes = g_Classes

	local ct = ClassTemplates.Building
	local BuildingTemplates = BuildingTemplates

	local MoistureVaporatorBuildingTemplate = BuildingTemplates.MoistureVaporator
	
	MoistureVaporatorBuildingTemplate.terraforming_param = "Water"
	MoistureVaporatorBuildingTemplate.terraforming_boost_sol = -10
	
	ct.MoistureVaporator.terraforming_param = "Water"
	ct.MoistureVaporator.terraforming_boost_sol = -10
end

OnMsg.LoadGame = modifyMoistureVaporators
OnMsg.CityStart = modifyMoistureVaporators

function MoistureVaporator:GetTerraformingBoostSol()
  return self.terraforming_boost_sol + MulDivRound(self.terraforming_boost_sol, GetTerraformParam("Water"), 100 * const.TerraformingScale)
end

function getWaterLoss() 
	local water = MulDivRound(GetTerraformParam("Water"), 1, const.TerraformingScale)
	return MulDivRound(water * -1, (100 * const.TerraformingScale - GetTerraformParam("Atmosphere")) * 0.02, const.TerraformingScale)
end

-- Passively lose water
GlobalVar("WaterLossThread", false)
function initializeWaterLossThread() 
    if IsValidThread(WaterLossThread) then
        DeleteThread(WaterLossThread)
    end
    WaterLossThread = (CreateGameTimeThread(
                               function()
            local sleep = const.HourDuration / 5
            local sol = const.DayDuration
            while true do
                Sleep(sleep)
                local waterLoss = (MulDivRound(GetVegetationReproductionBonus(), sleep, sol))
                if waterLoss > 0 then
                    ChangeTerraformParam("Water", waterLoss)
                end
            end
        end))
end
OnMsg.CityStart=initializeWaterLossThread
OnMsg.LoadGame=initializeWaterLossThread

-- Show the passive vegetation boost in the UI
function OnMsg.ClassesPostprocess()
    for _, preset in ipairs(Presets.TerraformingParam.Default or empty_table) do
        if preset.id == "Water" then
            if not preset.Factors then preset.Factors = {} end
            local alreadyDefined = false
            for _, factor in ipairs(preset.Factors or empty_table) do
                if factor.Id == "WaterLoss" then 
                    alreadyDefined = true 
                    break
                end
            end
            if not alreadyDefined then
                local newFactor = PlaceObj("TerraformingFactorItem", {
                    "Id", "WaterLoss", "display_name", "Water leaked out of the atmosphere",
                    "units", "PerSol", "GetFactorValue",
                    function(self) return getWaterLoss() end
                })
                table.insert(preset.Factors, newFactor)
            end
            break
        end
    end
end