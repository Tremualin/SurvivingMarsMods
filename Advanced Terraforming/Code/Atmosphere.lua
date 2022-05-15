local FindAllTemplatesForNames = Tremualin.Functions.FindAllTemplatesForNames
local AddParentToClass = Tremualin.Functions.AddParentToClass

-- Begin GHG Factories Produce Temperature
function GHGFactoriesProduceTemperature()
    AddParentToClass(GHGFactory, "SecondaryTerraformingParam")
    local templates = FindAllTemplatesForNames({"GHGFactory"})
    for _, template in ipairs(templates) do
        template.secondary_terraforming_param = "Atmosphere"
        template.secondary_terraforming_boost_sol = template.terraforming_boost_sol
    end

    function GHGFactory:GetSecondaryTerraformingBoostSol()
        if GetTerraformParamPct(self.secondary_terraforming_param) < 25 then
            return self.secondary_terraforming_boost_sol * self.initial_temp_boost_coef
        end
        return self.secondary_terraforming_boost_sol
    end
end

GHGFactoriesProduceTemperature()
-- End GHG Factories Produce Temperature

-- Begin Encyclopedia Changes
local ATMOSPHERE_ENCYCLOPEDIA_ARTICLE = Untranslated([[
The <em>Atmosphere</em> parameter represents the density and the composition of the Martian atmosphere. The higher this parameter is, the more Earth-like are the atmospheric pressure, Oxygen levels and cloud generation.
 
<em>Atmosphere</em> is increased by <em>GHG Factories</em>, <em>Lakes</em>, <em>Carbonate Processors</em>, by completing the <em>Import Greenhouse Gases</em> Special Project, and through <em>Photosynthesis</em>.
 
Due to the lack of a planetary magnetic field, Atmosphere is gradually lost over time. Atmosphere loss can be stopped by building <em>Magnetic Field Generators</em>, or by completing <em>Launch Magnetic Shield</em> Special Projects.
 
<em>Atmosphere</em> improvement boosts the effectiveness of <em>Wind Turbines</em> and <em>MOXIEs</em> but <red>decreases</red> the effectiveness of <em>Solar Panels</em> and creates environmental conditions for <em>Toxic Rains</em> and <em>clear water Rains</em> to occur. Recurring <em>Meteor Storms</em> decrease in severity with the improving of the <em>Atmosphere</em> and later disappear entirely.
 
When <em>Temperature</em>, <em>Atmosphere</em> and <em>Vegetation</em> are all high enough, the atmosphere on Mars becomes breathable and <em>Domes</em> may become <em>open-air Domes</em>.]])

function OnMsg.ClassesPreprocess()
    Presets.TerraformingParam.Default.Atmosphere.description = ATMOSPHERE_ENCYCLOPEDIA_ARTICLE
    Presets.EncyclopediaArticle.GameMechanics.Terraforming_Atmosphere.text = ATMOSPHERE_ENCYCLOPEDIA_ARTICLE
end
-- End Encyclopedia Changes
