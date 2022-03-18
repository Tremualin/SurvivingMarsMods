local ui_functions = Tremualin.UIFunctions

-- Initialize the removed_traits_log and lifetime cures to 0 when the Dome is built
local orig_Dome_Init = Dome.Init
function Dome:Init()
    orig_Dome_Init(self)
    self.tremualin_removed_traits_log = {}
    self.tremualin_lifetime = 0
end

local seniorsRemoveTraitsDescription = Untranslated("<em>Seniors</em> living in this Dome will help <em>non-Senior colonists</em> cure their <em>flaws</em>, including those that are normally unavailable in the <em>Sanatorium</em>, like <em>Renegade</em> and <em>Idiot</em>. Seniors in this Dome have cured:\n")

-- When the user puts their mouse in the area, show them how many traits have been removed
function Dome:GetUISectionTremualinSeniorsLifetimeRollover()
    local items = {}
    items[#items + 1] = seniorsRemoveTraitsDescription
    for trait_id, val in sorted_pairs(self.tremualin_removed_traits_log or empty_table) do
        local trait = TraitPresets[trait_id]
        items[#items + 1] = (T({
            432,
            "<trait_name><right><value>",
            trait_name = trait.display_name,
            value = val
        }))
    end
    return next(items) and table.concat(items, "<newline><left>") or Untranslated("Nothing yet")
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
        "Title", Untranslated("Traits cured by seniors on this Dome<right><TremualinSeniorsLifetime>"),
    "Icon", CurrentModPath .. "seniors_section.png"})

    table.insert(template, #template + 1, tremualin_SeniorsLifetime)
end
