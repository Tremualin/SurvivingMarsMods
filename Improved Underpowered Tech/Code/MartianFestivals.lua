local MARTIAN_FESTIVALS_DESCRIPTION = Untranslated([[
All <em>services</em> provide additional <em>Service Comfort</em> (+10).
 
<grey>Reinforcing the notion of a separate and unique Martian culture makes our Colonists more positive and helps them find comfort in the uncertain world which is life on Mars.</grey>
]])

local function ImproveMartianFestivals()
    local tech = Presets.TechPreset.Social["MartianFestivals"]
    local modified = tech.Tremualin_ImprovedMartianFestivals
    if not modified then
        for _, effect in pairs(tech) do
            if effect and type(effect) == "table" and effect.IsKindOf and effect:IsKindOf("Effect_ModifyLabel") and effect.Prop == "service_comfort" then
                effect.Label = "Service"
            end
        end
        tech.description = MARTIAN_FESTIVALS_DESCRIPTION
        tech.Tremualin_ImprovedMartianFestivals = true
    end
end

OnMsg.LoadGame = ImproveMartianFestivals
OnMsg.CityStart = ImproveMartianFestivals
