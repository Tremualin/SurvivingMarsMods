return PlaceObj('ModDef', {
    'title', "Trait Galore",
    'description', "Trait Galore adds several new perks, flaws and quirks to spice up your game.\nConsult the following table to learn more about each trait.\n \n    [table]\n  [tr]\n     [th]Trait[/th]\n     [th]Type[/th]\n     [th]Incompatible with[/th]\n     [th]Description[/th]\n     [th]Effect[/th]\n     [th]Can be gained due to Sanity Breakdown?[/th]\n     [th]Available at School?[/th]\n     [th]Curable in Sanatorium?[/th]\n     [th]Frequency[/th]\n  [/tr]\n  [tr]\n     [td]Anxious[/td]\n     [td]Flaw[/td]\n     [td]Composed[/td]\n     [td]Anxious colonists literally can't wait to get their interests satisfied. [/td]\n     [td]-2 sanity whenever unable to immediately satisfy an interest. If there is no building capable of satisfying the interest, they will losemassive sanity.[/td]\n     [td]Yes[/td]\n     [td]No[/td]\n     [td]Yes[/td]\n     [td]Normal[/td]\n  [/tr]\n  [tr]\n     [td]Argumentative[/td]\n     [td]Flaw[/td]\n     [td]Listener[/td]\n     [td]Argumentative colonists will drive each other crazy. [/td]\n     [td]Both this an another argumentative colonist in the same residence will lose 5 sanity each day.[/td]\n     [td]No[/td]\n     [td]No[/td]\n     [td]Yes[/td]\n     [td]Normal[/td]\n  [/tr]\n  [tr]\n     [td]Depressed[/td]\n     [td]Flaw[/td]\n     [td]Renegade[/td]\n     [td]Depressed colonists need to be assigned to a Sanatorium as soon as possible; for their own sake. [/td]\n     [td]Morale is set to 0. 80% chance of losing daily interest. Chance for suicide and new flaws (affected by Supportive Community) every day unless assigned to a Sanatorium. -Social[/td]\n     [td]Yes[/td]\n     [td]No[/td]\n     [td]Yes[/td]\n     [td]Very low[/td]\n  [/tr]\n  [tr]\n     [td]Mean[/td]\n     [td]Flaw[/td]\n     [td]Kind[/td]\n     [td]Mean colonists don't mean to be mean, they just are. [/td]\n     [td]-5 sanity to another random colonist in the dome[/td]\n     [td]No[/td]\n     [td]No[/td]\n     [td]Yes[/td]\n     [td]Normal[/td]\n  [/tr]\n  [tr]\n     [td]Paranoid[/td]\n     [td]Flaw[/td]\n     [td]Composed[/td]\n     [td]Paranoid colonists are afraid something bad is coming. Will a meteorite strike today? Probably.[/td]\n     [td]-3 sanity when moving to a new location in or out of the Dome[/td]\n     [td]Yes[/td]\n     [td]No[/td]\n     [td]Yes[/td]\n     [td]Low[/td]\n  [/tr]\n  [tr]\n     [td]Fickle[/td]\n     [td]Perk[/td]\n     [td]Religious[/td]\n     [td]Fickle colonists aren't too attached to any particular interest..or religion.[/td]\n     [td]Alternates between different interests until it can satisfy one or goes to sleep. [/td]\n     [td]No[/td]\n     [td]No[/td]\n     [td]No[/td]\n     [td]Low[/td]\n  [/tr]\n  [tr]\n     [td]Fixer[/td]\n     [td]Perk[/td]\n     [td]Idiot[/td]\n     [td]Fixer colonists can fix anything; and they will. Who needs Drones?[/td]\n     [td]Reduces the maintenance of any building it visits by 4%.[/td]\n     [td]No[/td]\n     [td]Yes[/td]\n     [td]No[/td]\n     [td]Low[/td]\n  [/tr]\n  [tr]\n     [td]Kind[/td]\n     [td]Perk[/td]\n     [td]Mean[/td]\n     [td]Kind colonists make other colonists feel better about themselves. You're welcome.[/td]\n     [td]A random colonist in the same residence gets +5 Sanity. [/td]\n     [td]No[/td]\n     [td]Yes[/td]\n     [td]No[/td]\n     [td]Normal[/td]\n  [/tr]\n  [tr]\n     [td]Mentor[/td]\n     [td]Perk[/td]\n     [td]Loner[/td]\n     [td]Mentors love helping others. Thankfully they cannot Mentor Idiocy[/td]\n     [td]Coworkers gain +20 performance and a moderate chance of losing the Idiot flaw; unless the Mentor is also an Idiot.[/td]\n     [td]No[/td]\n     [td]Yes[/td]\n     [td]No[/td]\n     [td]Low[/td]\n  [/tr]\n  [tr]\n     [td]Thrifty[/td]\n     [td]Perk[/td]\n     [td]Lazy[/td]\n     [td]Thrifty colonists find ways to do more with less; like bubbles in chocolate and air in chips bags.[/td]\n     [td]Reduces the amount of resources consumed by the workplace by 5%[/td]\n     [td]No[/td]\n     [td]Yes[/td]\n     [td]No[/td]\n     [td]Low[/td]\n  [/tr]\n  [tr]\n     [td]Brawler[/td]\n     [td]Quirk[/td]\n     [td]Composed[/td]\n     [td]Brawlers like to pump adrenaline with their fists from time to time; but they don't talk about it.[/td]\n     [td]Once a day, if healthy, this an another healthy non-child will both lose 10 health; then both colonists regain 5 sanity. [/td]\n     [td]No[/td]\n     [td]No[/td]\n     [td]No[/td]\n     [td]Normal[/td]\n  [/tr]\n  [tr]\n     [td]Early Bird[/td]\n     [td]Quirk[/td]\n     [td]Night Owl[/td]\n     [td]Early Birds just love the morning..and hate the night.[/td]\n     [td]Gains/loses 5 comfort when working the morning/night. Will try to switch jobs with someone in the Morning Shift.[/td]\n     [td]No[/td]\n     [td]No[/td]\n     [td]No[/td]\n     [td]Low[/td]\n  [/tr]\n  [tr]\n     [td]Listener[/td]\n     [td]Quirk[/td]\n     [td]Argumentative[/td]\n     [td]Listeners will listen to your woes. But who listens to the listener?[/td]\n     [td]The colonist with the lowest sanity in the residence gets +10 sanity. But this colonist will lose 5 sanity.[/td]\n     [td]No[/td]\n     [td]No[/td]\n     [td]No[/td]\n     [td]Normal[/td]\n  [/tr]\n  [tr]\n     [td]Night Owl[/td]\n     [td]Quirk[/td]\n     [td]Early Bird[/td]\n     [td]Night Owls just love the night...and hate mornings.[/td]\n     [td]Gains/loses 5 comfort when working the night/morning. Regains sanity lost from Night Shifts. Will try to switch jobs with someone on the Night Shift[/td]\n     [td]No[/td]\n     [td]No[/td]\n     [td]No[/td]\n     [td]Low[/td]\n  [/tr]\n[/table]\n \n[h2]Strategy: Flaws [/h2]\n \nAnxious, Argumentative, Mean and Paranoid are all flaws that remove sanity one way or another.\nThe maximum amount that each can remove is 30 for Anxious, 10 for Argumentative (divided within 2 colonists), 12 for Paranoid (-3 while visiting Residence, Workplace, chosen Service, Food and/or Medical), and 5 for Mean. \nDepressed on the other hand is a very low frequency very dangerous Flaw which most likely ends in Suicide in the early to mid game; you should set it as first priority in the Sanatorium and you should move all your Depressed colonists into the Sanatorium Dome.\nDon't forget that Depressed colonists can gain new flaws each day until assigned to a Sanatorium; Supportive Community reduces those chances. \n \n[h2]Strategy: Perks [/h2]\n \nSelecting Kind colonists in the early game can do wonders for your colony's sanity, while Fickle colonists will almost never lose comfort since they alternate through their interests. \n \nMentors provide supplementary performance for buildings with lots of workers, like Factories, Outdoor Farms, and Science Buildings; to calculate the workplace performance added by each mentor, do: 20 * (n-1)/n where n is the number of workers. For example, a Hawkings Lab has 8 workers per shift; one mentor gives you 20 * (8-1)/8 = 17.5 workplace performance, but a Mentor working in a Diner (2 workers) will you give you 20*(2-1)/2=10 workplace performance, and a Mentor in a Grocer will give you nothing.\n \nThrifty colonists are perfect for working in Factories, because they reduce the amount of materials needed to manufacture. An Electronics Factory has 10 Engineers; if all of them are Thrifty, that's 50% Rare Metal consumption reduction, from 0.3 to 0.15! Note: the UI might show 0.2 but it's just rounding up, the actual number is 0.15; you should consider having a School/University Dome that exclusively trains Thrifty Engineers.\nThrifty colonists who work at Grocers, Diners, Electronics or Art Stores will also save in resources consumed, although just 5% (10% for the Diner); those working in Workshops will also save a lot of materials.\nThrifty colonists can also use their powers to reduce electricity consumption on buildings that don't normally consume resources, like Science Buildings. \n \nFixer colonists will fix any building they enter, which makes them great at keeping their residences, services and workplaces working properly. This is particularly interesting in Science Domes since those tend to require a lot of Electronics. \nTheir usefulness is diminished for other type of Domes, since most buildings maintenance is Concrete and Polymers, not Electronics; you should consider having a School/University Dome that exclusively trains Fixer Scientists.\nFixer colonists also make Smart Residences more appealing, since they can keep them maintained for free, negating the cost in Electronics. They're also loved by Blue Sun Corporation and Paradox Interactive, whose unique buildings consume Electronics.\n \n[h2] Strategy: Quirks [/h2]\n \nBrawlers exchange health for sanity; they will however never start a fight if their health is below 30 and they will never pick a colonist whose health is below 30. They will often visit the infirmary.\n \nEarly Birds and Night Owls will try to find a suitable shift for them, and will gain +5 comfort every day while working in their preferred shift, which allows them to maximize comfort even in the early game. But too many of them at the same workplace and they will start losing comfort from being unable to find a nice work shift. \n \nListeners are probably the most useful since they target the colonist with the lowest sanity in the dome and help them regain sanity. But..that colonist is usually them, since they constantly lose sanity from listening to others complain all the time. \n \n[h2] Mod Compatibility [/h2]\n(Not yet implemented) If you have my [url=https://steamcommunity.com/sharedfiles/filedetails/?id=2535835676] Seniors with Benefits [/url] mod, then Seniors will be able to remove the new Flaws.",
    'last_changes', "First version",
    'dependencies', {
        PlaceObj('ModDependency', {
            'id', "Tremualin_Library",
            'title', "Tremualin's Library",
        }),
    },
    'id', "Tremualin_Trait_Galore",
    'pops_desktop_uuid', "a99c9ffd-2368-4e52-bb5b-609d16fe1037",
    'pops_any_uuid', "d69d4ba6-aec7-4677-8047-7c5addc99f12",
    'author', "Tremualin",
    'version_major', 1,
    'version', 56,
    'lua_revision', 233360,
    'saved_with_revision', 1001586,
    'code', {
        "Code/Anxious.lua",
        "Code/Common.lua",
        "Code/Cynical.lua",
        "Code/Depressed.lua",
        "Code/EarlyBird_NightOwl.lua",
        "Code/Fickle.lua",
        "Code/Fixer.lua",
        "Code/Mentor.lua",
        "Code/Paranoid.lua",
        "Code/Thrifty.lua",
    },
    'saved', 1630260577,
})
