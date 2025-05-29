local function SwapDustRepulsionWithLowGTurbines()
    local physics = Presets.TechPreset.Physics
    physics.DustRepulsion.position = range(1, 5)
    physics.LowGTurbines.position = range(7, 9)
end

local function SwapSupportiveCommunitywithProductivityTraining()
    local tech = Presets.TechPreset.Social
    tech.SupportiveCommunity.position = range(1, 5)
    tech.ProductivityTraining.position = range(7, 10)
end

local function SwapGeneralTrainingWithSystematicTraining()
    local tech = Presets.TechPreset.Social
    tech.GeneralTraining.position = range(1, 5)
    tech.SystematicTraining.position = range(7, 10)
end

local function TriboelectricScrubbingAppearsAtRange18()
    local physics = Presets.TechPreset.Physics
    physics.TriboelectricScrubbing.position = range(18, 18)
end

local function SwapProjectMoholeWithLargeScaleExcavation()
    local robotics = Presets.TechPreset.Robotics
    robotics.ProjectMohole.position = range(20, 20)
    robotics.LargeScaleExcavation.position = range(19, 19)
end

local function SwapSustainableArchitectureWithPlasmaCutters()
    local engineering = Presets.TechPreset.Engineering
    engineering.SustainableArchitecture.position = range(14, 19)
    engineering.PlasmaCutters.position = range(6, 12)
end

local function SwapWaterReclamationWithWaterConservationSystemWithUtilityCrops()
    local biotech = Presets.TechPreset.Biotech
    biotech.WaterReclamation.position = range(12, 19)
    biotech.WaterCoservationSystem.position = range(6, 6)
    biotech.UtilityCrops.position = range(1, 5)
end

function OnMsg.ClassesPostprocess()
    SwapDustRepulsionWithLowGTurbines()
    SwapSupportiveCommunitywithProductivityTraining()
    SwapGeneralTrainingWithSystematicTraining()
    TriboelectricScrubbingAppearsAtRange18()
    SwapProjectMoholeWithLargeScaleExcavation()
    SwapSustainableArchitectureWithPlasmaCutters()
    SwapWaterReclamationWithWaterConservationSystemWithUtilityCrops()
end

