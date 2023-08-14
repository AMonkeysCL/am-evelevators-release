--[[ ===================================================== ]]--
--[[            AM Elevator por AMonkeys                   ]]--
--[[ ===================================================== ]]--

local ESX = nil
TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

local PlayerData = {}
local inElevatorZone = false

local function isAuthorized(authorizedList)
    local playerJob = ESX.GetPlayerData().job.name
    local playerGang = ESX.GetPlayerData().gang.name
    
    for _, job in pairs(authorizedList) do
        if job == "public" or job == playerJob or job == playerGang then
            return true
        end
    end
    
    return false
end

local function ElevatorMenu(data)
    local authorized = isAuthorized(data.authorized)
    
    if authorized then
        local elements = {}
        
        for key, floor in pairs(Config.Elevators[data.elevator]['floors']) do        
            if data.level ~= key then
                table.insert(elements, {
                    label = Lang:t('menu.floor', { level = key, name = floor.name }),
                    value = key,
                })
            end
        end
        
        ESX.UI.Menu.Open(
            'default', GetCurrentResourceName(), 'elevator_menu',
            {
                title = Lang:t('menu.elevator', { label = data.menu }),
                align = 'top-left',
                elements = elements,
            },
            function(data2, menu)
                local selectedLevel = data2.current.value
                local selectedFloor = Config.Elevators[data.elevator]['floors'][selectedLevel]
                
                if selectedFloor then
                    UseElevator(selectedFloor)
                end
                menu.close()
            end,
            function(data2, menu)
                menu.close()
            end
        )
    else
        ESX.ShowNotification(Lang:t('error.no_access'))
    end
end

local function UseElevator(data)
    local ped = PlayerPedId()
    local vehicle = nil
    
    if data.tpVehicle and IsPedInAnyVehicle(ped) then
        vehicle = GetVehiclePedIsIn(ped)
    end
    
    DoScreenFadeOut(500)
    while not IsScreenFadedOut() do Wait(10) end
    
    RequestCollisionAtCoord(data.coords.x, data.coords.y, data.coords.z)
    
    while not HasCollisionLoadedAroundEntity(ped) do Wait(0) end
    
    if data.tpVehicle and vehicle ~= nil then
        SetEntityCoords(vehicle, data.coords.x, data.coords.y, data.coords.z, false, false, false, true)
        SetEntityHeading(vehicle, data.heading)
    else
        SetEntityCoords(ped, data.coords.x, data.coords.y, data.coords.z, false, false, false, false)
        SetEntityHeading(ped, data.heading)
    end
    
    Wait(1500)
    DoScreenFadeIn(500)
end

local function Listen4Control(data)
    CreateThread(function()
        while true do
            Wait(0)
            
            if IsControlJustPressed(0, 38) and inElevatorZone then -- E
                ElevatorMenu(data)
                break
            end
        end
    end)
end

local function PrepareElevatorMenu()
    if Config.UseTarget then
        for key, floors in pairs(Config.Elevators) do
            for index, floor in pairs(floors['floors']) do
                exports["esx_target"]:RemoveZone(index..key)
                exports["esx_target"]:AddBoxZone(index..key, floor.coords, 5, 4, {
                    name = index,
                    heading = floor.heading,
                    debugPoly = false,
                    minZ = floor.coords.z - 1.0,
                    maxZ = floor.coords.z + 1.0
                }, {
                    options = {
                        {
                            event = "am-elevators:client:elevatorMenu",
                            icon = "fas fa-hand-point-up",
                            label = Lang:t('menu.use_elevator', { level = index }),
                            elevator = key,
                            level = index,
                            menu = floors.blip.label,
                            authorized = floors.authorized
                        },
                    },
                    distance = 2.5
                })
            end
        end
    else
        for i, floors in pairs(Config.Elevators) do
            for index, floor in pairs(floors['floors']) do
                local LiftZone = BoxZone:Create(floor.coords, 2.0, 2.0, {
                    heading = floor.heading,
                    minZ = floor.coords.z - 1.0,
                    maxZ = floor.coords.z + 1.0,
                    debugPoly = false,
                    name = index..i,
                })
                
                LiftZone:onPlayerInOut(function(isPointInside)
                    if isPointInside then
                        ESX.ShowHelpNotification(Lang:t('menu.popup'))
                        local data = { elevator = i, level = index, menu = floors.blip.label, authorized = floors.authorized }
                        inElevatorZone = true
                        Listen4Control(data)
                    else
                        if inElevatorZone then
                            ESX.ShowNotification("")
                        end
                        inElevatorZone = false
                    end
                end)
            end
        end
    end
end

RegisterNetEvent('esx:playerLoaded', function(playerData)
    PlayerData = playerData
    PrepareElevatorMenu()
end)

RegisterNetEvent('esx:setJob', function(job)
    PlayerData.job = job
    PrepareElevatorMenu()
end)

AddEventHandler('onResourceStart', function(resourceName)
    if GetCurrentResourceName() == resourceName then
        PlayerData = ESX.GetPlayerData()
        PrepareElevatorMenu()
    end
end)

RegisterNetEvent('am-elevators:client:useElevator', function(data)
    UseElevator(data)
    ESX.ShowNotification("")
end)

RegisterNetEvent('am-elevators:client:elevatorMenu', function(data)
    ElevatorMenu(data)
    ESX.ShowNotification("")
end)

CreateThread(function()
    if Config.ShowBlips then
        for key, lift in pairs(Config.Elevators) do
            if lift.blip.show then
                local blip = AddBlipForCoord(lift.blip.coords.x, lift.blip.coords.y, lift.blip.coords.z)
                SetBlipSprite(blip, lift.blip.sprite)
                SetBlipAsShortRange(blip, true)
                SetBlipScale(blip, lift.blip.scale)
                SetBlipColour(blip, lift.blip.colour)
                BeginTextCommandSetBlipName("STRING")
                AddTextComponentString(lift.blip.label)
                EndTextCommandSetBlipName(blip)
            end
        end
    end
end)

