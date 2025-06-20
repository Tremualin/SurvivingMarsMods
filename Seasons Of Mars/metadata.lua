return PlaceObj('ModDef', {
    'title', "Seasons of Mars (Difficulty Mod)",
    'description', "Seasons of Mars extends Surviving Mars with new seasonal effects and game mechanics.\nVegetation will change colors as Seasons change (requires Green Planet)\n \nDust Storms and Cold Waves will be longer and more frequent in certain Seasons.\nNorthern hemisphere colonies will experience difference Seasons than southern hemisphere.\nDifficulty can be adjusted in mod options.\n \nSolar Irradiance will vary across Seasons and Latitudes.\nSolar Irradiance will modify the performance of Farms, Open Farms, Solar Panels and Forestation Plants.\nSolar Irradiance can be disabled in mod options.\n \nWind Speed will vary across Seasons and Latitudes\nWind Speed will modify the performance of Wind Turbines.\nWind Speed can be disabled in mod options.\n \nDetailed descriptions of each effect are included in the game's Encyclopedia.\n \nWill you Terraform your way out of the problem?\nWill you find refuge Below and Beyond instead?\nOr will you adapt and endure the Seasons?\n \n[url=https://steamcommunity.com/sharedfiles/filedetails/?id=2588828764]Steam[/url]\n[url=https://mods.paradoxplaza.com/authors/Tremualin]Paradox[/url]\n[url=https://github.com/Tremualin/SurvivingMarsMods]Github[/url]",
    'image', "Preview.jpg",
    'last_changes', "Fixed a harmless UI error",
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
    'version', 8,
    'lua_revision', 1009413,
    'saved_with_revision', 1011166,
    'code', {
        "Code/Color.lua",
        "Code/Seasons.lua",
        "Code/ModOptions.lua",
        "Code/UI.lua",
        "Code/SolarIrradiance.lua",
        "Code/WindSpeed.lua",
        "Code/Encyclopedia.lua",
        "Code/UnitTests.lua",
        "Code/SavegameFixups.lua"
    },
    'has_options', true,
    'saved', 1749436256,
    'screenshot1', "Introduction.jpg",
    'screenshot2', "Summer.jpg",
    'screenshot3', "Autumn.jpg",
    'screenshot4', "ModOptions.jpg",
    'screenshot5', "Colors.jpg",
    'TagGameplay', true,
})
