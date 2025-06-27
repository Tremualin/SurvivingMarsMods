local functions = Tremualin.Functions
local TraitsByCategory = functions.TraitsByCategory

function OnMsg.ColonistAddTrait(colonist, trait_id, init)
    if IsGameRuleActive("LosingMyReligion") then
        local trait = TraitPresets[trait_id]
        if trait and not init and trait.group == "Negative" then
            local traits_by_category = TraitsByCategory(colonist.traits)
            local positiveTraits = traits_by_category.Positive
            if #positiveTraits > 0 then
                colonist:RemoveTrait(table.rand(positiveTraits))
            end
        end
    end
end

function OnMsg.ClassesPostprocess()
    PlaceObj("GameRules", {
        SortKey = 200000,
        challenge_mod = 40,
        description = Untranslated("Colonists lose a perk anytime they gain a flaw (including becoming Renegades)."),
        display_name = Untranslated("Losing My Religion"),
        flavor = Untranslated("<grey>\"Sometimes I feel like I was born with a leak, and any goodness I started with just slowly spilled out of me, and now it's all gone.\"<newline><right>Bojack Horseman</grey><left>"),
        group = "Default",
        id = "Tremualin_LosingMyReligion"
    })
end
