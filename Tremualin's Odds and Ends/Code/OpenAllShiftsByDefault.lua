-- Enable all shifts for all buildings, regardless of what the game thinks
function OnMsg.ClassesPreprocess()
    local buildingTemplates = BuildingTemplates
    for id, bt in pairs(buildingTemplates) do
        if bt.enabled_shift_1 or bt.enabled_shift_2 or bt.enabled_shift_3 then
            bt.enabled_shift_1 = true
            bt.enabled_shift_2 = true
            bt.enabled_shift_3 = true
        end
    end -- for id, buildingTemplate
end -- function OnMsg.ClassesPostprocess
