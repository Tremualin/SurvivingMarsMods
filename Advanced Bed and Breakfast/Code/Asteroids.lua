local HasDustStorm = HasDustStorm
local HomeColonySpot = HomeColonySpot
local CargoTransporter = CargoTransporter

local IsInAnAsteroid = Tremualin.Functions.IsInAnAsteroid
local IsAsteroidCity = Tremualin.Functions.IsAsteroidCity
local RemoveXTemplateSections = Tremualin.UIFunctions.RemoveXTemplateSections

local TO_MARS_AND_BACK_BUTTON = "Tremualin_ToMarsAndBackButton"
local ASTEROID_CLEAN_UP_BUTTON_ID = "Tremualin_AsteroidCleanUpButton"
local CONVERT_TO_ASTEROID_LANDING_PAD_BUTTON_ID = "Tremualin_AsteroidLandingPadButton"
local SOLAR_ENERGY_LANDER_UPGRADE_ID = "Tremualin_SolarEnergyLanderUpgrade"
-- Shorter description, which will show up on top of the upgrade
local SOLAR_ENERGY_LANDER_DESCRIPTION = Untranslated("Asteroid Landers will use solar energy to navigate space, no longer needing fuel when moving between Asteroids or back to Mars. Asteroid Landers will still need fuel when departing from Mars.")
local MULTIPURPOSE_UPGRADE_STORAGE_UPGRADE_ID = "Tremualin_MultipurposeUpgradeStorageUpgrade"
-- Shorter description, which will show up on top of the upgrade
local MULTIPURPOSE_UPGRADE_STORAGE_DESCRIPTION = Untranslated("Asteroid Landers can store copies of the most common mining upgrades on a special compartment, which means buildings built on Asteroids can be upgraded for free. You won't get the upgrade resources back when dismantling the buildings, however.")

-- Add MultipurposeUpgradeStorage to ExtendedCargoModules
-- Don't forget to modify the tech description
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

    local tech = Presets.TechPreset.ReconAndExpansion.ExtendedCargoModules
    local modified = tech.Tremualin_MultipurposeUpgradeStorage
    if not modified then
        -- Longer description, to be shown on top of the tech description
        tech.description = Untranslated("Asteroid Lander Upgrade (<em>Multipurpose Upgrade Storage</em>) - ") .. MULTIPURPOSE_UPGRADE_STORAGE_DESCRIPTION .. "\n" .. tech.description
        table.insert(tech, #tech + 1, PlaceObj("Effect_UnlockUpgrade", {
            Upgrade = MULTIPURPOSE_UPGRADE_STORAGE_UPGRADE_ID
        }))
        tech.Tremualin_MultipurposeUpgradeStorage = true
    end
end

-- If the game wasn't started with this mod on; will unlock the upgrade
function SavegameFixups.Tremualin_UnlockMultipurposeUpgradeStorageUpgrade()
    if UIColony:IsTechResearched("ExtendedCargoModules") and
        not UIColony:IsUpgradeUnlocked(MULTIPURPOSE_UPGRADE_STORAGE_UPGRADE_ID) then
        UnlockUpgrade(MULTIPURPOSE_UPGRADE_STORAGE_UPGRADE_ID, MainCity)
    end
end

-- Add SolarEnergyLanderUpgrade to Mineral Applications
-- Don't forget to modify the tech description
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

    local tech = Presets.TechPreset.ReconAndExpansion.MineralApplications
    local modified = tech.Tremualin_SolarEnergyLanders
    if not modified then
        -- Longer description, to be shown on top of the tech description
        tech.description = Untranslated("Asteroid Lander Upgrade (<em>Solar Energy Landers</em>) - ") .. SOLAR_ENERGY_LANDER_DESCRIPTION .. "\n" .. tech.description
        table.insert(tech, #tech + 1, PlaceObj("Effect_UnlockUpgrade", {
            Upgrade = SOLAR_ENERGY_LANDER_UPGRADE_ID
        }))
        tech.Tremualin_SolarEnergyLanders = true
    end
end

-- Make sure Solar Energy Lander is unlocked for old save games
function SavegameFixups.UnlockSolarEnergyLandersUpgrade()
    if UIColony:IsTechResearched("MineralApplications")
        and not UIColony:IsUpgradeUnlocked(SOLAR_ENERGY_LANDER_UPGRADE_ID) then
        UnlockUpgrade(SOLAR_ENERGY_LANDER_UPGRADE_ID, MainCity)
    end
end

-- Add a ToMarsAndBack button to the Asteroid Lander
-- It makes the Lander go back to Mars, then return to the Asteroid
local function AddToMarsAndBackButton()
    local template = XTemplates.customLanderRocket
    RemoveXTemplateSections(template, TO_MARS_AND_BACK_BUTTON)
    local toMarsAndBackbutton = PlaceObj("XTemplateTemplate", {
        TO_MARS_AND_BACK_BUTTON, true,
        "__template", "InfopanelButton",
        "__context_of_kind", "LanderRocketBase",
        "RolloverTitle", Untranslated("To Mars and Back"),
        "OnContextUpdate", function(self, context)
            local toMarsAndBack = context.Tremualin_ToMarsAndBack
            self:SetVisible(true)
            self:SetIcon(toMarsAndBack and "UI/Icons/IPButtons/cancel.tga" or "UI/Icons/IPButtons/automated_mode.tga")
            self:SetRolloverText(toMarsAndBack and Untranslated("Cancel returning to/from Mars and back to/from the Asteroid automatically") or Untranslated("Automatically return from Mars after refueling, with all the drones and enough fuel for a trip back, landing in the same spot, in the last visited Asteroid"))
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

-- Add a button that refabbs/destroys (if it cannot be refabbed) everything in the Asteroid
-- Useful for cleaning up after we are done with the Asteroid
local function AddAsteroidCleanupButton()
    local template = XTemplates.customLanderRocket
    RemoveXTemplateSections(template, ASTEROID_CLEAN_UP_BUTTON_ID)
    local asteroidCleanUpbutton = PlaceObj("XTemplateTemplate", {
        ASTEROID_CLEAN_UP_BUTTON_ID, true,
        "__template", "InfopanelButton",
        "__context_of_kind", "LanderRocketBase",
        "RolloverTitle", Untranslated("Advanced B&B (Mod)"),
        "OnContextUpdate", function(self, context)
            if UIColony:IsTechResearched("PrefabRefab") and IsInAnAsteroid(context) then
                self:SetVisible(true)
                self:SetRolloverText(context.Tremualin_AsteroidCleanUp and Untranslated("Cancel refabbing all buildings on this Asteroid") or Untranslated("Refab all buildings on this Asteroid"))
                self:SetIcon(context.Tremualin_AsteroidCleanUp and "UI/Icons/IPButtons/cancel.tga" or "UI/Icons/IPButtons/refab.tga")
            else
                context.Tremualin_AsteroidCleanUp = false
                self:SetVisible(false)
            end
        end,
        "OnPress", function(self, gamepad)
            local context = self.context
            context.Tremualin_AsteroidCleanUp = not context.Tremualin_AsteroidCleanUp
            local refabOrDestroy = function(o)
                -- Refab/destroy only those that are Refablable
                -- Except StorageDepots, which for some reason are Refabable
                if o:IsRefabable() and not o:IsKindOf("StorageDepot") then
                    if o:CanRefab() then
                        o:ToggleRefab()
                    end
                end
            end
            GetRealmByID(context:GetMapID()):MapForEach("map", "Refabable", refabOrDestroy)
        end
    })

    table.insert(template, #template + 1, asteroidCleanUpbutton)
end

-- Add a button to transform a Landing Pad into an Asteroid Lander Pad
-- If Space Race (gagarin) is installed, then also apply it to Trade Pads
-- So that the Asteroid Landers can automatically use them
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

    local template
    if IsDlcAvailable("gagarin") then
        template = XTemplates.customTradePad
        RemoveXTemplateSections(template, CONVERT_TO_ASTEROID_LANDING_PAD_BUTTON_ID)
        table.insert(template, #template + 1, converToAsteroidLandingPadButton)
    end

    template = XTemplates.customLandingPad
    RemoveXTemplateSections(template, CONVERT_TO_ASTEROID_LANDING_PAD_BUTTON_ID)
    table.insert(template, #template + 1, converToAsteroidLandingPadButton)
end

-- A function used to filter landers that have been upgraded with the multipurpose upgrade storage
local function LanderHasMultipurposeUpgradeStorageFilter(key, value)
    return value:HasUpgrade(MULTIPURPOSE_UPGRADE_STORAGE_UPGRADE_ID)
end

-- Makes the Asteroid Lander land in Mars if there's an Asteroid Lander Pad
-- Makes the Asteroid Lander land in the Asteroid, in the same place where it was before
local Orig_Tremualin_LanderRocketBase_PrepareLanding = LanderRocketBase.PrepareLanding
function LanderRocketBase:PrepareLanding(target)
    Orig_Tremualin_LanderRocketBase_PrepareLanding(self, target)
    if target.id == "OurColony" then
        if HasDustStorm(MainMapID) then
            WaitMsg("DustStormEnded")
        end
        local padFound = false
        -- Try landing until a pad is found, the rocket lands manually, or it somehow goes to an asteroid
        while not padFound or self:IsRocketLanded() or IsInAnAsteroid(self) do
            local asteroidLanderPads = Cities[MainMapID].labels.AsteroidLanderPad or empty_table
            if #asteroidLanderPads == 0 then
                -- There are no asteroid lander pads
                -- Most likely, the rocket will be landed manually
                WaitMsg("RocketLanded")
            else
                for _, landerPad in pairs(asteroidLanderPads) do
                    if landerPad:IsAvailable() then
                        self.landing_site = PlaceBuildingIn("RocketLandingSite", landerPad:GetMapID())
                        self.landing_site:SetAngle(landerPad:GetAngle())
                        self.landing_site:SetPos(landerPad:GetPos())
                        self.landing_site.landing_pad = landerPad
                        self:SetCommand("LandOnMars", self.landing_site)
                        padFound = true
                        break
                    end
                end
                if not padFound then
                    -- If none of the pads is available, we wait for another rocket to launch and make some space
                    WaitMsg("RocketLanded")
                end
            end
        end
    elseif self.Tremualin_ToMarsAndBack
        and self.last_asteroid_visited == target
        and self.last_asteroid_landing_site_angle
        and self.last_asteroid_landing_site_pos then
        -- If returning to an Asteroid, and ToMarsAndBack is enabled, land in the same spot
        self.landing_site = PlaceBuildingIn("RocketLandingSite", self.last_asteroid_visited.id)
        self.landing_site:SetAngle(self.last_asteroid_landing_site_angle)
        self.landing_site:SetPos(self.last_asteroid_landing_site_pos)
        self:SetCommand("LandOnMars", self.landing_site)
    end
end

-- The Solar Energy Lander upgrade is applies only if the lander is in an Asteroid
-- And sets the lander fuel cost to 0
local function ApplySolarEnergyLanderUpgradeIfPossible(lander)
    if lander:IsUpgradeOn(SOLAR_ENERGY_LANDER_UPGRADE_ID) then
        lander:SetModifier("launch_fuel", SOLAR_ENERGY_LANDER_UPGRADE_ID, 0, -1000)
        if lander.refuel_request then
            lander.refuel_request:SetAmount(0)
        end
    end
end

-- If landing in an asteroid, see if the Solar Energy Lander upgrade can be applied
-- IF landing on Mars, then remove the Solar Energy Lander discount; it only applies on Asteroids
local Orig_Tremualin_LanderRocketBase_OnLanded = LanderRocketBase.OnLanded
function LanderRocketBase:OnLanded()
    if IsInAnAsteroid(self) then
        self.last_asteroid_visited = self.target_spot
        ApplySolarEnergyLanderUpgradeIfPossible(self)
    else
        self:SetModifier("launch_fuel", SOLAR_ENERGY_LANDER_UPGRADE_ID, 0, 0)
    end
    Orig_Tremualin_LanderRocketBase_OnLanded(self)
end

-- Check every hour if we need to go back to Mars
-- Which happens if we are landed on an Asteroid, the main city doesn't have a dust storm
-- And we are close to full cargo
local Orig_Tremualin_LanderRocketBase_HourlyUpdate = LanderRocketBase.HourlyUpdate
function LanderRocketBase:HourlyUpdate(hour)
    -- Slow down the rate at which the payload is recalculated
    -- But keep doing it anyway, because drones tend to get silly
    if hour == 4 or hour == 12 or hour == 20 then
        Orig_Tremualin_LanderRocketBase_HourlyUpdate(self, hour)
    end

    if self:IsRocketLanded()
        and self.Tremualin_ToMarsAndBack
        and IsInAnAsteroid(self)
        and not HasDustStorm(MainMapID)
        -- We will issue the return command when we are close to a full cargo, to avoid empty departures
        and self.cargo_capacity - self:CalculatePayloadWeight() <= 5000 then
        self.target_spot = HomeColonySpot()
        self:SetCommand("LoadAndLaunch", function() return self.target_spot end)
    end
end

-- Prevents the user from destroying buildings that have been upgraded for free in Asteroids
local Orig_Tremualin_Building_GatherUpgradeSpentResources = Building.GatherUpgradeSpentResources
function Building:GatherUpgradeSpentResources()
    if IsInAnAsteroid(self)
        and not self:IsKindOf("LanderRocket")
        and #table.filter(Cities[self:GetMapID()].labels.LanderRocketBase, LanderHasMultipurposeUpgradeStorageFilter) > 0 then
        return {}
    end
    return Orig_Tremualin_Building_GatherUpgradeSpentResources(self)
end

-- If we enable/disable the Solar Energy Lander Upgrade, we should update the required fuel accordingly
function LanderRocketBase:OnUpgradeToggled(upgrade_id, new_state)
    if upgrade_id == SOLAR_ENERGY_LANDER_UPGRADE_ID then
        if new_state and IsInAnAsteroid(self) then
            ApplySolarEnergyLanderUpgradeIfPossible(self)
        else
            self:SetModifier("launch_fuel", SOLAR_ENERGY_LANDER_UPGRADE_ID, 0, 0)
        end
    end
end

-- Try to fully upgrade all upgradable buildings (except ConstructionSites)
-- Called by the MultipurposeStorage Upgrade, in Asteroids
local function FullyUpgradeBuildingIfPossible(bld)
    if bld:IsKindOf("UpgradableBuilding")
        and not bld:IsKindOf("ConstructionSite") then
        if UIColony:IsUpgradeUnlocked(bld:GetUpgradeID(1)) then
            bld:CheatUpgrade1()
        end
        if UIColony:IsUpgradeUnlocked(bld:GetUpgradeID(2)) then
            bld:CheatUpgrade2()
        end
        if UIColony:IsUpgradeUnlocked(bld:GetUpgradeID(3)) then
            bld:CheatUpgrade3()
        end
    end
end

-- Upgrades all buildings in the Asteroid
-- Except for the Lander
local function FullyUpgradeAllNonLanderBuildings(city)
    local labels = city.labels or empty_table
    local buildings = labels.Building or empty_table
    for _, bld in pairs(buildings) do
        if not bld:IsKindOf("LanderRocket") then
            FullyUpgradeBuildingIfPossible(bld)
        end
    end
end

-- Apply the effects of the upgrades immediately upon landing with the Multipurpose Upgrade
function OnMsg.AsteroidRocketLanded(lander)
    if IsInAnAsteroid(lander) then
        lander.last_asteroid_landing_site_angle = lander.landing_site:GetAngle()
        lander.last_asteroid_landing_site_pos = lander.landing_site:GetPos()
        if lander:HasUpgrade(MULTIPURPOSE_UPGRADE_STORAGE_UPGRADE_ID) then
            FullyUpgradeAllNonLanderBuildings(Cities[lander:GetMapID()] or empty_table)
        end
    end
end

-- Apply the effects of the upgrades immediately upon upgrading
function OnMsg.BuildingUpgraded(building, upgrade_id)
    if upgrade_id == SOLAR_ENERGY_LANDER_UPGRADE_ID and IsInAnAsteroid(building) then
        ApplySolarEnergyLanderUpgradeIfPossible(building)
    end
    if upgrade_id == MULTIPURPOSE_UPGRADE_STORAGE_UPGRADE_ID and IsInAnAsteroid(building) then
        FullyUpgradeAllNonLanderBuildings(Cities[building:GetMapID()] or empty_table)
    end
end

local function CityHasAsteroidLander(city)
    local labels = city.labels or empty_table
    local landerRockets = labels.LanderRocketBase or empty_table

    return #table.filter(landerRockets, LanderHasMultipurposeUpgradeStorageFilter) > 0
end

-- If there's a lander with the multipurpose upgrade storage; fully upgrade newly built buildings
function OnMsg.ConstructionComplete(bld)
    if bld:IsKindOf("UpgradableBuilding") and IsInAnAsteroid(bld) then
        local city = Cities[bld:GetMapID()] or empty_table
        if CityHasAsteroidLander(city) then
            -- Even though construction is complete, the building isn't always initialized
            -- So let's upgrade it after sleeping for 100 seconds
            CreateRealTimeThread(function()
                Sleep(100)
                FullyUpgradeBuildingIfPossible(bld)
            end)
        end
    end
end

-- If a new upgrade is unlocked, and multipurpose upgrade storage is available,
-- then upgrade all buildings on the asteroid one more time
function OnMsg.UpgradeUnlocked(upg)
    if UIColony:IsUpgradeUnlocked(MULTIPURPOSE_UPGRADE_STORAGE_UPGRADE_ID) then
        for _, city in ipairs(table.filter(Cities, IsAsteroidCity)) do
            if CityHasAsteroidLander(city) then
                FullyUpgradeAllNonLanderBuildings(city)
            end
        end
    end
end

-- Unlock all the upgrades
-- Add all the buttons
function OnMsg.ClassesPostprocess()
    AddMultipurposeUpgradeStorageUpgrade()
    AddSolarEnergyLanderUpgrade()
    AddToMarsAndBackButton()
    AddAsteroidCleanupButton()
    AddConvertToAsteroidLandingPadButton()

    -- If we are on Mars, an the asteroid still exists,
    -- then prepare the launch order to get back with the same amount of Drones
    -- TODO: why is this inline?
    local Orig_Tremualin_RocketBase_WaitLaunchOrder = RocketBase.WaitLaunchOrder
    function LanderRocketBase:WaitLaunchOrder()
        if self.Tremualin_ToMarsAndBack
            and self.last_asteroid_visited
            and UIColony:IsActiveColonyMap(self.last_asteroid_visited.id)
            and not IsInAnAsteroid(self) then
            local fuel_needed_to_return = self:IsUpgradeOn(SOLAR_ENERGY_LANDER_UPGRADE_ID) and 0 or (self.launch_fuel / const.ResourceScale)
            local return_cargo_request = {Drone = {amount = #self.drones, class = "Drone", type = "Drone"}, Fuel = {amount = fuel_needed_to_return, class = "Fuel", type = "Resource"}}
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
end
