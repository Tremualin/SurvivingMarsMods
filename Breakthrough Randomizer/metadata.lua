return PlaceObj('ModDef', {
	'title', "Breakthrough Randomizer",
	'description', "Allows you to choose from 4 different Breakthroughs when scanning Breakthrough anomalies, Planetary Anomalies, and even the Omega Telescope. Does not affect Story Bits or Mystery Rewards.\n\nTo keep this compatible with [url=https://survivingmaps.com]Surviving Maps[/url] I made sure that the first breakthrough in the list of choices is always the same as it would if the mod wasn't there. So if your map should have The Positronic Brain; it will have The Positronic Brain. \n\nAll but the first Breakthrough is chosen at random the moment the Anomaly is scanned; realoding changes the list. If the first Breakthrough was already researched, it will be replaced with another. \n\nThis mod is compatible with Omega Unlocks All and Omega Unlocks All; you won't see any choices when you build it, however.\n\n[url=https://steamcommunity.com/sharedfiles/filedetails/?id=2588828764]Steam[/url]\n[url=https://mods.paradoxplaza.com/authors/Tremualin]Paradox[/url]\n[url=https://github.com/Tremualin/SurvivingMarsMods]Github[/url]",
	'image', "Preview.jpg",
	'last_changes', "Compatibility with Omega Unlocks All (and Omega Unlocks All Slowly)",
	'dependencies', {
		PlaceObj('ModDependency', {
			'id', "Tremualin_Library",
			'title', "Tremualin's Library",
		}),
	},
	'id', "Tremualin_BreakthroughRandomizer",
	'steam_id', "2605770617",
	'pops_desktop_uuid', "d1cfbe36-927d-48fd-b8e5-621050873c09",
	'pops_any_uuid', "106edf50-9912-482d-895b-adad607f1d1a",
	'author', "Tremualin",
	'version_major', 1,
	'version_minor', 3,
	'version', 21,
	'lua_revision', 1009413,
	'saved_with_revision', 1010838,
	'code', {
		"Code/Script.lua",
	},
	'saved', 1650241013,
	'screenshot1', "Choose.jpg",
	'TagGameplay', true,
})