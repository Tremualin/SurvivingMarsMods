-- Multiplies the consumption_max_storage of all buildings by 2
function Tremualin_DoubleBuildingCapacity()
	for key, buildingTemplate in pairs(BuildingTemplates) do
		if buildingTemplate.consumption_max_storage and not buildingTemplate.Tremualin_DoubleBuildingCapacity then
			buildingTemplate.consumption_max_storage = MulDivRound(buildingTemplate.consumption_max_storage, 2, 1)
			buildingTemplate.Tremualin_DoubleBuildingCapacity = true
		end
	end
end

OnMsg.ClassesPostprocess=Tremualin_DoubleBuildingCapacity