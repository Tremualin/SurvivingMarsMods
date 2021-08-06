return PlaceObj('ModDef', {
	'title', "InDome Buildings Pack Rebalanced",
	'description', "This mod aims to bring some balance to the In Dome Buildings Pack\n\n[list]\n    [*]School Spire has a 2% chance of producing any rare trait as opposed to a 10% chance to produce Genius\n    [*]Security Station negates 6 Renegades (affected by performance) instead of 5\n    [*]Security Post is now registered in the game as a security building (it wasn't)\n    [*]Security Post negates 2 Renegades (affected by performance) instead of 5\n    [*]Security Post reduces damage from disasters by 1/3 of that of Security Stations instead of the same amount at 1/3 the workers\n    [*]Smart Apartments require additional electricity and Maintenance\n    [*]Medical Post max capacity reduced from 3 to 2\n[/list]\n\n[h1]Rationale[/h1]\n\n[b]School Spire[/b]\nSchool Spire has 36 slots for Children, with a 10% chance of Genius; that means 3.6 Geniuses every 5 days (time it takes Children to become Young).\nA Research Lab at 110% performance provides 550 Research points, while a Genius provides 150 Research; which means a School Spire provides a free Research Lab (110% performance) every 5 days.\n\nNow the chance is 2% and it gives a random rare trait, like Celebrity, Empath, Genius, Saint or Guru. It should also cover modded Rare traits.\n\n[b]Security Post[/b]\nSecurity Posts weren't registered in the game as security buildings, and therefore did nothing at all.\nHad they worked however, they would have behaved exactly like Security Stations while requiring 1/3 of the workers to reach 100% performance; now they both work and act as 1/3 of a Security Station.\n\n[b]Smart Apartments[/b]\nSmarts Apartments consume less power than regular Apartments, have the same maintenance as Smart Complex, and the only penalty over Smart Complexes is 10 comfort. Now they consume the same amount of power as (Apartment + Smart Complex), and double the maintenance of a Smart Complex.\n\n[b] Medical Post [/b]\nA medical post cures the same amount of health and sanity that an Infirmary, but 2 Medical Posts require the same amount of workers as an Infirmary while providing 6 capacity vs 5 capacity, and the only cost is 10 comfort (30 vs 40). Now Medical Posts have 4 capacity (vs 5 of Infirmaries).",
	'last_changes', "Security Post wasn't registered in the game as a security building and therefore not doing anything; until now.",
	'id', "Tremualin_InDome_Buildings_Pack_Rebalanced",
	'steam_id', "2563628545",
	'pops_desktop_uuid', "c98904e7-fdd4-44ce-89e9-005f6e27d641",
	'pops_any_uuid', "3064ec8c-068f-4fe1-a9aa-5a15de6e0e2d",
	'author', "Tremualin",
	'version_major', 1,
	'version_minor', 1,
	'version', 22,
	'lua_revision', 233360,
	'saved_with_revision', 1001586,
	'code', {
		"Code/Script.lua",
	},
	'saved', 1628120960,
})