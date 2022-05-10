return {
PlaceObj('ModItemCode', {
	'name', "Accidents",
	'FileName', "Code/Accidents.lua",
}),
PlaceObj('ModItemCode', {
	'name', "Impairments",
	'FileName', "Code/Impairments.lua",
}),
PlaceObj('ModItemCode', {
	'name', "UI",
	'FileName', "Code/UI.lua",
}),
PlaceObj('ModItemEntity', {
	'name', "ArrowAccidented",
	'entity_name', "ArrowAccidented",
	'import', "Entities/ArrowAccidented.ent",
}),
PlaceObj('ModItemEntity', {
	'name', "SignAccidented",
	'entity_name', "SignAccidented",
	'import', "Entities/SignAccidented.ent",
}),
PlaceObj('ModItemTraitPreset', {
	apply_func = 
function (colonist, trait)
            colonist:RetrainBasedOnImpairments()
end,
	category = "other",
	daily_update_func = 
function (colonist, trait)
            colonist:RetrainBasedOnImpairments()
end,
	description = T(630404482146, --[[ModItemTraitPreset IntellectuallyImpaired description]] "Discouraged from working as a Scientist, Officer or Medic."),
	display_name = T(586654232200, --[[ModItemTraitPreset IntellectuallyImpaired display_name]] "Intellectually Impaired"),
	group = "other",
	id = "IntellectuallyImpaired",
	incompatible = {},
	initial_filter = true,
	name = "IntellectuallyImpaired",
	weight = 50,
}),
PlaceObj('ModItemTraitPreset', {
	apply_func = 
function (colonist, trait)
            colonist:RetrainBasedOnImpairments()
end,
	category = "other",
	daily_update_func = 
function (colonist, trait)
            colonist:RetrainBasedOnImpairments()
end,
	description = T(740962527296, --[[ModItemTraitPreset PhysicallyImpaired description]] "Discouraged from working as an Engineer, Geologist, Officer, or in Ranches."),
	display_icon = "",
	display_name = T(646566331597, --[[ModItemTraitPreset PhysicallyImpaired display_name]] "Physically Impaired"),
	group = "other",
	id = "PhysicallyImpaired",
	incompatible = {},
	initial_filter = true,
	name = "PhysicallyImpaired",
	weight = 50,
}),
PlaceObj('ModItemTraitPreset', {
	category = "other",
	daily_update_func = 
function (colonist, trait)
            local residence = colonist.residence
            if not residence or residence.service_comfort < 65 * const.Scale.Stat then
                colonist:ChangeSanity(-5 * const.Scale.Stat, "My residence is inadequate for my impairment (Sensory Impaired) ")
            end
            if not UIColony:IsTechResearched("SupportiveCommunity") then
                Tremualin.Functions.TemporarilyModifyMorale(colonist, -20, 0, 1, "Tremualin_SensoryImpaired", "This community isn't supportive of people with sensory impairments ")
            end
end,
	description = T(882932581551, --[[ModItemTraitPreset SensoryImpaired description]] "-5 sanity while living in any residence will less than 65 comfort. -20 morale while Supportive Community isn't researched."),
	display_name = T(123519526752, --[[ModItemTraitPreset SensoryImpaired display_name]] "Sensory Impaired"),
	group = "other",
	id = "SensoryImpaired",
	incompatible = {},
	initial_filter = true,
	name = "SensoryImpaired",
	weight = 50,
}),
}
