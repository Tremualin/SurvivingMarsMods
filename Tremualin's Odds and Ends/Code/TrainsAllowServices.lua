function Dome:GetCommutableDomes(colonist, reason, need)
    local lh_connected = {}
    for d in pairs(Dome.GetConnectedDomes(self)) do
        lh_connected[d] = true
    end
    for _, station in ipairs(self:GetConnectedStations()) do
        if station:IsWorkPossible() then
            for _, s in pairs(station:GetReachableStations(colonist)) do
                lh_connected[s] = true
                for _, d in ipairs(s.labels.Dome or {}) do
                    if d ~= self then
                        lh_connected[d] = true
                    end
                end
            end
        end
    end
    return lh_connected
end
