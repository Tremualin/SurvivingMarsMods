return PlaceObj('ModDef', {
	'title', "Dynamic Fitness",
	'description', "It has always bothered me that Fitness is decided at Youth and remains like that until the colonist dies.\n\nFitness is a measure of the body's ability to function efficiently and effectively in work and leisure activities. \nDynamic Fitness adds a Fitness indicator, much like Health and Sanity, which determines if the colonist is Fit, Unfit, or neither.\n\nGyms (and Tai Chi Gardens) provide +7 base Fitness, Decorations provide +3 Fitness, while Hanging Gardens and Low-G Amusement Parks provide +5 Fitness.\nFitness decays (-3) any day that the colonist hasn't exercised, and when eating unprepared food (-2).\n\nColonists with a low level (<30) of Fitness will become Unfit. Unfit colonists recover 50% less health from all sources, and lose (-5) sanity when visiting any service that provides exercise. \n\nColonists with a high level (>=70) of Fitness will become Fit. Fit colonists can work with low health, recover more health (+5) each Sol and will recover sanity (+5) when visiting any service that provides exercise.\n\nFitness gains can be augmented by proper nutrition; Grocers and Diners will apply a multiplicative effect (based on their performance; could be negative) to the next exercise session. Example: Anna eats from a Grocer at 130% performance, then visits the Gym. She gains +7 Fitness from the Gym, and 7*(130% - 100%)=+2 from Good Nutrition. Bob eats from a Grocer at 70% performance, then visits the Gym. He gains +7 Fitness from the Gym, and 7*(70% - 100%)=-2 from Bad Nutrition. \n\nChildren gain +7 Fitness from playing; anywhere.\n\nGyms and TaiChiGardens no longer recover health on visit.\nGyms and TaiChiGardens begin the game with a new free optional upgrade: \"Fitness Coaches\"\nFitness coaches increases service comfort by 10, gained comfort from +10 to +15, and allows 2 Fitness Coaches to be employed each shift.\nThese fitness coaches can increase Fitness and Comfort gained in the Gym based on their performance.\nAny unstaffed shifts will perform at 100% performance, even if \"Fitness Coaches\" is enabled. \nUnfit colonists cannot work as Fitness Coaches.",
	'dependencies', {
		PlaceObj('ModDependency', {
			'id', "Tremualin_Library",
			'title', "Tremualin's Library",
		}),
	},
	'id', "Tremualin_Dynamic_Fitness",
	'pops_desktop_uuid', "632664ed-09e9-40d5-b886-3054b3df2e75",
	'pops_any_uuid', "fd2c0590-3276-430b-b308-03f5c3127620",
	'author', "Tremualin",
	'version', 5,
	'lua_revision', 1009413,
	'saved_with_revision', 1010838,
	'code', {
		"Code/Fitness.lua",
		"Code/FitnessUI.lua",
		"Code/WorkOpenAirGym.lua",
	},
	'saved', 1647832163,
})