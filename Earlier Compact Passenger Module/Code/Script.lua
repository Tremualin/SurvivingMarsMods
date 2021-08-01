-- Swap compact passenger module with fuel compression
function OnMsg.ClassesPostprocess()
	local engineering = Presets.TechPreset.Engineering
	engineering.CompactPassengerModule.position = range(1, 5)
	engineering.FuelCompression.position = range(6, 12)
end