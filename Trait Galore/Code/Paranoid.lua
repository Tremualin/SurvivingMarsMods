local functions = Tremualin.Functions

local paranoid_sanity_loss = -2 * const.Scale.Stat
local paranoid_sanity_loss_message = "<red>Will the building collapse on me? (Paranoid) </color>"

function OnMsg.ClassesPostprocess()
    functions.AddTraitToSanityBreakdownTraits("Paranoid")
end

-- Paranoid is scared of entering services
local Orig_Tremualin_Colonist_VisitService = Colonist.VisitService
function Colonist:VisitService(service, need)
    if self.traits.Paranoid then
        self:ChangeSanity(paranoid_sanity_loss, paranoid_sanity_loss_message)
    end
    Orig_Tremualin_Colonist_VisitService(self, service, need)
end

-- Paranoid is scared of entering his residence
local Orig_Tremualin_Residence_Service = Residence.Service
function Residence:Service(unit, duration)
    if unit.traits.Paranoid then
        unit:ChangeSanity(paranoid_sanity_loss, paranoid_sanity_loss_message)
    end
    Orig_Tremualin_Residence_Service(self, unit, duration)
end

-- Paranoid is scared of entering his workplace
local Orig_Tremualin_Colonist_WorkCycle = Colonist.WorkCycle
function Colonist:WorkCycle()
    if self.traits.Paranoid then
        self:ChangeSanity(paranoid_sanity_loss, paranoid_sanity_loss_message)
    end
    Orig_Tremualin_Colonist_WorkCycle(self)
end
