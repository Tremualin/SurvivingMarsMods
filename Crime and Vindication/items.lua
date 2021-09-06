return {
    PlaceObj('ModItemCode', {
        'name', "Crime",
        'FileName', "Code/Crime.lua",
    }),
    PlaceObj('ModItemCode', {
        'name', "CrimeUI",
        'FileName', "Code/CrimeUI.lua",
    }),
    PlaceObj('ModItemCode', {
        'name', "DomesticViolence",
        'FileName', "Code/DomesticViolence.lua",
    }),
    PlaceObj('ModItemCode', {
        'name', "FirstResponders",
        'FileName', "Code/FirstResponders.lua",
    }),
    PlaceObj('ModItemCode', {
        'name', "Notifications",
        'FileName', "Code/Notifications.lua",
    }),
    PlaceObj('ModItemCode', {
        'name', "OffDutyHeros",
        'FileName', "Code/OffDutyHeroes.lua",
    }),
    PlaceObj('ModItemCode', {
        'name', "Rehabilitation",
        'FileName', "Code/Rehabilitation.lua",
    }),
    PlaceObj('ModItemCode', {
        'name', "RehabilitationUI",
        'FileName', "Code/RehabilitationUI.lua",
    }),
    PlaceObj('ModItemCode', {
        'name', "UnitTests",
        'FileName', "Code/UnitTests.lua",
    }),
    PlaceObj('ModItemTraitPreset', {
        __copy_group = "",
        _incompatible = "Renegade",
        category = "Positive",
        description = T(598838342649, --[[ModItemTraitPreset Vindicated description]] "Vindicated Renegades will no longer become Renegades and will gain (+20) additional performance on all jobs"),
        display_icon = "",
        display_name = T(520259899232, --[[ModItemTraitPreset Vindicated display_name]] "Vindicated"),
        dome_filter_only = true,
        group = "Positive",
        id = "Vindicated",
        incompatible = {
            Renegade = true,
            Violent = true,
        },
        modify_amount = 20,
        modify_property = "performance",
        modify_target = "self",
        name = "Vindicated",
        weight = 0,
    }),
    PlaceObj('ModItemTraitPreset', {
        _incompatible = "Composed,Vindicated",
        category = "Negative",
        description = T(635612439152, --[[ModItemTraitPreset Violent description]] "Violent people will resort to domestic violence more often, and their victims will be more scared to talk about it. Violent people cannot be Vindicated. Can be obtained via sanity breakdown or by being the victim of domestic violence."),
        display_icon = "",
        display_name = T(151354650363, --[[ModItemTraitPreset Violent display_name]] "Violent"),
        group = "Negative",
        id = "Violent",
        incompatible = {
            Composed = true,
            Vindicated = true,
        },
        initial_filter = true,
        name = "Violent",
        sanatorium_trait = true,
        weight = 100,
    }),
}
