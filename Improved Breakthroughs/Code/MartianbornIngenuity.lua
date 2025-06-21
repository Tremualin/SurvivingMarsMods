-- Replace Soylent Green
-- Make it give bonus performance based on Food
-- Or perhaps that belongs in Martian Diet?

function ApplyMartianbornIngenuityIfResearched(colonist)
    if colonist.city.colony:IsTechResearched("MartianbornIngenuity") then
        local performance = TechDef.MartianbornIngenuity.param1
        if colonist.serial then
            performance = performance + TechDef.MartianbornIngenuity.param1 * colonist.serial
        end
        colonist:SetModifier("performance", "MartianbornIngenuity", performance, 0, T(7600, "<green>Martian born Ingenuity +<amount> (Martianborn)</color>"))
        return performance
    end
end

function OnMsg.ClassesGenerate()
    TraitPresets.Martianborn.apply_func = function(colonist, trait, init)
        ApplyMartianbornIngenuityIfResearched(colonist)
    end
    --TraitPresets.Martianborn.daily_update_func = function (colonist, trait)
    --    ApplyMartianbornIngenuityIfResearched(colonist)
    --end
end

function SavegameFixups.Tremualin_FixMartianbornIngenuityBonusesForRebornColonists()
    table.foreach_value(UIColony.city_labels.labels.Colonist or empty_table, ApplyMartianbornIngenuityIfResearched)
end
