local AnotherBrickInTheWall_Penalty = -10000
local Orig_Tremualin_TrainingBuilding_OnChangeWorkshift = TrainingBuilding.OnChangeWorkshift
function TrainingBuilding:OnChangeWorkshift(old, new)
    Orig_Tremualin_TrainingBuilding_OnChangeWorkshift(self, old, new)
    if old and IsGameRuleActive("AnotherBrickInTheWall") then
        for _, visitor in ipairs(self.visitors[old]) do
            visitor:ChangeSanity(AnotherBrickInTheWall_Penalty, "Dark sarcasm in the classroom")
        end
    end
end

function OnMsg.ClassesPostprocess()
    PlaceObj("GameRules", {
        SortKey = 200001,
        challenge_mod = 30,
        description = Untranslated("Colonists lose sanity from educational buildings."),
        display_name = Untranslated("Another Brick In The Wall"),
        flavor = Untranslated("<grey>\"Teachers, leave them kids alone\"<newline><right>Pink Floyd</grey><left>"),
        group = "Default",
        id = "Tremualin_AnotherBrickInTheWall"
    })
end
