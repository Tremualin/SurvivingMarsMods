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
        text = Untranslated("<ColonistName(colonist)> just suffered a terrible accident. When colonists suffer an accident they are temporarily unable to work, and have an increasing chance of coming back to work each Sol. Access to a Hospital or Medical Spire at the time of the accident and the Fit perk allows a colonist to recover faster from accidents than normal.\n\nWhen an accident is really serious, the colonist will become permanently impaired, either Physically, Intellectually or Sensory. \n<em>Physically Impaired</em> colonists cannot work as Engineers, Geologists, or in Ranches.\n<em>Intellectually Impaired</em> colonists cannot work as Scientists, Medics or Officers.\n<em>Sensory Impaired</em> (deaf, blind, etc) colonists lose 8 sanity while living in residences with less than 65 comfort, and will lose 20 morale while Supportive Community isn't researched\n\nKeep colonists happy, cure their flaws at the Sanatorium, grants them more perks, and avoid heavy workload to reduce the risk of work accidents."),
    title = Untranslated("Accidents happen")})
end

local ACCIDENTS_ICON = CurrentModPath .. "Images/AccidentedIcon.png"
local ui_functions = Tremualin.UIFunctions

local accidents_text = {
    Fatal = "Fatal Accident",
    Injuries = "Minor Injury",
    StatusEffect_TemporarilyImpaired = "Temporarily Impaired",
    IntellectuallyImpaired = "Permanently Intellectually Impaired",
    PhysicallyImpaired = "Permanently Physically Impaired",
    SensoryImpaired = "Permanently Sensory Impaired"
}

local accidentsLogDescription = Untranslated("Colonists who suffer minor injuries lose 1-20 health.\nColonists who suffer an accident lose 20 health and can become <em>Temporarily or Permanently Impaired</em>. In rare cases, the accident will be <em>Fatal</em>.\nColonists have a chance of recovering from the accident starting at 10% (+10% if <em>Fit</em>, +10% if <em>Hospital/Medical Spire</em> in the Dome) and doubling each Sol.\n<em>Physically Impaired</em> colonists will be discouraged from working on mobility-unfriendly jobs like those requiring Engineers, Geologists,  Officers, or in  Ranches.\n<em>Intellectually Impaired</em> colonists will be discouraged from working on mentally-stressful jobs like those requiring Scientists, Officers or Medics. Intellectually Impaired Geniuses will still contribute with Research.\n<em>Sensory Impaired</em> colonists (deaf, blind) can work on all jobs, but they will lose 5 sanity every sol while living in any residence with less than 65 comfort, and will lose 20 morale while <em>Supportive Community</em> isn't researched.\n<em>Unhappy</em> (any stat < 30) colonists have +5% chances of suffering an injury or accident each Sol. <em>Neutral</em> colonists (not happy nor unhappy) have +1% chance. <em>Happy</em> colonists (all stats >= 70) have -2% chance of having accidents. Heavy workload adds an additional +3 % chance, and each flaw increases the chances of having an accident (+1%) while each perk reduces the chances (-1%).\n\n")

-- When the user puts their mouse in the area, show them how many accidents have happened in the dome
function Dome:GetTremualinAccidentsLogRollover()
    local items = {}
    items[#items + 1] = accidentsLogDescription
    for accident_id, val in sorted_pairs(self.Tremualin_Accidents_Log) do
        local trait = TraitPresets[accident_id]
        items[#items + 1] = accidents_text[accident_id] .. "<right>" .. val
    end
    return next(items) and table.concat(items, "<newline><left>") or Untranslated("Nothing yet")
end

-- UI classes use Getters to access values
function Dome:GetTremualinAccidentsLifetime()
    local accidents = 0
    for _, val in pairs(self.Tremualin_Accidents_Log) do
        accidents = accidents + val
    end
    return accidents
end

-- A panel that shows how many conversions have happened in the dome since it was built
function OnMsg.ClassesPostprocess()
    local sectionDomeTemplate = XTemplates.sectionDome
    ui_functions.RemoveXTemplateSections(sectionDomeTemplate, "Tremualin_AccidentsLifetime")
    local tremualin_AccidentsLifetime = PlaceObj("XTemplateTemplate", {
        "Tremualin_AccidentsLifetime", true,
        "__context_of_kind", "Dome",
        "__template", "InfopanelSection",
        "RolloverText", Untranslated("<TremualinAccidentsLogRollover>"),
        "Title", Untranslated("Accidents on this Dome<right><TremualinAccidentsLifetime>"),
    "Icon", ACCIDENTS_ICON})

    local possibleIndex1 = ui_functions.FindSectionIndexAfterExistingIfPossible(sectionDomeTemplate, "Tremualin_SeniorsLifetime")
    local possibleIndex2 = ui_functions.FindSectionIndexAfterExistingIfPossible(sectionDomeTemplate, "Tremualin_DomesticViolenceLifetime")
    table.insert(sectionDomeTemplate, Max(possibleIndex1, possibleIndex2), tremualin_AccidentsLifetime)
end

local Tremualin_Orig_Colonist_GetUIInfo = Colonist.GetUIInfo
function Colonist:GetUIInfo(remove_descr)
    return Tremualin_Orig_Colonist_GetUIInfo(self, remove_descr) .. "<newline><left>" .. Untranslated("Chances of having an Accident<right><Tremualin_AccidentChances>%", self)
end

local function ImproveSupportiveCommunity()
    local tech = Presets.TechPreset.Social["SupportiveCommunity"]
    local modified = tech.Tremualin_SensoryImpairment
    if not modified then
        tech.description = Untranslated("Removes the -20 morale penalty from <em>Sensory Impaired Colonists</em>\n") .. tech.description
        tech.Tremualin_SensoryImpairment = true
    end
end

OnMsg.ClassesPostprocess = ImproveSupportiveCommunity
