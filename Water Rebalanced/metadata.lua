return PlaceObj('ModDef', {
    'title', "Water Rebalanced",
    'dependencies', {
        PlaceObj('ModDependency', {
            'id', "Tremualin_Library",
            'title', "Tremualin's Library",
        }),
    },
    'id', "Tremualin_Water_Rebalanced",
    'pops_desktop_uuid', "3de82609-8d2d-4ee2-bec2-96bba98aa1ea",
    'pops_any_uuid', "8a7eaec6-c590-4982-81bb-2bf11a8d4ce0",
    'author', "Tremualin",
    'version_major', 1,
    'version', 5,
    'lua_revision', 1007000,
    'saved_with_revision', 1007783,
    'code', {
        "Code/LakeComfort.lua",
        "Code/WaterLoss.lua",
        "Code/MoistureVaporatorSucksWater.lua",
    },
    'saved', 1631475056,
    'TagGameplay', true,
    'TagTerraforming', true,
})
