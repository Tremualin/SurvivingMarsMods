return {
PlaceObj('ModItemCode', {
	'name', "Notifications",
	'FileName', "Code/Notifications.lua",
}),
PlaceObj('ModItemCode', {
	'name', "Seasons",
	'FileName', "Code/Seasons.lua",
}),
PlaceObj('ModItemCode', {
	'name', "UnitTests",
	'FileName', "Code/UnitTests.lua",
}),
PlaceObj('ModItemOptionNumber', {
	'name', "FrequencyDifficulty",
	'DisplayName', "Additional Disaster Frequency",
	'Help', "Move it to the left for softer disasters; to the right for longer disasters",
	'DefaultValue', 5,
	'MinValue', 5,
	'MaxValue', 1000,
	'StepSize', 5,
}),
PlaceObj('ModItemOptionNumber', {
	'name', "DurationDifficulty",
	'DisplayName', "Additional Disaster Duration",
	'Help', "Move it to the left for softer disasters; to the right for harder disasters",
	'DefaultValue', 25,
	'MinValue', 5,
	'MaxValue', 1000,
	'StepSize', 5,
}),
PlaceObj('ModItemOptionNumber', {
	'name', "DurationDivider",
	'DisplayName', "Season Duration Divider",
	'Help', "Move it to the left for longer seasons; to the right for shorter seasons.",
	'DefaultValue', 4,
	'MinValue', 1,
	'MaxValue', 20,
}),
}
