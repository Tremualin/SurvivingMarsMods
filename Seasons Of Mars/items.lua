return {
    PlaceObj('ModItemCode', {
        'name', "Color",
        'FileName', "Code/Color.lua",
    }),
    PlaceObj('ModItemCode', {
        'name', "Seasons",
        'FileName', "Code/Seasons.lua",
    }),
    PlaceObj('ModItemCode', {
        'name', "Notifications",
        'FileName', "Code/Notifications.lua",
    }),
    PlaceObj('ModItemCode', {
        'name', "SolarIrradiance",
        'FileName', "Code/SolarIrradiance.lua",
    }),
    PlaceObj('ModItemCode', {
        'name', "WindSpeed",
        'FileName', "Code/WindSpeed.lua",
    }),
    PlaceObj('ModItemCode', {
        'name', "Encyclopedia",
        'FileName', "Code/Encyclopedia.lua",
    }),
    PlaceObj('ModItemCode', {
        'name', "UnitTests",
        'FileName', "Code/UnitTests.lua",
    }),
    PlaceObj('ModItemOptionNumber', {
        'name', "DurationDifficulty",
        'DisplayName', "Additional Disaster Duration",
        'Help', "Move it to the left for softer disasters; to the right for harder disasters. 25=2.5%",
        'DefaultValue', 25,
        'MinValue', 5,
        'MaxValue', 1000,
        'StepSize', 5,
    }),
    PlaceObj('ModItemOptionNumber', {
        'name', "FrequencyDifficulty",
        'DisplayName', "Additional Disaster Frequency",
        'Help', "Move it to the left for softer disasters; to the right for longer disasters. 5=0.5%",
        'DefaultValue', 5,
        'MinValue', 5,
        'MaxValue', 1000,
        'StepSize', 5,
    }),
    PlaceObj('ModItemOptionNumber', {
        'name', "DurationDivider",
        'DisplayName', "Season Duration Divider",
        'Help', "Divides the duration of the season by this number. Default 4",
        'DefaultValue', 4,
        'MinValue', 1,
        'MaxValue', 20,
    }),
    PlaceObj('ModItemOptionToggle', {
        'name', "ChangeColors",
        'DisplayName', "Change Colors",
        'Help', "If enabled, all seasons will apply a different color filter to all vegetation",
        'DefaultValue', true,
    }),
}
