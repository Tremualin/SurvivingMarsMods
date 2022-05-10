return PlaceObj('ModDef', {
	'title', "Improved Wonders",
	'description', "I've always felt like these Project Morpheus and the Geoscape Dome wonders weren't at the same level as the other Wonders in terms of usefulness. I've made an attempt at making them more useful.\n\n[h1]Project Morpheus[/h1]\nBefore: [b]2%[/b] chance to gain traits each sol\nAfter: [b]4%[/b] chance to gain traits each sol\n\nBefore: grants [b]up to 4 perks[/b] to people who don't already have [b]4 traits[/b]. (A Martianborn Biorobot Loner would gain 1 perk from Morpheus, at best)\nAfter: grants [b]up to 7 perks[/b] to people who don't already have [b]7 perks[/b] (A Martianborn Biorobot Loner would gain 7 perks from Morpheus, at best)\n\nNew Effect: Tourists pay [b]10% additional funding[/b] for each perk received from Project Morpheus during their stay.\n\nNew Effect: Affects Colonists [b]Underground.[/b]\n\n[h1]Geoscape Dome[/h1]\nNew Effect: Tourists gain [b]3 satisfaction[/b] each sol while staying at the Geoscape Dome.\nNew Effect: Colonists recover [b]5 health[/b] when resting at the Geoscape Dome.\nNew Effect: Colonists gain [b]10 morale[/b] when resting at the Geoscape Dome (effect lasts for 2 sols)\n\n[url=https://steamcommunity.com/sharedfiles/filedetails/?id=2588828764]Steam[/url]\n[url=https://mods.paradoxplaza.com/authors/Tremualin]Paradox[/url]\n[url=https://github.com/Tremualin/SurvivingMarsMods]Github[/url]",
	'image', "Preview.jpg",
	'last_changes', "Project Morpheus works Underground now.",
	'dependencies', {
		PlaceObj('ModDependency', {
			'id', "Tremualin_Library",
			'title', "Tremualin's Library",
		}),
	},
	'id', "Tremualin_Improved_Wonders",
	'steam_id', "2753995861",
	'pops_desktop_uuid', "c948078b-e281-44e6-8347-822ddd4c65f5",
	'pops_any_uuid', "e7e8cebf-1e9d-4b6b-a264-a78a9940bce4",
	'author', "Tremualin",
	'version_major', 1,
	'version_minor', 1,
	'version', 14,
	'lua_revision', 1009413,
	'saved_with_revision', 1011140,
	'code', {
		"Code/Script.lua",
	},
	'saved', 1652160548,
	'screenshot1', "Benefits.jpg",
	'TagGameplay', true,
})