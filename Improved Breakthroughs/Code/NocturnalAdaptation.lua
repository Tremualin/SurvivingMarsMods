local NOCTURNAL_ADAPTATION_UPDATED_DESCRIPTION = Untranslated(
[[All colonists gain +<param2> performance during <em>night shifts</em>
Colonists no longer lose <em>sanity</em> during <em>night shifts</em>
 
<grey>The greater distance from the Sun makes it so that all colonists have to cope with the psychological strain of receiving reduced sunlight. This fact, combined with newly discovered techniques allow us to considerably boost the productivity of those who work outright nightshifts.</grey>]])

local function ImproveNocturnalAdaptation()
    local tech = Presets.TechPreset.Breakthroughs["NocturnalAdaptation"]
    tech.description = NOCTURNAL_ADAPTATION_UPDATED_DESCRIPTION

    if not tech[1] then
        table.insert(tech, PlaceObj('Effect_ModifyLabel', {
            Label = "Consts",
            Percent = -100,
            Prop = "WorkDarkHoursSanityDecrease",
        }))
    end
end
-- TODO: fix description if Nocturnal Adaptation is researched

OnMsg.ClassesPostprocess = ImproveNocturnalAdaptation

