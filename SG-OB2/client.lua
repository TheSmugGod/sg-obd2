
-- Event handler for using the OBD2 scanner
RegisterNetEvent('obd2:ReadData')
AddEventHandler('obd2:ReadData', function(vehicle, vehicleNetId)
    local playerPed = PlayerPedId()
    local vehiclePed = GetVehiclePedIsIn(playerPed, false)
    if vehiclePed then
        local state = Entity(vehiclePed).state
        local obd2Data = state.FaultData
        if obd2Data then
           -- print("OBD2 Data Found:", obd2Data)
            -- Handle displaying the OBD2 data to the player

            local faultAlert = lib.alertDialog({
                header = 'Falut Code/s Detected!',
                content = obd2Data,
                centered = true,
                cancel = true
            })
			if Config.debugprint then
            print(faultAlert)
			end
        else
           -- print("No OBD2 Data Found")
            -- Handle notifying the player that no data is available
            lib.notify({
                title = 'OBD2 Scanner',
                description = 'No Fault Codes Detected!',
                type = 'success'
            })
        end
    else
		if Config.debugprint then
        print("You must be in a vehicle to set OBD2 data.")
		end
    end
end)

RegisterNetEvent('obd2:UseScanner')
AddEventHandler('obd2:UseScanner', function(vehicle, vehicleNetId)
    local playerPed = PlayerPedId()
    local vehiclePed = GetVehiclePedIsIn(playerPed, false)
    if vehiclePed then
        local state = Entity(vehiclePed).state
        local obd2Data = state.FaultData

        lib.showContext('obd2_menu')

      --  if obd2Data then
       --     print("OBD2 Data Found:", obd2Data)
            -- Handle displaying the OBD2 data to the player
       -- else
       --     print("No OBD2 Data Found")
            -- Handle notifying the player that no data is available
      --  end
    else
		if Config.debugprint then
        print("You must be in a vehicle to set OBD2 data.")
		end
    end
end)

RegisterNetEvent("obd2:setData")
AddEventHandler("obd2:setData", function(vehicleNetId, obd2Data)
    local vehicle = NetworkGetEntityFromNetworkId(vehicleNetId)
    if DoesEntityExist(vehicle) then
        Entity(vehicle).state.FaultData = obd2Data
		if Config.debugprint then
        print("Updated OBD2 Data to:", Entity(vehicle).state.FaultData)
		end
    else
		if Config.debugprint then
        print("Invalid vehicle network ID received:", vehicleNetId)
		end
    end
end)

-- Event handler to display engine status to the player
RegisterNetEvent('obd2:DisplayEngineStatus')
AddEventHandler('obd2:DisplayEngineStatus', function(engineDamaged)
    if engineDamaged then
		if Config.debugprint then
		print("Vehicle engine is damaged ")
        -- Handle notifying the player that the engine is damaged
		end
    else
       -- print("Vehicle engine is not damaged")
        -- Handle notifying the player that the engine is not damaged
    end
end)

-- Event handler for when a vehicle/entity is damaged
AddEventHandler('entityDamaged', function(victim, attacker, weaponHash, damage)
    if IsEntityAVehicle(victim) then
        local vehicle = victim
        local engineHealth = GetVehicleEngineHealth(vehicle)

        if engineHealth > 675 and engineHealth < 800 then
            -- Engine health is between 700 and 800
            -- Set Data to P0128 - Coolant Temperature Below Thermostat Regulating Temperature
			if Config.debugprint then
            print(engineHealth)
			end
            TriggerServerEvent('obd2:UpdateTheDamage', vehicle, 'P0128 - Coolant Temperature Below Thermostat Regulating Temperature')
        end

        if engineHealth > 550 and engineHealth < 675 then
            -- Engine health is between 400 and 700
            -- Set Data to P0300 - Random or Multiple Cylinder Misfire Detected
            TriggerServerEvent('obd2:UpdateTheDamage', vehicle, 'P0128 - Coolant Temperature Below Thermostat Regulating Temperature     P0300 - Random or Multiple Cylinder Misfire Detected')
        end

        if engineHealth > 460 and engineHealth < 550 then
            -- Engine health is between 400 and 700
            -- Set Data to P0300 - Random or Multiple Cylinder Misfire Detected
            TriggerServerEvent('obd2:UpdateTheDamage', vehicle, 'P0128 - Coolant Temperature Below Thermostat Regulating Temperature     P0300 - Random or Multiple Cylinder Misfire Detected    P0340 — Camshaft Position Sensor Circuit Malfunction')
        end

        --print("Vehicle Engine Health:", engineHealth)
    end
end)


lib.registerContext({
    id = 'obd2_menu',
    title = 'OBD2 Scanner',
    options = {
      {
        title = 'OBD2 Scanner Connected!',
      },
      {
        title = 'Read Codes',
        description = 'Scan and Read Fault Codes',
        icon = 'magnifying-glass',
        event = 'obd2:ReadData',
        arrow = true
      },
      {
        title = 'Clear Codes',
        description = 'Scan and Read Fault Codes',
        icon = 'eraser',
        event = 'obd2:DeleteData',
        arrow = true
      }
    }
  })


RegisterNetEvent('obd2:DeleteData')
AddEventHandler('obd2:DeleteData', function()
      local playerPed = PlayerPedId()
      local vehiclePed = GetVehiclePedIsIn(playerPed, false)
      if vehiclePed then
          local state = Entity(vehiclePed).state
          state.FaultData = nil
          lib.notify({
              title = 'OBD2 Scanner',
              description = 'Fault Data Cleared Successfully!',
              type = 'success'
          })
      else
        if Config.debugprint then
            print('Unable to clear fault data due to player not in vehicle.')
			end
          lib.notify({
            title = 'OBD2 Scanner',
            description = 'Fault Data was unable to be Cleared!',
            type = 'error'
        })
      end
  end)