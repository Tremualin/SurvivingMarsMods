-- Add some helpful entries in the encyclopedia
local function AddEntriesToEncyclopedia()
    PlaceObj('EncyclopediaArticle', {
        SortKey = 10020,
        category_id = "Tremualin",
        group = "Tremualin",
        id = "Accidents and Impairments - Accidents and Injuries",
        text = Untranslated([[
Any colonist working on <em>non-medical services</em> like Grocers and Diners will have a chance of getting an injury (imagine a plate dropping on your feet or a box falling from a shelf). Injuries <em>lower the health</em> of the colonist by a random amount between 1 to 20, but otherwise have no other special effects.
 
<em>Accidents</em> are a special type of injury which can only happen in buildings worked by specialized colonists (Geologists, Engineers, etc) and in Ranches. In addition to losing 20 health, accidents can have lasting effects on your colony, leaving colonists <em>Temporarily</em> and sometimes, <em>Permanently Impaired</em>. In rare cases (1% of Accidents) the colonist <em>will die</em>.
 
Accident chances are affected by:
- <em>Unhappy</em> (any stat below 30) colonist's have <em>+5%</em> chances of having an injury or accident each Sol.
- <em>Neutral</em> colonist's (not happy nor unhappy) have <em>+1%</em> chances. 
- <em>Happy</em> colonist's (all stats above 70) have <em>-2%</em> chances.
- <em>Heavy workload</em> adds an additional <em>+3%</em> chance.
- <em>Flaws</em> increase the chances (+1%), each.
- <em>Perks</em> reduce the chances (-1%), each.
 
Example: Hardy-Harr is happy, working overtime and has 2 perks and a quirk. His chances of having an accident are: -2% (Happy) + -2% (Perks) + 3% (Heavy Workload) = -1%. Hardy-Harr won't have any accidents. 
 
You can see a colonist's chances of having an accident on their rollover text.
]]), 
        image = CurrentModPath .. "AccidentChancesSmall.jpg",
        title_id = "AccidentsAndImpairmentsAccidentsAndInjuries",
        title_text = Untranslated("Accidents and Impairments - Accidents and Injuries"),
    })

    PlaceObj('EncyclopediaArticle', {
        SortKey = 10021,
        category_id = "Tremualin",
        group = "Tremualin",
        id = "Accidents and Impairments - Impairments",
        text = Untranslated([[
<em>Temporarily Impaired</em> colonists can no longer work on any job for a few sols. 
- Each Sol, they have a chance of recovering from the accident, starting at 10 % ( + 10 % if there's a Medical Spire and/or Hospital in the same Dome) (+10% if the colonist is Fit) and doubling each day. 
- They will <em>lose 8 sanity</em> each Sol until they recover. 
- They will have an arrow with a band-aid floating above them.
 
<em>Permanently Impaired</em> colonists will be discouraged from taking jobs that puts them (and others) at risk, but will still work to help the colony thrive.
- <em>Physically Impaired</em> colonists will be discouraged from working on mobility-unfriendly jobs like those requiring <em>Engineers, Geologists,  Officers, or in Ranches.</em> 
- <em>Intellectually Impaired</em> colonists will be discouraged from working on mentally-stressful jobs like those requiring <em>Scientists, Officers or Medics</em>. Intellectually Impaired Geniuses will still contribute with Research.
- <em>Sensory Impaired</em> colonists (deaf, blind) can work on all jobs, but they will lose 5 sanity every day while living in any residence with less than <em>65 comfort</em>, and will lose <em>20 morale</em> while <em>Supportive Community</em> isn't researched. 
- You can find permanent impairments under Quirks.
 
A <em>specialized colonist</em> that becomes permanently impaired might <em>lose their specialization</em> if the impairment puts them at risk while doing their job; this is only to keep the mod compatible with Universities, Dome filters, and other mods. In that case, they will be retrained as as another compatible specialization, or as Botanists.
All types of impairments are low frequency traits that can appear naturally on Martianborn.
 
If an accident leaves a colonist <em>Permanently Impaired</em>, they will also be <em>Temporarily Impaired</em>.
<em>Biorobots</em> cannot become Permanently Impaired.
]]), 
        image = CurrentModPath .. "Accidented.jpg",
        title_id = "AccidentsAndImpairmentsImpairments",
        title_text = Untranslated("Accidents and Impairments - Impairments"),
    })
end
OnMsg.ClassesPostprocess = AddEntriesToEncyclopedia
