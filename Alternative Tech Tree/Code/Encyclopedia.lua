-- Add some helpful entries in the encyclopedia
local function AddEntriesToEncyclopedia()
    PlaceObj('EncyclopediaArticle', {
        SortKey = 10000,
        category_id = "Tremualin",
        group = "Tremualin",
        id = "Alternative Tech Tree",
        text = table.concat({
            Untranslated("Swaps around and adds a few technologies to make the game more interesting"),
            -- TODO: if Improved Underpowered Tech is active, it will grant probes

            Untranslated("<newline>Biotech Techs:"),
            Untranslated("<em>Water Conservation System</em> (buff) has moved to the place of <em>Utility Crops</em> "),
            Untranslated("<em>Utility Crops</em> (buff) has moved to the place of <em>Water Reclamation</em> "),
            Untranslated("<em>Water Reclamation</em> (nerf) has moved to the place of <em>Water Conservation System</em> "),

            Untranslated("<newline>Engineering Techs:"),
            Untranslated("<em>Plasma Cutters</em>  (buff) has swapped places with <em>Sustainable Architecture</em> (nerf)"),

            Untranslated("<newline>Robotics Techs"),
            Untranslated("<em>Large Scale Excavation</em> (buff) has swapped places with <em>Project Mohole</em> (nerf)"),

            Untranslated("<newline>Physics  Techs:"),
            Untranslated("<em>Adapted Probes</em> is automatically researched and removed from the tech tree at the beginning of the game. You can deep scan from the start with any probes you have. Probes you buy before the beginning of the game will still cost the regular price."),
            Untranslated("New Tech: <em>High Altitude Photovoltaics</em>. Provides a halved elevation boost to <em>Solar Panels</em>. Takes the place of <em>Adapted Probes</em>"),
            Untranslated("<em>Dust Repulsion</em> (buff) has swapped places with <em>Low-G Turbines</em> (nerf)"),
            Untranslated("<em>Triboelectric Scrubbing</em> (nerf) now appears at position 18 (right before the wonders)"),

            Untranslated("<newline>Social Techs:"),
            Untranslated("<em>Supportive Community</em> (buff) has swapped places with <em>Productivity Training</em> (nerf)"),
            Untranslated("<em>General Training</em> (buff) has swapped places with <em>Systematic Training</em> (nerf)"),

            Untranslated("<if_all(has_dlc('armstrong'))><newline>Terraforming Techs:</if>"),
            Untranslated("<if_all(has_dlc('armstrong'))>Install my <em>Advanced Terraforming</em> mod, for Terraforming changes</if>"),

            Untranslated("<if_all(has_dlc('picard'))><newline>Recon & Expansion Techs:</if>"),
            Untranslated("<if_all(has_dlc('picard'))>Install my <em>Advanced B&B</em> mod, for Recon & Expansion changes</if>"),

            Untranslated("<newline>This mod works best when combined with my <em>Improved Underpowered Tech</em> mod"),
        }, "<newline>"),
        title_id = "Alternative_Tech_Tree",
        title_text = Untranslated("Alternative Tech Trees"),
    })
end
OnMsg.ClassesPostprocess = AddEntriesToEncyclopedia
