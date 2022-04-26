local ui_functions = Tremualin.UIFunctions
local TO_MARS_AND_BACK_BUTTON = "Tremualin_ToMarsAndBackButton"
local ASTEROID_CLEAN_UP_BUTTON_ID = "Tremualin_AsteroidCleanUpButton"
local CONVERT_TO_ASTEROID_LANDING_PAD_BUTTON_ID = "Tremualin_AsteroidLandingPadButton"
local SOLAR_ENERGY_LANDER_UPGRADE_ID = "Tremualin_SolarEnergyLanderUpgrade"
local SOLAR_ENERGY_LANDER_DESCRIPTION = Untranslated("Asteroid Landers will use solar energy to navigate space, no longer needing fuel when moving between Asteroids or back to Mars. Asteroid Landers will still need fuel when departing from Mars.")
local MULTIPURPOSE_UPGRADE_STORAGE_UPGRADE_ID = "Tremualin_MultipurposeUpgradeStorageUpgrade"
local MULTIPURPOSE_UPGRADE_STORAGE_DESCRIPTION = Untranslated("Asteroid Landers can store copies of the most common mining upgrades on a special compartment, which means buildings built on Asteroids can be upgraded for free. You won't get the upgrade resources back when dismantling the buildings, however.")

local function AddMultipurposeUpgradeStorageUpgrade()
    local function AddMultipurposeUpgradeStorageUpgradeToObject(obj)
        obj.upgrade3_id = MULTIPURPOSE_UPGRADE_STORAGE_UPGRADE_ID
        obj.upgrade3_description = MULTIPURPOSE_UPGRADE_STORAGE_DESCRIPTION
        obj.upgrade3_display_name = Untranslated("Multipurpose Upgrade Storage")
        obj.upgrade3_icon = "UI/Icons/Upgrades/zero_space_01.tga"
        obj.upgrade3_upgrade_cost_PreciousMinerals = 70000
    end

    AddMultipurposeUpgradeStorageUpgradeToObject(ClassTemplates.Building.LanderRocket)
    AddMultipurposeUpgradeStorageUpgradeToObject(BuildingTemplates.LanderRocket)

    local tech = Presets.TechPreset.ReconAndExpansion["ExtendedCargoModules"]
    local modified = tech.Tremualin_MultipurposeUpgradeStorage
    if not modified then
        tech.description = Untranslated("Asteroid Lander Upgrade (<em>Multipurpose Upgrade Storage</em>) - ") .. MULTIPURPOSE_UPGRADE_STORAGE_DESCRIPTION .. "\n" .. tech.description
        table.insert(tech, #tech + 1, PlaceObj("Effect_UnlockUpgrade", {
            Upgrade = MULTIPURPOSE_UPGRADE_STORAGE_UPGRADE_ID
        }))
        tech.Tremualin_MultipurposeUpgradeStorage = true
    end
end

local function UnlockMultipurposeUpgradeStorageUpgrade()
    if UIColony:IsTechResearched("ExtendedCargoModules") and not UIColony:IsUpgradeUnlocked(MULTIPURPOSE_UPGRADE_STORAGE_UPGRADE_ID) then
        UnlockUpgrade(MULTIPURPOSE_UPGRADE_STORAGE_UPGRADE_ID, MainCity)
    end
end

OnMsg.LoadGame = UnlockMultipurposeUpgradeStorageUpgrade

local function AddSolarEnergyLanderUpgrade()
    local function AddSolarEnergyLanderUpgradeToObject(obj)
        obj.upgrade2_id = SOLAR_ENERGY_LANDER_UPGRADE_ID
        obj.upgrade2_description = SOLAR_ENERGY_LANDER_DESCRIPTION
        obj.upgrade2_display_name = Untranslated("Solar Energy Landers")
        obj.upgrade2_icon = "UI/Icons/Upgrades/Improved_Photovoltaics_01.tga"
        obj.upgrade2_upgrade_cost_PreciousMinerals = 35000
    end

    AddSolarEnergyLanderUpgradeToObject(ClassTemplates.Building.LanderRocket)
    AddSolarEnergyLanderUpgradeToObject(BuildingTemplates.LanderRocket)

    local tech = Presets.TechPreset.ReconAndExpansion["MineralApplications"]
    local modified = tech.Tremualin_SolarEnergyLanders
    if not modified then
        tech.description = Untranslated("Asteroid Lander Upgrade (<em>Solar Energy Landers</em>) - ") .. SOLAR_ENERGY_LANDER_DESCRIPTION .. "\n" .. tech.description
        table.insert(tech, #tech + 1, PlaceObj("Effect_UnlockUpgrade", {
            Upgrade = SOLAR_ENERGY_LANDER_UPGRADE_ID
        }))
        tech.Tremualin_SolarEnergyLanders = true
    end
end

local function UnlockSolarEnergyLandersUpgrade()
    if UIColony:IsTechResearched("MineralApplications") and not UIColony:IsUpgradeUnlocked(SOLAR_ENERGY_LANDER_UPGRADE_ID) then
        UnlockUpgrade(SOLAR_ENERGY_LANDER_UPGRADE_ID, MainCity)
    end
end

OnMsg.LoadGame = UnlockSolarEnergyLandersUpgrade

local function AddToMarsAndBackButton()
    local template = XTemplates.customLanderRocket
    ui_functions.RemoveXTemplateSections(template, TO_MARS_AND_BACK_BUTTON)
    local toMarsAndBackbutton = PlaceObj("XTemplateTemplate", {
        TO_MARS_AND_BACK_BUTTON, true,
        "__template", "InfopanelButton",
        "__context_of_kind", "LanderRocketBase",
        "RolloverTitle", Untranslated("Advanced B&B (Mod)"),
        "OnContextUpdate", function(self, context)
            if ObjectIsInEnvironment(context, "Asteroid") then
                self:SetVisible(true)
                self:SetIcon(context.Tremualin_ToMarsAndBack and "UI/Icons/IPButtons/cancel.tga" or "UI/Icons/IPButtons/automated_mode.tga")
                self:SetRolloverText(context.Tremualin_ToMarsAndBack and Untranslated("Cancel returning from Mars automatically") or Untranslated("Automatically return from Mars after refueling, with all the drones and enough fuel for a trip back, landing in the same spot"))
            else
                self:SetVisible(false)
            end
        end,
        "OnPress", function(self, gamepad)
            local context = self.context
            context.Tremualin_ToMarsAndBack = not context.Tremualin_ToMarsAndBack
            if not context.Tremualin_ToMarsAndBack then
                context.target_spot = nil
            end
        end
    })

    table.insert(template, #template + 1, toMarsAndBackbutton)
end

local function AddAsteroidCleanupButton()
    local template = XTemplates.customLanderRocket
    ui_functions.RemoveXTemplateSections(template, ASTEROID_CLEAN_UP_BUTTON_ID)
    local asteroidCleanUpbutton = PlaceObj("XTemplateTemplate", {
        ASTEROID_CLEAN_UP_BUTTON_ID, true,
        "__template", "InfopanelButton",
        "__context_of_kind", "LanderRocketBase",
        "RolloverTitle", Untranslated("Advanced B&B (Mod)"),
        "RolloverText", Untranslated("Salvage/Refab all buildings on this Asteroid"),
        "OnContextUpdate", function(self, context)
            if ObjectIsInEnvironment(context, "Asteroid") then
                self:SetVisible(true)
                self:SetIcon(context.Tremualin_AsteroidCleanUp and "UI/Icons/IPButtons/cancel.tga" or "UI/Icons/IPButtons/refab.tga")
            else
                self.Tremualin_AsteroidCleanUp = false
                self:SetVisible(false)
            end
        end,
        "OnPress", function(self, gamepad)
            local context = self.context
            context.Tremualin_AsteroidCleanUp = not context.Tremualin_AsteroidCleanUp
            local refabOrDestroy = function(o)
                if o:IsRefabable() and not o:IsKindOf("StorageDepot") then
                    if o:CanRefab() then
                        o:ToggleRefab()
                    elseif o:CanDemolish()
                        then o:ToggleDemolish()
                    end
                end
            end
            GetRealmByID(context:GetMapID()):MapForEach("map", "Refabable", refabOrDestroy)
        end
    })

    table.insert(template, #template + 1, asteroidCleanUpbutton)
end

local function AddConvertToAsteroidLandingPadButton()
    local converToAsteroidLandingPadButton = PlaceObj("XTemplateTemplate", {
        CONVERT_TO_ASTEROID_LANDING_PAD_BUTTON_ID, true,
        "comment", "convert",
        "__template", "InfopanelButton",
        "__condition", function(parent, context)
            return context.Id ~= "AsteroidLanderPad"
        end,
        "RolloverText", Untranslated("Convert this Pad to an Asteroid Lander Pad, used to service Asteroid Landers."),
        "RolloverDisabledText", T(545435213473, "Cannot be converted while servicing landed or inbound Rockets"),
        "RolloverTitle", Untranslated("Convert to Asteroid Lander Pad"),
        "OnContextUpdate", function(self, context, ...)
            self:SetEnabled(context:IsAvailable())
        end,
        "OnPress", function(self, gamepad)
            ConvertPad(self.context, "AsteroidLanderPad")
        end,
        "Icon", "UI/Icons/IPButtons/build.tga"
    })

    local template = XTemplates.customTradePad
    ui_functions.RemoveXTemplateSections(template, CONVERT_TO_ASTEROID_LANDING_PAD_BUTTON_ID)
    table.insert(template, #template + 1, converToAsteroidLandingPadButton)

    local template = XTemplates.customLandingPad
    ui_functions.RemoveXTemplateSections(template, CONVERT_TO_ASTEROID_LANDING_PAD_BUTTON_ID)
    table.insert(template, #template + 1, converToAsteroidLandingPadButton)
end

local function IsInAnAsteroid(object)
    return ObjectIsInEnvironment(object, "Asteroid")
end

local function LanderHasMultipurposeUpgradeStorageFilter(key, value)
    return value:HasUpgrade(MULTIPURPOSE_UPGRADE_STORAGE_UPGRADE_ID)
end

function OnMsg.ClassesPostprocess()
    AddMultipurposeUpgradeStorageUpgrade()
    AddSolarEnergyLanderUpgrade()
    AddToMarsAndBackButton()
    AddAsteroidCleanupButton()
    AddConvertToAsteroidLandingPadButton()

    local Orig_Tremualin_LanderRocketBase_PrepareLanding = LanderRocketBase.PrepareLanding
    function LanderRocketBase:PrepareLanding(target)
        Orig_Tremualin_LanderRocketBase_PrepareLanding(self, target)
        if target.id == "OurColony" then
            local asteroidLanderPads = Cities[MainMapID].labels.AsteroidLanderPad
            if asteroidLanderPads and #asteroidLanderPads > 0 then
                for _, landerPad in pairs(asteroidLanderPads) do
                    if landerPad:IsAvailable() then
                        self.landing_site = PlaceBuildingIn("RocketLandingSite", landerPad:GetMapID())
                        self.landing_site:SetAngle(landerPad:GetAngle())
                        self.landing_site:SetPos(landerPad:GetPos())
                        self.landing_site.landing_pad = landerPad
                        self:SetCommand("LandOnMars", self.landing_site)
                        break
                    end
                end
            end
        elseif self.last_asteroid_visited == target and self.last_asteroid_landing_site_angle and self.last_asteroid_landing_site_pos then
            self.landing_site = PlaceBuildingIn("RocketLandingSite", self.last_asteroid_visited.id)
            self.landing_site:SetAngle(self.last_asteroid_landing_site_angle)
            self.landing_site:SetPos(self.last_asteroid_landing_site_pos)
            self:SetCommand("LandOnMars", self.landing_site)
        end
    end

    local Orig_Tremualin_LanderRocketBase_OnLanded = LanderRocketBase.OnLanded
    function LanderRocketBase:OnLanded()
        if IsInAnAsteroid(self) then
            self.last_asteroid_visited = self.target_spot
            if self:IsUpgradeOn(SOLAR_ENERGY_LANDER_UPGRADE_ID) then
                self.launch_fuel = 0
                if self.refuel_request then
                    self.refuel_request:SetAmount(0)
                end
            end
        else
            self.launch_fuel = self.base_launch_fuel
        end
        Orig_Tremualin_LanderRocketBase_OnLanded(self)
    end

    local Orig_Tremualin_RocketBase_WaitLaunchOrder = RocketBase.WaitLaunchOrder
    function LanderRocketBase:WaitLaunchOrder()
        if self.Tremualin_ToMarsAndBack
            and self.last_asteroid_visited
            and UIColony:IsActiveColonyMap(self.last_asteroid_visited.id)
            and not IsInAnAsteroid(self) then
            local fuel_needed_to_return = self:IsUpgradeOn(SOLAR_ENERGY_LANDER_UPGRADE_ID) and 0 or self.launch_fuel / const.ResourceScale
            -- Sometimes drones are sent on missions or whatever; take at least 5
            local return_cargo_request = {Drone = {amount = Max(5, #self.drones), class = Drone, type = Drone}, Fuel = {amount = fuel_needed_to_return, class = Fuel, type = Resource}}
            local existing_cargo_request = self.cargo or empty_table
            for key, existing_resource_request in pairs(existing_cargo_request) do
                local new_resource_request = table.copy(existing_resource_request)
                local return_resource_request = return_cargo_request[key] or empty_table
                -- If the player choose more fuel or drones; we'll respect that
                new_resource_request.amount = Max(new_resource_request.requested or 0, return_resource_request.amount or 0)
                new_resource_request.requested = nil
                return_cargo_request[key] = new_resource_request
            end
            CargoTransporter.SetCargoRequest(self, return_cargo_request, empty_table)
            self.target_spot = self.last_asteroid_visited
            self:SetCommand("LoadAndLaunch", function() return self.target_spot end)
        else
            Orig_Tremualin_RocketBase_WaitLaunchOrder(self)
        end
    end

    local Orig_Tremualin_LanderRocketBase_HourlyUpdate = LanderRocketBase.HourlyUpdate
    function LanderRocketBase:HourlyUpdate(hour)
        Orig_Tremualin_LanderRocketBase_HourlyUpdate(self, hour)
        if self:IsRocketLanded()
            and IsInAnAsteroid(self)
            and self.Tremualin_ToMarsAndBack
            and not HasDustStorm(MainMapID)
            -- We will issue the return command when we are close to a full cargo
            and self.cargo_capacity - self:CalculatePayloadWeight() <= 5000 then
            self.target_spot = HomeColonySpot()
            self:SetCommand("LoadAndLaunch", function() return self.target_spot end)
        end
    end

    local Orig_Tremualin_Building_GatherUpgradeSpentResources = Building.GatherUpgradeSpentResources
    function Building:GatherUpgradeSpentResources()
        if IsInAnAsteroid(self)
            and not self:IsKindOf("LanderRocket")
            and #table.filter(Cities[self:GetMapID()].labels.LanderRocketBase, LanderHasMultipurposeUpgradeStorageFilter) > 0 then
            return {}
        end
        return Orig_Tremualin_Building_GatherUpgradeSpentResources(self)
    end

    local Orig_Tremualin_LanderRocketBase_OnUpgradeToggled = LanderRocketBase.OnUpgradeToggled
    function LanderRocketBase:OnUpgradeToggled(upgrade_id, new_state)
        if upgrade_id == SOLAR_ENERGY_LANDER_UPGRADE_ID then
            if new_state then
                if IsInAnAsteroid(self) then
                    self.launch_fuel = 0
                    if self.refuel_request then
                        self.refuel_request:SetAmount(0)
                    end
                end
            else
                self.launch_fuel = self.base_launch_fuel
            end
        end
        if Orig_Tremualin_LanderRocketBase_OnUpgradeToggled then
            Orig_Tremualin_LanderRocketBase_OnUpgradeToggled(self, upgrade_id, new_state)
        end
    end
end

local function FullyUpgradeBuilding(upgradableBuilding)
    if upgradableBuilding:IsKindOf("UpgradableBuilding") then
        if UIColony:IsUpgradeUnlocked(upgradableBuilding:GetUpgradeID(1)) then
            upgradableBuilding:CheatUpgrade1()
        end
        if UIColony:IsUpgradeUnlocked(upgradableBuilding:GetUpgradeID(2)) then
            upgradableBuilding:CheatUpgrade2()
        end
        if UIColony:IsUpgradeUnlocked(upgradableBuilding:GetUpgradeID(3)) then
            upgradableBuilding:CheatUpgrade3()
        end
    end
end

local function FullyUpgradeAllNonLanderBuildings(city)
    local labels = city.labels or empty_table
    local buildings = labels.Building or empty_table
    for _, upgradableBuilding in pairs(buildings) do
        if not upgradableBuilding:IsKindOf("LanderRocket") then
            FullyUpgradeBuilding(upgradableBuilding)
        end
    end
end

function OnMsg.AsteroidRocketLanded(lander)
    if IsInAnAsteroid(lander) then
        lander.last_asteroid_landing_site_angle = lander.landing_site:GetAngle()
        lander.last_asteroid_landing_site_pos = lander.landing_site:GetPos()
        if lander:HasUpgrade(MULTIPURPOSE_UPGRADE_STORAGE_UPGRADE_ID) then
            FullyUpgradeAllNonLanderBuildings(Cities[lander:GetMapID()] or empty_table)
        end
    end
end

function OnMsg.BuildingUpgraded(building, upgrade_id)
    if upgrade_id == MULTIPURPOSE_UPGRADE_STORAGE_UPGRADE_ID and IsInAnAsteroid(building) then
        FullyUpgradeAllNonLanderBuildings(Cities[building:GetMapID()] or empty_table)
    end
end

function OnMsg.BuildingInit(bld)
    if IsInAnAsteroid(bld) then
        local city = Cities[bld:GetMapID()] or empty_table
        local labels = city.labels or empty_table
        local landerRockets = labels.LanderRocketBase or empty_table

        if #table.filter(landerRockets, LanderHasMultipurposeUpgradeStorageFilter) > 0 then
            FullyUpgradeBuilding(bld)
        end
    end
end
