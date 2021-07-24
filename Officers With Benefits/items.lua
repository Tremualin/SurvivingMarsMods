return {
PlaceObj('ModItemCode', {
	'name', "RehabiliationCenter",
	'FileName', "Code/RehabiliationCenter.lua",
}),
PlaceObj('ModItemCode', {
	'FileName', "Code/Script.lua",
}),
PlaceObj('ModItemTraitPreset', {
	__copy_group = "",
	_incompatible = "Renegade",
	category = "Positive",
	description = T(598838342649, --[[ModItemTraitPreset Vindicated description]] "Vindicated renegades will no longer become renegades and will gain additional performance"),
	display_icon = "",
	display_name = T(520259899232, --[[ModItemTraitPreset Vindicated display_name]] "Vindicated"),
	dome_filter_only = true,
	group = "Positive",
	id = "Vindicated",
	incompatible = {
		Renegade = true,
	},
	infopanel_effect_text = T(870982270334, --[[ModItemTraitPreset Vindicated infopanel_effect_text]] "A new person in the eyes of society"),
	modify_amount = 20,
	modify_property = "performance",
	modify_target = "self",
	name = "Vindicated",
	rare = true,
	weight = 0,
}),
}
