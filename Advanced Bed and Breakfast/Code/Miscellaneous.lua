local function SignalBoostersEffect(object)
    if object.work_radius then
        return object.work_radius + (UIColony:IsTechResearched("SignalBoosters") and const.SignalBoostersBuff or 0)
    end
    print("This object has no work radius", object)
    return 0
end

-- Apply Signal Boosters to Rockets
function RocketBase:GetSelectionRadiusScale()
    return SignalBoostersEffect(self)
end

-- Apply Signal Boosters to RCCommanders
function RCRover:GetSelectionRadiusScale()
    if WorkRadiusShownForRover[self] then
        return SignalBoostersEffect(self)
    else
        -- Attack Rovers and other Rovers with hidden areas
        return 0
    end
end

-- Apply Signal Boosters to RCCommanders
function Elevator:GetSelectionRadiusScale()
    return SignalBoostersEffect(self)
end

-- Modify Signal Boosters description and update range of Rockets, RCRovers and Elevators when discovered
local function AdvancedSignalBoosters()
    local tech = Presets.TechPreset.ReconAndExpansion["SignalBoosters"]
    local modified = tech.Tremualin_AdvancedSignalBoosters

    local function BoostSignals(objects)
        local objects = objects or empty_table
        for _, object in ipairs(objects) do
            object:SetUIWorkRadius(object.base_work_radius)
        end
    end

    if not modified then
        local modifyRadiusOnDiscovery = PlaceObj("Effect_Code", {
            OnApplyEffect = function(self, colony, parent)
                BoostSignals(colony.city_labels.labels.Elevator)
                BoostSignals(colony.city_labels.labels.RCRoverAndChildren)
                BoostSignals(colony.city_labels.labels.AllRockets)
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
function SavegameFixups.TremualinFixSignalBoosters()
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

-- Colonists who are on a dome on one city but also appear on another city will be removed from the wrong city
local function FixColonistsInWrongCity()
    if removeColonistsFromWrongMap then
        local colonists = UIColony.city_labels.labels.Colonist or empty_table
        for _, colonist in ipairs(colonists) do
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
            colonist:AddToLabels()
        end
    end
end

OnMsg.LoadGame = FixColonistsInWrongCity
