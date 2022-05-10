local functions = Tremualin.Functions
local configuration = Tremualin.Configuration

local function ReportDomesticAssault(perpetrator)
    local dome = perpetrator.dome
    if dome then
        dome.Tremualin_DomesticViolenceReports = dome.Tremualin_DomesticViolenceReports or 0
        dome.Tremualin_DomesticViolenceReports = dome.Tremualin_DomesticViolenceReports + 1
    end
    functions.AddTraitIfCompatible(perpetrator, "Renegade")
    AddOnScreenNotification("Tremualin_Domestic_Violence_Report", false, {
        dome_name = perpetrator.dome:GetDisplayName(),
        perpetrator_name = perpetrator.name
        }, {
        perpetrator
    }, perpetrator:GetMapID())
end

function Colonist:GetTremualin_DomesticViolenceChances()
    local chances = 0
    local traits = self.traits
    local dome = self.dome
    local unhappy = functions.IsUnhappy(self)
    if dome and (unhappy or traits.Renegade or traits.Violent) then
        chances = g_Consts.LowSanityNegativeTraitChance
        if traits.Violent and unhappy then
            -- Unhappy violent colonists will always commit violence
            chances = 100
        else
            -- Regular colonists will commit violence a lot less often
            -- Chances are reduced by positive traits and increased by negative ones
            local traits_by_category = functions.TraitsByCategory(traits)
            chances = chances + traits_by_category["Positive"] - traits_by_category["Negative"]
        end
    end
    return chances
end

-- Domestic Violence
local report_chances = 33
local report_violent_chances = 11
local orig_Colonist_DailyUpdate = Colonist.DailyUpdate
function Colonist:DailyUpdate()
    local dome = self.dome
    orig_Colonist_DailyUpdate(self)
    local domesticViolenceChances = self:GetTremualin_DomesticViolenceChances()
    if self:Random(1, 100) <= domesticViolenceChances then
        local victims = {}
        local residence = self.residence
        if residence and residence.exclusive_trait == "Renegade" then
            -- only find a victim if unsupervised
            local officers_in_security_stations = functions.OfficersInSecurityStations(residence.parent_dome)
            local renegades_in_rehabilitation = functions.RenegadesInRehabilitation(residence.parent_dome)
            -- are there more renegades in rehabilitation than officers to monitor them?
            if #renegades_in_rehabilitation > #officers_in_security_stations * configuration.MaxRenegadesRehabilitatedPerOfficer then
                victims = functions.FindAllOtherColonistsInSameResidence(self)
            end
        else
            victims = functions.FindAllOtherColonistsInSameResidence(self)
        end

        if #victims > 0 then
            local victim = table.rand(victims)

            -- collect statistics
            dome.Tremualin_DomesticViolenceAssaults = dome.Tremualin_DomesticViolenceAssaults or 0
            dome.Tremualin_DomesticViolenceAssaults = dome.Tremualin_DomesticViolenceAssaults + 1

            -- apply damage, reduced by security stations
            local damageDecrease = dome:GetSecurityStationDamageDecrease()
            local random_health_damage = -MulDivRound(self:Random(1, 15), const.Scale.Stat * (100 - damageDecrease), 100)
            local random_sanity_damage = -MulDivRound(self:Random(1, 15), const.Scale.Stat * (100 - damageDecrease), 100)
            victim:ChangeHealth(random_health_damage, "Domestic violence assault ")
            victim:ChangeSanity(random_sanity_damage, "Domestic violence assault ")

            if victim.traits.Child then
                -- child will have permanent scars
                victim.domestic_violence = true
            elseif self:Random(1, 100) <= g_Consts.LowSanityNegativeTraitChance then
                functions.AddSanityBreakdownFlaw(victim)
            end
            if self.traits.Child then
                -- violence is carried over to adulthood
                self.domestic_violence = true
            end
            -- Violent victims retaliate
            if victim.traits.Violent then
                dome.Tremualin_DomesticViolenceRetalations = dome.Tremualin_DomesticViolenceRetalations or 0
                dome.Tremualin_DomesticViolenceRetalations = dome.Tremualin_DomesticViolenceRetalations + 1
                self:ChangeHealth(random_health_damage, "Domestic violence retaliation ")
                self:ChangeSanity(random_sanity_damage, "Domestic violence retaliation ")
                if self:Random(1, 100) <= g_Consts.LowSanityNegativeTraitChance then
                    functions.AddSanityBreakdownFlaw(self)
                end
                -- report the victim's retaliation
                if self:Random(1, 100) <= report_violent_chances then
                    ReportDomesticAssault(victim)
                end
            end
            -- 33% chance of being reported and becoming a Renegade
            if not self.traits.Renegade and not self.traits.Child then
                -- Violent people have lower chances of being reported to authorities
                if (self.traits.Violent and self:Random(1, 100) <= report_violent_chances) or (self:Random(1, 100) <= report_chances) then
                    ReportDomesticAssault(self)
                end
            end
        end
    end
end

-- Children who are victims of domestic violence get flaws
function OnMsg.ColonistBecameYouth(colonist)
    if colonist.domestic_violence then
        functions.AddSanityBreakdownFlaw(colonist)
    end
end

local function ImproveSupportiveCommunity()
    local tech = Presets.TechPreset.Social["SupportiveCommunity"]
    local modified = tech.Tremualin_DomesticViolence
    if not modified then
        tech.description = Untranslated("Lowers the risk of colonists developing flaws from <em>Domestic violence.</em>\n") .. tech.description
        tech.Tremualin_DomesticViolence = true
    end
end

local function SetViolentUIWarning()
    if ColonistTraitsWarnings then
        ColonistTraitsWarnings["Violent"] = Untranslated("This Colonist is Violent. Violent colonists will commit domestic violence, unless rehabilitated at a Sanatorium.")
    end
end

local Tremualin_Orig_Colonist_GetUIInfo = Colonist.GetUIInfo
function Colonist:GetUIInfo(remove_descr)
    return Tremualin_Orig_Colonist_GetUIInfo(self, remove_descr) .. "<newline><left>" .. Untranslated("Chances of committing violence<right><Tremualin_DomesticViolenceChances>%", self)
end

function OnMsg.ClassesGenerate()
    ImproveSupportiveCommunity()
    SetViolentUIWarning()
end
