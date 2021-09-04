return PlaceObj('ModDef', {
    'title', "Seniors With Benefits",
    'description', "In the current meta there are 3 ways to manage seniors citizens: research Forever Young and forget about them, put them in a dome and wait for them to die, or put them in a dome and actually kill them. \n\nThis mod hopes to change the meta by introducing a few more options: let seniors live in nursery domes, to visit their grandchildren, or in university domes, to mingle with the youth. If you are using SkiRich's Incubator mod, you can make perfectly functional Nursery-University-Retirement domes (my personal preference).\n\nThe mod also makes slightly harder (or easier, if you treat Seniors well) by making senior well being a concern for the common Martian, specially for those martians who are close to retiring themselves and do not wish to be made into soylent green, who will now react to senior neglect.\n\nWhile the mod can be enabled mid game, a few features (Seniors Well Being Matters) will take some time to trigger (to avoid performance penalties when loading games). Every other feature should work fine. \n\nAll of the features work, even if you research Forever Young.\n\n[h1]Features[/h1]\n\n[b]Cheap \"Senior residences\"[/b]\nA new toggle button has been added to all residences (except nurseries and senior residences) which allows you to designate them as senior residences; seniors will immediately flock to the chosen residence, which will now also gain 50% more capacity. This aims to be a cheap alternative to the senior residence in the In-dome Buildings Pack for those who still don't have it or those who think the buildings are unbalanced. Dome filters are still respected, so make sure to set those filters on any dome where you absolutely don't want any seniors.\n\n[b]Seniors bring out the best in Children[/b]\nChildren in a dome with a Senior colonist have 1% more chances of developing rare traits per Senior living in the dome, up to 50% more chances (regular chance is really low, so expect this to be like 1.5% instead of 1%).\n\n[b]Seniors share cautionary tales[/b]\nSenior colonists have a daily chance of removing flaws from younger colonists in the same Dome, based on the Perks of the Senior citizen. Each Senior citizen increases the chance if they have the proper perk, and the chance is higher the younger the colonist: 4% (max 20%) for Young, 2% (max 10%) for Adult, 1% (Max 5%) for Middle Aged. A new UI shows how many flaws have been removed by seniors on each Dome.\n\n[table]\n[tr]\n[th]Perk[/th]\n[th]Removes Flaw[/th]\n[/tr]\n[tr]\n[td]Celebrity[/td]\n[td]Nothing[/td]\n[/tr]\n[tr]\n[td]Composed[/td]\n[td]Coward[/td]\n[/tr]\n[tr]\n[td]Empath[/td]\n[td]Renegade[/td]\n[/tr]\n[tr]\n[td]Enthusiast[/td]\n[td]Melancholic[/td]\n[/tr]\n[tr]\n[td]Fit[/td]\n[td]Glutton[/td]\n[/tr]\n[tr]\n[td]Gamer[/td]\n[td]Gambler[/td]\n[/tr]\n[tr]\n[td]Genius[/td]\n[td]Idiot[/td]\n[/tr]\n[tr]\n[td]Nerd[/td]\n[td]Hypochondriac[/td]\n[/tr]\n[tr]\n[td]Party Animal[/td]\n[td]Loner[/td]\n[/tr]\n[tr]\n[td]Saint[/td]\n[td]Renegade[/td]\n[/tr]\n[tr]\n[td]Sexy[/td]\n[td]Nothing[/td]\n[/tr]\n[tr]\n[td]Survivor[/td]\n[td]Coward[/td]\n[/tr]\n[tr]\n[td]Religious[/td]\n[td]Alcoholic[/td]\n[/tr]\n[tr]\n[td]Rugged[/td]\n[td]Whiner[/td]\n[/tr]\n[tr]\n[td]Workaholic[/td]\n[td]Lazy[/td]\n[/tr]\n[/table]\n\n[b]Seniors provide care for other seniors[/b]\nSenior will follow up on other seniors who have been discharged from the infirmary; this means seniors recover extra health and sanity (+5) each day as long as there is a medical facility in the dome. Inspired by [url=https://scholarworks.wmich.edu/cgi/viewcontent.cgi?article=2549&context=jssw]The Use of Senior Volunteers in the Care of Discharged Geriatric Patients[/url]\n\n[b]Seniors become role models for younger colonists[/b]\nSeniors become role models and increase the performance of younger colonists (except Middle Aged), based on the traits (both perks, flaws, quirks, specialization, gender, etc) that are shared between the younger person and the seniors in the dome (+2 for each unique shared trait for Young, +1 for each unique shared trait for Adults). Children haven't fully developed yet so they receive bonus performance based on the unique perks and specializations of seniors in the dome (similar to HiveMind); unlike vanilla HiveMind, flaws reduce this bonus.\n\n[b]Senior well being matters[/b]\nColonists (except Children and Seniors) will have additional morale if at least 95% of seniors in the Colony are happy (Health, Sanity, Comfort and Morale are above 70) and lower moral if at least 10% of seniors in the Colony are unhappy (Health, Sanity, Comfort or Morale are below 30). The morale loss is higher the closer the colonist is to becoming a senior (varies between +15 and -30)",
    'image', "Preview.jpg",
    'last_changes', "Fixed a bug that caused Seniors not to remove Flaws",
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
    'version_minor', 1,
    'version', 14,
    'lua_revision', 233360,
    'saved_with_revision', 1001586,
    'code', {
        "Code/DailyUpdates.lua",
        "Code/SeniorResidences.lua",
        "Code/SeniorsRemoveTraitsUI.lua",
        "Code/SeniorsWellBeing.lua",
    },
    'saved', 1630715766,
    'screenshot1', "GluttonRemoved.png",
    'screenshot2', "TraitsRemovedUI.jpg",
    'screenshot3', "HappySeniors.png",
    'screenshot4', "MiserableSeniors.png",
    'screenshot5', "SeniorsCare.png",
    'TagGameplay', true,
})
