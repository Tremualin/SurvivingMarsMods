return PlaceObj('ModDef', {
    'title', "Trait Galore",
    'description', [[
Trait Galore adds several new perks, flaws and quirks to spice up your game.
Consult the following table to learn more about each trait.
 
    [table]
  [tr]
     [th]Trait[/th]
     [th]Type[/th]
     [th]Incompatible with[/th]
     [th]Description[/th]
     [th]Effect[/th]
     [th]Can be gained due to Sanity Breakdown?[/th]
     [th]Available at School?[/th]
     [th]Curable in Sanatorium?[/th]
     [th]Frequency[/th]
  [/tr]
  [tr]
     [td]Anxious[/td]
     [td]Flaw[/td]
     [td]Composed[/td]
     [td]Anxious colonists literally can't wait to get their interests satisfied. [/td]
     [td]-2 sanity whenever unable to immediately satisfy an interest. If there is no building capable of satisfying the interest, they will losemassive sanity.[/td]
     [td]Yes[/td]
     [td]No[/td]
     [td]Yes[/td]
     [td]Normal[/td]
  [/tr]
  [tr]
     [td]Argumentative[/td]
     [td]Flaw[/td]
     [td]Listener[/td]
     [td]Argumentative colonists will drive each other crazy. [/td]
     [td]Both this an another argumentative colonist in the same residence will lose 5 sanity each day.[/td]
     [td]No[/td]
     [td]No[/td]
     [td]Yes[/td]
     [td]Normal[/td]
  [/tr]
  [tr]
     [td]Depressed[/td]
     [td]Flaw[/td]
     [td]Renegade[/td]
     [td]Depressed colonists need to be assigned to a Sanatorium as soon as possible; for their own sake. [/td]
     [td]Morale is set to 0. 80% chance of losing daily interest. Chance for suicide and new flaws (affected by Supportive Community) every day unless assigned to a Sanatorium. -Social[/td]
     [td]Yes[/td]
     [td]No[/td]
     [td]Yes[/td]
     [td]Very low[/td]
  [/tr]
  [tr]
     [td]Mean[/td]
     [td]Flaw[/td]
     [td]Kind[/td]
     [td]Mean colonists don't mean to be mean, they just are. [/td]
     [td]-5 sanity to another random colonist in the dome[/td]
     [td]No[/td]
     [td]No[/td]
     [td]Yes[/td]
     [td]Normal[/td]
  [/tr]
  [tr]
     [td]Paranoid[/td]
     [td]Flaw[/td]
     [td]Composed[/td]
     [td]Paranoid colonists are afraid something bad is coming. Will a meteorite strike today? Probably.[/td]
     [td]-3 sanity when moving to a new location in or out of the Dome[/td]
     [td]Yes[/td]
     [td]No[/td]
     [td]Yes[/td]
     [td]Low[/td]
  [/tr]
  [tr]
     [td]Fickle[/td]
     [td]Perk[/td]
     [td]Religious[/td]
     [td]Fickle colonists aren't too attached to any particular interest..or religion.[/td]
     [td]Alternates between different interests until it can satisfy one or goes to sleep. [/td]
     [td]No[/td]
     [td]No[/td]
     [td]No[/td]
     [td]Low[/td]
  [/tr]
  [tr]
     [td]Fixer[/td]
     [td]Perk[/td]
     [td]Idiot[/td]
     [td]Fixer colonists can fix anything; and they will. Who needs Drones?[/td]
     [td]Reduces the maintenance of any building it visits by 4%.[/td]
     [td]No[/td]
     [td]Yes[/td]
     [td]No[/td]
     [td]Low[/td]
  [/tr]
  [tr]
     [td]Kind[/td]
     [td]Perk[/td]
     [td]Mean[/td]
     [td]Kind colonists make other colonists feel better about themselves. You're welcome.[/td]
     [td]A random colonist in the same residence gets +5 Sanity. [/td]
     [td]No[/td]
     [td]Yes[/td]
     [td]No[/td]
     [td]Normal[/td]
  [/tr]
  [tr]
     [td]Mentor[/td]
     [td]Perk[/td]
     [td]Loner[/td]
     [td]Mentors love helping others. Thankfully they cannot Mentor Idiocy[/td]
     [td]Coworkers gain +20 performance and a moderate chance of losing the Idiot flaw; unless the Mentor is also an Idiot.[/td]
     [td]No[/td]
     [td]Yes[/td]
     [td]No[/td]
     [td]Low[/td]
  [/tr]
  [tr]
     [td]Thrifty[/td]
     [td]Perk[/td]
     [td]Lazy[/td]
     [td]Thrifty colonists find ways to do more with less; like bubbles in chocolate and air in chips bags.[/td]
     [td]Reduces the amount of resources consumed by the workplace by 5%[/td]
     [td]No[/td]
     [td]Yes[/td]
     [td]No[/td]
     [td]Low[/td]
  [/tr]
  [tr]
     [td]Brawler[/td]
     [td]Quirk[/td]
     [td]Composed[/td]
     [td]Brawlers like to pump adrenaline with their fists from time to time; but they don't talk about it.[/td]
     [td]Once a day, if healthy, this an another healthy non-child will both lose 10 health; then both colonists regain 5 sanity. [/td]
     [td]No[/td]
     [td]No[/td]
     [td]No[/td]
     [td]Normal[/td]
  [/tr]
  [tr]
     [td]Early Bird[/td]
     [td]Quirk[/td]
     [td]Night Owl[/td]
     [td]Early Birds just love the morning..and hate the night.[/td]
     [td]Gains/loses 5 comfort when working the morning/night. Will try to switch jobs with someone in the Morning Shift.[/td]
     [td]No[/td]
     [td]No[/td]
     [td]No[/td]
     [td]Low[/td]
  [/tr]
  [tr]
     [td]Listener[/td]
     [td]Quirk[/td]
     [td]Argumentative[/td]
     [td]Listeners will listen to your woes. But who listens to the listener?[/td]
     [td]The colonist with the lowest sanity in the residence gets +10 sanity. But this colonist will lose 5 sanity.[/td]
     [td]No[/td]
     [td]No[/td]
     [td]No[/td]
     [td]Normal[/td]
  [/tr]
  [tr]
     [td]Night Owl[/td]
     [td]Quirk[/td]
     [td]Early Bird[/td]
     [td]Night Owls just love the night...and hate mornings.[/td]
     [td]Gains/loses 5 comfort when working the night/morning. Regains sanity lost from Night Shifts. Will try to switch jobs with someone on the Night Shift[/td]
     [td]No[/td]
     [td]No[/td]
     [td]No[/td]
     [td]Low[/td]
  [/tr]
[/table]
 
[h2]Strategy: Flaws [/h2]
 
Anxious, Argumentative, Mean and Paranoid are all flaws that remove sanity one way or another.
The maximum amount that each can remove is 30 for Anxious, 10 for Argumentative (divided within 2 colonists), 12 for Paranoid (-3 while visiting Residence, Workplace, chosen Service, Food and/or Medical), and 5 for Mean. 
Depressed on the other hand is a very low frequency very dangerous Flaw which most likely ends in Suicide in the early to mid game; you should set it as first priority in the Sanatorium and you should move all your Depressed colonists into the Sanatorium Dome.
Don't forget that Depressed colonists can gain new flaws each day until assigned to a Sanatorium; Supportive Community reduces those chances. 
 
[h2]Strategy: Perks [/h2]
 
Selecting Kind colonists in the early game can do wonders for your colony's sanity, while Fickle colonists will almost never lose comfort since they alternate through their interests. 
 
Mentors provide supplementary performance for buildings with lots of workers, like Factories, Outdoor Farms, and Science Buildings; to calculate the workplace performance added by each mentor, do: 20 * (n-1)/n where n is the number of workers. For example, a Hawkings Lab has 8 workers per shift; one mentor gives you 20 * (8-1)/8 = 17.5 workplace performance, but a Mentor working in a Diner (2 workers) will you give you 20*(2-1)/2=10 workplace performance, and a Mentor in a Grocer will give you nothing.
 
Thrifty colonists are perfect for working in Factories, because they reduce the amount of materials needed to manufacture. An Electronics Factory has 10 Engineers; if all of them are Thrifty, that's 50% Rare Metal consumption reduction, from 0.3 to 0.15! Note: the UI might show 0.2 but it's just rounding up, the actual number is 0.15; you should consider having a School/University Dome that exclusively trains Thrifty Engineers.
Thrifty colonists who work at Grocers, Diners, Electronics or Art Stores will also save in resources consumed, although just 5% (10% for the Diner); those working in Workshops will also save a lot of materials.
Thrifty colonists can also use their powers to reduce electricity consumption on buildings that don't normally consume resources, like Science Buildings. 
 
Fixer colonists will fix any building they enter, which makes them great at keeping their residences, services and workplaces working properly. This is particularly interesting in Science Domes since those tend to require a lot of Electronics. 
Their usefulness is diminished for other type of Domes, since most buildings maintenance is Concrete and Polymers, not Electronics; you should consider having a School/University Dome that exclusively trains Fixer Scientists.
Fixer colonists also make Smart Residences more appealing, since they can keep them maintained for free, negating the cost in Electronics. They're also loved by Blue Sun Corporation and Paradox Interactive, whose unique buildings consume Electronics.
 
[h2] Strategy: Quirks [/h2]
 
Brawlers exchange health for sanity; they will however never start a fight if their health is below 30 and they will never pick a colonist whose health is below 30. They will often visit the infirmary.
 
Early Birds and Night Owls will try to find a suitable shift for them, and will gain +5 comfort every day while working in their preferred shift, which allows them to maximize comfort even in the early game. But too many of them at the same workplace and they will start losing comfort from being unable to find a nice work shift. 
 
Listeners are probably the most useful since they target the colonist with the lowest sanity in the dome and help them regain sanity. But..that colonist is usually them, since they constantly lose sanity from listening to others complain all the time. 
 
[h2] Mod Compatibility [/h2]
(Not yet implemented) If you have my [url=https://steamcommunity.com/sharedfiles/filedetails/?id=2535835676] Seniors with Benefits [/url] mod, then Seniors will be able to remove the new Flaws.
 
    ]], 
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
    'version', 51,
    'lua_revision', 233360,
    'saved_with_revision', 1001586,
    'code', {
        "Code/Anxious.lua",
        "Code/Common.lua",
        "Code/Depressed.lua",
        "Code/EarlyBird_NightOwl.lua",
        "Code/Fickle.lua",
        "Code/Fixer.lua",
        "Code/Mentor.lua",
        "Code/Paranoid.lua",
        "Code/Thrifty.lua",
    },
    'saved', 1630203302,
})
