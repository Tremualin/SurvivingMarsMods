-- Make sure Colonists look for a job upon finishing their training
function OnMsg.TrainingComplete(building, colonist)
    -- Wait for the colonist to be fired from the training place, then find a job
    CreateRealTimeThread(function()
        Sleep(500)
        colonist:UpdateWorkplace()
    end)
end
