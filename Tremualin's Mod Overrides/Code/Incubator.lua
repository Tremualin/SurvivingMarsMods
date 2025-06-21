local function RemoveFromCityLabels(city, colonist)
    city:RemoveFromLabel(colonist.gender == "OtherGender" and "ColonistOther" or colonist.gender == "Male" and "ColonistMale" or "ColonistFemale", colonist)
    city:RemoveFromLabel("Colonist", colonist)
    city:RemoveFromLabel(colonist.specialist, colonist)
    city:RemoveFromLabel("Homeless", colonist)
    city:RemoveFromLabel("Unemployed", colonist)
    -- Just in case; I added these 2 in a mod
    city:RemoveFromLabel("Senior", colonist)
    city:RemoveFromLabel("Child", colonist)
    local dome = colonist.dome
    if IsValid(dome) then
        dome:RemoveFromLabel("Colonist", colonist)
        dome:RemoveFromLabel("Homeless", colonist)
        dome:RemoveFromLabel("Unemployed", colonist)
    end
    colonist:Affect("StatusEffect_Homeless", false)
    colonist:Affect("StatusEffect_Unemployed", false)
    for trait_id, _ in pairs(colonist.traits) do
        if IsValid(dome) then
            dome:RemoveFromLabel(trait_id, colonist)
        end
    end
end

function Tremualin_FixCityLabels(colonist)
    local mapId = colonist:GetMapID()
    if mapId then
        local city = Cities[mapId]
        for _, other_city in pairs(Cities) do
            if city:GetMapID() ~= other_city:GetMapID() then
                RemoveFromCityLabels(other_city, colonist)
            end
        end
        colonist.city = city
        colonist:AddToLabels()
        local dome = colonist.dome
        colonist.dome = false
        colonist:SetDome(dome)
        if not dome then
            colonist:SetCommand("Abandoned")
        end
    end
end

function OnMsg.ColonistBorn(colonist)
    Tremualin_FixCityLabels(colonist)
end

function SavegameFixups.FixIncubatorWrongCityLabels()
    for _, city in pairs(Cities) do
        local colonists = city.labels.Colonist or {}
        for _, colonist in ipairs(colonists) do
            Tremualin_FixCityLabels(colonist)
        end

        local colonists = city.labels.Homeless or {}
        for _, colonist in ipairs(colonists) do
            Tremualin_FixCityLabels(colonist)
        end
    end
end
