local function FixCity(colonist)
    if colonist.city:GetMapID() ~= colonist:GetMapID() then
        colonist:RemoveFromLabels()
        colonist.city = Cities[colonist:GetMapID()]
        colonist:AddToLabels()
    end
end

function OnMsg.ColonistBorn(colonist)
    FixCity(colonist)
end

function SavegameFixups.FixIncubatorWrongCity()
    local colonists = UIColony.city_labels.labels.Colonist or {}
    for _, colonist in ipairs(colonists) do
        FixCity(colonist)
    end
end
