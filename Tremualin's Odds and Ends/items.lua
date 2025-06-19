return {
    PlaceObj('ModItemCode', {
        'FileName', "Code/ExtractorAI.lua",
    }),
    PlaceObj('ModItemCode', {
        'FileName', "Code/LivingSpaceInformation.lua",
    }),
    PlaceObj('ModItemCode', {
        'FileName', "Code/MultiplesOfThree.lua",
    }),
    PlaceObj('ModItemCode', {
        'FileName', "Code/TrainingComplete.lua",
    }),
    PlaceObj('ModItemCode', {
        'FileName', "Code/OpenAllShiftsByDefault.lua",
    }),
    PlaceObj('ModItemCode', {
        'FileName', "Code/MoreStoryBits.lua",
    }),
    PlaceObj('ModItemOptionToggle', {
        'name', "MultiplesOfThree",
        'DisplayName', "Multiples Of Three",
        'Help', "Re-balances every residence capacity so they all become multiples of 3 (or 5 for smaller ones).\nBecause there are usually 3 shifts; this should make designing domes easier.\nNursery capacity increased from 8 to 9\nLarge Nursery capacity increased from 26 to 30\nLiving Complex capacity increased from 14 to 18\nLiving Quarter capacity increased from 4 to 5\nSmart Complex capacity increased from 12 to 15\nSmart Home capacity increased from 4 to 5 \nSmart Apartment capacity increased from 20 to 21\nRetirement Home capacity increased from 16 to 18\nApartment capacity increased from 24 to 27\nArcology capacity increased to from 32 to 36\nArcology Jumbo Cave upgrade capacity decreased from 10 to 9\nReload the game to apply changes",
        'DefaultValue', true,
    }),
    PlaceObj('ModItemOptionToggle', {
        'name', "MoreStoryBits",
        'DisplayName', "More Story Bits",
        'Help', "Reduces the cooldown between story bits by 50",
        'DefaultValue', true,
    }),
}
