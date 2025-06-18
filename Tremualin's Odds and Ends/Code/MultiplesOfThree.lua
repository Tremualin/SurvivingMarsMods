-- Nurseries have multiples of 3 (9, 30)
-- Which better fits with Schools (multiples of 15 or 36)
local function MofTNurseryCapacity()
    BuildingTemplates.Nursery.capacity = 9
    if IsDlcAvailable("kerwin") then
        BuildingTemplates.LargeNurseryCCP1.capacity = 30
    end
end

-- The others are modified to better fits with Jobs (which usually come in 3 Shifts)
local function MofTSeniorResidenceCapacity()
    if IsDlcAvailable("kerwin") then
        BuildingTemplates.SeniorsResidenceCCP1.capacity = 18
    end
end

local function MofTSmartApartmentCapacity()
    if IsDlcAvailable("kerwin") then
        BuildingTemplates.SmartApartmentsCCP1.capacity = 21
    end
end

local function MofTLivingQuartersCapacity()
    BuildingTemplates.LivingQuarters.capacity = 18
    if IsDlcAvailable("contentpack3") then
        BuildingTemplates.LivingQuarters_Small.capacity = 5
    end
end

local function MofTSmartHomeCapacity()
    BuildingTemplates.SmartHome.capacity = 15
    BuildingTemplates.SmartHome_Small.capacity = 5
end

local function MofTApartmentCapacity()
    BuildingTemplates.Apartments.capacity = 27
end

local function MofTArcologyCapacity()
    BuildingTemplates.Arcology.capacity = 36
    BuildingTemplates.Arcology.upgrade2_add_value_1 = 9
end

local function Mof3Capacity()
    MofTNurseryCapacity()
    MofTSeniorResidenceCapacity()
    MofTSmartApartmentCapacity()
    MofTLivingQuartersCapacity()
    MofTSmartHomeCapacity()
    MofTApartmentCapacity()
    MofTArcologyCapacity()
end
OnMsg.ClassesPostprocess = Mof3Capacity()
