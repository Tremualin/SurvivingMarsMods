-- Inspired by Choggi's Notification Disable mod

local lookup_disable = {}

local function SkipNot(func, id, ...)
    local preset = OnScreenNotificationPresets[id]
    if preset and preset.group == "GreenMars" then
        if not lookup_disable[id] then
            local result = func(id, ...)
            lookup_disable[id] = true
            return result
        end
    end
end

local Orig_Tremualin_AddOnScreenNotification = AddOnScreenNotification
function AddOnScreenNotification(id, ...)
    return SkipNot(Orig_Tremualin_AddOnScreenNotification, id, ...)
end

local Orig_Tremualin_AddCustomOnScreenNotification = AddCustomOnScreenNotification
function AddCustomOnScreenNotification(id, ...)
    return SkipNot(Orig_Tremualin_AddCustomOnScreenNotification, id, ...)
end
