function OnMsg.ClassesPostprocess()
    PlaceObj("GameRules", {
        SortKey = 200001,
        challenge_mod = 50,
        description = Untranslated("Colonists stats are green if above 90(rather than 70) and low if below 50(rather than 30)"),
        display_name = Untranslated("Royals"),
        flavor = Untranslated("<grey>\"Cristal, Maybach, diamonds on your timepiece. Jet planes, islands, tiger's on a gold leash\"<newline><right>Lorde</grey><left>"),
        group = "Default",
        id = "Tremualin_Royals",
        PlaceObj("Effect_ModifyLabel", {
            Label = "Consts",
            Amount = 20000,
            Prop = "LowStatLevel"
        }),
        PlaceObj("Effect_ModifyLabel", {
            Label = "Consts",
            Amount = 20000,
            Prop = "HighStatLevel"
        }),
    })
end

