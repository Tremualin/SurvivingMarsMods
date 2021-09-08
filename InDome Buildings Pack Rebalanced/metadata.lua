return PlaceObj('ModDef', {
	'title', "SecurityPost Fix",
	'description', "Originally this mod fixed some of the balance problems of the InDome Buildings Pack\nThe developers implemented most of the fixes in the Picard update, but they never fixed SecurityPosts.\n\n[list]\n    [*]Security Station negates 6 Renegades (affected by performance) instead of 5\n    [*]Security Post is now registered in the game as a security building (it wasn't)\n    [*]Security Post negates 2 Renegades (affected by performance) instead of 5\n    [*]Security Post reduces damage from disasters by 1/3 of that of Security Stations instead of the same amount at 1/3 the workers\n[/list]\n\nSecurity Posts weren't registered in the game as security buildings, and therefore did nothing at all.\nHad they worked however, they would have behaved exactly like Security Stations while requiring 1/3 of the workers to reach 100% performance; now they both work and act as 1/3 of a Security Station.",
	'image', "Preview.jpg",
	'last_changes', "Removed unnecessary code after Picard update",
	'id', "Tremualin_InDome_Buildings_Pack_Rebalanced",
	'steam_id', "2563628545",
	'pops_desktop_uuid', "c98904e7-fdd4-44ce-89e9-005f6e27d641",
	'pops_any_uuid', "3064ec8c-068f-4fe1-a9aa-5a15de6e0e2d",
	'author', "Tremualin",
	'version_major', 2,
	'version', 29,
	'lua_revision', 1007000,
	'saved_with_revision', 1007783,
	'code', {
		"Code/Script.lua",
	},
	'saved', 1631059374,
})