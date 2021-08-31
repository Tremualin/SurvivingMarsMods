return {
    PlaceObj('ModItemCode', {
        'name', "Anxious",
        'FileName', "Code/Anxious.lua",
    }),
    PlaceObj('ModItemCode', {
        'name', "Common",
        'FileName', "Code/Common.lua",
    }),
    PlaceObj('ModItemCode', {
        'name', "Cynical",
        'FileName', "Code/Cynical.lua",
    }),
    PlaceObj('ModItemCode', {
        'name', "Depressed",
        'FileName', "Code/Depressed.lua",
    }),
    PlaceObj('ModItemCode', {
        'name', "EarlyBird_NightOwl",
        'FileName', "Code/EarlyBird_NightOwl.lua",
    }),
    PlaceObj('ModItemCode', {
        'name', "Fickle",
        'FileName', "Code/Fickle.lua",
    }),
    PlaceObj('ModItemCode', {
        'name', "Fixer",
        'FileName', "Code/Fixer.lua",
    }),
    PlaceObj('ModItemCode', {
        'name', "Mentor",
        'FileName', "Code/Mentor.lua",
    }),
    PlaceObj('ModItemCode', {
        'name', "Paranoid",
        'FileName', "Code/Paranoid.lua",
    }),
    PlaceObj('ModItemCode', {
        'name', "Thrifty",
        'FileName', "Code/Thrifty.lua",
    }),
    PlaceObj('ModItemTraitPreset', {
        _incompatible = "Enthusiast",
        category = "other",
        description = T(444564099265, --[[ModItemTraitPreset Cynical description]] "All sanity gains and losses are halved (stacks with Composed) "),
        display_name = T(219804375063, --[[ModItemTraitPreset Cynical display_name]] "Cynical"),
        group = "other",
        id = "Cynical",
        incompatible = {
            Enthusiast = true,
        },
        name = "Cynical",
        weight = 100,
    }),
    PlaceObj('ModItemTraitPreset', {
        _incompatible = "Composed",
        category = "Negative",
        description = T(145718526879, --[[ModItemTraitPreset Anxious description]] "-2 sanity whenever unable to immediately satisfy an interest "),
        display_name = T(568836510722, --[[ModItemTraitPreset Anxious display_name]] "Anxious"),
        group = "Negative",
        id = "Anxious",
        incompatible = {
            Composed = true,
        },
        name = "Anxious",
    }),
    PlaceObj('ModItemTraitPreset', {
        _incompatible = "Listener",
        category = "Negative",
        daily_update_func =
        function (colonist, trait)
            local filter_function = function(another, same) return another.traits.Argumentative end
            local victims = Tremualin.Functions.FindAllOtherColonistsInSameResidence(colonist, filter_function)

            if #victims > 0 then
                local victim = table.rand(victims)
                victim:ChangeSanity(-5 * const.Scale.Stat, "Me, wrong? Never. (Argumentative) ")
                colonist:ChangeSanity(-5 * const.Scale.Stat, "Me, wrong? Never. (Argumentative) ")
            end
        end,
        description = T(480159664894, --[[ModItemTraitPreset Argumentative description]] "Both this and another argumentative colonist in the same residence will lose 5 sanity each day. "),
        display_name = T(473503548526, --[[ModItemTraitPreset Argumentative display_name]] "Argumentative"),
        group = "Negative",
        id = "Argumentative",
        incompatible = {
            Listener = true,
        },
        initial_filter = true,
        name = "Argumentative",
        sanatorium_trait = true,
    }),
    PlaceObj('ModItemTraitPreset', {
        _incompatible = "Composed",
        category = "other",
        daily_update_func =
        function (colonist, trait)
            local filter_function = function(another, same) return not another.traits.Child end
            local victims = Tremualin.Functions.FindAllOtherColonistsInSameResidence(colonist, filter_function)

            if #victims > 0 then
                for i = 1, 3 do
                    local victim = table.rand(victims)
                    if victim:GetHealth() > 30 then
                        victim:ChangeHealth(-10 * const.Scale.Stat, "Fought with a Brawler ")
                        victim:ChangeSanity(5 * const.Scale.Stat, "Adrenaline rush (fought a Brawler) ")
                        colonist:ChangeHealth(-10 * const.Scale.Stat, "Fought with another colonist (Brawler) ")
                        colonist:ChangeSanity(5 * const.Scale.Stat, "Adrenaline rush (Brawler) ")
                        break
                    end
                end
            end
        end,
        description = T(751189543735, --[[ModItemTraitPreset Brawler description]] "Once a day, if healthy, this an another healthy non-child will both lose 10 health; then both colonists regain 5 sanity. "),
        display_name = T(787206239319, --[[ModItemTraitPreset Brawler display_name]] "Brawler"),
        group = "other",
        id = "Brawler",
        incompatible = {
            Composed = true,
        },
        name = "Brawler",
    }),
    PlaceObj('ModItemTraitPreset', {
        _incompatible = "Renegade",
        category = "Negative",
        daily_update_func =
        function (colonist, trait)
            if not colonist.workplace or not IsKindOf(colonist.workplace, "Sanatorium") then
                -- Chances of committing suicide
                if not colonist.traits.Religious and colonist:Random(100) < g_Consts.LowSanitySuicideChance then
                    colonist:SetCommand("Suicide")
                end
                -- Chances of developing flaws
                if colonist:Random(100) < g_Consts.LowSanityNegativeTraitChance then
                    local compatible = (FilterCompatibleTraitsWith(const.SanityBreakdownTraits, colonist.traits))
                    if 0 < #compatible then
                        colonist:AddTrait(table.rand(compatible))
                    end
                end
            end
            -- High chances of losing interest in daily activities
            if colonist:Random(80) < 100 then
                colonist.daily_interest = ""
            end
        end,
        description = T(654217586731, --[[ModItemTraitPreset Depressed description]] "Morale is set to 0. 80% chance of losing daily interest. Chance for suicide and new flaws every day unless assigned to a Sanatorium. -Social"),
        display_icon = "",
        display_name = T(744529179578, --[[ModItemTraitPreset Depressed display_name]] "Depressed"),
        group = "Negative",
        id = "Depressed",
        incompatible = {
            Renegade = true,
        },
        initial_filter = true,
        name = "Depressed",
        remove_interest = "interestSocial",
        sanatorium_trait = true,
        weight = 50,
    }),
    PlaceObj('ModItemTraitPreset', {
        _incompatible = "NightOwl",
        category = "other",
        daily_update_func =
        function (colonist, trait)
            Tremualin_SwitchWithDesiredWorkshift(colonist, 1, trait)
        end,
        description = T(135341313645, --[[ModItemTraitPreset EarlyBird description]] "Gains/loses comfort when working the morning/night. Will try to switch jobs with someone in the Morning Shift."),
        display_icon = "",
        display_name = T(430948295700, --[[ModItemTraitPreset EarlyBird display_name]] "Early Bird"),
        group = "other",
        id = "EarlyBird",
        incompatible = {
            NightOwl = true,
        },
        name = "EarlyBird",
        weight = 100,
    }),
    PlaceObj('ModItemTraitPreset', {
        __copy_group = "Positive",
        _incompatible = "Religious",
        category = "Positive",
        description = T(248606183601, --[[ModItemTraitPreset Fickle description]] "Alternates between different interests until it can satisfy one or goes to sleep."),
        display_name = T(562811521981, --[[ModItemTraitPreset Fickle display_name]] "Fickle"),
        group = "Positive",
        id = "Fickle",
        incompatible = {
            Religious = true,
        },
        name = "Fickle",
        weight = 100,
    }),
    PlaceObj('ModItemTraitPreset', {
        _incompatible = "Idiot",
        category = "Positive",
        description = T(385525620058, --[[ModItemTraitPreset Fixer description]] "Reduces the maintenance of any building it visits by 5%. "),
        display_name = T(487457715140, --[[ModItemTraitPreset Fixer display_name]] "Fixer"),
        group = "Positive",
        id = "Fixer",
        incompatible = {
            Idiot = true,
        },
        name = "Fixer",
        school_trait = true,
        weight = 100,
    }),
    PlaceObj('ModItemTraitPreset', {
        _incompatible = "Mean",
        category = "Positive",
        daily_update_func =
        function (colonist, trait)
            local victims = Tremualin.Functions.FindAllOtherColonistsInSameResidence(colonist)

            if #victims > 0 then
                local victim = table.rand(victims)
                victim:ChangeSanity(5 * const.Scale.Stat, "Someone was kind to me ")
            end
        end,
        description = T(435767739758, --[[ModItemTraitPreset Kind description]] "A random colonist in the same residence gets +5 Sanity. "),
        display_name = T(540302319362, --[[ModItemTraitPreset Kind display_name]] "Kind"),
        group = "Positive",
        id = "Kind",
        incompatible = {
            Mean = true,
        },
        name = "Kind",
    }),
    PlaceObj('ModItemTraitPreset', {
        _incompatible = "Argumentative",
        category = "other",
        daily_update_func =
        function (colonist, trait)
            local colonist_with_lowest_sanity = nil
            local residence = colonist.residence
            if residence and residence.colonists then
                for i = #residence.colonists, 1, -1 do
                    local victim = residence.colonists[i]
                    if IsValid(victim) and victim ~= colonist then
                        if not colonist_with_lowest_sanity then
                            colonist_with_lowest_sanity = victim
                        end
                        if colonist_with_lowest_sanity.stat_sanity > victim.stat_sanity then
                            colonist_with_lowest_sanity = victim
                        end
                    end
                end
            end
            if colonist_with_lowest_sanity then
                colonist_with_lowest_sanity:ChangeSanity(5 * const.Scale.Stat, "Someone listened to my woes ")
                colonist:ChangeSanity(-4 * const.Scale.Stat, "It ain't easy being a good listener ")
            end
        end,
        description = T(810886541611, --[[ModItemTraitPreset Listener description]] "The colonist with the lowest sanity in the residence gets +10 sanity. But this colonist will lose 5 sanity. "),
        display_name = T(936788763981, --[[ModItemTraitPreset Listener display_name]] "Listener"),
        group = "other",
        id = "Listener",
        incompatible = {
            Argumentative = true,
        },
        name = "Listener",
    }),
    PlaceObj('ModItemTraitPreset', {
        _incompatible = "Kind",
        category = "Negative",
        daily_update_func =
        function (colonist, trait)
            local victims = Tremualin.Functions.FindAllOtherColonistsInSameResidence(colonist)

            if #victims > 0 then
                local victim = table.rand(victims)
                victim:ChangeSanity(-5 * const.Scale.Stat, "Another colonist was mean to me ")
            end
        end,
        description = T(692728959809, --[[ModItemTraitPreset Mean description]] "-5 sanity to another random colonist in the dome"),
        display_name = T(306220161089, --[[ModItemTraitPreset Mean display_name]] "Mean"),
        group = "Negative",
        id = "Mean",
        incompatible = {
            Kind = true,
        },
        initial_filter = true,
        name = "Mean",
        sanatorium_trait = true,
    }),
    PlaceObj('ModItemTraitPreset', {
        __copy_group = "Positive",
        _incompatible = "Introvert",
        category = "Positive",
        description = T(570630308235, --[[ModItemTraitPreset Mentor description]] "Coworkers gain +20 performance and a moderate chance of losing the Idiot flaw; unless the Mentor is also an Idiot."),
        display_name = T(365414621943, --[[ModItemTraitPreset Mentor display_name]] "Mentor"),
        group = "Positive",
        id = "Mentor",
        incompatible = {
            Introvert = true,
        },
        name = "Mentor",
        school_trait = true,
        weight = 100,
    }),
    PlaceObj('ModItemTraitPreset', {
        _incompatible = "EarlyBird",
        category = "other",
        daily_update_func =
        function (colonist, trait)
            Tremualin_SwitchWithDesiredWorkshift(colonist, 1, trait)
        end,
        description = T(765493344095, --[[ModItemTraitPreset NightOwl description]] "Gains/loses comfort when working the night/morning. Regains sanity lost from Night Shifts. Will try to switch jobs with someone on the Night Shift"),
        display_name = T(123528136563, --[[ModItemTraitPreset NightOwl display_name]] "Night Owl"),
        group = "other",
        id = "NightOwl",
        incompatible = {
            EarlyBird = true,
        },
        name = "NightOwl",
        weight = 100,
    }),
    PlaceObj('ModItemTraitPreset', {
        _incompatible = "Composed",
        category = "Negative",
        description = T(118077551271, --[[ModItemTraitPreset Paranoid description]] "-3 sanity when moving to a new location in or out of the Dome"),
        display_icon = "",
        display_name = T(179422768941, --[[ModItemTraitPreset Paranoid display_name]] "Paranoid"),
        group = "Negative",
        id = "Paranoid",
        incompatible = {
            Composed = true,
        },
        name = "Paranoid",
        sanatorium_trait = true,
        weight = 100,
    }),
    PlaceObj('ModItemTraitPreset', {
        _incompatible = "Lazy",
        category = "Positive",
        description = T(682642468760, --[[ModItemTraitPreset Thrifty description]] "Reduces the amount of resources consumed by the workplace by 5%. If the building consumes no resources, then it will reduce the consumption of electricity instead."),
        display_icon = "",
        display_name = T(207956885932, --[[ModItemTraitPreset Thrifty display_name]] "Thrifty"),
        group = "Positive",
        id = "Thrifty",
        incompatible = {
            Lazy = true,
        },
        name = "Thrifty",
        school_trait = true,
        weight = 100,
    }),
}
