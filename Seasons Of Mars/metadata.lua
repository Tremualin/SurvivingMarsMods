return PlaceObj('ModDef', {
	'title', "Seasons of Mars (Difficulty Mod)",
	'description', "Seasons of Mars aims to fulfill 2 goals: \n[list]\n[*]If you have Green Planet; make Terraforming much more important in the early to mid game.\n[*]If you have Below and Beyond; make Underground colonization and Asteroid mining much more important in the early to mid game.\n[/list]\n\nYou have a choice to make: Terraform as fast as possible, move your domes into the Underground, or weather the Weather?\n\nSeasons represent actual Martian Seasons (although their duration in game is half of the duration in real life), with each Season having unique effects, most of which are no longer relevant after Terraforming. This is a difficulty mod.\n\nThe game begins on Spring, the moment you enable the mod for the first time.\n\n[b]Seasons[/b]\n[list]\n    [*]Summer (45 sols): Dust Storms appear 0.5% faster each sol\n    [*]Autumn (36 sols): Cold Waves are 2.5% longer each sol. Dust Storms slowly normalize\n    [*]Winter (39 sols): Cold Waves appear 0.5% faster each sol\n    [*]Spring (49 sols): Dust Storms are 2.5% longer each sol. Cold Waves slowly normalize\n[/list]\nHint: Each Season applies a color filter to vegetation. You can disable the filter in the Mod Options\nHint: You can change duration, frequency and difficulty of Seasons in the Mod Options.\n\n[b]Notes[/b] \nI'm not sure if this works without Green Planet; let me know in the comments.\nNone of the effects are actually based on Science. There isn't much information to go around on Martian Seasons.\n\n[url=https://steamcommunity.com/sharedfiles/filedetails/?id=2588828764]Steam[/url]\n[url=https://mods.paradoxplaza.com/authors/Tremualin]Paradox[/url]\n[url=https://github.com/Tremualin/SurvivingMarsMods]Github[/url]",
	'image', "Preview.jpg",
	'last_changes', "Fixed a compatibility issue with Vegetation Rebalanced",
	'dependencies', {
		PlaceObj('ModDependency', {
			'id', "Tremualin_Library",
			'title', "Tremualin's Library",
		}),
	},
	'id', "Tremualin_Seasons_Of_Mars",
	'steam_id', "2599530116",
	'pops_desktop_uuid', "395c7ade-b619-4528-8ae1-5752cdd09d3b",
	'pops_any_uuid', "a8229293-1d25-41d5-b9da-9b5b0220fb34",
	'author', "Tremualin",
	'version_major', 1,
	'version_minor', 5,
	'version', 45,
	'lua_revision', 1009413,
	'saved_with_revision', 1010838,
	'code', {
		"Code/Color.lua",
		"Code/Notifications.lua",
		"Code/Seasons.lua",
		"Code/UnitTests.lua",
	},
	'has_options', true,
	'saved', 1650241170,
	'screenshot1', "Welcome.jpg",
	'screenshot2', "Seasons.jpg",
	'screenshot3', "Long.png",
	'screenshot4', "ModOptions.jpg",
	'screenshot5', "Colors.jpg",
	'TagGameplay', true,
})