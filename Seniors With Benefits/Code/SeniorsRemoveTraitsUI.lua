local ui_functions = Tremualin.UIFunctions

-- Initialize the removed_traits_log and lifetime cures to 0 when the Dome is built
local orig_Dome_Init = Dome.Init
function Dome:Init()
    orig_Dome_Init(self)
    self.tremualin_removed_traits_log = {}
    self.tremualin_lifetime = 0
end

-- When the user puts their mouse in the area, show them how many traits have been removed
function Dome:GetUISectionTremualinSeniorsLifetimeRollover()
    local items = {}
    for trait_id, val in sorted_pairs(self.tremualin_removed_traits_log or empty_table) do
        local trait = TraitPresets[trait_id]
        items[#items + 1] = (T({
            432,
            "<trait_name><right><value>",
            trait_name = trait.display_name,
            value = val
        }))
    end
    return next(items) and table.concat(items, "<newline><left>") or Untranslated("Information about the traits removed by Seniors")
end

-- UI classes use Getters to access values
function Dome:GetTremualinSeniorsLifetime()
    return self.tremualin_lifetime or 0
end

-- A panel that shows how many conversions have happened in the dome since it was built
function OnMsg.ClassesPostprocess()
    local template = XTemplates.sectionDome
    ui_functions.RemoveXTemplateSections(template, "Tremualin_SeniorsLifetime")
    local tremualin_SeniorsLifetime = PlaceObj("XTemplateTemplate", {
        "Tremualin_SeniorsLifetime", true,
        "__context_of_kind", "Dome",
        "__template", "InfopanelSection",
        "RolloverText", Untranslated("<UISectionTremualinSeniorsLifetimeRollover>"),
        "Title", Untranslated("Traits removed by seniors"),
        "Icon", "UI/Icons/Sections/facility.tga"}, {PlaceObj("XTemplateTemplate", {
            "__template",
            "InfopanelText",
            "Text",
        Untranslated("Lifetime<right><TremualinSeniorsLifetime>")});
    })

    table.insert(template, #template, tremualin_SeniorsLifetime)
end
