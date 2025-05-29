local print_debug = false

if print_debug then
    -- Helps debug changes in sanity
    local Orig_Tremualin_Colonist_ChangeSanity = Colonist.ChangeSanity
    function Colonist:ChangeSanity(amount, reason)
        if amount > 0 then
            if reason and reason ~= "rest" then print (string.format("Changing sanity : %s", reason)) end
        end
        Orig_Tremualin_Colonist_ChangeSanity(self, amount, reason)
    end
end

local function SortTraitPresets()
    local comparator = function (k1, k2)
        if k1.display_name and k2.display_name then
            return _InternalTranslate(k1.display_name) < _InternalTranslate(k2.display_name)
        else
            -- Never actually called, but just in case
            return 0
        end
    end
    table.sort(Presets.TraitPreset.other, comparator)
    table.sort(Presets.TraitPreset.Negative, comparator)
    table.sort(Presets.TraitPreset.Positive, comparator)
end

OnMsg.LoadGame = SortTraitPresets
OnMsg.CityStart = SortTraitPresets
