local FITNESS_ICON = CurrentModPath .. "fitness.png"
local FITNESS_STAT_ID = "Tremualin_Fitness"
local ui_functions = Tremualin.UIFunctions

function OnMsg.ClassesPostprocess()
    -- Morale statuses related to Fitness
    ColonistStatReasons["-" .. FITNESS_STAT_ID] = Untranslated("<red>Existence is pain <amount> (Fitness)</red>")
    ColonistStatReasons["+" .. FITNESS_STAT_ID] = Untranslated("Ain’t no mountain high enough <amount> (Fitness)")

    -- A panel that shows average fitness averages on the UI; appears before Domestic
    local sectionDomeTemplate = XTemplates.sectionDome
    ui_functions.RemoveXTemplateSections(sectionDomeTemplate, "Tremualin_AverageFitnessSection")
    local tremualin_AverageFitnessSection = PlaceObj("XTemplateTemplate", {
        "Tremualin_AverageFitnessSection", true,
        "__context_of_kind", "Dome",
        '__template', "InfopanelSection",
        'RolloverText', Untranslated("The average <em>Fitness</em> of all Colonists living in this Dome."),
        'RolloverTitle', Untranslated("Average Fitness <Stat(AverageFitness)>"),
        'Icon', FITNESS_ICON,
        }, {
        PlaceObj('XTemplateTemplate', {
            '__template', "InfopanelStat",
            'BindTo', "AverageFitness",
        }),
    })

    local possibleIndex1 = ui_functions.FindSectionIndexBeforeExistingIfPossible(sectionDomeTemplate, "Tremualin_SeniorsLifetime")
    local possibleIndex2 = ui_functions.FindSectionIndexBeforeExistingIfPossible(sectionDomeTemplate, "Tremualin_DomesticViolenceLifetime")
    table.insert(sectionDomeTemplate, Min(possibleIndex1, possibleIndex2), tremualin_AverageFitnessSection)
end

local function BuildColonistsOverviewFitnessFilter()
    return PlaceObj('XTemplateWindow', {
        'comment', "stats: fitness",
        '__class', "XTextButton",
        'Margins', box(24, 0, 0, 0),
        'MinWidth', 36,
        'MinHeight', 31,
        'MaxWidth', 36,
        'MaxHeight', 31,
        'MouseCursor', "UI/Cursors/Rollover.tga",
        'OnPress', function (self, gamepad)
            SetColonistsSorting(self, "Tremualin_stat_fitness")
        end,
        'Image', FITNESS_ICON,
    })
end

local function BuildDomesOverviewFitnessFilter()
    return PlaceObj('XTemplateWindow', {
        'comment', "stats: fitness",
        '__class', "XImage",
        'Margins', box(0, 0, 27, 0),
        'MinWidth', 65,
        'MinHeight', 34,
        'MaxWidth', 65,
        'MaxHeight', 34,
        'Image', FITNESS_ICON,
        'ImageFit', "smallest",
    })
end

function UpdateColonistsOverviewFitnessFilter(template)
    for index, section in pairs(template) do
        if (type(section) == "table") then
            if section.Image and section.Image == "UI/Icons/Sections/satisfaction.tga" then
                table.insert(template, index + 1, BuildColonistsOverviewFitnessFilter())
                break
            else UpdateColonistsOverviewFitnessFilter(section)
            end
        end
    end
end

function UpdateDomesOverviewFitnessFilter(template)
    for index, section in pairs(template) do
        if (type(section) == "table") then
            if section.Image and (section.Image == "UI/Icons/Sections/satisfaction" or section.Image == "UI/Icons/Sections/satisfaction.tga") then
                section.Margins = box(0, 0, 0, 0)
                table.insert(template, index + 1, BuildDomesOverviewFitnessFilter())
                break
            else UpdateDomesOverviewFitnessFilter(section)
            end
        end
    end
end

function OnMsg.ClassesPostprocess()
    UpdateColonistsOverviewFitnessFilter(XTemplates.ColonistsOverview)
    UpdateDomesOverviewFitnessFilter(XTemplates.DomesOverview)
end
