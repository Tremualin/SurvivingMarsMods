local ui_functions = Tremualin.UIFunctions
local HIGH_ALTITUDE_PHOTOVOLTAICS_ID = "Tremualin_High_Altitude_Photovoltaics"
local HIGH_ALTITUDE_PHOTOVOLTAICS_DESCRIPTION = Untranslated(
[[<em>Solar Panels</em> gain a halved <em>elevation bonus</em>.
 
<grey>Recent studies show that solar energy is more efficient at high altitude than at sea level. Higher altitudes have more direct radiation and less diffuse radiation.</grey>]])

GlobalVar("Tremualin_HighAltitudePhotovoltaicsBonusPerKilometerElevation", 0)
local function AddHighAltitudePhotovoltaics()
    local physics = Presets.TechPreset.Physics
    if not physics[HIGH_ALTITUDE_PHOTOVOLTAICS_ID] then
        table.insert(physics, #physics + 1, PlaceObj('TechPreset', {
            SortKey = 5,
            description = HIGH_ALTITUDE_PHOTOVOLTAICS_DESCRIPTION,
            display_name = Untranslated("High Altitude Photovoltaics"),
            group = "Physics",
            icon = "UI/Icons/Research/solar_exploration.tga",
            id = HIGH_ALTITUDE_PHOTOVOLTAICS_ID,
            position = range(1, 5),
            PlaceObj('Effect_Code', {
                OnApplyEffect = function (self, colony, parent)
                    -- Wind Power bonus is 300 per km; Solar will be 150 per km
                    Tremualin_HighAltitudePhotovoltaicsBonusPerKilometerElevation = 150
                    colony:ForEachLabelObject("SolarPanelBase", "UpdateProduction")
                end,
            }),
        }))
    end

    -- Show how much the elevation bonus is boosting Solar Power production
    local SECTION_SOLAR_POWER_ELEVATION_ID = "Tremualin_SectionSolarPowerElevation"
    local sectionPowerProduction = XTemplates.sectionPowerProduction[1]
    ui_functions.RemoveXTemplateSections(sectionPowerProduction, SECTION_SOLAR_POWER_ELEVATION_ID)
    local sectionSolarPowerElevation = PlaceObj("XTemplateTemplate", {
        SECTION_SOLAR_POWER_ELEVATION_ID, true,
        "__context_of_kind", "SolarPanelBuilding",
        '__condition', function (parent, context) return Tremualin_HighAltitudePhotovoltaicsBonusPerKilometerElevation > 0 end,
        '__template', "InfopanelText",
        'Text', Untranslated("Elevation boost<right><ElevationBonus>%"),
    })
    table.insert(sectionPowerProduction, #sectionPowerProduction + 1, sectionSolarPowerElevation)

    -- Show the elevation boost during construction as well
    local SECTION_SOLAR_POWER_ELEVATION_CONSTRUCTION_ID = "Tremualin_SectionSolarPowerElevation"
    local sectionIpConstruction = XTemplates.ipConstruction[1]
    ui_functions.RemoveXTemplateSections(sectionIpConstruction, SECTION_SOLAR_POWER_ELEVATION_CONSTRUCTION_ID)
    sectionSolarPowerElevation = PlaceObj('XTemplateTemplate', {
        SECTION_SOLAR_POWER_ELEVATION_CONSTRUCTION_ID, true,
        '__condition', function (parent, context) return context.template_obj:IsKindOf("SolarPanelBuilding") and Tremualin_HighAltitudePhotovoltaicsBonusPerKilometerElevation > 0 end,
        '__template', "InfopanelSection",
        'RolloverText', Untranslated("High Altitude Solar Powers produce more Power at higher elevation."),
        'Title', Untranslated("Terrain"),
        'Icon', "UI/Icons/Sections/construction.tga",
        }, {
        PlaceObj('XTemplateTemplate', {
            '__template', "InfopanelText",
            'Text', T(906, --[[XTemplate ipConstruction Text]] "Elevation Boost<right><GetElevationBoost>%"),
        }),
    })
    table.insert(sectionIpConstruction, 5, sectionSolarPowerElevation)
end

OnMsg.ClassesPostprocess = AddHighAltitudePhotovoltaics

-- Solar panels don't usually have elevation; add it
function SolarPanelBase:GetElevation()
    return GetElevation(self:GetVisualPos(), self:GetMapID())
end

-- Solar panels don't usually get an elevation bonus; add it
function SolarPanelBase:GetElevationBonus()
    return self:GetElevation() * Tremualin_HighAltitudePhotovoltaicsBonusPerKilometerElevation / 1000
end

-- Include the Elevation Bonus in the Solar Panel's Power calculations calculations
function SolarPanelBase:UpdateProduction()
    local new_base_production = self:CanBeOpened() and self:GetClassValue("electricity_production") or 0
    local elevation_bonus = self:GetElevationBonus()
    local production_bonus = 100 + (elevation_bonus - 50)
    local new_base_production_with_elevation = MulDivRound(50 + production_bonus, new_base_production, 100)
    self:UpdateCounterAtmosphereModifier()
    if self.base_electricity_production ~= new_base_production_with_elevation then
        self:SetBase("electricity_production", new_base_production_with_elevation)
        RebuildInfopanel(self)
    end
end

-- Function is ambitiously inherited, so let's make it explicit
-- for both SolarPanelBase and SolarPanelBuilding
local function SolarPanelBaseGetEletricityUnderproduction(solarPanel)
    local elevation_bonus = solarPanel:GetElevationBonus()
    return Max(0, (solarPanel:GetOptimalElectricityProduction() + elevation_bonus) - solarPanel.electricity_production)
end

function SolarPanelBase:GetEletricityUnderproduction()
    return SolarPanelBaseGetEletricityUnderproduction(self)
end

function SolarPanelBuilding:GetEletricityUnderproduction()
    return SolarPanelBaseGetEletricityUnderproduction(self)
end

-- Make sure solar panels can show an Elevation Boost
-- The original requires the template to have a field we do not have
local Orig_Tremualin_ConstructionController_GetElevationBoost = ConstructionController.GetElevationBoost
function ConstructionController:GetElevationBoost()
    if IsKindOf(self.template_obj, "SolarPanelBase") then
        local pos = self.cursor_obj:GetPos()
        local map_id = self:GetMapID()
        return GetElevation(pos, map_id) * Tremualin_HighAltitudePhotovoltaicsBonusPerKilometerElevation / 1000
    end
    return Orig_Tremualin_ConstructionController_GetElevationBoost(self)
end
