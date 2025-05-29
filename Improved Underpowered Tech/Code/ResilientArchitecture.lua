local function ImproveResilientArchitecture()
    local tech = Presets.TechPreset.Engineering["ResilientArchitecture"]
    local modified = tech.Tremualin_AdditionalRefund
    if not modified then
        tech.description = Untranslated("Salvaging now yields back the <em>full cost</em> of a building\n") .. tech.description
        tech.Tremualin_AdditionalRefund = true
    end
end

local orig_CalcRefundAmount = Building.CalcRefundAmount
function Building:CalcRefundAmount(total_amount)
    if self.city.colony:IsTechResearched("ResilientArchitecture") then
        total_amount = total_amount * 2
    end
    return orig_CalcRefundAmount(self, total_amount)
end

OnMsg.LoadGame = ImproveResilientArchitecture
OnMsg.CityStart = ImproveResilientArchitecture
