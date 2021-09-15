local function GetSeasonDuration(season)
    local seasonsOfMars = SeasonsOfMars
    return MulDivRound(seasonsOfMars[season].Duration, 1, seasonsOfMars.DurationDivider)
end

local function GetSeasonalEffectsText()
    return table.concat({
        Untranslated("<white>Seasons:</white>"),
        Untranslated(string.format("<em>Summer</em> (%d sols): <em>Dust Storms</em> appear %.1f%% faster each sol", GetSeasonDuration("Summer"), SeasonsOfMars.FrequencyDifficulty)),
        Untranslated(string.format("<em>Autumn</em> (%d sols): <em>Cold Waves</em> are %.1f%% longer each sol. <em>Dust Storms</em> slowly normalize", GetSeasonDuration("Autumn"), SeasonsOfMars.DurationDifficulty)),
        Untranslated(string.format("<em>Winter</em> (%d sols): <em>Cold Waves</em> appear %.1f%% faster each sol", GetSeasonDuration("Winter"), SeasonsOfMars.FrequencyDifficulty)),
        Untranslated(string.format("<em>Spring</em> (%d sols): <em>Dust Storms</em> are %.1f%% longer each sol. <em>Cold Waves</em> slowly normalize", GetSeasonDuration("Spring"), SeasonsOfMars.DurationDifficulty)),
        Untranslated("Hint: Each Season applies a color filter to vegetation. You can disable the filter in the Mod Options"),
    Untranslated("Hint: You can change duration, frequency and difficulty of Seasons in the Mod Options")}, "< newline >")
end

local function SeasonsOfMarsWelcome()
    if not SeasonsOfMars.Greetings then
        CreateRealTimeThread(function()
            local params = {
                title = Untranslated("Welcome to Seasons of Mars (Mod)"),
                minimized_notification_priority = "CriticalBlue",
                image = "UI/Messages/hints.tga",
                start_minimized = true,
                dismissable = true
            }

            local greetings = Untranslated("<white>Seasons of Mars</white> extends <em>Surviving Mars</em> with new seasonal effects to make the game more difficult.< newline >< newline >Will you Terraform your way out of the problem?< newline >Will you find refuge Below and Beyond instead?< newline >Or will you power through the seasons and survive until next year?< newline >< newline >")
            params.text = greetings .. GetSeasonalEffectsText() .. Untranslated("< newline >< newline >It's the beginning of <em>Spring</em> and all is calm. But not for long. Good luck!< newline >")
            Sleep(5000) -- add 5 second delay to allow for the map load to prevent issue with lockup
            WaitPopupNotification(false, params)
            SeasonsOfMars.Greetings = true
        end) -- CreateRealTimeThread
    end
end -- function end

OnMsg.LoadGame = SeasonsOfMarsWelcome
OnMsg.CityStart = SeasonsOfMarsWelcome

local vanilla_id_day_rollover_progress_text = T(4027, "Hour <hour> of Sol <day>. Martian days consist of nearly 25 Earth hours.")
local vanilla_id_sol_rollover_text = T(8104, "Martian days consist of nearly 25 Earth hours.")
local vanilla_id_sol_text = T({4031, "Sol <day>", day = day})

local orig_HUD_SetDayProgress = HUD.SetDayProgress
function HUD:SetDayProgress(value)
    orig_HUD_SetDayProgress(self, value)
    local seasonsOfMars = SeasonsOfMars
    local activeSeasonId = seasonsOfMars.ActiveSeason
    local daysLeft = GetSeasonDuration(activeSeasonId) - seasonsOfMars.ActiveSeasonDuration
    local currentSeasonDescription = Untranslated(string.format("< newline >< newline ><white>%d sols</white> before <em>%s</em>< newline >< newline >", daysLeft, seasonsOfMars[activeSeasonId].NextSeason))

    -- Appears over the progress bar
    self.idDayProgress:SetRolloverText(GetSeasonalEffectsText() .. currentSeasonDescription .. vanilla_id_day_rollover_progress_text)

    local dlg = GetHUD()
    -- Appears over the day bar
    if dlg then
        dlg.idSol:SetRolloverText(GetSeasonalEffectsText() .. currentSeasonDescription .. vanilla_id_sol_rollover_text)
    end

    local dlg = GetHUD()
    if dlg then
        dlg.idSol:SetText(Untranslated(string.format("%s:", activeSeasonId)) .. vanilla_id_sol_text)
    end
end
