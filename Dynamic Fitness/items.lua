return {
PlaceObj('ModItemCode', {
	'name', "Fitness",
	'FileName', "Code/Fitness.lua",
}),
PlaceObj('ModItemCode', {
	'name', "FitnessUI",
	'FileName', "Code/FitnessUI.lua",
}),
PlaceObj('ModItemCode', {
	'name', "WorkOpenAirGym",
	'FileName', "Code/WorkOpenAirGym.lua",
}),
PlaceObj('ModItemTraitPreset', {
	_incompatible = "Fit",
	auto = false,
	category = "Negative",
	description = T(766702943671, --[[ModItemTraitPreset Unfit description]] "Unfit colonists recover 50% less health from all sources and lose sanity when visiting any building that provides exercise. The flaw is lost when the Fitness level is >=30"),
	display_icon = "",
	display_name = T(707453261314, --[[ModItemTraitPreset Unfit display_name]] "Unfit"),
	dome_filter_only = true,
	group = "Negative",
	id = "Unfit",
	incompatible = {
		Fit = true,
	},
	name = "Unfit",
	weight = 0,
}),
}
