

--  في حين مواجهة اي مشاكل بالسكربت يرجى فتح تذكرة برمجية  https://discord.gg/2mNts9zxdn

vRP = Proxy.getInterface("vRP")
vRPserver = Tunnel.getInterface("vRP", "B3-mechanic")
function LocalPed()
	return GetPlayerPed(-1)
end

local tempo = 300 --وقت تجديد المخزون بالثواني
local oldTowModel = nil
local visits = 1
local l = 0
local area = 0
local onjob = false
local CanLeaveItem = false
local veh
local HashKeyBox = 1778631864
local vehspawn = false
local distanceRepair = 0
local BrokenCar
local service = false

modelTow = {
	[1] = 575699050, --مقعد السيارة
	[2] = -1048832984, --دولاب
	[3] = 309108893, --النفط التعبئة والتغليف
	[4] = -171729071, --مشاكل عامة
	[5] = -1570565546, --الإطارات 2
	[6] = 1589402764, --بطارية
}

local positions = { -- احداثيات العملاء
	{339.86563110352, -744.22387695313, 29.177097320557, 343.37579345703},
	{240.37727355957, -741.38122558594, 34.174812316895, 340.43869018555},
	{245.31466674805, -757.64953613281, 34.2258644104, 159.63557434082},
	{130.36720275879, -703.17340087891, 32.636589050293, 340.24145507813},
	{108.09704589844, -1402.9510498047, 29.273923873901, 317.97241210938},
	{34.917934417725, -1728.1331787109, 29.002185821533, 230.19750976563},
	{24.709989547729, -1739.9895019531, 28.817911148071, 225.16397094727},
	{-56.970668792725, -1844.3989257813, 25.996040344238, 139.78047180176},
	{1325.5910644531, 595.41619873047, 80.095581054688, 312.95910644531},
	{1753.3181152344, 3322.9609375, 41.194774627686, 207.09378051758},
	{1619.5562744141, 3590.5168457031, 35.14624786377, 293.76815795898},
	{1853.6071777344, 3675.9689941406, 33.764854431152, 27.766691207886},
	{-125.21897888184, 6455.2651367188, 31.468463897705, 134.58120727539},
	{2552.0341796875, 4677.1298828125, 33.923233032227, 209.06773376465},
}

local vehmodels = {   --- اكواد المركبات عشوائي يمكن التعديل عليها
	"SENTINEL",
	"BLISTA", 
	"LANDSTALKER", 
	"FACTION",
	"PENUMBRA",
	"WINDSOR", 
	"SCHAFTER3",
	"BUFFALO", 
	"FELTZER2",
	"HUNTLEY", 
	"SABREGT", 
	"DOMINATOR", 
	"EXEMPLAR",
	"RAPIDGT", 
	"BUFFALO", 
	"COMET2",
	"PICADOR",
	"WASHINGTON",
	"GLENDALE",
	"XLS",
	"SULTAN",
	"STRATUM",
	"CHEETAH",
	"COMET2",
	"ELEGY2",
	"EMPEROR2",
	"FELON",
	"FUGITIVE",
	"LANDSTALKER",
	"NINEF",
	"NINEF2",
	"ORACLE",
	"ORACLE2",
	"PHOENIX", 
	"PICADOR", 
	"RAPIDGT",
	"RAPIDGT2",
	"SANCHEZ",
	"SANCHEZ2", 
	"STINGERGT",
	"STRATUM",
	"SULTAN",
	"VOODOO2",
	"WASHINGTON",
	"FELTZER3",
	"VIRGO",
	"WINDSOR"
}  


local myCoords = {}
local coords = {}

Citizen.CreateThread(function()
	while true do
	Citizen.Wait(1)

		local myCoords = GetEntityCoords(GetPlayerPed(-1))
		
		for i = 1, #modelTow do
			closestTowMachine = GetClosestObjectOfType(myCoords.x, myCoords.y, myCoords.z, 2.0, modelTow[i], false, false)
			if closestTowMachine ~= nil and closestTowMachine ~= 0 then
				coords    = GetEntityCoords(closestTowMachine)
				local distance = GetDistanceBetweenCoords(myCoords.x, myCoords.y, myCoords.z, coords.x,coords.y,coords.z, true)
				if distance < 1.50 and onjob then
					nearTow = true
					openMenuTow(nearTow, closestTowMachine)
				elseif distance >= 1.50 and onjob then
					nearTow = false
					openMenuTow(nearTow)
				end
			end
		end	
	end	
end)

Citizen.CreateThread(function()
	while true do
	Citizen.Wait(1)
		local myCoords = GetEntityCoords(GetPlayerPed(-1))
		veh = getNearVeh(10)
		local model = GetEntityModel(veh)
		
		if model == 1353720154 then
		coordsCar = GetOffsetFromEntityInWorldCoords(veh, 0.0, -1.75, 0.0)	
		local distance = GetDistanceBetweenCoords(myCoords.x, myCoords.y, myCoords.z, coordsCar.x,coordsCar.y,coordsCar.z, true)
			if distance < 2.0 and onjob then
				nearTowCar = true
				openMenuTowCar(nearTowCar)
			elseif distance >= 2.0 and onjob then
				nearTowCar = false
				openMenuTowCar(nearTowCar)
			end
		end		
	end	
end)

Citizen.CreateThread(function()		   
	while true do
		--وقت رسبنة المركبة =  math.random(750000,850000)	 عشوائي من الى
		timerpawn =  math.random(10000,15000)	 
		Wait(timerpawn)	
		TriggerServerEvent('B3-mechanic:checkjob2')
-------------------------------------------  
		timerdespawn = math.random(300000,300000)
		Wait(timerdespawn)
		TriggerEvent('B3-mechanic:timeOutService')
		vehspawn = false		
	end
end)

Citizen.CreateThread(function()
	while true do 
		Wait(0)
		if vehspawn and onjob then 
			vehmodel = vehmodels[math.random(1, #vehmodels)]
			vehmodel = string.upper(vehmodel)
			RequestModel(GetHashKey(vehmodel))
			while not HasModelLoaded(GetHashKey(vehmodel)) or not HasCollisionForModelLoaded(GetHashKey(vehmodel)) do
				Wait(1)
			end
			local x, y, z, h = table.unpack(positions[math.random(1, #positions)])
			local myCoords = GetEntityCoords(GetPlayerPed(-1))
			BrokenCar = CreateVehicle(vehmodel, x, y, z, h, false, true)	
			SetVehicleEngineHealth(BrokenCar, 0.0)
			SetVehicleDoorOpen(BrokenCar,4,false,true)
			SetVehicleDoorsLockedForPlayer(BrokenCar,GetPlayerPed(-1), false)
			SetEntityAsMissionEntity(BrokenCar,1,1)
			vehicle_blip(BrokenCar)		 
			vehspawn = false	
			toolate = false
			SetNewWaypoint(x, y)
			distanceRepair = GetDistanceBetweenCoords(myCoords.x, myCoords.y, myCoords.z, x, y, z, true)
			vRP.notify({"<FONT FACE = 'A9eelsh'>"..'~g~ﻫﻨﺎﻙ ﺷﺨﺺ ﻳﺤﺘﺎﺝ ﺍﻟﻰ ﻣﺴﺎﻋﺪﺗﻚ ﺗﻢ ﺗﺤﺪﻳﺪ ﻣﻮﻗﻌﻪ ﺑﺎﻟﺨﺮﻳﻄﺔ'})
			vRP.notify({"<FONT FACE = 'A9eelsh'>"..'~g~يرجى ارجاع المركبة بعد الانتهاء من العمل'})
		end	
		if DoesEntityExist(BrokenCar) and (not IsPedInVehicle(GetPlayerPed(-1),BrokenCar,1)) and (not toolate) then 
			local vehpos = GetEntityCoords(BrokenCar)
			DrawMarker(0, vehpos.x, vehpos.y, vehpos.z+2.0, 0.0, 0.0,0.0, 0.0, 0.0,0.0, 0.5, 0.5, 0.45, 250,230,30, 100, 1, 0, 2, 0, 0, 0, 0)	
		end	 

		if toolate then 
			if DoesBlipExist(vehicle) then
				RemoveBlip(vehicle)	
			end
		end	
		if GetIsVehicleEngineRunning(BrokenCar) then
			TriggerEvent('B3-mechanic:completeService')
			Wait(5000)
		end
	end
end)

Citizen.CreateThread(function()
	if service then
	end
end)

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)
		DrawMarker(23, -213.65698242188, -1357.7783203125, 31.260095596313 - 1, 0, 0, 0, 0, 0, 0, 3.0001, 3.0001, 1.5001, 255, 165, 0, 50, 0, 0, 0,0) --- اماكن تسجيل الدخول و الخروج
		if GetDistanceBetweenCoords(-213.65698242188, -1357.7783203125, 31.260095596313, GetEntityCoords(LocalPed())) < 2.0 then  --- اماكن تسجيل الدخول و الخروج
			basiccheck()
		end
	end
end)

RegisterNetEvent('B3-mechanic:uniforme')
AddEventHandler('B3-mechanic:uniforme', function()
	Citizen.Wait(1000)
	if GetEntityModel(GetPlayerPed(-1)) == 1885233650 then
		SetPedComponentVariation(GetPlayerPed(-1), 3, 4)
		SetPedComponentVariation(GetPlayerPed(-1), 4, 38)
		SetPedComponentVariation(GetPlayerPed(-1), 5, 0)
		SetPedComponentVariation(GetPlayerPed(-1), 6, 24)
		SetPedComponentVariation(GetPlayerPed(-1), 7, 0)
		SetPedComponentVariation(GetPlayerPed(-1), 8, 15)
		SetPedComponentVariation(GetPlayerPed(-1), 10, 0)
		SetPedComponentVariation(GetPlayerPed(-1), 11, 65)
	elseif GetEntityModel(GetPlayerPed(-1)) == -1667301416 then
		SetPedComponentVariation(GetPlayerPed(-1), 3, 3)
		SetPedComponentVariation(GetPlayerPed(-1), 4, 38)
		SetPedComponentVariation(GetPlayerPed(-1), 5, 0)
		SetPedComponentVariation(GetPlayerPed(-1), 6, 24)
		SetPedComponentVariation(GetPlayerPed(-1), 7, 94)
		SetPedComponentVariation(GetPlayerPed(-1), 8, 14)
		SetPedComponentVariation(GetPlayerPed(-1), 9, 0)
		SetPedComponentVariation(GetPlayerPed(-1), 10, 0)
		SetPedComponentVariation(GetPlayerPed(-1), 11, 59)
	end
end)

RegisterNetEvent("spawnMissionCar")
AddEventHandler("spawnMissionCar", function()
	vehspawn = true
end)

RegisterNetEvent("spawnTowCar")
AddEventHandler("spawnTowCar", function()
	SpawnTowCar()
	SetNotificationTextEntry("STRING");
	TriggerEvent('B3-mechanic:uniforme')
	AddTextComponentString("<FONT FACE = 'A9eelsh'>"..'~r~!ﻞﻤﻌﻟﺎﺑ ﺃﺪﺒﻟﺍ ﻢﺗ ﺪﻘﻟ' );
	DrawNotification(false, true);
	vehicle = true
end)

RegisterNetEvent("notmechanic")
AddEventHandler("notmechanic", function()
  SetNotificationTextEntry("STRING");
  AddTextComponentString("<FONT FACE = 'A9eelsh'>"..'~r~!ﻲﻜﻴﻧﺎﻜﻴﻤﺑ ﺖﺴﻟ ﺖﻧﺍ' );
  DrawNotification(false, true);
end)

function openMenuTow(nearTow, mechanicModel)
	if nearTow then
		DisplayHelpText("<FONT FACE = 'A9eelsh'>"..'ﻂﻐﺿﺍ ~INPUT_CONTEXT~  ﺽﺮﻐﻟﺍ ﻰﻠﻋ ﻝﻮﺼﺤﻠﻟ~w~')
		if (IsControlJustPressed(1, 38)) and mechanicModel ~= oldTowModel then
			while not HasAnimDictLoaded("pickup_object") do
				RequestAnimDict("pickup_object")
				Citizen.Wait(100)
			end
			TaskPlayAnim(GetPlayerPed(PlayerId()), "pickup_object", "pickup_low", 1.0, -1, -1, 50, 0, 0, 0, 0)
			Citizen.Wait(100)	
			oldTowModel = mechanicModel
			Wait(1000)
			SetEntityCoords(oldTowModel, 0.0, 0.0, 0.0, false, false, false, true)
			CanLeaveItem = true	
			ClearPedTasksImmediately(GetPlayerPed(-1))
		end
		if CanLeaveItem then
			local x,y,z = table.unpack(GetEntityCoords(GetPlayerPed(-1)))
			local prop = CreateObject(HashKeyBox, x+5.5, y+5.5, z+0.2,  true,  true, true)
			AttachEntityToEntity(prop, GetPlayerPed(-1), GetPedBoneIndex(GetPlayerPed(-1), 11816), -0.05, 0.38, -0.050, 15.0, 285.0, 270.0, true, true, false, true, 1, true)
			--الافضل لا تعدل شي هنا
			RequestAnimDict('anim@heists@box_carry@')
			while not HasAnimDictLoaded('anim@heists@box_carry@') do
				Wait(0)
			end
			TaskPlayAnim(GetPlayerPed(-1), 'anim@heists@box_carry@', 'idle', 8.0, -8, -1, 49, 0, 0, 0, 0)
			repeat
			Citizen.Wait(100)
			if CanLeaveItem == false then
				DeleteEntity(prop)
			end
			until(CanLeaveItem == false)
		end
	end
end

function openMenuTowCar(nearTowCar)
	if nearTowCar and CanLeaveItem then
		DisplayHelpText("<FONT FACE = 'A9eelsh'>"..'ﻂﻐﺿﺍ ~INPUT_MULTIPLAYER_INFO~ ﺽﺮﻐﻟﺎﺑ ﻅﺎﻔﺘﺣﻼﻟ~w~')
		if (IsControlJustPressed(1, 20)) then
			local pid = PlayerPedId()
			SetVehicleDoorOpen(veh,5,false,true)
			DetachEntity(prop, true, false)
			SetEntityCoords(prop, 0.0, 0.0, 0.0, false, false, false, true)
			CanLeaveItem = false
			RequestAnimDict("anim@heists@money_grab@briefcase")
			while (not HasAnimDictLoaded("anim@heists@money_grab@briefcase")) do
				Citizen.Wait(0) 
			end
			TaskPlayAnim(pid,"anim@heists@money_grab@briefcase","put_down_case",100.0, 200.0, 0.3, 120, 0.2, 0, 0, 0)
			Wait(2000)
			StopAnimTask(pid, "anim@heists@money_grab@briefcase","put_down_case", 1.0)
			TriggerServerEvent("B3-mechanic:rewardTow")
			SetVehicleDoorsShut(veh, true)
		end
	end
end

RegisterNetEvent("B3-mechanic:completeService")
AddEventHandler("B3-mechanic:completeService", function()
	toolate = true  	   
	Wait(1000)	    
	TriggerServerEvent('B3-mechanic:rewardRepair', distanceRepair)	    
	SetEntityAsNoLongerNeeded(BrokenCar)
	SetModelAsNoLongerNeeded(GetHashKey(model))
	DeleteEntity((BrokenCar))
end)

function IsInVehicle()
	local ply = GetPlayerPed(-1)
	if IsPedSittingInAnyVehicle(ply) then
		return true
	else
		return false
	end
end

function vehicle_blip(entity)
	vehicle =  AddBlipForEntity(entity)
	SetBlipSprite(vehicle,595) 
	SetBlipColour(vehicle,3)
	BeginTextCommandSetBlipName("STRING")
	AddTextComponentString("<FONT FACE = 'A9eelsh'>"..'ﺔﻠﻄﻌﻣ ﺔﺒﻛﺮﻣ')
	EndTextCommandSetBlipName(vehicle)
end

RegisterNetEvent("B3-mechanic:timeOutService")
AddEventHandler("B3-mechanic:timeOutService", function()
	toolate = true
----------------لا تعدل
	Wait(1000)	    
	SetEntityAsNoLongerNeeded(BrokenCar)
	SetModelAsNoLongerNeeded(GetHashKey(model))	
	SetEntityAsNoLongerNeeded(BrokenCar)
	SetModelAsNoLongerNeeded(GetHashKey(model))
	DeleteEntity((BrokenCar))
end)

function basiccheck()
	if onjob == false then 
		if (IsInVehicle()) then
			if IsVehicleModel(GetVehiclePedIsIn(GetPlayerPed(-1), true), GetHashKey("flatbed")) then
				drawTxt("<FONT FACE = 'A9eelsh'>"..'ﺔﻨﺣﺎﺸﻟﺍ ﻝﺩﺎﺒﺘﻟ ~g~E~s~ ﻂﻐﺿﺍ', 1, 1, 0.5, 0.8, 0.6, 255, 255, 255, 255)
				if (IsControlJustReleased(1, 38)) then
					TriggerServerEvent('B3-mechanic:checkjob')
				end
			else
				drawTxt("<FONT FACE = 'A9eelsh'>"..'ﻞﻤﻌﻟﺍ ﺃﺪﺒﻟ ~g~E~s~ ﻂﻐﺿﺍ', 1, 1, 0.5, 0.8, 0.6, 255, 255, 255, 255)
				if (IsControlJustReleased(1, 38)) then
				TriggerServerEvent('B3-mechanic:checkjob')
				end
			end	
		else
			drawTxt("<FONT FACE = 'A9eelsh'>"..'ﻞﻤﻌﻟﺍ ﺃﺪﺒﻟ ~g~E~s~ ﻂﻐﺿﺍ', 1, 1, 0.5, 0.8, 0.6, 255, 255, 255, 255)
			if (IsControlJustReleased(1, 38)) then
				TriggerServerEvent('B3-mechanic:checkjob')
			end
		end
	else
		drawTxt("<FONT FACE = 'A9eelsh'>"..'ﺔﻣﺪﺨﻟﺍ ﻦﻣ ﺝﻭﺮﺨﻠﻟ ~g~H~s~ ﻂﻐﺿﺍ', 1, 1, 0.5, 0.8, 0.6, 255, 255, 255, 255)
		if (IsControlJustReleased(1, 74)) then
			--TriggerServerEvent('bank:withdrawAmende', destination[l].money)
			--TriggerServerEvent('bank:withdrawAmende', l)
			onjob = false
			RemoveBlip(deliveryblip)
			DeleteEntity(getNearVeh(2))
			SetWaypointOff()
			visits = 1
		end
	end
end

function DisplayHelpText(str)
	SetTextComponentFormat("STRING")
	AddTextComponentString(str)
	DisplayHelpTextFromStringLabel(0, 0, 1, -1)
end


function SpawnTowCar()
	if (IsInVehicle()) then
		if IsVehicleModel(GetVehiclePedIsIn(GetPlayerPed(-1), true), GetHashKey("flatbed")) then
			startjob()
		end
	else
		Citizen.Wait(0)
		local myPed = GetPlayerPed(-1)
		local player = PlayerId()
		local vehicle = GetHashKey('flatbed')  -- كود مركبة الميكانيكي من الممكن تبديله

		RequestModel(vehicle)

		while not HasModelLoaded(vehicle) do
			Wait(1)
		end

		local coords = GetOffsetFromEntityInWorldCoords(GetPlayerPed(-1), 0, 5.0, 0)
		local spawned_car = CreateVehicle(vehicle, -224.6047668457, -1373.5208740234, 31.345762252808, 163.0029296875, true, false)
		SetVehicleOnGroundProperly(spawned_car)
		SetVehicleNumberPlateText(spawned_car, "DAMN")
		SetPedIntoVehicle(myPed, spawned_car, -1)
		SetModelAsNoLongerNeeded(vehicle)
		Citizen.InvokeNative(0xB736A491E64A32CF, Citizen.PointerValueIntInitialized(spawned_car))
		startjob()
	end
end

function startjob()

	onjob = true

end

function drawTxt(text, font, centre, x, y, scale, r, g, b, a)
	SetTextFont(6)
	SetTextProportional(0)
	SetTextScale(scale, scale)
	SetTextColour(r, g, b, a)
	SetTextDropShadow(0, 0, 0, 0, 255)
	SetTextEdge(1, 0, 0, 0, 255)
	SetTextDropShadow()
	SetTextOutline()
	SetTextCentre(centre)
	SetTextEntry("STRING")
	AddTextComponentString(text)
	DrawText(x, y)
end

function getNearVeh(radius)
	local playerPed = GetPlayerPed(-1)
	local coordA = GetEntityCoords(playerPed, 1)
	local coordB = GetOffsetFromEntityInWorldCoords(playerPed, 0.0, radius+0.00001, 0.0)
	local nearVehicle = getVehicleInDirection(coordA, coordB)

	if IsEntityAVehicle(nearVehicle) then
	    return nearVehicle
	else
		local x,y,z = table.unpack(coordA)
	    if IsPedSittingInAnyVehicle(playerPed) then
	        local veh = GetVehiclePedIsIn(playerPed, true)
	        return veh
	    else
	        local veh = GetClosestVehicle(x+0.0001,y+0.0001,z+0.0001, radius+0.0001, 0, 8192+4096+4+2+1)  -- boats, helicos
	        if not IsEntityAVehicle(veh) then veh = GetClosestVehicle(x+0.0001,y+0.0001,z+0.0001, radius+0.0001, 0, 4+2+1) end -- cars
	        return veh
	    end
	end
end

function getVehicleInDirection(coordFrom, coordTo)
	local rayHandle = CastRayPointToPoint(coordFrom.x, coordFrom.y, coordFrom.z, coordTo.x, coordTo.y, coordTo.z, 10, PlayerPedId(), 0)
	local a, b, c, d, vehicle = GetRaycastResult(rayHandle)
	return vehicle
end