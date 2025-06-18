return {
    PlaceObj('ModItemCode', {
        'FileName', "Code/ExtractorAI.lua",
    }),

    PlaceObj('ModItemCode', {
        'FileName', "Code/MultiplesOfThree.lua",
    }),

    PlaceObj('ModItemCode', {
        'FileName', "Code/TrainingComplete.lua",
    }),
    PlaceObj('ModItemOptionToggle', {
        'name', "MultiplesOfThree",
        'DisplayName', "Multiples Of Three",
        'Help', [[
Re-balances every residence capacity so they all become multiples of 3 (or 5 for smaller ones).
Because there are usually 3 shifts; this should make designing domes easier.
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
Arcology Jumbo Cave upgrade capacity decreased from 10 to 9]], 
        'DefaultValue', true,
    }),
}
