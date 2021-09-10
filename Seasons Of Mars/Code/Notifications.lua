local seasonalEffectsText = table.concat({
    Untranslated("<white>Seasons:</white>"),
    Untranslated("<em>Summer</em> (89 sols): <em>Dust Storms</em> are 2% longer each sol"),
    Untranslated("<em>Autumn</em> (71 sols): <em>Dust Storms</em> and <em>Cold Waves</em> appear 1% faster each sol"),
    Untranslated("<em>Winter</em> (77 sols): <em>Cold Waves</em> are 2% longer each sol"),
    Untranslated("<em>Spring</em> (97 sols): <em>Everything</em> slowly returns to their original value"),
}, "< newline >")

local function SeasonsOfMarsWelcome()
    if not SeasonsOfMars.Greetings then
        CreateRealTimeThread(function()
            local params = {
                title = Untranslated("Welcome to Seasons of Mars (Mod)"),
                minimized_notification_priority = "CriticalBlue",
                choice1 = Untranslated("Ok"),
                image = "UI/Messages/hints.tga",
                start_minimized = true,
            }

            local greetings = Untranslated("<white>Seasons of Mars</white> extends <em>Surviving Mars</em> with new seasonal effects to make the game more difficult.< newline >< newline >Will you Terraform your way out of the problem?< newline >Will you find refuge Below and Beyond instead?< newline >Or will you power through the seasons and survive until next Spring?< newline >< newline >")
            params.text = greetings .. seasonalEffectsText .. Untranslated("< newline >< newline >It's the beginning of <em>Summer</em> and all is calm. But not for long. Good luck!")
            Sleep(5000) -- add 5 second delay to allow for the map load to prevent issue with lockup
            local choice = WaitPopupNotification(false, params)
            SeasonsOfMars.Greetings = true
        end) -- CreateRealTimeThread
    end
end -- function end

OnMsg.LoadGame = SeasonsOfMarsWelcome
OnMsg.CityStart = SeasonsOfMarsWelcome

local vanilla_id_day_progress_text = T(4027, "Hour <hour> of Sol <day>. Martian days consist of nearly 25 Earth hours.")
local vanilla_id_sol_text = T(8104, "Martian days consist of nearly 25 Earth hours.")

local orig_HUD_SetDayProgress = HUD.SetDayProgress
function HUD:SetDayProgress(value)
    orig_HUD_SetDayProgress(self, value)
    local seasonsOfMars = SeasonsOfMars
    local activeSeason = seasonsOfMars.ActiveSeason
    local daysLeft = seasonsOfMars[activeSeason].Duration - seasonsOfMars.ActiveSeasonDuration
    local currentSeasonDescription = Untranslated(string.format("< newline >< newline ><white>%d sols</white> before <em>%s</em>< newline >< newline >", daysLeft, seasonsOfMars[activeSeason].NextSeason))

    -- Appears over the progress bar
    self.idDayProgress:SetRolloverText(seasonalEffectsText .. currentSeasonDescription .. vanilla_id_day_progress_text)

    local dlg = GetHUD()
    -- Appears over the day bar
    if dlg then
        dlg.idSol:SetRolloverText(seasonalEffectsText .. currentSeasonDescription .. vanilla_id_sol_text)
    end
end
