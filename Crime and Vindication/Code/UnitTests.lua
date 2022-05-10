-- Functions that I can call from ECM to test the mod is working fine

local DomeCrimeTests = {
    Protests = Dome.Tremualin_CrimeEvents_Protest,
    Vandalism = Dome.Tremualin_CrimeEvents_Vandalism,
    StoleResource = Dome.CrimeEvents_StoleResource,
    SabotageBuilding = Dome.CrimeEvents_SabotageBuilding,
    Embezzlement = Dome.Tremualin_CrimeEvents_Embezzlement,
    CheckCrimeEvents1 = Dome.CheckCrimeEvents,
    CheckCrimeEvents2 = Dome.CheckCrimeEvents,
    CheckCrimeEvents3 = Dome.CheckCrimeEvents,
    CheckCrimeEvents4 = Dome.CheckCrimeEvents,
    CheckCrimeEvents5 = Dome.CheckCrimeEvents
}

local function CrimeTests(dome)
    for _, colonist in ipairs(dome.labels.Colonist or empty_table) do
        colonist:AddTrait("Renegade")
    end
    for crime_text, crime_function in pairs(DomeCrimeTests) do
        local status, err = pcall(crime_function, dome)
        if status then
            print (string.format("%s test threw no errors", crime_text))
        else
            print (string.format("%s test threw an error: %s", crime_text, err))
        end
    end
end

local function DomesticViolenceTests(dome)
    local failed = false
    for _, colonist in ipairs(dome.labels.Colonist or empty_table) do
        colonist:AddTrait("Violent")
        local status, err = pcall(colonist.DailyUpdate, colonist)
        if not status then
            failed = true
            print (string.format("Domestic violence test threw an error: %s", err))
        end
    end
    if failed then print("Domestic violence tests failed at least once")
    else print("Domestic violence tests successful") end
end

local function FirstRespondersTest(dome)
    local failed = false
    local status, err = pcall(Dome.GetDomeComfort, dome)
    if not status then
        failed = true
        print (string.format("First Responders test threw an error: %s", err))
    end
    if failed then print("First Responders test failed at least once")
    else print("First Responders tests successful") end
end

local function CrimeAndVindicationTests()
    for dome in ipairs(UIColony.city_labels.labels.Dome or empty_table) do
        CrimeTests(dome)
        DomesticViolenceTests(dome)
        FirstRespondersTest(dome)
    end
end

Tremualin.Tests.CrimeTests = CrimeTests
Tremualin.Tests.DomesticViolenceTests = DomesticViolenceTests
Tremualin.Tests.FirstRespondersTest = FirstRespondersTest
Tremualin.Tests.CrimeAndVindicationTests = CrimeAndVindicationTests
