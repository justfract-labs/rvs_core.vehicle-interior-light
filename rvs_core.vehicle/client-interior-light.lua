CreateThread(function ()
    local keyPressedTime = nil

    while true do
        local player = PlayerPedId()
        local waitTime = 3000

        if IsPedInAnyVehicle(player, false) then
            local vehicle = GetVehiclePedIsIn(player, false)

            if GetPedInVehicleSeat(vehicle, -1) == player then
                waitTime = 50

                local currentTime = GetGameTimer()

                -- H키를 짧게 누르면 기본값인 차량의 헤드라이트가 작동되도록 하고, 길게 누르면 차량의 실내등이 작동되도록 합니다.
                if IsControlPressed(0, 74) or IsDisabledControlPressed(0, 74) then
                    if not keyPressedTime then
                        keyPressedTime = currentTime

                    elseif currentTime - keyPressedTime > 100 then
                        waitTime = 1; DisableControlAction(0, 74, true)
                    end

                    if currentTime - keyPressedTime >= 1000 then
                        local networkId = NetworkGetNetworkIdFromEntity(vehicle)

                        TriggerServerEvent('server/reverse_core:ToggleVehicleState', networkId, 'interior_light', not IsVehicleInteriorLightOn(vehicle)); keyPressedTime = nil

                        local disableUntil = GetGameTimer() + 100; while GetGameTimer() < disableUntil do
                            Wait(1); DisableControlAction(0, 74, true)
                        end
                    end
                else
                    keyPressedTime = nil
                end
            end
        end

        Wait(waitTime)
    end
end)

AddStateBagChangeHandler('interior_light', '', function (name, key, value)
    local entity = GetEntityFromStateBagName(name); if entity == 0 then
        return
    end

    SetVehicleInteriorlight(entity, value)
end)