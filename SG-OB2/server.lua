if Config.framework = "esx" then

local ESX = exports["es_extended"]:getSharedObject()
	ESX.RegisterUsableItem('obd2', function(source)
	local playerped = GetPlayerPed(source)
	local vehicle = GetVehiclePedIsIn(playerped, false)
		if vehicle then
			local vehicleNetId = NetworkGetNetworkIdFromEntity(vehicle)
			TriggerClientEvent('obd2:UseScanner', source, vehicle, vehicleNetId) -- Pass the vehicle to the clients
		end
	end)

elseif Config.framework = "qb" then 


local QBCore = exports['qb-core']:GetCoreObject()

	QBCore.Functions.CreateUseableItem("obd2", function(source, item)
	local playerped = GetPlayerPed(source)
	local vehicle = GetVehiclePedIsIn(playerped, false)
		if vehicle then
			local vehicleNetId = NetworkGetNetworkIdFromEntity(vehicle)
			TriggerClientEvent('obd2:UseScanner', source, vehicle, vehicleNetId) -- Pass the vehicle to the clients
		end
	end)

end

RegisterCommand("set_obd2_data", function(source, args, rawCommand)
    local playerped = GetPlayerPed(source)
    local vehicle = GetVehiclePedIsIn(playerped, false)
    if vehicle then
        local obd2Data = args[1] -- Assuming the data is passed as the first argument to the command
        local vehicleNetId = NetworkGetNetworkIdFromEntity(vehicle)
        if vehicleNetId ~= 0 then
            TriggerClientEvent("obd2:setData", source, vehicleNetId, obd2Data)
			if Config.debugprint then
            print("OBD2 data set successfully:", obd2Data)
			end
        else
		if Config.debugprint then
            print("Failed to get network ID for the vehicle.")
			end
        end
    else
		if Config.debugprint then
        print("You must be in a vehicle to set OBD2 data.")
		end
    end
end, false)



-- Function to check if a vehicle engine is damaged or not working
function IsVehicleEngineDamaged(vehicle)
    local engineHealth = GetVehicleEngineHealth(vehicle)
 --   print (engineHealth)
    -- Define a threshold value for engine health
    local damageThreshold = 800
    local engineLockedThreshold = 100

    return engineHealth < damageThreshold or engineHealth <= engineLockedThreshold
end

--  command to check vehicle engine damage
RegisterCommand("check_vehicle_damage", function(source, args, rawCommand)
    local playerPed = GetPlayerPed(source)
        local vehicle = GetVehiclePedIsIn(playerPed, false)
        if vehicle then
            if IsVehicleEngineDamaged(vehicle) then
                TriggerClientEvent('chatMessage', source, "^1Vehicle engine is damaged")
            else
                TriggerClientEvent('chatMessage', source, "^2Vehicle engine is not damaged")
            end
        else
            TriggerClientEvent('chatMessage', source, "^1You are not in a vehicle")
        end
end, false)


-- Function to update the engine status in the state bag
function UpdateEngineStatus(vehicle)
    local engineDamaged = IsVehicleEngineDamaged(vehicle)
    local state = Entity(vehicle).state
    state.EngineDamaged = engineDamaged
end

-- Event handler to handle player using the OBD2 scanner
RegisterCommand("check_engine_status", function(source, args, rawCommand)
    local playerPed = GetPlayerPed(source)
    local vehicle = GetVehiclePedIsIn(playerPed, false)
    if vehicle then
        UpdateEngineStatus(vehicle)
        local state = Entity(vehicle).state
        local engineDamaged = state.EngineDamaged
        TriggerClientEvent('obd2:DisplayEngineStatus', source, engineDamaged, vehicle)
    else
      --  TriggerClientEvent('chatMessage', source, "^1You are not in a vehicle")
    end
end, false)

RegisterNetEvent('obd2:UpdateTheDamage')
AddEventHandler('obd2:UpdateTheDamage', function(veh, faultdata)
    local playerped = GetPlayerPed(source)
    local vehicle = GetVehiclePedIsIn(playerped, false)
    if vehicle then
        local obd2Data = faultdata -- Assuming the data is passed as the first argument to the command
        local vehicleNetId = NetworkGetNetworkIdFromEntity(vehicle)
        if vehicleNetId ~= 0 then
            TriggerClientEvent("obd2:setData", source, vehicleNetId, obd2Data)
			if Config.debugprint then
            print("OBD2 data set successfully:", obd2Data)
			end
        else
			if Config.debugprint then
            print("Failed to get network ID for the vehicle.")
			end
        end
    else
		if Config.debugprint then
        print("You must be in a vehicle to set OBD2 data.")
		end
    end
end)
