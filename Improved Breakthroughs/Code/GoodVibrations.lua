local GOOD_VIBRATIONS_UPDATED_DESCRIPTION = Untranslated(
[[<em>Domes</em> provide an additional <em>5 sanity</em> to Colonists every Sol.
All <em>Colonists</em> have permanently increased <em>birth rates</em>(+20).
 
<grey>"I'm pickin' up good vibrations
She's giving me the excitations"<right>
The Beach Boys</grey><left>
]])

local function ImproveGoodVibrations()
    local tech = Presets.TechPreset.Breakthroughs["GoodVibrations"]
    tech.description = GOOD_VIBRATIONS_UPDATED_DESCRIPTION
    if not tech[2] then
        table.insert(tech, PlaceObj("Effect_ModifyLabel", {
            Amount = 20,
            Label = "Colonist",
            Prop = "birth_comfort_modifier"
        }))
    end
end

OnMsg.ClassesPostprocess = ImproveGoodVibrations

