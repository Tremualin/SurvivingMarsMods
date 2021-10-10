function OnMsg.ClassesGenerate()
    local Tremualin_Orig_Colonist_Roam = Colonist.Roam
    function Colonist:Roam(duration)
        local shock_status = self:IsShocked()
        local medium_sanity = self.stat_sanity < g_Consts.HighStatLevel
        if not shock_status and medium_sanity then
            self:TryVisit("needMedical")
        end -- if not shock_status
        return Tremualin_Orig_Colonist_Roam(self, duration)
    end -- function Colonist:Roam
end -- OngMsg.ClassesGenerate
