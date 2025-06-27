return PlaceObj('ModDef', {
    'title', "Tremualin's Odds and Ends",
    'description', [[
Small things that didn't fit in any other mod.
 
Extractor AI: If Extractor AI is researched, Extractors begin with all their shifts enabled and work slots disabled. 
Find Sanatorium Fast: Colonists with flaws will try to find Sanatoriums automatically. 
Living Space Information: Adds a warning to Dome's if Workplaces > Living Spaces, or Living Spaces > Workplaces.
More Story Bits: Reduces Story Bit cool-down by 75%. 
Multiples of Three:
- Can be disabled in mod options
- Re-balances every (larger) residence capacity so they all become multiples of 3.
- Because there are usually 3 shifts and this makes designing domes easier.
- Nursery capacity increased from 8 to 9
- Large Nursery capacity increased from 26 to 30
- Living Complex capacity increased from 14 to 18
- Living Quarter capacity increased from 4 to 5
- Smart Complex capacity increased from 12 to 15
- Smart Home capacity increased from 4 to 5
- Smart Apartment capacity increased from 20 to 21
- Retirement Home capacity increased from 16 to 18
- Apartment capacity increased from 24 to 27
- Arcology capacity increased to from 32 to 36
- Arcology Jumbo Cave upgrade capacity decreased from 10 to 9
Open All Shifts By Default: New buildings begin with all shifts open.
Training Complete: Colonists will try to find a job immediately after finishing their education (including Sanatorium).
TrainsAllowServices: Trains can be used to full-fill services, same as passages. 
Tunnel Cost Scale: Tunnels are cheaper and have unlimited distance, but their cost increases with distance.
 
New Game Rules:
Losing my Religion: Colonists lose a perk anytime they gain a flaw.
Another Brick In The Wall: Colonists lose sanity from educational buildings
Royals: Colonists stats are green if above 90(rather than 70) and low if below 50(rather than 30)
]], 
    'dependencies', {
        PlaceObj('ModDependency', {
            'id', "ZbvSHa",
            'title', "Fix Emigration Issues",
            'required', false,
        }),
    },
    'id', "Tremualins_Odds_and_Ends",
    'pops_desktop_uuid', "5ccd1160-7823-4d54-8b22-de769181e896",
    'pops_any_uuid', "e8863fde-d513-42a0-a258-81cd42859117",
    'author', "Tremualin",
    'version', 2,
    'lua_revision', 1009413,
    'saved_with_revision', 1011166,
    'code', {
        "Code/ExtractorAI.lua",
        "Code/LivingSpaceInformation.lua",
        "Code/MultiplesOfThree.lua",
        "Code/TrainingComplete.lua",
        "Code/OpenAllShiftsByDefault.lua",
        "Code/MoreStoryBits.lua",
        "Code/TunnelCostScale.lua",
        "Code/TrainsAllowServices.lua",
        "Code/FindSanatoriumFast.lua",
        "Code/LosingMyReligion.lua",
        "Code/AnotherBrickInTheWall.lua",
        "Code/Royals.lua",
    },
    'has_options', true,
    'saved', 1750228067,
})
