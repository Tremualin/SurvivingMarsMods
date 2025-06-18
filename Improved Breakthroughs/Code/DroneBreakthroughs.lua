local DRONE_TECHS = {"AdvancedDroneDrive", "ArtificialMuscles", "WirelessPower"}
local WIRELESS_POWER_ADDITIONAL_DESCRIPTION = Untranslated("\n\nUnlocks either <em>Advanced Drone Drive or Artificial Muscles</em>. Unless already unlocked")
local ADVANCED_DRONE_DRIVE_ADDITIONAL_DESCRIPTION = Untranslated("\n\nUnlocks either <em>Artificial Muscles or Wireless Power</em>. Unless already unlocked")
local ARTIFICIAL_MUSLCES_ADDITIONAL_DESCRIPTION = Untranslated("\n\nUnlocks either <em>Advanced Drone Drive or Wireless Power</em>. Unless already unlocked")

local function ModifyDescription(tech, new_description)
    if not tech.Tremualin_DiscoverFirstUndiscoveredDroneTechDescription then
        tech.description = tech.description .. new_description
        tech.Tremualin_DiscoverFirstUndiscoveredDroneTechDescription = true
    end
end

local function DiscoverFirstUndiscoveredDroneTech(self, colony, parent)
    for _, tech in ipairs(DRONE_TECHS) do
        if not colony:IsTechDiscovered(tech) then
            colony:SetTechDiscovered(tech)
            break
        end
    end
end

-- Researching one of these will eventually research them all
function ImproveDroneBreakthroughts()
    local artificialMuscles = Presets.TechPreset.Breakthroughs["ArtificialMuscles"]
    local advancedDroneDrive = Presets.TechPreset.Breakthroughs["AdvancedDroneDrive"]
    local wirelessPower = Presets.TechPreset.Breakthroughs["WirelessPower"]

    if not artificialMuscles[2] then
        table.insert(artificialMuscles, PlaceObj("Effect_Code", {
            OnApplyEffect = DiscoverFirstUndiscoveredDroneTech
        }))
    end

    if not advancedDroneDrive[2] then
        table.insert(advancedDroneDrive, PlaceObj("Effect_Code", {
            OnApplyEffect = DiscoverFirstUndiscoveredDroneTech
        }))
    end

    if not wirelessPower[1] then
        table.insert(wirelessPower, PlaceObj("Effect_Code", {
            OnApplyEffect = DiscoverFirstUndiscoveredDroneTech
        }))
    end

    ModifyDescription(artificialMuscles, ARTIFICIAL_MUSLCES_ADDITIONAL_DESCRIPTION)
    ModifyDescription(advancedDroneDrive, ADVANCED_DRONE_DRIVE_ADDITIONAL_DESCRIPTION)
    ModifyDescription(wirelessPower, WIRELESS_POWER_ADDITIONAL_DESCRIPTION)
end

OnMsg.ClassesPostprocess = ImproveDroneBreakthroughts
