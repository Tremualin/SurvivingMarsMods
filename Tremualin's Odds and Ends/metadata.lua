return PlaceObj('ModDef', {
    'title', "Tremualin's Odds and Ends",
    'description', "Small things that didn't fit in any other mod.\n\nOpen All Shifts By Default: New buildings begin with all shifts open.\n\nTraining Complete: Colonists will look for a job immediately after finishing their education.\n\nAuto Extractor AI: If Extractor AI is researched, Extractors begin with all their shifts enabled and workslots disabled.\n\nMultiples of Three (can be disabled in mod options):\nRe-balances every residence capacity so they all become multiples of 3.\nBecause there are usually 3 shifts and this makes designing domes easier.\nNursery capacity increased from 8 to 9\nLarge Nursery capacity increased from 26 to 30\nLiving Complex capacity increased from 14 to 18\nLiving Quarter capacity increased from 4 to 5\nSmart Complex capacity increased from 12 to 15\nSmart Home capacity increased from 4 to 5 \nSmart Apartment capacity increased from 20 to 21\nRetirement Home capacity increased from 16 to 18\nApartment capacity increased from 24 to 27\nArcology capacity increased to from 32 to 36\nArcology Jumbo Cave upgrade capacity decreased from 10 to 9\n\nShut During Dust Storms: Buildings that shut down during Dust Storms no longer appear in notifications, and no longer show X's above them. \nSolar Powered Buildings: Adds a \"Solar Powered\" Toggle to Buildings. Solar Powered buildings automatically shut down during Dust Storms and at Night.\n\nNew Game Rules:\nLosing my Religion: Colonists will lose a perk anytime they gain a flaw. (+40% difficulty)\nEverybody Hurts: Unnatural death sanity losses affect the entire Colony. (+100% difficulty) \nAnother Day In Paradise: Doubles morale bonuses and penalties for high and low stats respectively.\nWhat a Wonderful World: Stats (health, sanity, comfort) are considered high when over 90 instead of 70, and low when below 50 instead of 30.\nAnother Brick In the Wall: Colonists lose sanity from Schools, Universities and Sanatoriums.\nDinner Bell: Double comfort losses from eating food from depots.\n",
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
    },
    'has_options', true,
    'saved', 1750228067,
})
