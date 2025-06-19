local Original_Cooldowns = {
    ExtraCooldown = 10800000,
    MaxCooldown = 8640000,
    MinCooldown = 360000,
    TickDuration = 30000
}

-- Lower Story Bit Cooldown
function ApplyStoryBitCooldownModifier()
    local apply = CurrentModOptions:GetProperty("MoreStoryBits")
    for id, cooldown in pairs(Original_Cooldowns) do
        if apply then
            const.StoryBits[id] = cooldown / 2
        else
            const.StoryBits[id] = cooldown
        end
    end
end
OnMsg.ModsReloaded = ApplyStoryBitCooldownModifier
OnMsg.ApplyModOptions = ApplyStoryBitCooldownModifier
