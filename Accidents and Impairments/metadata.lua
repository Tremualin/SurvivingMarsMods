return PlaceObj('ModDef', {
	'title', "Accidents and Impairments",
	'description', "Any colonist working on a building that's best worked by non-specialized colonists like Grocers and Diners will have a chance of getting an injury (imagine a plate dropping on your feet or a box falling from a shelf). Injuries lower the health of the colonist by a random amount between 5 to 20, but otherwise have no other special effects.\n\n[h1]Accidents[/h1] \nAccidents are a special type of injury which can only happen in buildings worked by specialized colonists like Geologists, Engineers, etc; and Ranches. In addition to losing 20 points of health, accidents can have lasting effects on your colony, leaving colonists Temporary and sometimes Permanently Impaired. In rare cases (1% of Accidents) the colonist can die.\n\n[h1]Temporary Impairments[/h1]\nTemporarily Impaired colonists can no longer work on any job for a few sols. Each sol, they have a chance of recovering and coming back to work, starting at 10% (+10% if there's a Medical Spire and/or Hospital in the same Dome, +10% if Fit) and doubling each day.  While Temporarily Impaired, they lose 8 sanity each day.\n\n[h1]Permanent Impairments[/h1]\nPhysically Impaired colonists will not be able to work on mobility-unfriendly jobs like those requiring Engineers, Geologists or Botanists (nor Ranches). \n\nIntellectually Impaired colonists will have have memory loss and/or difficulty concentrating; they can no longer work as Scientists, Officers or Medics. Geniuses will still contribute with Research, in their own way.\n\nSensory Impaired colonists (deaf, blind) can still work on all jobs, but they will lose 5 sanity every day while living in any residence will less than 65 comfort, and will lose 20 morale while Supportive Community isn't researched. \n\nAll permanently impaired colonists are also temporarily impaired; they need time off work to adjust to their new impairment, but should come back to work once the temporary impairment runs out.\n\nAn specialized colonist that becomes permanently impaired might lose their specialization if the impairment prohibits them from doing their job; this is only to keep the mod compatible with Universities and mods that depend on specializations such as SkiRich's Career AI.\n\n[h1]Naturally Occurring Impairments[/h1]\nIn addition to accidents, all types of impairments are very low frequency traits that can appear naturally on Martianborn. You can find them under Quirks.\n\n[h1]Probability of Injuries and Accidents[/h1]\nAn unhappy (any stat below 30) colonist has 3% chances of having an injury or accident each day. A neutral colonist (not happy nor unhappy) has a 1% chance. A happy colonist (all stats above 70) has a -1% chance of having accidents. Heavy workload adds an additional 2% chance.\n\nIn addition to happiness and heavy workload, flaws and perks play a role in the likelihood that a colonist has an accident. Each flaw increases the chances of having an accident by 1% while each perk reduces the chances by 1%. \n\nExample: Hardy-Harr is happy, working overtime and has 2 perks and a quirk. His chances of having an accident are -1% + 2% - 2% = -1%. Hardy-Harr won't have accidents.\n\nIf you want to minimize the chance of accidents, you must keep your colonists happy, ensure their flaws are treated at a Sanatorium, and avoid heavy workload. But you can still use heavy workload if your colonists are happy and gain enough perks at School. \n\n[h1]Severe Accidents[/h1] \nThere's a 1% chance that a colonist might die from an accident.\n\n[url=https://steamcommunity.com/sharedfiles/filedetails/?id=2588828764]Steam[/url]\n[url=https://mods.paradoxplaza.com/authors/Tremualin]Paradox[/url]\n[url=https://github.com/Tremualin/SurvivingMarsMods]Github[/url]",
	'image', "Preview.jpg",
	'last_changes', "Initial version",
	'dependencies', {
		PlaceObj('ModDependency', {
			'id', "Tremualin_Library",
			'title', "Tremualin's Library",
		}),
	},
	'id', "Tremualin_Accidents_And_Impairments",
	'pops_desktop_uuid', "cde5b387-9d44-434b-84e0-78e8e438f5b9",
	'pops_any_uuid', "0ee854bb-fbea-47b8-b052-f328dcf4eead",
	'author', "Tremualin",
	'version_major', 1,
	'version', 11,
	'lua_revision', 1007000,
	'saved_with_revision', 1008107,
	'bin_assets', true,
	'code', {
		"Code/Accidents.lua",
		"Code/Impairments.lua",
		"Code/UI.lua",
	},
	'saved', 1633932676,
	'TagGameplay', true,
})