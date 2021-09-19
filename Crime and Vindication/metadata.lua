return PlaceObj('ModDef', {
    'title', "Crime and Vindication",
    'description', "Trigger warning: This mod includes depictions of domestic, verbal and physical violence.\n\n[h1] Introduction [/h1]\nIn the current meta, Security Stations aren't usually worth it. It's easier to ignore Renegades, or, if you are playing with Rebel Yell, to move them into a murder dome. Some mods have added a few ways to deal with Renegades, but I felt like they were missing something, so I made my own.\n\nI wanted to:\n1. Replace Renegade murder domes with Rehabilitation domes\n2. Make Officers and Security Stations more appealing\n3. Make Crime more diverse and punishing\n4. Make Rebel-Yell more fun\n5. Add more Renegades to regular games\nAnd I think I've accomplished all points with this mod.\n\n[h1] Table of Features [/h1]\nSteam wouldn't let me paste the detailed here because it was too long; so instead, here is a table providing a summary of all features; check the pinned item at the bottom for a detailed description and a strategy discussion. \n\n[table]\n[tr]\n[th]Feature[/th]\n[th]Affects[/th]\n[th]Effect[/th]\n[th]Unlocked with[/th]\n[/tr]\n[tr]\n[td]Toggle: Rehabilitation center[/td]\n[td]Residences[/td]\n[td]Houses Renegades who need Rehabilitation[/td]\n[td]Behavorial Shaping[/td]\n[/tr]\n[tr]\n[td]Rehabilitation[/td]\n[td]Security Stations[/td]\n[td]Cures Renegades in Rehabilitation Centers[/td]\n[td]Behavorial Shaping[/td]\n[/tr]\n[tr]\n[td]Vigilance[/td]\n[td]Renegades[/td]\n[td]Renegades in Rehabilitation Centers don't commit crimes[/td]\n[td]Behavorial Shaping[/td]\n[/tr]\n[tr]\n[td]Perk: Vindicated[/td]\n[td]Colonists[/td]\n[td]+20 performance and cannot become a Renegade ever again[/td]\n[td]Behavioral Melding[/td]\n[/tr]\n[tr]\n[td]Upgrade: Vindication[/td]\n[td]Security Stations[/td]\n[td]Cured Renegades become Vindicated[/td]\n[td]Behavioral Melding[/td]\n[/tr]\n[tr]\n[td]Upgrade: Criminal Psychologists[/td]\n[td]Security Stations[/td]\n[td]+10 performance if at least one medical building present in dome. +20 if Spire or Hospital[/td]\n[td]Supportive Community[/td]\n[/tr]\n[tr]\n[td]First Responders[/td]\n[td]Domes[/td]\n[td]+(2*performance) comfort for each officer working in security.[/td]\n[td]Emergency Training[/td]\n[/tr]\n[tr]\n[td]Fitness for Duty Evaluations[/td]\n[td]Security Stations[/td]\n[td]Renegades can't work on security and will be fired at the end of the shift if turning Renegade[/td]\n[td]Mod installation[/td]\n[/tr]\n[tr]\n[td]Off-duty Hero[/td]\n[td]Officers[/td]\n[td]5% or 10% (Supportive Community) chance to stop suicides and become a Celebrity[/td]\n[td]Mod installation[/td]\n[/tr]\n[tr]\n[td]Domestic Violence[/td]\n[td]Colonists[/td]\n[td]30% chance to inflict health and/or sanity damage on other colonists when unhappy[/td]\n[td]Mod installation[/td]\n[/tr]\n[tr]\n[td]Domestic Violence: Reports[/td]\n[td]Colonists[/td]\n[td]33% chance that colonists who commit domestic violence can become Renegades[/td]\n[td]Mod installation[/td]\n[/tr]\n[tr]\n[td]Domestic Violence: Survivors[/td]\n[td]Colonists[/td]\n[td]Survivors of domestic violence have a chance to developt flaws[/td]\n[td]Mod installation[/td]\n[/tr]\n[tr]\n[td]Violence Prevention[/td]\n[td]Security Stations[/td]\n[td]Security Stations reduce the negative effects of domestic violence[/td]\n[td]Mod installation[/td]\n[/tr]\n[tr]\n[td]Curable Flaw: Violent[/td]\n[td]Colonists[/td]\n[td]Commits domestic violence more often. Retaliates violently when receiving violence. 11% of becoming Renegade instead of 33%[/td]\n[td]Mod installation[/td]\n[/tr]\n[tr]\n[td]Improved Supportive Community[/td]\n[td]Supportive Community[/td]\n[td]Reduces the chances of domestic violence, and the chances of gaining flaws from domestic violence; increases chances of Off-duty Hero[/td]\n[td]Mod installation[/td]\n[/tr]\n[tr]\n[td]Crime: Protest[/td]\n[td]Renegades[/td]\n[td]Reduces morale in the dome by 1 for each Renegade participating[/td]\n[td]4 Renegades[/td]\n[/tr]\n[tr]\n[td]Crime: Vandalism[/td]\n[td]Renegades[/td]\n[td]Increases the maintenance of buildings in the dome by 5% for each Renegade participating[/td]\n[td]4 Renegades[/td]\n[/tr]\n[tr]\n[td]Crime: Resource stealing[/td]\n[td]Renegades[/td]\n[td]Steals 1 resource per Renegade participating[/td]\n[td]8 Renegades[/td]\n[/tr]\n[tr]\n[td]Crime: Embezzlement[/td]\n[td]Renegades[/td]\n[td]Steals 1% of funds per Renegade participating[/td]\n[td]8 Renegades[/td]\n[/tr]\n[tr]\n[td]Crime: Sabotage[/td]\n[td]Renegades[/td]\n[td]Destroys 1 building per every 8 Renegades participating[/td]\n[td]12 Renegades[/td]\n[/tr]\n[tr]\n[td]Crime: Rebel-Yell[/td]\n[td]Crime[/td]\n[td]Unlocks new crimes with 2 Renegades less than normal[/td]\n[td]Rebel-Yell[/td]\n[/tr]\n[/table]\n\n[url=https://steamcommunity.com/sharedfiles/filedetails/?id=2588828764]Steam[/url]\n[url=https://mods.paradoxplaza.com/authors/Tremualin]Paradox[/url]\n[url=https://github.com/Tremualin/SurvivingMarsMods]Github[/url]",
    'image', "Preview.jpg",
    'last_changes', "Fixed a bug that prevented the rehabilitation ui from showing progress",
    'dependencies', {
        PlaceObj('ModDependency', {
            'id', "Tremualin_Library",
            'title', "Tremualin's Library",
        }),
    },
    'id', "Tremualin_Crime_And_Vindication",
    'steam_id', "2567194262",
    'pops_desktop_uuid', "c5c41894-cc51-4fba-bc16-9a2bd9edcb28",
    'pops_any_uuid', "15aa1a0f-5a9d-4cf8-bf0a-3780fd655598",
    'author', "Tremualin",
    'version_major', 1,
    'version_minor', 4,
    'version', 52,
    'lua_revision', 1007000,
    'saved_with_revision', 1007783,
    'code', {
        "Code/Crime.lua",
        "Code/CrimeUI.lua",
        "Code/DomesticViolence.lua",
        "Code/FirstResponders.lua",
        "Code/Notifications.lua",
        "Code/OffDutyHeroes.lua",
        "Code/Rehabilitation.lua",
        "Code/RehabilitationUI.lua",
        "Code/UnitTests.lua",
    },
    'saved', 1631076692,
    'screenshot1', "DomesticViolence.png",
    'screenshot2', "Protests.png",
    'screenshot3', "Crimes.png",
    'screenshot4', "Rehabilitation.jpg",
    'TagGameplay', true,
    'TagTraits', true,
})
