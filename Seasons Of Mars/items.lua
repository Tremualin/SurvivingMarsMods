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
	'name', "ModOptions",
	'FileName', "Code/ModOptions.lua",
}),
PlaceObj('ModItemCode', {
	'name', "UI",
	'FileName', "Code/UI.lua",
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
	'DisplayName', "Additional Disaster Duration Per Sol",
	'Help', "Move it to the left for softer disasters; to the right for harder disasters. 25=2.5% per Sol",
	'DefaultValue', 25,
	'MinValue', 5,
	'MaxValue', 1000,
	'StepSize', 5,
}),
PlaceObj('ModItemOptionNumber', {
	'name', "FrequencyDifficulty",
	'DisplayName', "Additional Disaster Frequency Per Sol",
	'Help', "Move it to the left for softer disasters; to the right for longer disasters. 5=0.5% per Sol",
	'DefaultValue', 5,
	'MinValue', 5,
	'MaxValue', 1000,
	'StepSize', 5,
}),
PlaceObj('ModItemOptionNumber', {
	'name', "DurationDivider",
	'DisplayName', "Season Duration Divider",
	'Help', "Divides the real duration of the season by this number, for shorter games",
	'DefaultValue', 3,
	'MinValue', 1,
	'MaxValue', 20,
}),
PlaceObj('ModItemOptionToggle', {
	'name', "ChangeColors",
	'DisplayName', "Change Colors",
	'Help', "If enabled, vegetation will change colors at the beginning of each season",
	'DefaultValue', true,
}),
PlaceObj('ModItemOptionToggle', {
	'name', "SolarIrradianceEnabled",
	'DisplayName', "Enable Solar Irradiance",
	'Help', "If enabled, Solar Irradiance boosts will be applied to Solar Panels, Farms and Forestation Plants (Green Planet required)",
	'DefaultValue', true,
}),
PlaceObj('ModItemOptionNumber', {
	'name', "BaseSolarIrradiance",
	'DisplayName', "Base Solar Irradiance",
	'Help', "Increase this number for less solar power bonuses (and even negative solar power) and more wind power bonuses. Decrease it for higher solar power bonuses and less wind power.",
	'DefaultValue', 52,
	'MinValue', 1,
	'MaxValue', 200,
}),
PlaceObj('ModItemOptionToggle', {
	'name', "WindSpeedEnabled",
	'DisplayName', "Enable Wind Speed",
	'Help', "If enabled, Wind Speed boosts will be applied to all Wind Turbines",
	'DefaultValue', true,
}),
PlaceObj('ModItemOptionToggle', {
	'name', "ReadSunAndWindUpdate",
	'DisplayName', "Read Sun and Wind Update Message",
	'Help', "If false, will show a message each time you start or load a game",
}),
}
