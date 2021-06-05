return PlaceObj('ModDef', {
	'title', "Vegetation Rebalanced",
	'description', 'ForestationPlant will now receive up to a +400% boost based on current Atmosphere, Temperature, Water, and Vegetation levels.\nForestation plant will not stop contributing to global vegetation once it reaches 40%.\n\nVegetation % grows passively based on vegetation % squared (at 10% it will be 0.01%, at 50% it will be 0.25%), even without forestation plants. The passive spread is also boosted by Atmosphere, Temperature and Water.\n\nDust Storm no longer occur when Atmosphere is at 50% AND Vegetation is at 30%, instead of just 50% Atmosphere.\n30% Vegetation is also required for Breathable Atmosphere, to prevent Dust Storms on Open Domes.\nThis setting can be disabled on the mod configuration if you just want the passive boost with none of the drawbacks.\n\nOverrides "Vegetation Goes to 11" by Choggi if present.',
	'image', "Preview.jpg",
	'id', "Tremualin_Vegetation_Rebalanced",
	'pops_desktop_uuid', "6c2c7e13-d0a4-418d-baf9-784d03a83963",
	'pops_any_uuid', "50d68d9d-303f-479b-8866-f8be05694c4c",
	'author', "Tremualin",
	'version_major', 1,
	'version', 5,
	'lua_revision', 233360,
	'saved_with_revision', 1001586,
	'code', {
		"Code/Script.lua",
	},
	'has_options', true,
	'saved', 1622896196,
	'TagTerraforming', true,
})