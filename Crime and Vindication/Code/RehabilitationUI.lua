local ui_functions = Tremualin.UIFunctions

local function GetPointsRolloverText(residence)
    local text = {}
    local colonists = residence.colonists
    for i = #colonists, 1, -1 do
        local colonist = colonists[i]
        colonist.training_points = colonist.training_points or {}
        local training_points = colonist.training_points[training_type] or 0

        text[i] = T(colonist:GetDisplayName()) .. "<right>"
        .. T{9766, "<percent(number)>",
            number = MulDivRound(training_points, 100, vindication_points),
        }
    end
    text[#text + 1] = Untranslated("<newline>Lifetime cured: <right>" .. (residence.total_cured or 0))
    return table.concat(text, "<newline><left>")
end

-- A button that turns a residence into a rehabilitation center
function OnMsg.ClassesPostprocess()
    local template = XTemplates.sectionResidence
    ui_functions.RemoveXTemplateSections(template, "Tremualin_RehabilitationCenter")
    local rehabilitationInfo = PlaceObj("XTemplateTemplate", {
        "Tremualin_RehabilitationCenter", true,
        "__template", "InfopanelSection",
        "__context_of_kind", "Residence",
        "OnContextUpdate", function(self, context)
            if IsTechResearched("BehavioralShaping") then
                if context.exclusive_trait == "Renegade" then
                    self:SetRolloverText("Renegade progress towards rehabilitation:<newline><newline>" .. GetPointsRolloverText(context))
                    self:SetTitle("Rehabilitation Center")
                    self:SetIcon("UI/Icons/Upgrades/behavioral_melding_01.tga")
                elseif context.exclusive_trait then
                    self:SetVisible(false)
                else
                    self:SetRolloverText("Not a rehabilitation center")
                    self:SetTitle("Regular Residence")
                    self:SetIcon("UI/Icons/Upgrades/behavioral_melding_02.tga")
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
