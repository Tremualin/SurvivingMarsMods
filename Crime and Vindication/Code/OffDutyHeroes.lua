local functions = Tremualin.Functions

-- Off-Duty Hero
local orig_Colonist_Suicide = Colonist.Suicide
function Colonist:Suicide()
    local saved = false
    local dome = self.dome
    if dome then
        local supportive_community = UIColony:IsTechResearched("SupportiveCommunity")
        local security_in_proximity = {}
        local security = dome.labels.security or empty_table
        for i = 1, #security do
            local unit = security[i]
            if self:Random(100) <= 5 then
                table.insert(security_in_proximity, unit)
            end
        end
        for i = 1, #security_in_proximity do
            local random = self:Random(100)
            print(random)
            local unit = security_in_proximity[i]
            if unit ~= self then
                if supportive_community and random <= 10 or random <= 5 then
                    functions.TemporarilyModifyMorale(unit, 10, 0, 3, "Tremualin_Suicide_Hero", "I saved a life ")
                    unit:AddTrait("Celebrity")
                    saved = true
                    AddOnScreenNotification("Tremualin_Suicide_Hero", false, {
                        dome_name = dome:GetDisplayName(),
                        officer_name = unit.name,
                        colonist_name = self.name
                        }, {
                        unit
                    })
                    break
                elseif supportive_community and random >= 99 or random >= 95 then
                    functions.TemporarilyModifyMorale(unit, -20, 0, 3, "Tremualin_Suicide_Failure", "They're dead... because of me ")
                    AddOnScreenNotification("Tremualin_Suicide_Failure", false, {
                        dome_name = dome:GetDisplayName(),
                        officer_name = unit.name,
                        colonist_name = self.name
                        }, {
                        unit
                    })
                    break
                end
            end
        end
    end
    if not saved then
        orig_Colonist_Suicide(self)
    end
end

local function ImproveSupportiveCommunity()
    local tech = Presets.TechPreset.Social["SupportiveCommunity"]
    local modified = tech.Tremualin_OffDutyHeroes
    if not modified then
        tech.description = Untranslated("Increases the chances of Officers preventing colonists from committing <em>Suicide</em>.\n") .. tech.description
        tech.Tremualin_OffDutyHeroes = true
    end
end

OnMsg.LoadGame = ImproveSupportiveCommunity
OnMsg.CityStart = ImproveSupportiveCommunity
