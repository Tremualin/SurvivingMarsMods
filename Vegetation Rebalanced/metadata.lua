return PlaceObj('ModDef', {
	'title', "Vegetation Rebalanced",
	'description', 'Forestation Plants will now receive a boost of up to +400% based on current Atmosphere, Temperature, Water, and Vegetation levels.Forestation Plant will also continue contributing to g lobal Vegetation once Vegetation reaches 40%.\n\nVegetation % grows passively based on Vegetation % squared (at 10% it will be 0.01%, at 50% it will be 0.25%), and works even without forestation plants (you can just do seed missions). The passive spread is also boosted by Atmosphere, Temperature and Water.\n\nDust Storms no longer occur at 30% Vegetation, instead of 50% Atmosphere. 30% Vegetation is also required for Breathable Atmosphere (to prevent having both Dust Storms and Open Domes). This setting can be disabled on the mod configuration, if you just want the passive boost with none of the drawbacks.\n\nAdditionally, Vegetation takes water from the soil and releases it into the Atmosphere, boosting Water by up to 2% per sol. The boost scales with Vegetation and is increased by Atmosphere and Temperature, but decreased by Water. This change was inspired by https://www.usgs.gov/special-topic/water-science-school/science/evapotranspiration-and-water-cycle?qt-science_center_objects=0#qt-science_center_objects\n\nOverrides "Vegetation Goes to 11" by Choggi if present.',
	'image', "Preview.jpg",
	'last_changes', "Vegetation wasn't truly required to stop dust storms after the last hotfix; now it is.",
	'id', "Tremualin_Vegetation_Rebalanced",
	'steam_id', "2508142535",
	'pops_desktop_uuid', "6c2c7e13-d0a4-418d-baf9-784d03a83963",
	'pops_any_uuid', "50d68d9d-303f-479b-8866-f8be05694c4c",
	'author', "Tremualin",
	'version_major', 1,
	'version_minor', 3,
	'version', 22,
	'lua_revision', 1009413,
	'saved_with_revision', 1010838,
	'code', {
		"Code/Script.lua",
		"Code/Disasters.lua",
	},
	'has_options', true,
	'saved', 1650244570,
})