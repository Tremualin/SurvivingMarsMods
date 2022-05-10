SeasonsOfMars_Colors = {
    Autumn = {RGB(96, 60, 20), RGB(156, 39, 6), RGB(212, 91, 18), RGB (230, 0, 126), RGB(255, 8, 0)},
    Spring = {const.clrNoModifier},
    Summer = {orange, yellow, white},
    Winter = {RGB(0, 0, 0), RGB(25, 25, 25), RGB(50, 50, 50)};
}

function SeasonsOfMars_ChangeColors(activeSeasonId, override)
    if SeasonsOfMars.ChangeColors or override then
        CreateRealTimeThread(function()
            if SeasonsOfMars_Colors[activeSeasonId] then
                GetRealm(MainCity):MapForEach("map", "VegetationBillboardObject", function(obj)
                    local color = table.rand(SeasonsOfMars_Colors[activeSeasonId])
                    obj:SetColorModifier(color)
                end)
                GetRealm(MainCity):MapForEach("map", "VegetationGrass_01", function(obj)
                    local color = table.rand(SeasonsOfMars_Colors[activeSeasonId])
                    obj:SetColorModifier(color)
                end)
                GetRealm(MainCity):MapForEach("map", "VegetationGrass_02", function(obj)
                    local color = table.rand(SeasonsOfMars_Colors[activeSeasonId])
                    obj:SetColorModifier(color)
                end)
            end
        end)
    end
end

function OnMsg.SeasonsOfMars_SeasonChange(activeSeasonId)
    SeasonsOfMars_ChangeColors(activeSeasonId, false)
end
