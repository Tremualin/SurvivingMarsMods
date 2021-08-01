return {
PlaceObj('ModItemCode', {
	'name', "Crime",
	'FileName', "Code/Crime.lua",
}),
PlaceObj('ModItemCode', {
	'name', "RehabiliationCenter",
	'FileName', "Code/RehabiliationCenter.lua",
}),
PlaceObj('ModItemCode', {
	'name', "Notifications",
	'FileName', "Code/Notifications.lua",
}),
PlaceObj('ModItemTraitPreset', {
	__copy_group = "",
	_incompatible = "Renegade",
	category = "Positive",
	description = T(598838342649, --[[ModItemTraitPreset Vindicated description]] "Vindicated renegades will no longer become renegades and will gain (+10) additional performance on all jobs"),
	display_icon = "",
	display_name = T(520259899232, --[[ModItemTraitPreset Vindicated display_name]] "Vindicated"),
	dome_filter_only = true,
	group = "Positive",
	id = "Vindicated",
	incompatible = {
		Renegade = true,
		Violent = true,
	},
	modify_amount = 20,
	modify_property = "performance",
	modify_target = "self",
	name = "Vindicated",
	weight = 0,
}),
PlaceObj('ModItemTraitPreset', {
	_incompatible = "Composed,Vindicated",
	category = "Negative",
	description = T(635612439152, --[[ModItemTraitPreset Violent description]] "Violent people will resort to domestic violence (100% chance) whenever they're unhappy, and their victims will be more scared to talk about it (11% chance of becoming Renegades, instead of 33%). Violent people cannot become Vindicated until they work on their anger issues at the Sanatorium, and lose their violent urges. Can be obtained via sanity breakdown or by being the victim of domestic violence."),
	display_icon = "",
	display_name = T(151354650363, --[[ModItemTraitPreset Violent display_name]] "Violent"),
	group = "Negative",
	id = "Violent",
	incompatible = {
		Composed = true,
		Vindicated = true,
	},
	initial_filter = true,
	name = "Violent",
	sanatorium_trait = true,
	weight = 100,
}),
}
