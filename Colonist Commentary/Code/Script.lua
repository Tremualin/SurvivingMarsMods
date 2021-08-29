DefineClass.OnScreenNotificationsDlg_Right = {
  __parents = {"OnScreenNotificationsDlg"},
  HAlign = "right",
}

GlobalVar("g_ActiveOnScreenNotifications", {})
GlobalVar("g_ShownOnScreenNotifications", {})
function AddOnScreenNotification_Right(id, callback, params, cycle_objs)
  params = params or {}
  local preset
  if params.popup_notification then
    local title = params.title or ""
    local text = params.text or ""
    local preset_name = params.preset or ""
    local title_id = IsT(title) and TGetID(title)
    local text_id = IsT(text) and TGetID(text)
    local notification_id = params.id or preset_name ~= "" and preset_name or (title_id or text_id) and tostring(title_id) .. tostring(text_id) or text ~= "" and Encode16(SHA256(text)) or title ~= "" and Encode16(SHA256(title)) or ""
    id = "popup" .. notification_id
    preset = (OnScreenNotificationPreset:new({
      title = title,
      text = T(10918, "View Message"),
      dismissable = false,
      popup_preset = params.id,
      id = id,
      close_on_read = true,
      priority = params.minimized_notification_priority or "Critical",
      ShowVignette = true,
      VignetteImage = "UI/Onscreen/onscreen_gradient_red.tga",
      VignettePulseDuration = 2000
    }))
  else
    preset = OnScreenNotificationPresets[params.preset_id or id]
    params.preset_id = params.preset_id or id
    id = params.override_id or id
  end
  if not preset then
    return
  end
  if preset.show_once and g_ShownOnScreenNotifications[id] then
    return
  end
  local entry = (pack_params(id, callback, params, cycle_objs))
  local idx = table.find(g_ActiveOnScreenNotifications, 1, id) or #g_ActiveOnScreenNotifications + 1
  g_ActiveOnScreenNotifications[idx] = entry
  local dlg = (GetDialog("OnScreenNotificationsDlg_Right"))
  if not dlg then
    if not GetInGameInterface() then
      return
    end
    dlg = (OpenDialog("OnScreenNotificationsDlg_Right", GetInGameInterface()))
  end
  dlg:AddNotification(id, preset, callback, params, cycle_objs)
  g_ShownOnScreenNotifications[id] = true
  if preset.fx_action ~= "" then
    PlayFX(preset.fx_action)
  end
  return id
end
function AddCustomOnScreenNotification_Right(id, title, text, image, callback, params)
  params = params or {}
  local cycle_objs = params.cycle_objs
  local entry = (pack_params(id, callback, params, cycle_objs))
  local data = {
    id = id,
    name = id,
    title = title,
    text = text,
    image = image
  }
  table.set_defaults(data, params)
  setmetatable(data, OnScreenNotificationPreset)
  entry.custom_preset = data
  local idx = table.find(g_ActiveOnScreenNotifications, 1, id) or #g_ActiveOnScreenNotifications + 1
  g_ActiveOnScreenNotifications[idx] = entry
  local dlg = (GetDialog("OnScreenNotificationsDlg_Right"))
  if not dlg then
    if not GetInGameInterface() then
      return
    end
    dlg = (OpenDialog("OnScreenNotificationsDlg_Right", GetInGameInterface()))
  end
  dlg:AddCustomNotification(data, callback, params, cycle_objs)
  g_ShownOnScreenNotifications[id] = true
  if type(params.fx_action) == "string" and params.fx_action ~= "" then
    PlayFX(params.fx_action)
  end
end

function RemoveOnScreenNotification(id)
  local dlg1 = GetDialog("OnScreenNotificationsDlg_Right")
  if dlg1 then
    dlg1:RemoveNotificationFromDlg(id)
  end
  local dlg2 = GetDialog("OnScreenNotificationsDlg")
  if dlg2 then
    dlg2:RemoveNotificationFromDlg(id)
  end
  if dlg1 then 
    dlg1:RemoveNotificationFromTable(id)
  end
  if dlg2 then 
    dlg1:RemoveNotificationFromTable(id)
  end
end
function PressOnScreenNotification(id)
  local dlg = GetDialog("OnScreenNotificationsDlg")
  if dlg then
    dlg:PressNotification(id)
  end
  dlg = GetDialog("OnScreenNotificationsDlg_Right")
  if dlg then
    dlg:PressNotification(id)
  end
end
function IsOnScreenNotificationShown(id)
  local dlg = GetDialog("OnScreenNotificationsDlg")
  local dlg2 = GetDialog("OnScreenNotificationsDlg_Right")
  return (dlg and dlg:IsActive(id)) or (dlg2 and dlg2:IsActive(id))
end
function OnMsg.GatherFXActions(list)
  list[#list + 1] = "NotificationDismissed"
end
function GetOnScreenNotificationDismissable(id)
  local dlg = GetDialog("OnScreenNotificationsDlg")
  if dlg then
    local notification = (dlg:GetNotificationById(id))
    if notification then
      return notification.dismissable
    end
  end
  dlg = GetDialog("OnScreenNotificationsDlg_Right")
  if dlg then
    local notification = (dlg:GetNotificationById(id))
    if notification then
      return notification.dismissable
    end
  end
end
function OnMsg.SafeAreaMarginsChanged()
  local notifications_dlg = (GetDialog("OnScreenNotificationsDlg_Right"))
  if notifications_dlg then
    notifications_dlg:RecalculateMargins()
  end
end

function OnScreenNotificationsDlg:RemoveNotificationFromDlg(id)
  local ctrl = (self:GetNotificationById(id))
  if ctrl then
    local notif_container = self.idNotifications
    if ctrl:IsThreadRunning("show_thread") then
      return
    end
    ctrl:CreateThread("show_thread", function()
      local time = const.InterfaceAnimDuration
      if ctrl.window_state ~= "destroying" then
        ctrl:Show(false, time)
      end
      Sleep(time)
      if ctrl.window_state ~= "destroying" then
        local new_selection
        if self.gamepad_selection then
          local notif_count = #notif_container
          local pos = notif_count == self.gamepad_selection and notif_count - 1 or Min(self.gamepad_selection + 1, notif_count)
          new_selection = notif_container[pos]
          if new_selection then
            new_selection:SetFocus(true)
          end
        end
        ctrl:Close()
        if 0 < #notif_container then
          self:ResolveRelativeFocusOrder()
          if new_selection then
            self.gamepad_selection = (new_selection:GetFocusOrder():y())
          end
        else
          self:SetFocus(false, true)
          self.gamepad_selection = false
        end
        self:UpdateGamepadHint()
      end
    end)
  end
end

function OnScreenNotificationsDlg:RemoveNotificationFromTable(id)
  local idx = (table.find(g_ActiveOnScreenNotifications, 1, id))
  if idx then
    table.remove(g_ActiveOnScreenNotifications, idx)
  end
end