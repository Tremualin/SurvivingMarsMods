-- Whenever a building is constructed after ExtractorAI is researched, make sure it has all work slots disabled
-- And that all work shifts are enabled.
function OnMsg.ConstructionComplete(bld)
    if bld.specialist and bld.specialist == "geologist" and g_ExtractorAIResearched then
        -- Something else interferes with this code, unless executed with a delay
        CreateRealTimeThread(function()
            Sleep(500)
            for i = 1, 3 do
                bld:OpenShift(i)
                bld:ClosePositions(i, 1)
            end
        end)
    end
end

--[[
local LONG_RANGE_EXTRACTORS_ID = "TREMUALIN_LONG_RANGE_EXTRACTORS_ID"
function OnMsg.ClassesPreprocess()
    for _, property in ipairs(BuildingDepositExploiterComponent.properties) do
        if property.id == "exploitation_radius" then
            property.modifiable = true
        end
    end
end
 
--local EXTRACTORS = {MetalsExtractor, PreciousMetalsExtractor, WaterExtractor, AutomaticMicroGExtractor, }
function OnMsg.LoadGame()
    MainCity:SetLabelModifier("ResourceExploiter", LONG_RANGE_EXTRACTORS_ID, Modifier:new({
        prop = "exploitation_radius",
        percent = 100,
        id = LONG_RANGE_EXTRACTORS_ID
    }))
end
]]
