return PlaceObj('ModDef', {
    'title', "Tremualin's Mod Overrides",
    'description', [[
Fixes compatibility issues or bugs with other modder's mods.
 
AutoGatherTransport: transports gather as much as they can before coming back to a depot, instead of 1 resource at a time.
Incubator: Children born on the surface and sent to the Underground are removed from the Surface (and vice-versa)
 ]], 
    'id', "Tremualins_Mod_Overrides",
    'pops_desktop_uuid', "8917bba7-89b0-4395-9929-d63749b49a75",
    'pops_any_uuid', "76521014-cd01-425e-9847-c55bf8f654b1",
    'author', "Tremualin",
    'version', 3,
    'lua_revision', 1009413,
    'saved_with_revision', 1011166,
    'code', {
        "Code/AutoGatherTransport.lua",
        "Code/Incubator.lua",
    },
    'saved', 1724819204,
})
