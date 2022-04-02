Tremualin.Configuration.RandomBreakthroughChoices = 4

local configuration = Tremualin.Configuration

local function GetRandomUnregisteredBreakthroughs(first_breakthrough)
    local colony = UIColony
    local choices = configuration.RandomBreakthroughChoices
    local unregistered_breakthroughs = colony:GetUnregisteredBreakthroughs()
    local random_breakthroughts = {}
    if first_breakthrough and not colony:IsTechDiscovered(first_breakthrough.id) and colony:TechAvailableCondition(first_breakthrough) then
        table.insert(random_breakthroughts, first_breakthrough)
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
        table.insert(random_breakthroughts, TechDef[unregistered_breakthroughs[i]])
    end
    return random_breakthroughts
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
                text = Untranslated("Our scientists believe that the recent findings will reveal never before seen technologies. But the experts can't agree on which path to pursue. Would you kindly help them choose a possible practical application of the discovery?"),
                minimized_notification_priority = "CriticalBlue",
                image = "UI/Messages/Events/03_discussion.tga",
                start_minimized = false,
                dismissable = false
            }

            local choices = {}
            local random_breakthroughts = GetRandomUnregisteredBreakthroughs(first_breakthrough)
            for i, breakthrought in ipairs(random_breakthroughts) do
                choices[i] = breakthrought
                params["choice" .. i] = breakthrought.display_name
            end
            if #random_breakthroughts > 0 then
                local choice = choices[WaitPopupNotification(false, params)]
                -- Is the chosen tech is already choice we had a bit of a race condition; try again
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

local orig_PlanetaryAnomaly_Scan = PlanetaryAnomaly.Scan
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
    orig_PlanetaryAnomaly_Scan(self, rocket)
end

function OmegaTelescope:UnlockBreakthroughs(count)
    CreateGameTimeThread(function()
        local unlocked = 0
        while count > unlocked do
            ShowCherryPickingPopup(nil, nil, "BreakthroughDiscovered", true)
            unlocked = unlocked + 1
            Sleep(100)
        end
    end)
end
