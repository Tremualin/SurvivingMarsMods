-- Add the Senior label to city
-- Makes iterating and counting seniors easier
local orig_Colonist_AddTolabels = Colonist.AddToLabels
function Colonist:AddToLabels()
    orig_Colonist_AddTolabels(self)
    if self.traits.Senior then
        self.city:AddToLabel("Senior", self)
    end
end

-- Remove the Senior label from city
-- Makes iterating and counting seniors easier
local orig_Colonist_RemoveFromLabels = Colonist.RemoveFromLabels
function Colonist:RemoveFromLabels()
    orig_Colonist_RemoveFromLabels(self)
    self.city:RemoveFromLabel("Senior", self)
end
