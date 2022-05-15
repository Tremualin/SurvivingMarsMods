-- Must be applied on top of a Terraforming Building
-- Grants an additional Terraforming property
DefineClass.SecondaryTerraformingParam = {
    -- Very important; otherwise the class won't register the BuildingUpdate method
    __parents = {"InitDone"},
    properties = {
        {
            template = true,
            category = "Terraforming",
            name = Untranslated("Secondary Terraforming Param"),
            id = "secondary_terraforming_param",
            editor = "choice",
            default = "",
        items = PresetsCombo("TerraformingParam")},
        {
            template = true,
            category = "Terraforming",
            name = Untranslated("Secondary Terraforming Boost (%/sol)"),
            id = "secondary_terraforming_boost_sol",
            editor = "number",
            default = 0,
            scale = "Terraforming",
            modifiable = true
        },
    },
    building_update_time = const.HourDuration,
}

function SecondaryTerraformingParam:GetSecondaryTerraformingBoostSum()
    -- Original method works for any param; just give it the right one
    return GetTerraformingBoostSum(self.secondary_terraforming_param)
end

function SecondaryTerraformingParam:GetSecondaryTerraformingProgress()
    -- Original method works for any param; just give it the right one
    return Clamp(Terraforming[self.secondary_terraforming_param], 0, MaxTerraformingValue)
end
function SecondaryTerraformingParam:GetSecondaryTerraformingBoostSol()
    return self.secondary_terraforming_boost_sol
end
function SecondaryTerraformingParam:GetSecondaryTerraformingBoost(delta)
    if not self:IsTerraformingActive() then
        return 0
    end
    delta = delta or const.DayDuration
    return MulDivRound(self:GetSecondaryTerraformingBoostSol(), delta, const.DayDuration)
end
function SecondaryTerraformingParam:BuildingUpdate(delta, ...)
    local boost = self:GetSecondaryTerraformingBoost(delta)
    if boost == 0 then
        return
    end
    local value, change = ChangeTerraformParam(self.secondary_terraforming_param, boost)
    Msg("TerraformingProduced", self.secondary_terraforming_param, change)
end
function SecondaryTerraformingParam:GameInit()
    self.city:AddToLabel("SecondaryTerraformingParam", self)
end
function SecondaryTerraformingParam:Done()
    self.city:RemoveFromLabel("SecondaryTerraformingParam", self)
end
function SecondaryTerraformingParam:GetSecondaryParameterInfoPanelIconName()
    return self.secondary_terraforming_param .. const.TerraformingParamSuffix
end

local Orig_Tremualin_GetTerraformingBoostSum = GetTerraformingBoostSum
function GetTerraformingBoostSum(terraforming_param)
    local buildings = MainCity.labels.SecondaryTerraformingParam or empty_table
    local sum = 0
    for _, building in ipairs(buildings) do
        if building.secondary_terraforming_param == terraforming_param then
            sum = sum + building:GetSecondaryTerraformingBoost()
        end
    end
    return sum + Orig_Tremualin_GetTerraformingBoostSum(terraforming_param)
end
