
--  في حين مواجهة اي مشاكل بالسكربت يرجى فتح تذكرة برمجية  https://discord.gg/2mNts9zxdn

local Tunnel = module("vrp", "lib/Tunnel")
local Proxy = module("vrp", "lib/Proxy")

vRP = Proxy.getInterface("vRP")
vRPclient = Tunnel.getInterface("vRP","B3-mechanic")


local reward = {100,200}
local rewardKm = 1
local rewardService = 300
local rewardValue = 100
local rndResult = math.random(1,1)
local permissaoMecanico = "B3-mechanic"

RegisterServerEvent('B3-mechanic:rewardTow')
AddEventHandler('B3-mechanic:rewardTow', function(farm)
	local user_id = vRP.getUserId({source})
	local player = vRP.getUserSource({user_id})
	local x,y = table.unpack(reward)
	local rewardValue = math.random(x, y)
	vRP.giveMoney({user_id,rewardValue})
	TriggerClientEvent('chatMessage', source, '', {255,192,203}, "جمعت "..rndResult.." اصلحت و حصلت على "..rewardValue..".", {255,255,255,1.0,'',0, 100, 0, 0.5})  -- يطلع بالشات بعد انتهاء التصليح
	TriggerEvent("DMN:farmLog", ""..GetPlayerName(player).." [user_id "..user_id.."] حصلت "..rndResult.." اصلحت و اكتسبت "..rewardValue..".")  -- يطلع بالشات بعد انتهاء التصليح
end)

RegisterServerEvent('B3-mechanic:checkjob')
AddEventHandler('B3-mechanic:checkjob', function()
	local player = source
	local user_id = vRP.getUserId({player})

	if vRP.hasPermission({user_id, permissaoMecanico}) then
		TriggerClientEvent('spawnTowCar', source)
	else
		TriggerClientEvent('notmechanic', source)
	end
end)

RegisterServerEvent('B3-mechanic:checkjob2')
AddEventHandler('B3-mechanic:checkjob2', function()
	local player = source
	local user_id = vRP.getUserId({player})

	if vRP.hasPermission({user_id, permissaoMecanico}) then
		TriggerClientEvent('spawnMissionCar', source)
	end
end)

RegisterServerEvent('B3-mechanic:rewardRepair')
AddEventHandler('B3-mechanic:rewardRepair', function(distance)
	local player = source
	local user_id = vRP.getUserId({player})
	local rewardCourse = round((rewardKm*parseInt(distance))/10)
	vRP.giveMoney({user_id,rewardCourse})
	vRP.giveMoney({user_id,rewardService})
	TriggerClientEvent('chatMessage', source, '', {255,192,203}, "حصلت $ "..rewardService.." على خدمتك", {255,255,255,1.0,'',0, 100, 0, 0.5})  -- يطلع بالشات بعد انتهاء التصليح
	TriggerClientEvent('chatMessage', source, '', {255,192,203}, "حصلت $ "..tonumber(rewardCourse).." من قبل العميل", {255,255,255,1.0,'',0, 100, 0, 0.5})  -- يطلع بالشات بعد انتهاء التصليح
end)

function round(num, numDecimalPlaces)
    return tonumber(string.format("%." .. (numDecimalPlaces or 0) .. "f", num))
end

-- Updates
        print("^4"..GetCurrentResourceName() .."^7 is on the ^2newest ^7version!^7")