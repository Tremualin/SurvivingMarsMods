DefineClass.UnitSignAccidented = {
    __parents = {"UnitSign"},
    entity = "SignAccidented",
}

DefineClass.UnitArrowAccidented = {
    __parents = {"UnitSign"},
    entity = "ArrowAccidented",
}

function OnMsg.ClassesPostprocess()
    -- Temporarily Impaired show up as Temporary Ill in the UI
    local Tremualin_Orig_Colonist_IsTemporaryIll = Colonist.IsTemporaryIll
    function Colonist:IsTemporaryIll()
        return self.status_effects.StatusEffect_TemporarilyImpaired or Tremualin_Orig_Colonist_IsTemporaryIll(self)
    end -- function Colonist:IsTemporaryIll

    if PopupNotificationPreset.FirstStatusEffect_Tremualin_Accident then
        return
    end

    PlaceObj("PopupNotificationPreset", {
        SortKey = 1004300,
        choice1 = T(7987, "View."),
        choice2 = T(5715, "Troubling."),
        group = "Colonist",
        id = "FirstStatusEffect_Tremualin_Accident",
        image = "UI/Messages/colonists.tga",
        text = Untranslated("<ColonistName(colonist)> just suffered a terrible accident. When colonists suffer an accident they become temporarily unable to work, and have an increasing chance of coming back to work each Sol. Access to a Hospital or Medical Spire at the time of the accident increases the chances of recovery, and Fit colonists recover faster from accidents than other colonists.\n\nWhen an accident is really serious, the colonist can become permanently impaired.\nPhysically Impaired colonists have limited mobility, which prevents them from working as Engineers, Geologists, Botanists or in Ranches.\nIntellectually Impaired colonists have trouble solving complex problems, which prevents them from working as Scientists, Medics or Officers.\nSensory Impaired (deaf, blind, etc) colonists lose 8 sanity while living in residences with less than 65 comfort, and will lose 20 morale while Supportive Community isn't researched\n\n<hint>Keep colonists happy, cure their flaws at the Sanatorium and avoid Heavy workload to reduce the risk of work accidents."),
    title = Untranslated("Accidents happen")})
end
