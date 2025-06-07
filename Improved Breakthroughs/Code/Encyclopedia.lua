
-- Add some helpful entries in the encyclopedia
local function AddEntriesToEncyclopedia()
    PlaceObj('EncyclopediaArticle', {
        SortKey = 20000,
        category_id = "Tremualin",
        group = "Tremualin",
        id = "Improved Breakthroughs",
        text = table.concat({
            Untranslated("<em>Alien Imprints</em> always spawns 10 anomalies (30% research discount)"),
            Untranslated("<em>Dome Streamlining</em> now provides a 50% discount to all resources (even Polymers and Exotic Minerals) "),
            Untranslated("<em>Advanced Drone Drive</em>, <em>Artificial Muscles</em> and <em>Wireless Power</em> will now unlock each other if you get any of them"),
            Untranslated("<em>Good Vibrations</em> now increases birth rate by 20 for each Colonist"),
            Untranslated("<em>Hive Mind</em> reworked. Applies to all residences. Provides +1 performance for all unique traits (age, gender, perks, quirks, specializations) in the same residence, but -2 performance for each unique flaw."),
            Untranslated("<em>Martian Steel</em> metals discount increased to 33%"),
            Untranslated("<em>Neo Concrete</em> reworked. Provides a 33% concrete discount to all buildings."),
            Untranslated("<em>Nocturnal Adaptation</em> disables night shift sanity loss."),
            Untranslated("<em>Plasma Rocket</em> now correctly reduces travel time when playing with the Long Ride rule (Russia still slow). Also provides a 20 fuel discount."),
            Untranslated("<em>Space Rehabilitation</em> now always removes one flaw (100% success). Also, Tourists pay 50% more funding during their visits."),
            Untranslated("<em>Superfungus</em> now provides 100% more production at 50% more Oxygen (if you don't have B&B)"),
            Untranslated("<em>Superior Pipes</em> and <em>Superior Cables</em> will now unlock each other if you get any of them"),
            -- TODO: Landscaping and Construction nanites should unlock each other
            -- TOOD: redo Vocation Oriented Society
            -- TOOD: redo Martian Ingenuity Oriented Society to give bonuses as people age
            -- TODO: Core Metals, Core Rare Metals and Core Water all unlock each other
            -- TODO: Boost Hull Polarization to 33%
            -- TODO: Multispiral Architecture and Gem Architecture now unlock each other
            -- TODO: Prefab Compression now provides a discount to all prefabs
            -- TODO: Ancient Terraforming Device now provides 0.5% per sol to all Terraforming Parameters
            -- TODO: Cargobay of holding and Vehicle Weight Optimizations unlock each other
            -- TODO: Dry Farming and Resilient Vegetation are unlocked together
        }, "<newline>"),
        title_id = "ImprovedBreakthroughs",
        title_text = Untranslated("Improved Breakthroughs"),
    })
end
OnMsg.ClassesPostprocess = AddEntriesToEncyclopedia
