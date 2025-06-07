-- Super-fungus provides +100% productivity for +50% Oxygen
-- Instead of the other way around
-- But only for non-B&B games
function ImproveSuperfungus()
    if not IsDlcAvailable("picard") then
        BuildingTemplates.FungalFarm.upgrade1_mul_value_1 = 100
        ClassTemplates.Building.FungalFarm.upgrade1_mul_value_1 = 100

        BuildingTemplates.FungalFarm.upgrade1_mul_value_2 = 50
        ClassTemplates.Building.FungalFarm.upgrade1_mul_value_2 = 50
    end
end

OnMsg.ClassesPostprocess = ImproveSuperfungus
