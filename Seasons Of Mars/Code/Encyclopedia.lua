-- Add some helpful entries in the encyclopedia
local function AddEntriesToEncyclopedia()
    PlaceObj('EncyclopediaArticle', {
        SortKey = 10000,
        category_id = "Tremualin",
        group = "Tremualin",
        id = "Seasons of Mars - Welcome",
        text = table.concat({
            Untranslated("<white>Seasons of Mars</white> extends <em>Surviving Mars</em> with new seasonal effects and game mechanics to make the game more interesting."),
            Untranslated("<em>Vegetation</em> will change colors as <white>Seasons</white> change"),
            Untranslated("<em>Solar Irradiance</em> will vary across <white>Seasons</white> and <white>Latitudes</white>"),
            Untranslated("<em>Dust Storms</em> will be longer on some <white>Seasons</white> and more frequent on others"),
            Untranslated("<em>Cold Waves</em> will be longer on some <white>Seasons</white> and more frequent on others"),
            Untranslated("<em>Northern</em> and <em>Southern</em> colonies will play differently from each other"),
            Untranslated("< newline >"),
            Untranslated("Will you Terraform your way out of the problem?"),
            Untranslated("Will you find refuge Below and Beyond instead?"),
            Untranslated("Or will you power through and survive until the next Season?"),
        }, "< newline >"),
        title_id = "SeasonsofMarsWelcome",
        title_text = Untranslated("Seasons of Mars - Welcome"),
    })

    PlaceObj('EncyclopediaArticle', {
        SortKey = 10001,
        category_id = "Tremualin",
        group = "Tremualin",
        id = "Seasons of Mars - Colors",
        text = table.concat({
            Untranslated("<em>Vegetation</em> changes colors at the beginning of each new season"),
            Untranslated("<em>Vegetation</em> doesn't change retroactively new vegetation until the next season (for performance reasons)"),
            Untranslated("< newline >"),
            Untranslated("If you have an extreme amount of vegetation and a slow CPU, you could experience some lag at the beginning of a new season"),
            Untranslated("If this becomes a problem, you can set ChangeColors to False in ModOptions"),
        }, "< newline >"),
        title_id = "SeasonsofMarsVegetation",
        title_text = Untranslated("Seasons of Mars - Colors"),
    })

    PlaceObj('EncyclopediaArticle', {
        SortKey = 10001,
        category_id = "Tremualin",
        group = "Tremualin",
        id = "Seasons of Mars - Solar Irradiance",
        text = table.concat({
            Untranslated("<em>Solar Irradiance</em> is the power per unit area (surface power density) received from the sun in the form of electromagnetic radiation. In simpler terms, it's how much solar power is shining down on a specific area at a given time. "),
            Untranslated("< newline >"),
            Untranslated("<em>Solar Irradiance</em> can increase or decrease the performance of <em>Farms</em> (half effect)"),
            Untranslated("<em>Solar Irradiance</em> can increase or decrease the performance of <em>Solar Panels</em> (full effect)"),
            Untranslated("<em>Solar Irradiance</em> can increase or decrease the performance of <em>Forestation Plants</em> (half effect)"),
            --Untranslated("<em>Solar Irradiance</em> can increase or decrease <em>Sanity</em> gained from <em>Sleep</em>"),
            Untranslated("Due to implementation issues, <em>Solar Irradiance</em> won't modify the performance of <em>Open Farms</em>"),
            Untranslated("< newline >"),
            Untranslated("<em>Solar Irradiance</em> changes gradually with the seasons"),
            Untranslated("<em>Solar Irradiance</em> trend is different in Spring&Summer than in Autumn&Winter"),
            Untranslated("<em>Solar Irradiance</em> trend, min and max, is unique for each latitude"),
            Untranslated("< newline >"),
            Untranslated("<em>Solar Irradiance</em> is stronger and more stable at the equator"),
            Untranslated("<em>Solar Irradiance</em> varies the most during seasons the further you are from the equator"),
            Untranslated("< newline >"),
            Untranslated("<em>Solar Irradiance</em> can be disabled in ModOptions"),
            Untranslated("< newline >"),
            Untranslated("<em>Solar Irradiance</em> math based is on graphs found on Reddit:"),
            Untranslated("https://www.reddit.com/r/Colonizemars/comments/5gj2st/i_simulated_solar_irradiance_on_mars_at_various/"),
            Untranslated("And then approximated to the closest sinusoidal functions"),
        }, "< newline >"),
        title_id = "SeasonsofMarsSolarIrradiance",
        title_text = Untranslated("Seasons of Mars - Solar Irradiance"),
    })

    PlaceObj('EncyclopediaArticle', {
        SortKey = 10001,
        category_id = "Tremualin",
        group = "Tremualin",
        id = "Seasons of Mars - Seasons",
        text = table.concat({
            Untranslated("Seasons on Mars are affected by both the planet's tilt and its distance from the Sun, leading to variations in length and intensity. Winters in the southern hemisphere are long and cold while those in the north are short and relatively warm in comparison. The duration and intensity is therefore different for each hemisphere.< newline >"),
            Untranslated("Seasons duration is based on real Martian season duration."),
            Untranslated("Seasons duration can be modified in ModOptions"),
            Untranslated("Seasons difficulty (duration, frequency) can be modified in ModOptions"),
            Untranslated("< newline >"),
            Untranslated("<white>Seasons on the Southern hemisphere</white><newline>"),
            Untranslated("<em>Spring</em>: <em>Dust Storms</em> become longer each sol. <em>Cold Waves</em> slowly normalize. <em>Solar Irradiance</em> grows."),
            Untranslated("<em>Summer</em>: <em>Dust Storms</em> appear faster each sol. <em>Cold Waves</em> normalize. <em>Solar Irradiance</em> grows to its highest point, then shrinks."),
            Untranslated("<em>Autumn</em>: <em>Cold Waves</em> become longer each sol. <em>Dust Storms</em> slowly normalize. <em>Solar Irradiance</em> shrinks."),
            Untranslated("<em>Winter</em>: <em>Cold Waves</em> appear faster each sol. <em>Dust Storms</em> are normal. <em>Solar Irradiance</em> shrinks to its lowest point then begins to grow."),
            Untranslated("< newline >"),
            Untranslated("<white>Seasons on the Northern hemisphere</white><newline>"),
            Untranslated("<em>Spring</em>: <em>Dust Storms</em> and <em>Cold Waves</em> normalize.. <em>Solar Irradiance</em> grows."),
            Untranslated("<em>Summer</em>: <em>Dust Storms</em> and <em>Cold Waves</em> normalize. <em>Solar Irradiance</em> grows to its highest point, then shrinks."),
            Untranslated("<em>Autumn</em>: <em>Dust Storms</em> and <em>Cold Waves</em> become longer each sol. <em>Solar Irradiance</em> shrinks."),
            Untranslated("<em>Winter</em>: <em>Dust Storms</em> and <em>Cold Waves</em> appear faster each sol. <em>Solar Irradiance</em> shrinks to its lowest point then begins to grow."),

        }, "< newline >"),
        title_id = "SeasonsofMarsSeasons",
        title_text = Untranslated("Seasons of Mars - Seasons"),
    })
end
OnMsg.ClassesPostprocess = AddEntriesToEncyclopedia
