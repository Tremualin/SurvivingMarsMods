TremualinUI = {}
TremualinUI.Debugging = {}
TremualinUI.Functions = {}

local function RemoveXTemplateSections(list, name)
    local idx = table.find(list, name, true)
    if idx then
        list[idx]:delete()
        table.remove(list, idx)
    end
end

TremualinUI.Functions.RemoveXTemplateSections = RemoveXTemplateSections
