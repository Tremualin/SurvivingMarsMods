local Orig_Tremualin_DroneHubExtender_CanInteractWithObject = DroneHubExtender.CanInteractWithObject
function DroneHubExtender:CanInteractWithObject(obj)
    if obj:IsKindOf("Elevator") then
        return true, Untranslated("Connect to Elevator")
    end
    return Orig_Tremualin_DroneHubExtender_CanInteractWithObject(self, obj)
end

local Orig_Tremualin_CaveInRubble_GameInit = CaveInRubble.GameInit
function CaveInRubble:GameInit()
    Orig_Tremualin_CaveInRubble_GameInit(self)
    if self:CanBeCleared() then
        self:RequestClear()
    end
end

function ChooseBuriedWonders()
    local modOptions = CurrentModOptions
    local ancientArtifact = modOptions:GetProperty("AncientArtifact")
    local caveOfWonders = modOptions:GetProperty("CaveOfWonders")
    local bottomlessPit = modOptions:GetProperty("BottomlessPit")
    local jumboCave = modOptions:GetProperty("JumboCave")

    local likedWonders = {}
    local dislikedWonders = {}
    if ancientArtifact then
        table.insert(likedWonders, "AncientArtifact")
    else
        table.insert(dislikedWonders, "AncientArtifact")
    end
    if caveOfWonders then
        table.insert(likedWonders, "CaveOfWonders")
    else
        table.insert(dislikedWonders, "CaveOfWonders")
    end
    if bottomlessPit then
        table.insert(likedWonders, "BottomlessPit")
    else
        table.insert(dislikedWonders, "BottomlessPit")
    end
    if jumboCave then
        table.insert(likedWonders, "JumboCave")
    else
        table.insert(dislikedWonders, "JumboCave")
    end

    while #likedWonders < 2 do
        local wonder = table.rand(dislikedWonders)
        table.insert(likedWonders, wonder)
    end
    const.BuriedWonders = likedWonders
end

OnMsg.PreNewGame = ChooseBuriedWonders
