local function ImproveSupportiveCommunity()
    local tech = Presets.TechPreset.Social["SupportiveCommunity"]
    local modified = tech.Tremualin_ImprovedSupportiveCommunity
    if not modified then
        tech.description = Untranslated('<em>Renegade</em> generation takes 50% more time\n') .. tech.description

        -- Increases points necessary to become a Renegade by 50%
        table.insert(tech, #tech + 1, PlaceObj('Effect_ModifyLabel', {
            Label = "Consts",
            Percent = 50,
            Prop = "RenegadeCreation",
        }))

        -- Increases points necessary to become a Renegade (with RebelYell on) by 50%
        table.insert(tech, #tech + 1, PlaceObj('Effect_ModifyLabel', {
            Label = "Consts",
            Percent = 50,
            Prop = "GameRuleRebelYellRenegadeCreation",
        }))

        tech.Tremualin_ImprovedSupportiveCommunity = true
    end
end

OnMsg.LoadGame = ImproveSupportiveCommunity
OnMsg.CityStart = ImproveSupportiveCommunity
