return PlaceObj('ModDef', {
    'title', "Seasons of Mars (Difficulty Mod)",
    'description', "Martian Seasons aims to fulfill 2 goals: \n- If you have Green Planet; make Terraforming much more important in the early to mid game.\n- If you have Below and Beyond; make Underground colonization and Asteroid mining much more important in the early to mid game.\nYou have a choice to make: Terraform as fast as possible, move your domes into the Underground, or weather the Weather?\n\nSeasons represent actual Martian Seasons, with each Season having unique effects, most of which are no longer relevant after Terraforming. This is a difficulty mod.\n\nThe mod begins with Summer, the moment you enable the mod for the first time.\n\n[b]Seasons[/b]\nSummer(89 sols): Dust Storms and ~Rains~ become 2% longer each sol.\nAutumn(71 sols): Cool-down between Dust Storms, Cold Waves and ~Rains~ (Pure and Toxic) is 2% shorter each sol.\nWinter(77 sols): Cold Waves 1% longer each sol. ~Rain stops~ unless 100% Temperature.\nSpring(97 sols): Everything slowly loses 1% of their additional duration until it returns to their original duration.\n\n[b]Notes[/b] \nI still haven't been able to modify Rains; I will keep trying.\nI will add notifications when each Season starts in an update.\nI'm not sure if this works without Green Planet; let me know in the comments.\nI still don't have the new DLC; but this mod is dealing strictly with Green Planet code, so I think it should work fine.\nNone of the effects are actually based on Science. There isn't much information to go around on Martian Seasons.",
    'image', "Preview.png",
    'last_changes', "Initial version",
    'id', "Tremualin_Seasons_Of_Mars",
    'pops_desktop_uuid', "395c7ade-b619-4528-8ae1-5752cdd09d3b",
    'pops_any_uuid', "a8229293-1d25-41d5-b9da-9b5b0220fb34",
    'author', "Tremualin",
    'version_major', 1,
    'version', 3,
    'lua_revision', 1007000,
    'saved_with_revision', 1007783,
    'dependencies', {
        PlaceObj('ModDependency', {
            'id', "Tremualin_Library",
            'title', "Tremualin's Library",
        }),
    },
    'code', {
        "Code/Seasons.lua",
        "Code/Notifications.lua",
    },
    'saved', 1631164445,
    'TagGameplay', true,
})
