-- Add some helpful entries in the encyclopedia
local function AddEntriesToEncyclopedia()
    PlaceObj('EncyclopediaArticle', {
        SortKey = 10001,
        category_id = "Tremualin",
        group = "Tremualin",
        id = "Improved Underpowered Tech",
        text = table.concat({
            Untranslated("Improves a few technologies to make the game more interesting"),
            Untranslated("<newline>"),
            Untranslated("<em>+</em> means the effect is in addition to the original effect"),
            Untranslated("<em>~</em> means the effect has replaced the original effect"),
            Untranslated("<newline>"),
            Untranslated("<em>Adapted Probes</em>: + Immediately gain 3-5 probes upon research."),
            Untranslated("<em>Dust Repulsion</em>: ~ Solar panels (and special ones) no longer require maintenance."),
            Untranslated("<em>Fuel Compression</em>: + Rocket Rare Metal Export capacity increased by 10."),
            Untranslated("<em>Live From Mars</em>: + Gain applicants for every new technology or milestone you get (1 per 500 research, rounded up, min 2)"),
            Untranslated("<em>Martian Festivals</em>: ~ All services gain an additional 10 comfort (not just parks)"),
            Untranslated("<em>Resilient Architecture</em>: + Salvaging now yields back the full cost of the the building."),
            Untranslated("<em>Supportive Community</em>: + Renegade generation takes 50 % more time."),

            Untranslated("<newline>"),
            Untranslated("This mod works best when combined with <em>Alternative Tech Tree</em>"),
            Untranslated("Also checkout my <em>Advanced Terraforming</em> and <em>Advanced B&B</em> mods for DLC improvements"),

        }, "<newline>"),
        title_id = "Improved_Underpowered_Tech",
        title_text = Untranslated("Improved Underpowered Tech"),
    })
end
OnMsg.ClassesPostprocess = AddEntriesToEncyclopedia
