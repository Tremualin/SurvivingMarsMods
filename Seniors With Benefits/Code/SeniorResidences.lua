local ui_functions = Tremualin.UIFunctions

-- A button that turns a residence into a seniors only residence
-- Useful for those that don't have the new DLC
function OnMsg.ClassesPostprocess()
    local template = XTemplates.sectionResidence
    ui_functions.RemoveXTemplateSections(template, "Tremualin_SeniorsAllowed")
    local seniorsInfo = PlaceObj("XTemplateTemplate", {
        "Tremualin_SeniorsAllowed", true,
        "__template", "InfopanelSection",
        "__context_of_kind", "Residence",
        "OnContextUpdate", function(self, context)
            if context.exclusive_trait == "Senior" and not context:IsKindOf("SeniorsResidence") then
                self:SetRolloverText("Only seniors are allowed on this residence")
                self:SetTitle("Only seniors allowed")
                self:SetIcon("UI/Icons/Upgrades/rejuvenation_treatment_01.tga")
            elseif context.exclusive_trait then
                self:SetVisible(false)
            else
                self:SetRolloverText("Everyone is allowed on this residence")
                self:SetTitle("Everyone allowed")
                self:SetIcon("UI/Icons/Upgrades/rejuvenation_treatment_02.tga")
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
                if context.exclusive_trait == "Senior" then
                    context.capacity = context.capacity - context.seniors_extra_capacity
                    context.exclusive_trait = false
                    -- since we changed capacity, we need to ensure there is room for everyone
                    for i = #context.colonists, 1, -1 do
                        if i >= context.capacity then
                            local colonist = context.colonists[i]
                            context:RemoveResident(colonist)
                        end
                    end
                    context:CheckHomeForHomeless()
                elseif context.exclusive_trait then
                    -- do nothing
                else
                    context.exclusive_trait = "Senior"
                    -- increase capacity by 50% to compete with senior residences
                    context.seniors_extra_capacity = context.capacity * 0.5
                    context.capacity = context.capacity + context.seniors_extra_capacity
                    -- first we process all colonists within the residence and kick out the youngsters
                    for i = #context.colonists, 1, -1 do
                        local colonist = context.colonists[i]
                        if IsValid(colonist) then
                            colonist:UpdateResidence()
                        end
                    end
                    -- then we process all colonists within the dome to make sure all seniors move into the residence
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

    table.insert(template, #template, seniorsInfo)
end
