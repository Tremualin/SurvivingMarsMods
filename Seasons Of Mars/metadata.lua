return PlaceObj('ModDef', {
    'title', "Seasons of Mars",
    'description', [[
    Seasons of Mars extends Surviving Mars with new seasonal effects and game mechanics.
    Vegetation will change colors as <white>Seasons</white> change (requires Green Planet)
 
    Dust Storms and Cold Waves will be longer and more frequent in certain Seasons.
    Northern hemisphere colonies will experience difference Seasons than southern hemisphere.
    Difficulty can be adjusted in mod options.
    
    Solar Irradiance will vary across Seasons and Latitudes
    Solar Irradiance will modify the performance of Farms, Solar Panels and Forestation Plants.
    Solar Irradiance can be disabled in mod options.
 
    Wind Speed will vary across Seasons and Latitudes
    Wind Speed will modify the performance of Wind Turbines.
    Wind Speed can be disabled in mod options.
 
    Detailed descriptions of each effect are included in the game's Encyclopedia.
 
    Will you Terraform your way out of the problem?
    Will you find refuge Below and Beyond instead?
    Or will you adapt and endure the Seasons?
 
    [url=https://steamcommunity.com/sharedfiles/filedetails/?id=2588828764]Steam[/url]
    [url=https://mods.paradoxplaza.com/authors/Tremualin]Paradox[/url]\n[url=https://github.com/Tremualin/SurvivingMarsMods]Github[/url]
]], 
    'image', "Preview.jpg",
    'last_changes', "Scripts are applied on MainCity only now",
    'dependencies', {
        PlaceObj('ModDependency', {
            'id', "Tremualin_Library",
            'title', "Tremualin's Library",
        }),
    },
    'id', "Tremualin_Seasons_Of_Mars",
    'steam_id', "2599530116",
    'pops_desktop_uuid', "395c7ade-b619-4528-8ae1-5752cdd09d3b",
    'pops_any_uuid', "a8229293-1d25-41d5-b9da-9b5b0220fb34",
    'author', "Tremualin",
    'version_major', 2,
    'version_minor', 0,
    'version', 48,
    'lua_revision', 1009413,
    'saved_with_revision', 1011140,
    'code', {
        "Code/Color.lua",
        "Code/Seasons.lua",
        "Code/ModOptions.lua",
        "Code/SolarIrradiance.lua",
        "Code/WindSpeed.lua",
        "Code/UI.lua",
        "Code/Encyclopedia.lua",
        "Code/UnitTests.lua",
    },
    'has_options', true,
    'saved', 1652161513,
    'screenshot1', "Welcome.jpg",
    'screenshot2', "Seasons.jpg",
    'screenshot3', "Long.png",
    'screenshot4', "ModOptions.jpg",
    'screenshot5', "Colors.jpg",
    'TagGameplay', true,
})
