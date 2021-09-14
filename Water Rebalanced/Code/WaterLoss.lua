local water_loss_id = "Tremualin_WaterAtmosphereLoss"
local water_loss_text = Untranslated("Water loss from lack of Atmosphere")

-- Loses 2% of current Water each sol. Reduced by Atmosphere.
function GetWaterLoss()
    local water = MulDivRound(GetTerraformParam("Water"), 1, const.TerraformingScale)
    return MulDivRound(water * -1, (100 * const.TerraformingScale - GetTerraformParam("Atmosphere")) * 0.02, const.TerraformingScale)
end

-- Passively lose water
GlobalVar("WaterLossThread", false)
function InitializeWaterLossThread()
    if IsValidThread(WaterLossThread) then
        DeleteThread(WaterLossThread)
    end
    WaterLossThread = (CreateGameTimeThread(function()
        local sleep = const.HourDuration / 5
        local sol = const.DayDuration
        while true do
            Sleep(sleep)
            local waterLoss = (MulDivRound(GetVegetationReproductionBonus(), sleep, sol))
            if waterLoss > 0 then
                ChangeTerraformParam("Water", waterLoss)
            end
        end
    end))
end

OnMsg.CityStart = InitializeWaterLossThread
OnMsg.LoadGame = InitializeWaterLossThread

-- Show the passive water loss in the UI
function OnMsg.ClassesPostprocess()
    for _, preset in ipairs(Presets.TerraformingParam.Default or empty_table) do
        if preset.id == "Water" then
            if not preset.Factors then preset.Factors = {} end
            local alreadyDefined = false
            for _, factor in ipairs(preset.Factors or empty_table) do
                if factor.Id == water_loss_id then
                    alreadyDefined = true
                    break
                end
            end
            if not alreadyDefined then
                local newFactor = PlaceObj("TerraformingFactorItem", {
                    "Id", water_loss_id, "display_name", water_loss_text, "units", "PerSol", "GetFactorValue",
                    function(self) return GetWaterLoss() end
                })
                table.insert(preset.Factors, newFactor)
            end
            break
        end
    end
end
