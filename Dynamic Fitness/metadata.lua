return PlaceObj('ModDef', {
	'title', "Dynamic Fitness",
	'description', "Fitness is a measure of the body's ability to function efficiently and effectively in work and leisure activities. \nDynamic Fitness adds a Fitness indicator, much like Health and Sanity, which determines if the colonist is Fit, Unfit, or neither.\n\nGyms (and Tai Chi Gardens) provide +7 base Fitness, Decorations provide +3 Fitness, while Hanging Gardens and Low-G Amusement Parks provide +5 Fitness. Fitness decays (-3) any day that the colonist hasn't exercised, and when eating unprepared food (-2).\n\nColonists with a low level (<30) of Fitness will become Unfit. Unfit colonists recover 50% less health from all sources, and lose (-5) sanity when visiting any service that provides exercise. You can filter Unfit colonists like any other trait.\n\nColonists with a high level (>=70) of Fitness will become Fit. Fit colonists can work with low health, recover more health (+5) each Sol and will recover sanity (+5) when visiting any service that provides exercise. You can filter Fit colonists like any other trait.\n\nFitness gains can be augmented by proper nutrition; Grocers and Diners will apply a multiplicative effect (based on their performance; could be negative) to the next exercise session. Example: Anna eats from a Grocer at 130% performance, then visits the Gym. She gains +7 Fitness from the Gym, and 7*(130% - 100%)=+2 from Good Nutrition. Bob eats from a Grocer at 70% performance, then visits the Gym. He gains +7 Fitness from the Gym, and 7*(70% - 100%)=-2 from Bad Nutrition. \n\nGyms and TaiChiGardens no longer recover health on visit and will require 1 Polymer maintenance to continue function, just like the Amphitheatre.\n\nGyms and TaiChiGardens begin the game with a new free optional upgrade: \"Fitness Coaches\". Fitness coaches increases service comfort by 10, gained comfort from +10 to +15, and allows 2 Fitness Coaches to be employed each shift. These fitness coaches can further increase Fitness and Comfort gained in the Gym based on their performance. Any unstaffed shifts will perform at 100% performance, even if \"Fitness Coaches\" is enabled. Unfit colonists cannot work as Fitness Coaches.\nMartian Diet (Breakthrough) now improves Fitness gained from Good Nutrition by 25%.\n\n[url=https://steamcommunity.com/sharedfiles/filedetails/?id=2588828764]Steam[/url]\n[url=https://mods.paradoxplaza.com/authors/Tremualin]Paradox[/url]\n[url=https://github.com/Tremualin/SurvivingMarsMods]Github[/url]",
	'image', "Preview.jpg",
	'last_changes', "Simplified code.",
	'dependencies', {
		PlaceObj('ModDependency', {
			'id', "Tremualin_Library",
			'title', "Tremualin's Library",
		}),
	},
	'id', "Tremualin_Dynamic_Fitness",
	'steam_id', "2782782042",
	'pops_desktop_uuid', "632664ed-09e9-40d5-b886-3054b3df2e75",
	'pops_any_uuid', "fd2c0590-3276-430b-b308-03f5c3127620",
	'author', "Tremualin",
	'version_major', 1,
	'version_minor', 3,
	'version', 21,
	'lua_revision', 1009413,
	'saved_with_revision', 1011140,
	'code', {
		"Code/Fitness.lua",
		"Code/FitnessUI.lua",
		"Code/ImprovedTech.lua",
		"Code/WorkOpenAirGym.lua",
	},
	'saved', 1652162427,
	'screenshot1', "FitnessNeed.jpg",
	'screenshot2', "GymUpgrade.jpg",
	'screenshot3', "MoraleEffect.jpg",
	'screenshot4', "ColonistsOverview.jpg",
	'screenshot5', "DomesOverview.jpg",
	'TagGameplay', true,
	'TagTraits', true,
})