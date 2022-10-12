local ped = 0
local damageTester = false

-- AddEventHandler("onResourceStart", function ()
--     start()
-- end)

AddEventHandler("onResourceStop", function ()
    DeleteEntity(ped)
end)

RegisterCommand("damagetester",function()
    SetEntityCoords(PlayerPedId(),258.64,-1011.57,61.64)
    Wait(300)
    start()
end)

function startDamageTester()
    Citizen.CreateThread( function()
        while damageTester do
            Citizen.Wait(1)

            if HasEntityBeenDamagedByAnyPed(ped) then
                local pped = PlayerPedId()
                local damage = (GetEntityHealth(ped) + GetPedArmour(ped) - 300)
				local distance = #(GetEntityCoords(ped) - GetEntityCoords(pped))
                print("Damage: "..damage)
                print("Shots to kill: "..(200/damage))
                print("Distance: "..distance)
                ClearEntityLastDamageEntity(ped)
            end

            if IsEntityDead(ped) then
                Wait(1000)
                DeleteEntity(ped)
                genPed()
            end

            if GetEntityHealth(ped) + GetPedArmour(ped) ~= 300 then
                SetEntityHealth(ped,200)
                SetPedArmour(ped,100)
            end
        end
    end)
end

function genPed()
    local mHash = GetHashKey("ig_tomcasino")

    RequestModel(mHash)
    while not HasModelLoaded(mHash) do
        Citizen.Wait(1)
    end
    ped = CreatePed(4,mHash,258.64,-1011.57,61.64-1,252.29,false,true)
    FreezeEntityPosition(ped,true)
    SetPedArmour(ped,100)
    SetBlockingOfNonTemporaryEvents(ped,true)
end

function start()
    genPed()
    damageTester = true
    Wait(150)
    startDamageTester()
end