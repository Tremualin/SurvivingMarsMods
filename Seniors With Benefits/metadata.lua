return PlaceObj('ModDef', {
	'title', "Seniors With Benefits",
	'description', "There are 3 ways to manage Seniors today: get lucky with Forever Young, isolate them in a Retirement Dome, or the most popular, murder them with little consequence.\n \nThis mod introduces a few more options: let seniors live in nursery domes, to visit their grandchildren, or in university domes, to mingle with the youth. If you are using \n[url=https://steamcommunity.com/sharedfiles/filedetails/?id=1438832844]SkiRich's Incubator[/url], you can make perfectly functional Nursery-University-Retirement domes (my personal preference), because Children will only take Nursery slots.\n \nAll features will continue to work, even if you research Forever Young.\n \n[b]Senior well being matters[/b]\nColonists (except Children and Seniors) have additional morale if at least 95% of seniors in the Colony are happy (Health, Sanity, Comfort and Morale are above 70) and lower moral if at least 10% of seniors in the Colony are unhappy (Health, Sanity, Comfort or Morale are below 30). The morale loss is higher the closer the colonist is to becoming a senior (varies between +15 and -30)\n \n[b]Seniors nurture Children[/b]\nChildren have 1% more chances of developing rare traits per Senior living in the same Dome.\n \n[b]Seniors share cautionary tales[/b]\nColonists have a chance to lose Flaws, based on the Traits of the Seniors living in the same Dome. Each Senior with the proper trait increases the chance of recovery, and the chance is higher the younger the colonist: 4% (max 15%) for Young, 2% (max 10%) for Adult, 1% (Max 5%) for Middle Aged. A new UI will show how many flaws have been removed by Seniors on each Dome. \n\nSome of the Traits you will see here are from my other mods which you can find [url=https://steamcommunity.com/sharedfiles/filedetails/?id=2588828764]in my collection[/url]. You don't need to have the other mods for Seniors with Benefits to work.\n \n[table][tr][th]Flaw[/th][th]Removed by Perks[/th][/tr]\n[tr][td]Alcoholic[/td][td]Religious[/td][/tr]\n[tr][td]Anxious[/td][td]Composed[/td][/tr]\n[tr][td]Argumentative[/td][td]Listener[/td][/tr]\n[tr][td]Coward[/td][td]Composed,Survivor[/td][/tr]\n[tr][td]Gambler[/td][td]Fickle,Gamer[/td][/tr]\n[tr][td]Glutton[/td][td]Fit[/td][/tr]\n[tr][td]Hypochondriac[/td][td]Nerd[/td][/tr]\n[tr][td]Idiot[/td][td]Fixer,Genius,Mentor[/td][/tr]\n[tr][td]Lazy[/td][td]Thrifty,Workaholic[/td][/tr]\n[tr][td]Loner[/td][td]Party Animal[/td][/tr]\n[tr][td]Mean[/td][td]Kind[/td][/tr]\n[tr][td]Melancholic[/td][td]Enthusiast[/td][/tr]\n[tr][td]Paranoid[/td][td]Composed[/td][/tr]\n[tr][td]Renegade[/td][td]Empath,Saint[/td][/tr]\n[tr][td]Violent[/td][td]Vindicated[/td][/tr]\n[tr][td]Whiner[/td][td]Brawler,Rugged[/td][/tr]\n[/table]\n \n[b]Seniors inspire younger colonists[/b]\nSeniors inspire younger colonists (except Middle Aged), and increase their performance based on the traits (both perks, flaws, quirks, specialization, nationality, gender, etc) that are shared between the younger person and the seniors in the dome (+2 for each unique shared trait for Young, +1 for each unique shared trait for Adults). Children haven't fully developed yet so they receive bonus performance based on the unique perks and specializations of seniors in the dome (similar to Hive Mind); unlike vanilla Hive Mind, flaws reduce this bonus.\n \n[b]Seniors provide care for other seniors[/b]\nSenior will follow up on other seniors who have been discharged from the infirmary; this means seniors recover extra health and sanity (+5) each day as long as there is a medical facility in the dome, an ability with proves useful during certain mysteries. Inspired by [url=https://scholarworks.wmich.edu/cgi/viewcontent.cgi?article=2549&context=jssw]The Use of Senior Volunteers in the Care of Discharged Geriatric Patients[/url]\n \n[b]Cheap \"Senior residences\"[/b]\nA new toggle button has been added to all residences (except nurseries and senior residences) which allows you to designate them as senior residences; seniors will immediately flock to the chosen residence, which will now also gain 50% more capacity. This aims to be a cheap alternative to the senior residence in the In-dome Buildings Pack for those who still don't have it, those who think the buildings is unbalanced and those who think the building cost of Electronics is too high. Dome filters are still respected (I didn't modify any of them), so make sure to set those filters on any dome where you absolutely don't want any seniors.\n\n[url=https://steamcommunity.com/sharedfiles/filedetails/?id=2588828764]Steam[/url]\n[url=https://mods.paradoxplaza.com/authors/Tremualin]Paradox[/url]\n[url=https://github.com/Tremualin/SurvivingMarsMods]Github[/url]",
	'image', "Preview.jpg",
	'last_changes', "Simplified wellbeing code.",
	'dependencies', {
		PlaceObj('ModDependency', {
			'id', "Tremualin_Library",
			'title', "Tremualin's Library",
		}),
	},
	'id', "Tremualin_SeniorsWithBenefits",
	'steam_id', "2535835676",
	'pops_desktop_uuid', "25da34aa-eafc-4744-88f6-5e622eac8a07",
	'pops_any_uuid', "4c8abca7-68cf-407c-9986-79dd2b04f336",
	'author', "Tremualin",
	'version_major', 1,
	'version_minor', 11,
	'version', 63,
	'lua_revision', 1009413,
	'saved_with_revision', 1011166,
	'code', {
		"Code/DailyUpdates.lua",
		"Code/SeniorResidences.lua",
		"Code/SeniorsRemoveTraitsUI.lua",
		"Code/SeniorsWellBeing.lua",
		"Code/UnitTests.lua",
	},
	'saved', 1664757657,
	'screenshot1', "GluttonRemoved.png",
	'screenshot2', "TraitsRemovedUI.jpg",
	'screenshot3', "HappySeniors.png",
	'screenshot4', "MiserableSeniors.png",
	'screenshot5', "SeniorsCare.png",
	'TagGameplay', true,
})