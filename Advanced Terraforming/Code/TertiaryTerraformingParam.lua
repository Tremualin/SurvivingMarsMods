-- Must be applied on top of a Terraforming Building
-- Grants an additional Terraforming property
DefineClass.TertiaryTerraformingParam = {
    -- Very important; otherwise the class won't register the BuildingUpdate method
    __parents = {"InitDone"},
    properties = {
        {
            template = true,
            category = "Terraforming",
            name = Untranslated("Tertiary Terraforming Param"),
            id = "tertiary_terraforming_param",
            editor = "choice",
            default = "",
        items = PresetsCombo("TerraformingParam")},
        {
            template = true,
            category = "Terraforming",
            name = Untranslated("Tertiary Terraforming Boost (%/sol)"),
            id = "tertiary_terraforming_boost_sol",
            editor = "number",
            default = 0,
            scale = "Terraforming",
            modifiable = true
        },
    },
    building_update_time = const.HourDuration,
}

function TertiaryTerraformingParam:GetTertiaryTerraformingBoostSum()
    -- Original method works for any param; just give it the right one
    return GetTerraformingBoostSum(self.tertiary_terraforming_param)
end

function TertiaryTerraformingParam:GetTertiaryTerraformingProgress()
    -- Original method works for any param; just give it the right one
    return Clamp(Terraforming[self.tertiary_terraforming_param], 0, MaxTerraformingValue)
end
function TertiaryTerraformingParam:GetTertiaryTerraformingBoostSol()
    return self.tertiary_terraforming_boost_sol
end
function TertiaryTerraformingParam:GetTertiaryTerraformingBoost(delta)
    if not self:IsTerraformingActive() then
        return 0
    end
    delta = delta or const.DayDuration
    return MulDivRound(self:GetTertiaryTerraformingBoostSol(), delta, const.DayDuration)
end
function TertiaryTerraformingParam:BuildingUpdate(delta, ...)
    local boost = self:GetTertiaryTerraformingBoost(delta)
    if boost == 0 then
        return
    end
    local value, change = ChangeTerraformParam(self.tertiary_terraforming_param, boost)
    Msg("TerraformingProduced", self.tertiary_terraforming_param, change)
end
function TertiaryTerraformingParam:GameInit()
    self.city:AddToLabel("TertiaryTerraformingParam", self)
end
function TertiaryTerraformingParam:Done()
    self.city:RemoveFromLabel("TertiaryTerraformingParam", self)
end
function TertiaryTerraformingParam:GetTertiaryParameterInfoPanelIconName()
    return self.tertiary_terraforming_param .. const.TerraformingParamSuffix
end

local Orig_Tremualin_GetTerraformingBoostSum = GetTerraformingBoostSum
function GetTerraformingBoostSum(terraforming_param)
    local buildings = MainCity.labels.TertiaryTerraformingParam or empty_table
    local sum = 0
    for _, building in ipairs(buildings) do
        if building.tertiary_terraforming_param == terraforming_param then
            sum = sum + building:GetTertiaryTerraformingBoost()
        end
    end
    return sum + Orig_Tremualin_GetTerraformingBoostSum(terraforming_param)
end
