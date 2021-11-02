return PlaceObj('ModDef', {
	'title', "Improved LastArk Rewards",
	'description', "Playing The Last Ark, some mission goal rewards are almost impossible to get.\nParticularly when those rewards involve having people on the ground and gaining new Applicants.\nThis mod is an attempt to make those rewards better. So far I've only identified one.\n \n[b]Church Of The New Ark, Reward #3:[/b]\nBefore: Have 20 Martianborn Colonists by the end of Sol 50, gain [b]3 Saint Applicants[/b]\nAfter: Have 20 Martianborn Colonists by the end of Sol 50, gain [b]3 Saint Martianborn Children[/b]\n\n[url=https://steamcommunity.com/sharedfiles/filedetails/?id=2588828764]Steam[/url]\n[url=https://mods.paradoxplaza.com/authors/Tremualin]Paradox[/url]\n[url=https://github.com/Tremualin/SurvivingMarsMods]Github[/url]",
	'image', "Preview.jpg",
	'last_changes', "Initial version",
	'dependencies', {
		PlaceObj('ModDependency', {
			'id', "Tremualin_Library",
			'title', "Tremualin's Library",
		}),
	},
	'id', "Tremualin_Improved_LastArk_Rewards",
	'steam_id', "2643662735",
	'pops_desktop_uuid', "7e0ff58b-60a4-405a-afd9-a2382afc3a63",
	'pops_any_uuid', "582cb89e-4b0d-43f2-9c86-7a12350b197e",
	'author', "Tremualin",
	'version_major', 1,
	'version', 8,
	'lua_revision', 1007000,
	'saved_with_revision', 1008298,
	'code', {
		"Code/ChurchOfTheNewArk.lua",
	},
	'saved', 1635819960,
	'TagGameplay', true,
})