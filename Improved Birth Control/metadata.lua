return PlaceObj('ModDef', {
	'title', "Improved Birth Control",
	'description', "The Picard update added a new birth control policy: Births are forbidden if the Dome is Full.\nI've made it the default for all new domes and modified it to:\n \n1. Expand to the entire colony (all Domes must be full before births are forbidden)\n2. Apply only to open slots on inclusive residences (so, no Senior Residences, Nurseries, Hotels, or other modded exclusive residences like Crime and Vindication Rehabilitation Centers)\n3. Take homelessness into account (if 3 inclusive residences are empty, but there are 5 homeless in a different Dome, then births are forbidden)\n4. Take existing children into account (if 3 inclusive residences are empty, but there are 3 children in nurseries, births are forbidden)\n \n This is provided as a best effort mod. If your birth rate is really high, you could get slightly more births than you need; but the algorithm will wait before adding more children, so you should eventually be fine. I've been playing with this mod for a while on a Church of the New Ark run and it lead to a mostly stable number of homeless (close to 0). \n \nRequirements:\nThis mod requires my shared library: Tremualin's Library.\nThis mod requires SkiRich's Fix Emigration Issues; the fixes on that mod are vital to proper counting of residences.\nThis mod requires Senior Residences. If you don't have the DLC which adds Senior Residences, my mod \"Seniors With Benefits\" allows you to designate any existing residence as a Senior Residence (and grants it +50% capacity). Otherwise, Seniors might end up homeless. \n \nCompatibility:\nThis mod is compatible with my mod Crime and Vindication, SkiRich's Incubator and ChoGGi's Dome Birth Progress.\n \nKnown issues:\nThis mod does not make sure Children aren't homeless. Make sure to use SkiRich's Incubator to avoid having homeless children.\nThis mod does not make sure Seniors aren't homeless. Make sure to build enough Senior Residences.\nThis mod does not make sure Tourists aren't homeless. Make sure you have enough Hotels.\n \nFor Modders:\nThis mod modifies Community:CalcBirths; but it returns the original when births should be allowed.",
	'image', "Preview.jpg",
	'last_changes', "Initial version",
	'dependencies', {
		PlaceObj('ModDependency', {
			'id', "ZbvSHa",
			'title', "Fix Emigration Issues",
		}),
		PlaceObj('ModDependency', {
			'id', "Tremualin_Library",
			'title', "Tremualin's Library",
		}),
	},
	'id', "Tremualin_Improved_Birth_Control",
	'steam_id', "2643634030",
	'pops_desktop_uuid', "8a64e507-4e30-4a4c-8d69-4052202fa2a8",
	'pops_any_uuid', "4a41bae4-3c64-4297-b067-e09fcf2ea9aa",
	'author', "Tremualin",
	'version_major', 1,
	'version', 6,
	'lua_revision', 1007000,
	'saved_with_revision', 1008298,
	'code', {
		"Code/Script.lua",
	},
	'saved', 1635816588,
	'TagGameplay', true,
})