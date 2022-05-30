-- Modify Signal Boosters description and update range of Rockets, RCRovers and Elevators when discovered
local function AdvancedSignalBoosters()
    local tech = Presets.TechPreset.ReconAndExpansion["SignalBoosters"]
    local modified = tech.Tremualin_AdvancedSignalBoosters

    local function BoostSignals(objects, service_area_max)
        local objects = objects or empty_table
        for _, object in ipairs(objects) do
            object.service_area_max = service_area_max
            object:SetUIWorkRadius(object.service_area_max)
        end
    end

    if not modified then
        local modifyRadiusOnDiscovery = PlaceObj("Effect_Code", {
            OnApplyEffect = function(self, colony, parent)
                Elevator.service_area_max = const.CommandCenterDefaultRadius + const.SignalBoostersBuff
                RCRover.service_area_max = const.RCRoverMaxRadius + const.SignalBoostersBuff
                RocketBase.service_area_max = const.CommandCenterDefaultRadius + const.SignalBoostersBuff
                BoostSignals(colony.city_labels.labels.Elevator, Elevator.service_area_max)
                BoostSignals(colony.city_labels.labels.RCRoverAndChildren, RCRover.service_area_max)
                BoostSignals(colony.city_labels.labels.AllRockets, RocketBase.service_area_max)
            end
        })

        tech.description = Untranslated("Increases the service range on <em>all drone controllers</em> by <param1> hexes.\n\n<grey>\226\128\156In the new era, thought itself will be transmitted by radio.\226\128\157\n<right>Guglielmo Marconi</grey><left>")
        table.insert(tech, #tech + 1, modifyRadiusOnDiscovery)

        tech.Tremualin_AdvancedSignalBoosters = true
        -- If this happens, tech was already researched; we must manually execute the effects
        if UIColony:IsTechResearched("SignalBoosters") then
            modifyRadiusOnDiscovery:OnApplyEffect(UIColony, nil)
        end
    end
end

OnMsg.CityStart = AdvancedSignalBoosters
OnMsg.LoadGame = AdvancedSignalBoosters

-- Accidentally applied the signal booster effect too many times before; let's start over
function SavegameFixups.TremualinFixSignalBoosters2()
    Presets.TechPreset.ReconAndExpansion["SignalBoosters"].Tremualin_AdvancedSignalBoosters = false
end

local applyAntiFreeze
local removeColonistsFromWrongMap

local function ModOptions(id)
    if id and id ~= CurrentModId then
        return
    end

    applyAntiFreeze = CurrentModOptions:GetProperty("ApplyAntiFreeze")
    removeColonistsFromWrongMap = CurrentModOptions:GetProperty("RemoveColonistsFromWrongMap")
end

OnMsg.ModsReloaded = ModOptions
OnMsg.ApplyModOptions = ModOptions

local Orig_Tremualin_Colonist_DailyUpdate = Colonist.DailyUpdate
function Colonist:DailyUpdate()
    if applyAntiFreeze then
        self.Tremualin_Abandoned_Counter = 0
    end
    Orig_Tremualin_Colonist_DailyUpdate(self)
end

local Orig_Tremualin_Colonist_Abandoned = Colonist.Abandoned
function Colonist:Abandoned()
    if applyAntiFreeze then
        self.Tremualin_Abandoned_Counter = self.Tremualin_Abandoned_Counter or 0
        self.Tremualin_Abandoned_Counter = self.Tremualin_Abandoned_Counter + 1
        if (self.Tremualin_Abandoned_Counter > 100) then
            self:SetCommand("Die")
        end
    end
    Orig_Tremualin_Colonist_Abandoned(self)
end

local function RemoveFromLabelsInAnotherCity(colonist, city)
    city:RemoveFromLabel(colonist.gender == "OtherGender" and "ColonistOther" or colonist.gender == "Male" and "ColonistMale" or "ColonistFemale", colonist)
    city:RemoveFromLabel("Colonist", colonist)
    city:RemoveFromLabel(colonist.specialist, colonist)
    city:RemoveFromLabel("Homeless", colonist)
    city:RemoveFromLabel("Unemployed", colonist)
    city:RemoveFromLabel("Senior", colonist)
    city:RemoveFromLabel("Child", colonist)
    for _, dome in pairs(city.labels.Dome or empty_table) do
        if IsValid(dome) then
            dome:RemoveFromLabel("Colonist", colonist)
            dome:RemoveFromLabel("Homeless", colonist)
            dome:RemoveFromLabel("Unemployed", colonist)
        end
        for trait_id, _ in pairs(colonist.traits) do
            if IsValid(dome) then
                dome:RemoveFromLabel(trait_id, colonist)
            end
        end
    end
end

-- Colonists who are on a dome on one city but also appear on another city will be removed from the wrong city
local function FixColonistsInWrongCity(colonists)
    if removeColonistsFromWrongMap then
        for _, colonist in pairs(colonists) do
            local city = colonist.city
            local dome = colonist.dome
            if city and dome and dome:GetMapID() ~= city:GetMapID() then
                -- dome and colonist are in different maps
                -- remove the colonist from the wrong city labels
                colonist:RemoveFromLabels()
                colonist.city = dome.city
                colonist:SetDome(false)
                colonist:SetDome(dome)
            end
            if city then
                for _, anotherCity in pairs(Cities) do
                    if anotherCity:GetMapID() ~= city:GetMapID() then
                        RemoveFromLabelsInAnotherCity(colonist, anotherCity)
                    end
                end
            end
            colonist:AddToLabels()
        end
    end
end

local function FixAllPossibleColonistsInWrongCity()
    FixColonistsInWrongCity(UIColony.city_labels.labels.Colonist or empty_table)
    for _, city in pairs(Cities) do
        FixColonistsInWrongCity(city.labels.Homeless or empty_table)
        FixColonistsInWrongCity(city.labels.Unemployed or empty_table)
    end
end

OnMsg.LoadGame = FixAllPossibleColonistsInWrongCity
