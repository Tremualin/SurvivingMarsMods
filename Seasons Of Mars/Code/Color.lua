local SeasonsOfMars_Colors = {
    Autumn = {RGB(96, 60, 20), RGB(156, 39, 6), RGB(212, 91, 18), RGB(255, 8, 0)},
    Spring = {const.clrNoModifier},
    Summer = {orange, yellow, white},
    Winter = {RGB(0, 0, 0), RGB(25, 25, 25), RGB(50, 50, 50)};
}

local function ChangeColors(activeSeasonId)
    if IsDlcAvailable("armstrong") then
        CreateGameTimeThread(function()
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

local function DailyChangeColors(sol)
    if SeasonsOfMars.ChangeColors and sol % 5 == 0 then
        ChangeColors(activeSeasonId, false)
    end
end

function OnMsg.SeasonsOfMars_SeasonChange(activeSeasonId)
    if SeasonsOfMars.ChangeColors then
        ChangeColors(activeSeasonId, false)
    end
end

OnMsg.NewDay = DailyChangeColors

function OnMsg.Tremualin_SeasonsOfMars_ColorsDisabled()
    -- Spring is neutral colors
    SeasonsOfMars_ChangeColors("Spring")
end
