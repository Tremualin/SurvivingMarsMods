local ui_functions = Tremualin.UIFunctions

-- Shows stats on domestic violence in the Dome UI
function Dome:GetUISectionTremualinDomesticViolenceRollover()
    local domesticViolenceFlaws = self.Tremualin_DomesticViolenceFlaws or 0
    local domesticViolenceRetalations = self.Tremualin_DomesticViolenceRetalations or 0
    local domesticViolenceAssaults = self.Tremualin_DomesticViolenceAssaults or 0
    local domesticViolenceReports = self.Tremualin_DomesticViolenceReports or 0
    local items = {
        Untranslated("Domestic violence assaults: <right>" .. domesticViolenceAssaults),
        Untranslated("Renegades reported for domestic violence: <right>" .. domesticViolenceReports),
        Untranslated("Flaws gained due to domestic violence: <right>" .. domesticViolenceFlaws),
        Untranslated("Violent retaliations: <right>" .. domesticViolenceRetalations),
    }
    return table.concat(items, "<newline><left>")
end

-- A panel that shows domestic violence in the Dome UI
function OnMsg.ClassesPostprocess()
    local template = XTemplates.sectionDome
    ui_functions.RemoveXTemplateSections(template, "Tremualin_DomesticViolenceLifetime")
    local tremualin_DomesticViolenceLifetime = PlaceObj("XTemplateTemplate", {
        "Tremualin_DomesticViolenceLifetime", true,
        "__context_of_kind", "Dome",
        "__template", "InfopanelSection",
        "RolloverText", Untranslated("<UISectionTremualinDomesticViolenceRollover>"),
        "Title", Untranslated("Information about domestic violence in the dome"),
        "Icon", "UI/Icons/Notifications/renegade.tga"
    })

    table.insert(template, #template, tremualin_DomesticViolenceLifetime)
end
