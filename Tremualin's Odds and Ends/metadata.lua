return PlaceObj('ModDef', {
    'title', "Tremualin's Odds and Ends",
    'description', [[
Small things that didn't fit in any other mod.
 
Training Complete: Colonists will look for a job immediately after finishing their education.
 
Auto Extractor AI: If Extractor AI is researched, Extractors begin with all their shifts enabled and workslots disabled.
  
Multiples of Three (can be disabled in mod options):
Re-balances every residence capacity so they all become multiples of 3.
Because there are usually 3 shifts and this makes designing domes easier.
Nursery capacity increased from 8 to 9
Large Nursery capacity increased from 26 to 30
Living Complex capacity increased from 14 to 18
Living Quarter capacity increased from 4 to 5
Smart Complex capacity increased from 12 to 15
Smart Home capacity increased from 4 to 5 
Smart Apartment capacity increased from 20 to 21
Retirement Home capacity increased from 16 to 18
Apartment capacity increased from 24 to 27
Arcology capacity increased to from 32 to 36
Arcology Jumbo Cave upgrade capacity decreased from 10 to 9
 
Shut During Dust Storms: Buildings that shut down during Dust Storms no longer appear in notifications, and no longer show X's above them. 
Solar Powered Buildings: Adds a "Solar Powered" Toggle to Buildings. Solar Powered buildings automatically shut down during Dust Storms and at Night.   
]], 
    'id', "Tremualins_Odds_and_Ends",
    'pops_desktop_uuid', "5ccd1160-7823-4d54-8b22-de769181e896",
    'pops_any_uuid', "e8863fde-d513-42a0-a258-81cd42859117",
    'author', "Tremualin",
    'version', 1,
    'lua_revision', 1009413,
    'saved_with_revision', 1011166,
    'code', {
        "Code/ExtractorAI.lua",
        "Code/MultiplesOfThree.lua",
        "Code/TrainingComplete.lua",
    },
    'saved', 1749614963,
})
