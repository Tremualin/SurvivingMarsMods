Tremualin.UIFunctions = {}

local function RemoveXTemplateSections(list, name)
    local idx = table.find(list, name, true)
    if idx then
        list[idx]:delete()
        table.remove(list, idx)
    end
end

Tremualin.UIFunctions.RemoveXTemplateSections = RemoveXTemplateSections

local Tremualin_Orig_UpdateAttachedSign = UpdateAttachedSign
function UpdateAttachedSign(unit, forceadd)
    local orig = Tremualin_Orig_UpdateAttachedSign(unit, forceadd)
    if IsValid(unit) and unit:IsKindOf("Colonist") then
        unit:ForEachAttach("UnitSign", function(attach) attach:SetScale(200) end)
    end
    return orig
end

local Tremualin_Orig_SelectionArrowAdd = SelectionArrowAdd
function SelectionArrowAdd(obj)
    local orig = Tremualin_Orig_SelectionArrowAdd(obj)
    if IsValid(obj) and obj:IsKindOf("Colonist") then
        obj:ForEachAttach("SelectionArrow", function(attach) attach:SetScale(150) end)
    end
    return orig
end
