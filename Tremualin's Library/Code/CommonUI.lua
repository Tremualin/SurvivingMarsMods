Tremualin.UIFunctions = {}

local function RemoveXTemplateSections(list, name)
    local idx = table.find(list, name, true)
    if idx then
        list[idx]:delete()
        table.remove(list, idx)
    end
end

local function FindSectionIndexAfterExistingIfPossible(baseSection, existsSectionId)
    for index, section in pairs(baseSection) do
        if section[existsSectionId] then
            return index + 1
        end
    end
    return #baseSection + 1
end

local function FindSectionIndexBeforeExistingIfPossible(baseSection, existsSectionId)
    for index, section in pairs(baseSection) do
        if section[existsSectionId] then
            return index
        end
    end
    return #baseSection + 1
end

Tremualin.UIFunctions.RemoveXTemplateSections = RemoveXTemplateSections
Tremualin.UIFunctions.FindSectionIndexAfterExistingIfPossible = FindSectionIndexAfterExistingIfPossible
Tremualin.UIFunctions.FindSectionIndexBeforeExistingIfPossible = FindSectionIndexBeforeExistingIfPossible

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
