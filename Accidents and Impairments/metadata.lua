return PlaceObj('ModDef', {
    'title', "Accidents and Impairments",
    'description', [[
Any colonist working on non-medical services like Grocers and Diners will have a chance of getting an injury (imagine a plate dropping on your feet or a box falling from a shelf). Injuries lower the health of the colonist by a random amount between 1 to 20, but otherwise have no other special effects.
 
Accidents are a special type of injury which can only happen in buildings worked by specialized colonists (Geologists, Engineers, etc) and in Ranches. In addition to losing 20 health, accidents can have lasting effects on your colony, leaving colonists Temporary and sometimes, Permanently Impaired. In rare cases (1% of Accidents) the colonist will die.
 
Temporarily Impaired colonists can no longer work on any job for a few sols. Each sol, they have a chance of recovering from the accident, starting at 10% (+10% if there's a Medical Spire and/or Hospital in the same Dome, +10% if the colonist is Fit) and doubling each day. While Temporarily Impaired, they lose 8 sanity each day. Temporarily Impaired colonists will have an arrow with a band-aid floating above them.
 
Permanently Impaired colonists will be discouraged from taking jobs that puts them (and others) at risk, but will still work to help the colony thrive.
Physically Impaired colonists will be discouraged from working on mobility-unfriendly jobs like those requiring Engineers, Geologists,  Officers, or in Ranches.
Intellectually Impaired colonists will be discouraged from working on mentally-stressful jobs like those requiring Scientists, Officers or Medics. Intellectually Impaired Geniuses will still contribute with Research.
Sensory Impaired colonists (deaf, blind) can work on all jobs, but they will lose 5 sanity every day while living in any residence with less than 65 comfort, and will lose 20 morale while Supportive Community isn't researched. 
 
All permanently impaired colonists are also temporarily impaired; they need time off work to adjust to their new impairment, but should come back to work once the temporary impairment runs out.
 
An specialized colonist that becomes permanently impaired might lose their specialization if the impairment puts them at risk while doing their job; this is only to keep the mod compatible with Universities, Dome filters, and mods that depend on specializations such as SkiRich's Career AI.
 
In addition to accidents, all types of impairments are very low frequency traits that can appear naturally on Martianborn. You can find them under Quirks.
 
An unhappy (any stat below 30) colonist has +5% chances of having an injury or accident each day. 
A neutral colonist (not happy nor unhappy) has +1% chance. 
A happy colonist (all stats above 70) has -2% chance of having accidents. 
Heavy workload adds an additional +3% chance.
 
In addition to happiness and heavy workload, flaws and perks play a role in the likelihood that a colonist has an accident. Each flaw increases the chances of having an accident (+1%) while each perk reduces the chances (-1%). 
 
Example: Hardy-Harr is happy, working overtime and has 2 perks and a quirk. His chances of having an accident are: -2% (Happy) + -2% (Perks) + 3% (Heavy Workload) = -1%. Hardy-Harr won't have any accidents.
 
If you want to minimize the chance of accidents, you must keep your colonists happy, ensure their flaws are treated, and avoid using heavy workload, unless your colonists gain enough perks at School or through other means to offset the penalties. 
 
There's a 1% chance that a colonist might die from an accident.
 
[url=https://steamcommunity.com/sharedfiles/filedetails/?id=2588828764]Steam[/url]
[url=https://mods.paradoxplaza.com/authors/Tremualin]Paradox[/url]
[url=https://github.com/Tremualin/SurvivingMarsMods]Github[/url
]], 
    'image', "Preview.jpg",
    'last_changes', "Fixed a bug that prevented minor injuries from occurring",
    'dependencies', {
        PlaceObj('ModDependency', {
            'id', "Tremualin_Library",
            'title', "Tremualin's Library",
        }),
    },
    'id', "Tremualin_Accidents_And_Impairments",
    'steam_id', "2788599289",
    'pops_desktop_uuid', "cde5b387-9d44-434b-84e0-78e8e438f5b9",
    'pops_any_uuid', "0ee854bb-fbea-47b8-b052-f328dcf4eead",
    'author', "Tremualin",
    'version_major', 1,
    'version_minor', 2,
    'version', 26,
    'lua_revision', 1009413,
    'saved_with_revision', 1011140,
    'bin_assets', true,
    'code', {
        "Code/Accidents.lua",
        "Code/Impairments.lua",
        "Code/UI.lua",
        "Code/Encyclopedia.lua",
    },
    'saved', 1652162939,
    'screenshot1', "AccidentsUI.jpg",
    'screenshot2', "Accidented.jpg",
    'screenshot3', "AccidentChances.jpg",
    'TagGameplay', true,
})
