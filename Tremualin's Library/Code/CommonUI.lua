Tremualin.UIFunctions = {}

local function RemoveXTemplateSections(list, name)
    local idx = table.find(list, name, true)
    if idx then
        list[idx]:delete()
        table.remove(list, idx)
    end
end

Tremualin.UIFunctions.RemoveXTemplateSections = RemoveXTemplateSections
