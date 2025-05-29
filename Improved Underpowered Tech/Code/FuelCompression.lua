function ImproveFuelCompression()
    local tech = Presets.TechPreset.Engineering["FuelCompression"]

    local alreadyDefined = false
    for _, effect in pairs(tech) do
        if effect and type(effect) == "table" and effect.IsKindOf and effect:IsKindOf("Effect_ModifyLabel") and effect.Label == "AllRockets" then
            alreadyDefined = true
            break
        end
    end
    if not alreadyDefined then
        -- Fuel Compression allows you to export 10 additional Rare Metals
        table.insert(tech, PlaceObj("Effect_ModifyLabel", {
            Amount = 10,
            Label = "AllRockets",
            Prop = "max_export_storage"
        }))

        tech.description = Untranslated("<em>Rocket</em> Rare Metal Export capacity increased by 10.\n") .. tech.description
    end
end

OnMsg.LoadGame = ImproveFuelCompression
OnMsg.CityStart = ImproveFuelCompression
