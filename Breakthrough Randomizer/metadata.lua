return PlaceObj('ModDef', {
	'title', "Breakthrough Randomizer",
	'description', "Allows you to choose from 4 different Breakthroughs when scanning Breakthrough anomalies, Planetary Anomalies, and even the Omega Telescope. Does not affect Story Bits or Mystery Rewards.\n\nTo keep this compatible with [url=https://survivingmaps.com]Surviving Maps[/url] I made sure that the first breakthrough in the list of choices is always the same as it would if the mod wasn't there. So if your map should have The Positronic Brain; it will have The Positronic Brain. \n\nAll but the first Breakthrough is chosen at random the moment the Anomaly is scanned; realoding changes the list. If the first Breakthrough was already researched, it will be replaced with another. \n\n[url=https://steamcommunity.com/sharedfiles/filedetails/?id=2588828764]Steam[/url]\n[url=https://mods.paradoxplaza.com/authors/Tremualin]Paradox[/url]\n[url=https://github.com/Tremualin/SurvivingMarsMods]Github[/url]",
	'image', "Preview.jpg",
	'last_changes', "First version",
	'dependencies', {
		PlaceObj('ModDependency', {
			'id', "Tremualin_Library",
			'title', "Tremualin's Library",
		}),
	},
	'id', "Tremualin_BreakthroughRandomizer",
	'steam_id', "2605770617",
	'pops_desktop_uuid', "6c2c7e13-d0a4-418d-baf9-784d03a83963",
	'pops_any_uuid', "50d68d9d-303f-479b-8866-f8be05694c4c",
	'author', "Tremualin",
	'version_major', 1,
	'version', 6,
	'lua_revision', 1007000,
	'saved_with_revision', 1007874,
	'code', {
		"Code/Script.lua",
	},
	'saved', 1632021362,
	'screenshot1', "Choose.jpg",
	'TagGameplay', true,
})