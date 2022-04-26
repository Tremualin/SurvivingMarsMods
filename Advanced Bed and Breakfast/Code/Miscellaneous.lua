local function AdvancedSignalBoosters()
    local tech = Presets.TechPreset.ReconAndExpansion["SignalBoosters"]
    local modified = tech.Tremualin_AdvancedSignalBoosters
    if not modified then
        local function BoostSignals(objects)
            local objects = objects or empty_table
            for _, object in ipairs(objects) do
                object:SetUIWorkRadius(object.work_radius + const.SignalBoostersBuff)
            end
        end

        local modifyAllRocketsEffect = PlaceObj("Effect_ModifyLabel", {
            Amount = 15,
            Label = "AllRockets",
            Prop = "work_radius"
        })

        local modifyAllElevatorsEffect = PlaceObj("Effect_ModifyLabel", {
            Amount = 15,
            Label = "Elevator",
            Prop = "work_radius"
        })

        local modifyAllRCCommandersEffect = PlaceObj("Effect_ModifyLabel", {
            Amount = 15,
            Label = "RCRoverAndChildren",
            Prop = "work_radius"
        })
        --tech.description = Untranslated("Asteroid Lander Upgrade (<em>Solar Energy Landers</em>) - ") .. SOLAR_ENERGY_LANDER_DESCRIPTION .. "\n" .. tech.description
        table.insert(tech, #tech + 1, modifyAllRocketsEffect)
        table.insert(tech, #tech + 1, modifyAllElevatorsEffect)
        table.insert(tech, #tech + 1, modifyAllRCCommandersEffect)
        PlaceObj("Effect_Code", {
            OnApplyEffect = function(self, colony, parent)
                BoostSignals(colony.city_labels.labels.Elevator)
                BoostSignals(colony.city_labels.labels.RCRoverAndChildren)
                BoostSignals(colony.city_labels.labels.AllRockets)
            end
        })

        -- If this happens, tech was already researched; we must manually execute the effects
        if UIColony:IsTechResearched("SignalBoosters") then
            modifyAllRocketsEffect:OnApplyEffect(UIColony, nil)
            modifyAllElevatorsEffect:OnApplyEffect(UIColony, nil)
            modifyAllRCCommandersEffect:OnApplyEffect(UIColony, nil)
        end
        tech.Tremualin_AdvancedSignalBoosters = true
    end
end

OnMsg.CityStart = AdvancedSignalBoosters
OnMsg.LoadGame = AdvancedSignalBoosters