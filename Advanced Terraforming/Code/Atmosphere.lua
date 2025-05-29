local FindAllTemplatesForNames = Tremualin.Functions.FindAllTemplatesForNames
local AddParentToClass = Tremualin.Functions.AddParentToClass

-- Begin GHG Factories Produce Temperature
local function GHGFactoriesProduceAtmosphere()
    AddParentToClass(GHGFactory, "SecondaryTerraformingParam")
    local templates = FindAllTemplatesForNames({"GHGFactory"})
    for _, template in ipairs(templates) do
        template.secondary_terraforming_param = "Atmosphere"
    end

    function GHGFactory:GetSecondaryTerraformingBoostSol()
        if GetTerraformParamPct(self.secondary_terraforming_param) < 25 then
            -- Use the same temp_boost_coef for atmosphere
            return self.terraforming_boost_sol * self.initial_temp_boost_coef
        end
        return self.terraforming_boost_sol
    end
end

GHGFactoriesProduceAtmosphere()
-- End GHG Factories Produce Temperature

-- Begin Blue skies increases morale
local BLUE_SKIES_MORALE_ID = "Tremualin_BlueSkiesMorale"
local function ApplySkiesMorale(blueSkies)
    if blueSkies then
        MainCity:SetLabelModifier("Dome", BLUE_SKIES_MORALE_ID, Modifier:new({
            prop = "dome_morale",
            amount = 10000,
            percent = 0,
            id = BLUE_SKIES_MORALE_ID,
            display_text = Untranslated("Nothing but blue skies from now on"),
        }))
    else
        -- Remove the blue skies modifier if the sky is no longer blue
        local old_mod = table.find_value(MainCity.modifications, "id", BLUE_SKIES_MORALE_ID)
        if old_mod then
            MainCity:UpdateModifier("remove", old_mod, 0, 0)
        end
    end
end
function OnMsg.AtmosphereChanged(blueSkies)
    ApplySkiesMorale(blueSkies)
end
function OnMsg.LoadGame()
    ApplySkiesMorale(GetTerraformParamPct("Atmosphere") >= 50)
end
-- End Blue skies increases morale

-- Begin Encyclopedia Changes
local ATMOSPHERE_ENCYCLOPEDIA_ARTICLE = Untranslated([[
The <em>Atmosphere</em> parameter represents the density and the composition of the Martian atmosphere. The higher this parameter is, the more Earth-like are the atmospheric pressure, Oxygen levels and cloud generation.
 
<em>Atmosphere</em> is increased by <em>GHG Factories</em>, <em>Lakes</em>, <em>Carbonate Processors</em>, by completing the <em>Import Greenhouse Gases</em> Special Project, and through <em>Photosynthesis</em>.
 
Due to the lack of a planetary magnetic field, up to 4% of Atmosphere is gradually lost over time. Atmosphere loss can be stopped by building <em>Magnetic Field Generators</em>, or by completing <em>Launch Magnetic Shield</em> Special Projects.
 
<em>Atmosphere</em> improvement boosts the effectiveness of <em>Wind Turbines</em> and <em>MOXIEs</em> but <red>decreases</red> the effectiveness of <em>Solar Panels</em> and creates environmental conditions for <red>Toxic Rains</red> and <green>Pure Rains</green> to occur. Recurring <em>Meteor Storms</em> decrease in severity and later disappear entirely. When skies become blue, colonists gain +10 morale.
 
When <em>Temperature</em> and <em>Atmosphere</em> are high enough, but Water is not at 80%, <red>Wildfires</red> could appear, <red>decreasing</red> <em>Vegetation</em> until either they're dealt with, or it <em>Rains</em>.
 
When <em>Temperature</em>, <em>Atmosphere</em> and <em>Vegetation</em> are all high enough, the atmosphere on Mars becomes breathable and <em>Domes</em> may become <em>open-air Domes</em>.]])

function OnMsg.ClassesPreprocess()
    Presets.TerraformingParam.Default.Atmosphere.description = ATMOSPHERE_ENCYCLOPEDIA_ARTICLE
    Presets.EncyclopediaArticle.GameMechanics.Terraforming_Atmosphere.text = ATMOSPHERE_ENCYCLOPEDIA_ARTICLE
end
-- End Encyclopedia Changes
