local lake_crafting_text = Untranslated("<em>Artificial lakes</em> grant a stacking comfort bonus to any Dome up to 20 hexes away when full and unfrozen.<newline>")
-- Lakes grant comfort equal to their volume divided 50
-- 20 for Huge Lakes, 10 for Big Lakes, 5 for Lakes, and 2 for Small Lakes
local function GetLakeComfort(lake)
    return abs(lake.volume_max / 50)
end

local function GetLakeText(lake)
    return Untranslated(string.format("Grants <em>%d comfort</em> to any Dome up to 20 hexes away when full and unfrozen <newline>", GetLakeComfort(lake) / 1000))
end

function ImproveLakes()
    local tech = Presets.TechPreset.Terraforming["LakeCrafting"]
    local modified = tech.Tremualin_LakeComfort
    if not modified then
        tech.description = lake_crafting_text .. tech.description
        tech.Tremualin_LakeComfort = true

        local buildingTemplates = BuildingTemplates
        local lakeBuildingTemplates = {buildingTemplates.LandscapeLakeSmall, buildingTemplates.LandscapeLakeMid, buildingTemplates.LandscapeLakeBig, buildingTemplates.LandscapeLakeHuge}
        for _, lakeTemplate in pairs(lakeBuildingTemplates) do
            lakeTemplate.description = GetLakeText(lakeTemplate) .. lakeTemplate.description
        end
    end
end

function OnMsg.ClassesGenerate()
    ImproveLakes()
    -- Find all Lakes up to twice the work distance from the Dome and add their comfort to the Dome
    local orig_Dome_GetDomeComfort = Dome.GetDomeComfort
    function Dome:GetDomeComfort()
        local lake_comfort = 0
        local realm = GetRealm(self)
        realm:MapForEach(self, "hex", self:GetOutsideWorkplacesDist() * 2, "LandscapeLake", function(lake, self)
            if not (not lake.working or lake.destroyed or lake:IsFrozen()) and lake.volume >= lake.volume_max then
                lake_comfort = lake_comfort + GetLakeComfort(lake)
            end
        end, self)
        return orig_Dome_GetDomeComfort(self) + lake_comfort
    end
end
