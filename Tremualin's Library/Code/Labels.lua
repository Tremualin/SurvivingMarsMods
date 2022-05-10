-- Add the Senior and Child label to city
-- Makes iterating and counting seniors and children easier
local Orig_Tremualin_Colonist_AddTolabels = Colonist.AddToLabels
function Colonist:AddToLabels()
    Orig_Tremualin_Colonist_AddTolabels(self)
    if self.traits.Senior then
        self.city:AddToLabel("Senior", self)
    end
    if self.traits.Child then
        self.city:AddToLabel("Child", self)
    end
end

-- Add the Senior label to the city when they gain the trait
local Orig_Tremualin_Colonist_AddTrait = Colonist.AddTrait
function Colonist:AddTrait(trait_id, ...)
    if trait_id == "Senior" then
        self.city:AddToLabel("Senior", self)
    end
    return Orig_Tremualin_Colonist_AddTrait(self, trait_id, ...)
end

-- Remove the Senior and Child label from city
-- Makes iterating and counting seniors and children easier
local Orig_Tremualin_Colonist_RemoveFromLabels = Colonist.RemoveFromLabels
function Colonist:RemoveFromLabels()
    Orig_Tremualin_Colonist_RemoveFromLabels(self)
    self.city:RemoveFromLabel("Senior", self)
    self.city:RemoveFromLabel("Child", self)
end

-- Remove Child from labels once they become Youth
function OnMsg.ColonistBecameYouth(colonist)
    colonist.city:RemoveFromLabel("Child", colonist)
end

function OnMsg.LoadGame()
    for _, city in ipairs(Cities) do
        city.labels.Child = {}
        local domes = city.labels.Dome or empty_table
        for j = #domes, 1, -1 do
            local dome = domes[j]
            for _, child in pairs(dome.labels.Child or empty_table) do
                city:AddToLabel("Child", child)
            end
        end
    end
end
