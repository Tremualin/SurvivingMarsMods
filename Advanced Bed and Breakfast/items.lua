return {
PlaceObj('ModItemBuildingTemplate', {
	'Group', "Infrastructure",
	'Id', "AsteroidLanderPad",
	'template_class', "LandingPad",
	'pin_rollover_hint', T(794826756950, --[[ModItemBuildingTemplate AsteroidLanderPad pin_rollover_hint]] "<image UI/Infopanel/left_click.tga 1400> Select"),
	'pin_rollover_hint_xbox', T(790932376662, --[[ModItemBuildingTemplate AsteroidLanderPad pin_rollover_hint_xbox]] "<image UI/DesktopGamepad/ButtonA.tga> View"),
	'construction_cost_Concrete', 10000,
	'construction_entity', "RocketLandingPlatform",
	'is_tall', true,
	'dome_forbidden', true,
	'force_extend_bb_during_placement_checks', 1000,
	'can_user_change_prio', false,
	'use_demolished_state', false,
	'consumption_max_storage', 10000,
	'display_name', T(491522694807, --[[ModItemBuildingTemplate AsteroidLanderPad display_name]] "Asteroid Lander Pad"),
	'display_name_pl', T(545036680627, --[[ModItemBuildingTemplate AsteroidLanderPad display_name_pl]] "Asteroid Lander Pads"),
	'description', T(366371489649, --[[ModItemBuildingTemplate AsteroidLanderPad description]] "A dedicated landing site that protects nearby buildings and vehicles from dust during Asteroid Lander landings and takeoffs."),
	'build_category', "Infrastructure",
	'display_icon', "landing_pad.tga",
	'build_pos', 7,
	'entity', "RocketLandingPlatform",
	'encyclopedia_id', "LandingPad",
	'encyclopedia_image', "UI/Encyclopedia/LandingSite.tga",
	'label1', "OutsideBuildings",
	'on_off_button', false,
	'prio_button', false,
	'clear_soil_underneath', true,
}),
PlaceObj('ModItemCode', {
	'name', "Asteroids",
	'FileName', "Code/Asteroids.lua",
}),
PlaceObj('ModItemCode', {
	'name', "Miscellaneous",
	'FileName', "Code/Miscellaneous.lua",
}),
PlaceObj('ModItemCode', {
	'name', "Underground",
	'FileName', "Code/Underground.lua",
}),
PlaceObj('ModItemOptionToggle', {
	'name', "ApplyAntiFreeze",
	'DisplayName', "Anti Freeze Protection",
	'Help', "Attempts to kill colonists who are stuck in an infinite loop. Could unfreeze your game.",
}),
PlaceObj('ModItemOptionToggle', {
	'name', "RemoveColonistsFromWrongMap",
	'DisplayName', "Remove Colonists From Wrong Map",
	'Help', "If enabled, loading a game will remove colonists from the wrong maps (unless the colonists are stuck; use ApplyAntiFreeze for that)",
}),
PlaceObj('ModItemOptionToggle', {
	'name', "AncientArtifact",
	'DisplayName', "Ancient Artifact?",
	'Help', "Do you want the underground contain the Ancient Artifact?",
	'DefaultValue', true,
}),
PlaceObj('ModItemOptionToggle', {
	'name', "BottomlessPit",
	'DisplayName', "Bottomless Pit?",
	'Help', "Do you want the underground contain the Bottomless Pit?",
	'DefaultValue', true,
}),
PlaceObj('ModItemOptionToggle', {
	'name', "CaveOfWonders",
	'DisplayName', "Cave Of Wonders?",
	'Help', "Do you want the underground contain the Cave Of Wonders?",
	'DefaultValue', true,
}),
PlaceObj('ModItemOptionToggle', {
	'name', "JumboCave",
	'DisplayName', "Jumbo Cave",
	'Help', "Do you want the underground contain the Jumbo Cave?",
	'DefaultValue', true,
}),
}
