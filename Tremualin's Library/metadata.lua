return PlaceObj('ModDef', {
	'title', "Tremualin's Library",
	'description', "I got tired of writing the same code and fixing the same bugs in all my mods, so I decided to make a shared library with all my code, and tests.\n\nOriginal game fixes:\nFixed a bug with modded traits not applying their daily effects.\nFixed a bug with Sanatorium and School not properly loading modded traits.\nFixed a bug where Max Disaster rules don't work (partially works on existing games; won't work if you never got a disaster of that type)\nAdded additional numbers to Sanatorium and School; up to 15 trait (thanks ChoGGi for the code)\nFixed a bug where colonists would end up with multiple workplaces.\nMade icons floating above colonists larger and more visible.\n\n[url=https://steamcommunity.com/sharedfiles/filedetails/?id=2588520023]Steam[/url]\n[url=https://mods.paradoxplaza.com/mods/29864/Any]Paradox[/url]\n[url=https://github.com/Tremualin/SurvivingMarsMods/tree/main/Tremualin's%20Library]Github[/url]",
	'image', "Icon.png",
	'last_changes', "Removed old fixes",
	'id', "Tremualin_Library",
	'steam_id', "2588520023",
	'pops_desktop_uuid', "528d9c7d-a649-4912-8e89-04d7e567dd3c",
	'pops_any_uuid', "c6935ae7-5714-41c2-a503-54a162e3d0fb",
	'author', "Tremualin",
	'version_major', 1,
	'version_minor', 12,
	'version', 71,
	'lua_revision', 1009413,
	'saved_with_revision', 1011140,
	'code', {
		"Code/Common.lua",
		"Code/CommonUI.lua",
		"Code/Numbers.lua",
		"Code/Labels.lua",
		"Code/Fixes.lua",
	},
	'saved', 1651297196,
	'screenshot1', "PrintVisitDurations.jpg",
	'TagOther', true,
})