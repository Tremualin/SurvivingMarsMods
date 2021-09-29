Tremualin.Configuration.VindicationPointsRequired = 700
Tremualin.Configuration.VindicationPointsAcquiredPerShift = 70
Tremualin.Configuration.VindicationTrainingType = "vindication"
Tremualin.Configuration.MaxRenegadesRehabilitatedPerOfficer = 4

local functions = Tremualin.Functions
local configuration = Tremualin.Configuration

local securityStationBehavioralMelding = "Tremualin_SecurityStation_BehavioralMelding"
local securityStationCriminalPsychologists = "Tremualin_SecurityStation_CriminalPsychologists"

-- Gain rehabilitation points at the end of every shift
function OnMsg.NewWorkshift(shift)
    local remove_trait = "Renegade"
    local add_trait = "Vindicated"
    for _, city in ipairs(Cities) do
        local domes = city.labels.Dome or empty_table
        for j = #domes, 1, -1 do
            local dome = domes[j]

            -- determine how many Renegades are in Rehabilitation
            local renegades_in_rehabilitation = functions.RenegadesInRehabilitation(dome)
            -- determine how many officers are working in security stations during this shift
            local officers_in_security_stations = functions.OfficersInSecurityStations(dome)

            -- split renegades on groups of MaxRenegadesRehabilitatedPerOfficer
            -- so they can be treated by a security officer
            local table_key = 1
            local renegades_per_officer_table = {}
            for i = #renegades_in_rehabilitation, 1, -1 do
                renegades_per_officer_table[table_key] = renegades_per_officer_table[table_key] or {}
                table.insert(renegades_per_officer_table[table_key], renegades_in_rehabilitation[i])
                if #renegades_per_officer_table[table_key] >= configuration.MaxRenegadesRehabilitatedPerOfficer then
                    table_key = table_key + 1
                end
            end

            -- for each officer; treat up to MaxRenegadesRehabilitatedPerOfficer renegades
            table_key = 1
            for _, officer in pairs(officers_in_security_stations) do
                for _, renegade in pairs(renegades_per_officer_table[table_key] or empty_table) do
                    local gain_points = MulDivRound(configuration.VindicationPointsAcquiredPerShift * renegade.stat_sanity / (100 * const.Scale.Stat) * renegade.stat_comfort / (100 * const.Scale.Stat) * renegade.residence.service_comfort / (100 * const.Scale.Stat), officer.performance, 100)
                    renegade.training_points = renegade.training_points or {}
                    renegade.training_points[configuration.VindicationTrainingType] = (renegade.training_points[configuration.VindicationTrainingType] or 0) + gain_points
                    if renegade.training_points[configuration.VindicationTrainingType] >= configuration.VindicationPointsRequired then
                        renegade:RemoveTrait(remove_trait)
                        local residence = renegade.residence
                        residence.parent_dome.officers_with_benefits_rehabilitated = (residence.parent_dome.officers_with_benefits_rehabilitated or 0) + 1
                        residence:RemoveResident(renegade)
                        residence.total_cured = (residence.total_cured or 0) + 1
                        if officer.workplace:HasUpgrade(securityStationBehavioralMelding) then
                            local compatible = (FilterCompatibleTraitsWith({add_trait}, renegade.traits))
                            if 0 < #compatible then
                                renegade:AddTrait(add_trait)
                                Msg("ColonistCured", renegade, residence, remove_trait, add_trait)
                            else
                                Msg("ColonistCured", renegade, residence, remove_trait, nil)
                            end
                        else
                            Msg("ColonistCured", renegade, residence, remove_trait, nil)
                        end
                    end
                end
                table_key = table_key + 1
            end
        end
    end
end

local function AddBehavioralMeldingUpgrade(obj, id)
    obj.upgrade1_id = securityStationBehavioralMelding
    obj.upgrade1_description = Untranslated("Allows Renegades to become Vindicated")
    obj.upgrade1_display_name = T(5243, "Behavioral Melding")
    obj.upgrade1_icon = "UI/Icons/Upgrades/behavioral_melding_01.tga"
    obj.upgrade1_upgrade_cost_Polymers = id == "SecurityPostCCP1" and 4000 or 10000
    obj.upgrade1_upgrade_cost_Electronics = id == "SecurityPostCCP1" and 4000 or 10000

    local tech = Presets.TechPreset.Social["BehavioralMelding"]
    local modified = tech.Tremualin_Vindication
    if not modified then
        tech.description = Untranslated("Security building Upgrade (<em>Behavioral Melding</em>) - Renegades in Rehabilitation become <em>Vindicated</em>, gaining +20 performance and becoming unable to become Renegades ever again.\n") .. tech.description
        tech.Tremualin_Vindication = true
    end
end

local function AddCriminalPsychologistsUpgrade(obj, id)
    obj.upgrade2_id = securityStationCriminalPsychologists
    obj.upgrade2_description = Untranslated("Increases the performance of the Security building by 10 if there's a medical building in the Dome. Doubled if the medical building is a Spire or a Hospital.")
    obj.upgrade2_display_name = Untranslated("Criminal Psychologists")
    obj.upgrade2_icon = "UI/Icons/Upgrades/factory_ai_01.tga"
    obj.upgrade2_upgrade_cost_Polymers = id == "SecurityPostCCP1" and 3000 or 8000

    local tech = Presets.TechPreset.Social["SupportiveCommunity"]
    local modified = tech.Tremualin_CriminalPsychologists
    if not modified then
        tech.description = Untranslated("Security building Upgrade (<em>Criminal Psychologists</em>) - Increases the performance of the Security building by 10 if there's a medical building in the Dome. Doubled if the medical building is a Spire or a Hospital.\n") .. tech.description
        tech.Tremualin_CriminalPsychologists = true
    end
end

function SecurityStation:OnChangeWorkshift(old, new)
    Workplace.OnChangeWorkshift(self, old, new)
    if self:HasUpgrade(securityStationCriminalPsychologists) then
        local performanceBonus = 10
        local spire_or_hospital = false
        local dome = self.parent_dome
        for _, spire in ipairs(dome.labels.Spire or empty_table) do
            if spire.working and spire:IsKindOf("MedicalCenter") then
                spire_or_hospital = true
            end
        end
        if not spire_or_hospital then
            for _, medical_building in ipairs(dome.labels.MedicalBuilding or empty_table) do
                if medical_building.working and medical_building:IsKindOf("Hospital") then
                    spire_or_hospital = true
                end
            end
        end
        if spire_or_hospital then
            performanceBonus = performanceBonus + 10
        end
        self:SetModifier("performance", "Tremualin_CriminalPsychologists", performanceBonus, 0, "<green>Access to criminal psychologists +" .. performanceBonus .. "</color>")
    end
    -- Fitness for duty evaluation: fire all Renegades from security stations
    if new then
        for _, worker in ipairs(self.workers[new] or empty_table) do
            if not self:IsSuitable(worker) then
                self:FireWorker(worker)
            end
        end
    end
    RebuildInfopanel(self)
end

local function AddBuilding(id, obj, obj_ct)
    -- If the template doesn't have the prop, check the class obj
    local template_id = obj.template_class
    if template_id == "" then
        template_id = obj.template_name
    end

    AddBehavioralMeldingUpgrade(obj, id)
    AddBehavioralMeldingUpgrade(obj_ct, id)
    AddCriminalPsychologistsUpgrade(obj, id)
    AddCriminalPsychologistsUpgrade(obj_ct, id)
end

-- Fitness for duty evaluation: Renegades cannot work on security buildings anymore
function OnMsg.ClassesPostprocess()
    local ct = ClassTemplates.Building
    local BuildingTemplates = BuildingTemplates

    for id, buildingTemplate in pairs(BuildingTemplates) do
        if id == "SecurityStation" or id == "SecurityPostCCP1" then
            AddBuilding(id, buildingTemplate, ct[id])
            -- Don't allow Renegades to work on Security Stations
            buildingTemplate.incompatible_traits = {"Renegade"}
            ct[id].incompatible_traits = {"Renegade"}
        end
    end
end

local function ImproveBehavioralShaping()
    local tech = Presets.TechPreset.Social["BehavioralShaping"]
    local modified = tech.Tremualin_Rehabilitation
    if not modified then
        tech.description = Untranslated("Allows you to turn any non-Senior Residence into a <em>Rehabilitation Center</em> which can cure up to 4 Renegades in Rehabilitation for each Officer working in a Security building in the same dome.\n") .. tech.description
        tech.Tremualin_Rehabilitation = true
    end
end

function StartupCode(...)
    ImproveBehavioralShaping()

    local unlocked_upgrades = UIColony.unlocked_upgrades
    if UIColony:IsTechResearched("BehavioralMelding") then
        UnlockUpgrade(securityStationBehavioralMelding)
    end
    if UIColony:IsTechResearched("SupportiveCommunity") then
        UnlockUpgrade(securityStationCriminalPsychologists)
    end

    ColonistPerformanceReasons["Vindicated"] = Untranslated("Compensating for past crimes <amount> (Vindicated)")
end

OnMsg.TechResearched = StartupCode
OnMsg.LoadGame = StartupCode

-- Renegades under rehabilitation are negated, if security stations are properly staffed
local origin_Dome_GetAdjustedRenegades = Dome.GetAdjustedRenegades
function Dome:GetAdjustedRenegades()
    local renegades_in_rehabilitation = functions.RenegadesInRehabilitation(self)
    local officers_in_security_stations = functions.OfficersInSecurityStations(self)
    local negatedRehabilitationOfficers = Min(#officers_in_security_stations * configuration.MaxRenegadesRehabilitatedPerOfficer, #renegades_in_rehabilitation)
    return Max(0, origin_Dome_GetAdjustedRenegades(self) - negatedRehabilitationOfficers)
end

-- Renegades in rehabilitation don't count
function Dome:CanPreventCrimeEvents()
    local officers = #(self.labels.security or empty_table)
    local renegades = self:GetAdjustedRenegades()
    if officers <= renegades then
        return false
    end
    local stations = self.labels.SecurityStation or empty_table
    for _, station in ipairs(stations) do
        if station.working then
            local chance = 50
            if officers <= renegades * 3 then
                chance = (MulDivRound(officers, 100, 6 * renegades))
            end
            return chance >= Random(1, 100)
        end
    end
    return false
end

function OnMsg.ClassesGenerate()
    -- Prevents Vindicated colonists from becoming Renegades
    local Trem_orig_Colonist_AddTrait = Colonist.AddTrait
    function Colonist:AddTrait(trait_id, init)
        if trait_id == "Renegade" and self.traits.Vindicated then
            return
        else
            Trem_orig_Colonist_AddTrait(self, trait_id, init)
        end
    end
end -- function OnMsg.ClassesGenerate()
