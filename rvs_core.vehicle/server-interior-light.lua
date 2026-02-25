RegisterNetEvent('server/reverse_core:ToggleVehicleState', function (networkId, type, state)
    local vehicle = NetworkGetEntityFromNetworkId(networkId); if not DoesEntityExist(vehicle) then
        return
    end

    Entity(vehicle).state[type] = state
end)