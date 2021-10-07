local ui_functions = Tremualin.UIFunctions
local configuration = Tremualin.Configuration

function Residence:GetUISectionTremualinVindicationRolloverText()
    if not self.exclusive_trait == "Renegade" then
        return "Not a rehabilitation center"
    end

    local text = {}
    local colonists = self.colonists
    for i = #colonists, 1, -1 do
        local colonist = colonists[i]
        colonist.training_points = colonist.training_points or {}
        local training_points = colonist.training_points[configuration.VindicationTrainingType] or 0
        text[i] = T(colonist:GetDisplayName()) .. "<right>"
        .. T{9766, "<percent(number)>",
            number = MulDivRound(training_points, 100, configuration.VindicationPointsRequired),
        }
    end
    text[#text + 1] = Untranslated("<newline>Lifetime cured: <right>" .. (self.total_cured or 0))
    return "Renegade progress towards rehabilitation:<newline><newline>" .. table.concat(text, "<newline><left>")
end

-- A button that turns a residence into a rehabilitation center
function OnMsg.ClassesPostprocess()
    local template = XTemplates.sectionResidence
    ui_functions.RemoveXTemplateSections(template, "Tremualin_RehabilitationCenter")
    local rehabilitationInfo = PlaceObj("XTemplateTemplate", {
        "Tremualin_RehabilitationCenter", true,
        "__template", "InfopanelSection",
        "__context_of_kind", "Residence",
        "RolloverText", Untranslated("<UISectionTremualinVindicationRolloverText>"),
        "OnContextUpdate", function(self, context)
            if UIColony:IsTechResearched("BehavioralShaping") then
                if context.exclusive_trait == "Renegade" then
                    self:SetTitle("Rehabilitation Center")
                    self:SetIcon("UI/Icons/Upgrades/behavioral_melding_01.tga")
                    self:SetVisible(true)
                elseif context.exclusive_trait then
                    self:SetVisible(false)
                else
                    self:SetTitle("Regular Residence")
                    self:SetIcon("UI/Icons/Upgrades/behavioral_melding_02.tga")
                    self:SetVisible(true)
                end
            else
                self:SetVisible(false)
            end
        end,
    },
    {
        PlaceObj("XTemplateFunc", {
            "name", "OnActivate(self, context)",
            "parent", function(self)
                return self.parent
            end,
            "func", function(self, context)
                -- we remove the trait if present, and reduce capacity
                if context.exclusive_trait == "Renegade" then
                    context.exclusive_trait = nil
                    context:CheckHomeForHomeless()
                elseif context.exclusive_trait then
                    -- do nothing
                else
                    context.exclusive_trait = "Renegade"
                    -- first we process all colonists within the residence and kick out non-renegades
                    for i = #context.colonists, 1, -1 do
                        local colonist = context.colonists[i]
                        if IsValid(colonist) then
                            colonist:UpdateResidence()
                        end
                    end
                    -- then we process all colonists within the dome to make sure all renegades move into rehabilitation centers
                    -- we will process some colonists twice but I'm too lazy to care
                    for i = #(context.parent_dome.labels.Colonist or empty_table), 1, -1 do
                        local colonist = context.parent_dome.labels.Colonist[i]
                        if IsValid(colonist) then
                            colonist:UpdateResidence()
                        end
                    end
                end
                -- If you modified a value then use this, if not remove
                ObjModified(context)
                RebuildInfopanel(context)
                ---
            end
        }),
    })

    table.insert(template, #template, rehabilitationInfo)
end
