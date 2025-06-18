-- Whenever a building is constructed after ExtractorAI is researched, make sure it has all work slots disabled
-- And that all work shifts are enabled.
function OnMsg.ConstructionComplete(bld)
    if bld.specialist and bld.specialist == "geologist" and g_ExtractorAIResearched then
        -- Something else interferes with this code, unless executed with a delay
        CreateRealTimeThread(function()
            Sleep(100)
            for i = 1, 3 do
                bld:OpenShift(i)
                bld:ClosePositions(i, 1)
            end
        end)
    end
end

