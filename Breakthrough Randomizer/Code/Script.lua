local randomBreakthroughChoices

local function ModOptions(id)
    if id and id ~= CurrentModId then
        return
    end

    randomBreakthroughChoices = CurrentModOptions:GetProperty("BreakthroughChoices")
end

OnMsg.ModsReloaded = ModOptions
OnMsg.ApplyModOptions = ModOptions

local function GetRandomUnregisteredBreakthroughs(first_breakthrough)
    local colony = UIColony
    local choices = randomBreakthroughChoices
    local unregistered_breakthroughs = colony:GetUnregisteredBreakthroughs()
    local breakthroughs = {}
    if first_breakthrough and not colony:IsTechDiscovered(first_breakthrough.id) and colony:TechAvailableCondition(first_breakthrough) then
        table.insert(breakthroughs, first_breakthrough)
        for i = 1, #unregistered_breakthroughs do
            if unregistered_breakthroughs[i] == first_breakthrough.id then
                table.remove(unregistered_breakthroughs, i)
                choices = choices - 1
                break
            end
        end
    end
    StableShuffle(unregistered_breakthroughs, AsyncRand, 100)
    for i = 1, choices do
        table.insert(breakthroughs, TechDef[unregistered_breakthroughs[i]])
    end
    return breakthroughs
end

local GetUUID = function()
    local template = 'xxxxxxxx-xxxx-4xxx-yxxx-xxxxxxxxxxxx'
    return string.gsub(template, '[xy]', function (c)
        local v = (c == 'x') and SessionRandom:Random(0, 0xf) or SessionRandom:Random(8, 0xb)
        return string.format('%x', v)
    end)
end

local function ShowCherryPickingPopup(first_breakthrough, map_id, notification_type, research_instead_of_discover)
    local colony = UIColony
    local unregistered_breakthroughs = colony:GetUnregisteredBreakthroughs()
    if #unregistered_breakthroughs > 0 then
        CreateRealTimeThread(function()
            local params = {
                id = GetUUID(),
                title = Untranslated("Available Breakthroughs"),
                text = Untranslated("Our Rover has found a specimen like none we have ever seen before. Scientists, Engineers, Botanists, Medics, Geologists and even Officers believe they can gather crucial information from the samples, and have some ideas of what we might find if we analyze them. There's a catch...the analysis will alter the specimen permanently. We might not get any more useful data from it after the experiment. As the commander of the Colony, the choice is yours to make."),
                minimized_notification_priority = "CriticalBlue",
                image = "UI/Messages/Events/03_discussion.tga",
                start_minimized = false,
                dismissable = false
            }

            local choices = {}
            local breakthroughs = GetRandomUnregisteredBreakthroughs(first_breakthrough)
            for i, breakthrough in ipairs(breakthroughs) do
                choices[i] = breakthrough
                params["choice" .. i] = breakthrough.display_name
                params["choice" .. i .. "_rollover_title"] = "<image " .. breakthrough.icon .. " 400>" .. breakthrough.display_name
                params["choice" .. i .. "_rollover"] = _InternalTranslate(breakthrough.description, breakthrough)
            end
            if #breakthroughs > 0 then
                local confirmationParams = {
                    id = GetUUID(),
                    title = Untranslated("Are you sure?"),
                    minimized_notification_priority = "CriticalBlue",
                    image = "UI/Messages/Events/03_discussion.tga",
                    start_minimized = false,
                    dismissable = false
                }
                local confirmedChoice = false
                while not confirmedChoice do
                    local choice = choices[WaitPopupNotification(false, params)]
                    confirmedChoice = "ok" == WaitQuestion(terminal.desktop, Untranslated("<image " .. choice.icon .. " 400>" .. choice.display_name), Untranslated("Commander, you've chosen to unlock " .. choice.display_name .. ". Are you sure about that?"), Untranslated("Yes, unlock " .. choice.display_name), Untranslated("Um, Actually...No"))
                    if confirmedChoice then
                        -- Is the chosen tech is already chosen we had a bit of a race condition; try again
                        if colony:IsTechResearched(choice.id) then
                            ShowCherryPickingPopup(first_breakthrough, map_id, notification_type, research_instead_of_discover)
                            return
                        end

                        -- Omega telescope will research instead of discover
                        if research_instead_of_discover then colony:SetTechResearched(choice.id) else colony:SetTechDiscovered(choice.id) end
                        if map_id then
                            AddOnScreenNotification(notification_type, OpenResearchDialog, {
                                name = choice.display_name,
                                context = choice,
                                rollover_title = choice.display_name,
                                rollover_text = choice.description
                            }, nil, map_id)
                        else
                            AddOnScreenNotification(notification_type, OpenResearchDialog, {
                                name = choice.display_name,
                                context = choice,
                                rollover_title = choice.display_name,
                                rollover_text = choice.description
                            })
                        end
                    end
                end
            end
        end) -- CreateRealTimeThread
        return true
    else
        return false
    end
end

local orig_SubsurfaceAnomaly_ScanCompleted = SubsurfaceAnomaly.ScanCompleted
function SubsurfaceAnomaly:ScanCompleted(scanner, ...)
    local research = scanner and scanner.city and scanner.city.colony or UIColony
    local tech_action = self.tech_action
    local map_id = self:GetMapID()
    if tech_action == "breakthrough" then
        local first_breakthrough = TechDef[self.breakthrough_tech]
        if ShowCherryPickingPopup(first_breakthrough, map_id, "BreakthroughDiscovered") then
            -- proceeds with the original method but doesn't unlock anything extra
            self.tech_action = "none"
        else
            -- if no breakthroughs are found, unlock new technologies
            self.tech_action = "unlock"
        end
    end
    return orig_SubsurfaceAnomaly_ScanCompleted(self, scanner, ...)
end

local Orig_Tremualin_PlanetaryAnomaly_Scan = PlanetaryAnomaly.Scan
function PlanetaryAnomaly:Scan(rocket)
    local reward = self.reward
    if reward == "breakthrough" then
        local first_breakthrough = TechDef[self.breakthrough_tech]
        if ShowCherryPickingPopup(first_breakthrough, nil, "PlanetaryAnomaly_BreakthroughDiscovered") then
            self.reward = false
        else
            self.reward = "tech unlock"
        end
    end
    Orig_Tremualin_PlanetaryAnomaly_Scan(self, rocket)
end

local Orig_Tremualin_Research_UnlockBreakthroughs = Research.UnlockBreakthroughs
function Research:UnlockBreakthroughs(count, name, map_id)
    if table.find(ModsLoaded, "id", "ChoGGi_OmegaUnlocksAll") or table.find(ModsLoaded, "id", "ChoGGi_OmegaUnlocksAllSlowly") then
        return Orig_Tremualin_Research_UnlockBreakthroughs(self, count, name, map_id)
    else
        local unlocked = 0
        while count > unlocked do
            ShowCherryPickingPopup(nil, map_id, "BreakthroughDiscovered", true)
            unlocked = unlocked + 1
        end
    end
end
