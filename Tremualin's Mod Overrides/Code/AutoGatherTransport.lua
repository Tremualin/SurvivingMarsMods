-- Original gathers 1 deposit at a time then travels back; this makes the Rover gather as much as possible before coming back
local function IdleRoverLogic(rover, zonesReachable, roverZone, deposits, tunnelHandling)
    -- if inventory is not full, search for a resource
    -- else, unload the inventory
    if not rover:IsStorageFull() then
        AutoGatherFindDeposit(rover, zonesReachable, roverZone, deposits, tunnelHandling)
        -- If we are still idle, it means there are no more deposits; go unload
        if rover.command == "Idle" then
            AutoGatherUnloadContent(rover, zonesReachable, roverZone, tunnelHandling)
        end
    else
        AutoGatherUnloadContent(rover, zonesReachable, roverZone, tunnelHandling)
    end
end

-- If the mod is installed, we will override it
if AutoGatherHandleTransports then
    function AutoGatherHandleTransports()
        -- game is not yet initialized
        if not ActiveMapData.GameLogic then
            return
        end
        -- should the logic try and work out paths via tunnels?
        local tunnelHandling = AutoGatherTunnelHandling() == "on";

        -- first collect up all the zones which have tunnel entrances/exits
        local zonesReachable = AutoGatherPathFinding:GetZonesReachableViaTunnels()

        local deposits = GetObjects {
            classes = "SurfaceDepositMetals,SurfaceDepositConcrete,SurfaceDepositPolymers,SurfaceDepositGroup,WasteRockStockpileBase"
        }

        --[[
        local deposits = { }
     
        for _, obj in pairs(UICity.labels.SurfaceDeposit) do
            deposits[#deposits + 1] = obj
        end
     
        for _, obj in pairs(SurfaceDepositGroups) do
            if obj.holder then
                deposits[#deposits + 1] = obj.holder
            end
        end
        --]]

        AutoGatherForEachLabel("RCTransportAndChildren", function(rover)
            -- Enabled via the InfoPanel UI section "Auto Gather"
            if rover.auto_gather then

                local roverZone = AutoGatherPathFinding:GetObjectZone(rover) or 0

                -- Idle transporters only
                if rover.command == "Idle" or rover.command == "LoadingComplete" then
                    IdleRoverLogic(rover, zonesReachable, roverZone, deposits, tunnelHandling)
                end
            end
        end)
    end
end
