function OnMsg.ClassesPostprocess()
    if OnScreenNotificationPresets.Tremualin_CrimeEvents_Embezzlement then
        return
    end

    PlaceObj("OnScreenNotificationPreset", {
        ImagePreview = "UI/Icons/Notifications/New/renegade.tga",
        SortKey = 1000200,
        VignetteImage = "UI/Onscreen/onscreen_gradient_red.tga",
        VignettePulseDuration = 2000,
        close_on_read = true,
        expiration = 150000,
        fx_action = "UINotificationResource",
        group = "Colonists",
        id = "Tremualin_CrimeEvents_Embezzlement",
        image = "UI/Icons/Notifications/New/renegade_2.tga",
        priority = "Important",
        text = Untranslated("<funding(stolen_amount)> stolen from <dome_name>!"),
    title = Untranslated("Renegades Embezzle Money")})
end

function OnMsg.ClassesPostprocess()
    if OnScreenNotificationPresets.Tremualin_CrimeEvents_Protest then
        return
    end

    PlaceObj("OnScreenNotificationPreset", {
        ImagePreview = "UI/Icons/Notifications/New/renegade.tga",
        SortKey = 1000200,
        VignetteImage = "UI/Onscreen/onscreen_gradient_red.tga",
        VignettePulseDuration = 2000,
        close_on_read = true,
        expiration = 150000,
        fx_action = "UINotificationResource",
        group = "Colonists",
        id = "Tremualin_CrimeEvents_Protest",
        image = "UI/Icons/Notifications/New/renegade_2.tga",
        priority = "Important",
        text = Untranslated("<protest_text>; on <dome_name>"),
    title = Untranslated("Renegades Organize Protest")})
end

function OnMsg.ClassesPostprocess()
    if OnScreenNotificationPresets.Tremualin_CrimeEvents_Vandalism then
        return
    end

    PlaceObj("OnScreenNotificationPreset", {
        ImagePreview = "UI/Icons/Notifications/New/renegade.tga",
        SortKey = 1000200,
        VignetteImage = "UI/Onscreen/onscreen_gradient_red.tga",
        VignettePulseDuration = 2000,
        expiration = 150000,
        fx_action = "UINotificationResource",
        group = "Colonists",
        id = "Tremualin_CrimeEvents_Vandalism",
        image = "UI/Icons/Notifications/New/renegade_2.tga",
        priority = "Important",
        text = Untranslated("Renegades vandalize multiple buildings on <dome_name>!"),
    title = Untranslated("Renegades Vandalize Buildings")})
end

function OnMsg.ClassesPostprocess()
    if OnScreenNotificationPresets.Tremualin_Suicide_Hero then
        return
    end

    PlaceObj("OnScreenNotificationPreset", {
        ImagePreview = "UI/Icons/Notifications/New/renegade.tga",
        SortKey = 1000200,
        expiration = 150000,
        group = "Colonists",
        id = "Tremualin_Suicide_Hero",
        image = "UI/Icons/Notifications/New/renegade_2.tga",
        priority = "Important",
        text = Untranslated("<officer_name> has saved <colonist_name> on <dome_name>"),
    title = Untranslated("Off-duty Hero")})
end

function OnMsg.ClassesPostprocess()
    if OnScreenNotificationPresets.Tremualin_Suicide_Failure then
        return
    end

    PlaceObj("OnScreenNotificationPreset", {
        ImagePreview = "UI/Icons/Notifications/New/renegade.tga",
        SortKey = 1000200,
        close_on_read = true,
        expiration = 150000,
        fx_action = "UINotificationResource",
        group = "Colonists",
        id = "Tremualin_Suicide_Failure",
        image = "UI/Icons/Notifications/New/renegade_2.tga",
        priority = "Important",
        text = Untranslated("<officer_name> provoked the suicide of <colonist_name> on <dome_name>"),
    title = Untranslated("Off-duty Screw-up")})
end

function OnMsg.ClassesPostprocess()
    if OnScreenNotificationPresets.Tremualin_Domestic_Violence_Report then
        return
    end

    PlaceObj("OnScreenNotificationPreset", {
        ImagePreview = "UI/Icons/Notifications/New/renegade.tga",
        SortKey = 1000200,
        close_on_read = true,
        expiration = 150000,
        fx_action = "UINotificationResource",
        group = "Colonists",
        id = "Tremualin_Domestic_Violence_Report",
        image = "UI/Icons/Notifications/New/renegade_2.tga",
        priority = "Important",
        text = Untranslated("<perpetrator_name> reported for domestic assault on <dome_name>"),
    title = Untranslated("Domestic violence")})
end

function OnMsg.ClassesPostprocess()
    if OnScreenNotificationPresets.Tremualin_Renegades_Sabotage_Buildings then
        return
    end

    PlaceObj("OnScreenNotificationPreset", {
        ImagePreview = "UI/Icons/Notifications/New/renegade.tga",
        SortKey = 1000400,
        VignetteImage = "UI/Onscreen/onscreen_gradient_red.tga",
        VignettePulseDuration = 2000,
        expiration = 150000,
        group = "Colonists",
        id = "Tremualin_Renegades_Sabotage_Buildings",
        image = "UI/Icons/Notifications/New/renegade_2.tga",
        priority = "Important",
        text = Untranslated("Buildings destroyed in <dome_name>!"),
    title = Untranslated("Renegades Sabotage Buildings")})
end
