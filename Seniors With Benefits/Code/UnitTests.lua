
local function SeniorsWithBenefitsDailyUpdatesTest()
    local failed = false
    for _, city in ipairs(Cities) do
        for _, colonist in ipairs(city.labels.Colonist or empty_table) do
            local status, err = pcall(Colonist.DailyUpdate, colonist)
            if not status then
                failed = true
                print (string.format("SeniorsWithBenefitsDailyUpdatesTest threw an error: %s", err))
            end
        end
    end
    if failed then print("SeniorsWithBenefitsDailyUpdatesTest failed at least once")
    else print("SeniorsWithBenefitsDailyUpdatesTest successful") end
end

local function SeniorsWithBenefitsWellBeingMattersTest()
    for _, city in ipairs(Cities) do
        local status, err = pcall(City.DailyUpdate, city, city.day)
        if not status then print (string.format("SeniorsWithBenefitsWellBeingMattersTest threw an error: %s", err))
        else print("SeniorsWithBenefitsWellBeingMattersTest successful") end
    end
end

local function SeniorsWithBenefitsTests()
    SeniorsWithBenefitsWellBeingMattersTest()
    SeniorsWithBenefitsDailyUpdatesTest()
end

Tremualin.Tests.SeniorsWithBenefitsDailyUpdatesTest = SeniorsWithBenefitsDailyUpdatesTest
Tremualin.Tests.SeniorsWithBenefitsTests = SeniorsWithBenefitsTests
