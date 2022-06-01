-- File isn't loaded
-- TODO: finish the integration with Space Race
function OnMsg.ClassesBuilt()
    table.insert_unique(BuildingTemplates.ForeignAidRocket.storable_resources, "Seeds")
    table.insert_unique(BuildingTemplates.ForeignTradeRocket.storable_resources, "Seeds")
    table.insert_unique(Presets.ListItem.AIResource, PlaceObj("AIResource", {id = "seeds", save_in = "armstrong"}))
    table.insert_unique(Presets.ListItem.AIResource, PlaceObj("AIResource", {id = "seeds_production", save_in = "armstrong"}))
end

local TERRA_INITIATIVE_DESCRIPTION = Untranslated([[
    Always offers Seeds for any tradable resource
    Initial Standing: <em>Neutral</em>
    Development speed: <em>Normal</em>
    Bias: <em>Terraforming</em>]])
local function AddTerraformingInitiativeAsARival()
    if not Presets.DumbAIDef.MissionSponsors.TerraInitiative then
        table.insert(Presets.DumbAIDef.MissionSponsors, PlaceObj("DumbAIDef", {
            Comment = "TerraformingInitiative",
            SortKey = 12000,
            biases = {
                PlaceObj("AIBias", {
                    "tag",
                    "terraforming",
                    "bias",
                    1100000
                });
            },
            description = TERRA_INITIATIVE_DESCRIPTION,
            display_name = T(392743248058, "Terraforming Initiative"),
            group = "MissionSponsors",
            id = "TerraInitiative",
            initial_resources = {
                PlaceObj("AIResourceAmount", {
                    "resource",
                    "funding",
                    "amount",
                    8000
                }),
                PlaceObj("AIResourceAmount", {
                    "resource",
                    "rockets",
                    "amount",
                    2
                }),
                PlaceObj("AIResourceAmount", {
                    "resource",
                    "research_production",
                    "amount",
                    100
                }),
                PlaceObj("AIResourceAmount", {
                    "resource",
                    "polymers",
                    "amount",
                    10
                }),
                PlaceObj("AIResourceAmount", {
                    "resource",
                    "machineparts",
                    "amount",
                    25
                }),
                PlaceObj("AIResourceAmount", {
                    "resource",
                    "electronics",
                    "amount",
                    10
                }),
                PlaceObj("AIResourceAmount", {
                    "resource",
                    "seeds",
                    "amount",
                    100
                }),
                PlaceObj("AIResourceRange", {
                    "resource",
                    "standing",
                    "min",
                    -5,
                    "max",
                    5
                });
            },
            production_rules = {},
            save_in = "armstrong"
        }))
    end
end

OnMsg.ClassesBuilt = AddTerraformingInitiativeAsARival

local SetUIResourceValues_LandingSiteObject = LandingSiteObject.SetUIResourceValues
function LandingSiteObject:SetUIResourceValues(...)
    SetUIResourceValues_LandingSiteObject(self, ...)
    local spot = self.selected_spot
    if spot and spot.spot_type == "rival" then
        local obj = RivalAIs[spot.id]
        local resources = obj.resources
        local other = self.dialog:ResolveId("idOtherResources")
        if other then
            other:SetText(T({
                12758,
                "<seeds(seeds)>  ",
                seeds = resources.seeds and Max(resources.seeds * const.ResourceScale, 0) or 0
            }))
        end
    end
end
