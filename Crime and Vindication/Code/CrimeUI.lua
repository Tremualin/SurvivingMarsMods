local ui_functions = Tremualin.UIFunctions

-- Shows stats on domestic violence in the Dome UI
function Dome:GetUISectionTremualinDomesticViolenceRollover()
    local domesticViolenceFlaws = self.Tremualin_DomesticViolenceFlaws or 0
    local domesticViolenceRetalations = self.Tremualin_DomesticViolenceRetalations or 0
    local domesticViolenceAssaults = self.Tremualin_DomesticViolenceAssaults or 0
    local domesticViolenceReports = self.Tremualin_DomesticViolenceReports or 0
    local items = {
        Untranslated("<em>Unhappy</em> (any stat < 30), <em>Violent</em> and <em>Renegade</em> colonists can commit acts of <em>domestic violence</em>. When this happens, the <em>domestic violence survivor</em> will lose up to 15 health and/or sanity, can gain flaws from the encounter, and the perpetrator can become a Renegade (if reported and not already a Renegade).\nViolent colonists have a lower chance of being reported and can can even <em>escalate the violence</em> to other violent colonists in the same Residence.\nSecurity Stations can mitigate the effects of domestic violence.\n\n"),
        Untranslated(string.format("Renegades reported for domestic violence: <right><colonist(%s)>", domesticViolenceReports)),
        Untranslated("Flaws gained due to domestic violence: <right>" .. domesticViolenceFlaws),
        Untranslated("Violent escalations: <right>" .. domesticViolenceRetalations),
        Untranslated("Domestic violence assaults: <right>" .. domesticViolenceAssaults),
    }
    return table.concat(items, "<newline><left>")
end

function Dome:GetTremualin_DomesticViolenceAssaults()
    return self.Tremualin_DomesticViolenceAssaults or 0
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
        "Title", Untranslated("Domestic violence assaults on this Dome<right><Tremualin_DomesticViolenceAssaults>"),
    "Icon", table.rand({CurrentModPath .. "violence_1.png", CurrentModPath .. "violence_2.png"})})

    table.insert(template, #template + 1, tremualin_DomesticViolenceLifetime)
end
