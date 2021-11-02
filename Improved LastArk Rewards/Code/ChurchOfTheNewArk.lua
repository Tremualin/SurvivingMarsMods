local function BabySaints()
    local sponsor = GetMissionSponsor()
    if sponsor.id == "NewArk" then
        sponsor.reward_effect_3 = PlaceObj('SpawnColonist', {
            'Count', 3,
            'Trait1', "Martianborn",
            'Trait2', "Saint",
            'Age', "Child"
        })
    end
end

OnMsg.LoadGame = BabySaints
OnMsg.NewGame = BabySaints
