local SPACE_REHABILITATION_UPDATED_DESCRIPTION = Untranslated(
[[Colonists will always lose one <em>flaw</em> on their journey to Mars.
Tourists will pay 50% more <em>funding</em> (when going back to Earth).
 
<grey>It is never too late to improve on oneself, and the months spent traversing the void between Mars and Earth gives ample opportunity to do so.</grey>]])

function ImproveSpaceRehabilitation()
    local tech = Presets.TechPreset.Breakthroughs["SpaceRehabilitation"]
    -- SpaceRehabilitation chance of removing flaws increased to 100%
    tech.param1 = 100
    tech.description = SPACE_REHABILITATION_UPDATED_DESCRIPTION

    -- Increase TouristFundingMultiplier by 50%
    if not tech[1] then
        table.insert(tech, PlaceObj("Effect_Code", {
            OnApplyEffect = function(self, colony, parent)
                g_Consts:SetModifier("TouristFundingMultiplier", "Tremualin_SpaceRehabilitation", 0, 50)
            end
        }))
    end
end

OnMsg.ClassesPostprocess = ImproveSpaceRehabilitation
