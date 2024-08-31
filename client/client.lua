local coordsToJobs = {}

AddEventHandler('onResourceStart', function(resourceName)
    if (GetCurrentResourceName() ~= resourceName) then return end
    for job, data in pairs(K3.jobs) do
        for _, coords in pairs(data.coords) do
            table.insert(coordsToJobs, {coords = coords, job = job, data = data})
        end
    end
end)

CreateThread(function()
    while true do
        local ped = PlayerPedId()
        local pedCoords = GetEntityCoords(ped)
        local inRange = false

        for _, item in pairs(coordsToJobs) do
            local distance = #(pedCoords - item.coords)

            if distance <= item.data.marker.drawDistance then
                inRange = true
                local data = item.data
                DrawMarker(
                    data.marker.type,
                    item.coords.x, item.coords.y, item.coords.z,
                    0.0, 0.0, 0.0,
                    0, 0.0, 0.0,
                    data.marker.size.x, data.marker.size.y, data.marker.size.z,
                    data.marker.color.r, data.marker.color.g, data.marker.color.b, data.marker.color.a,
                    data.marker.upAndDown, false, 2, false, false, false, false
                )

                if distance <= K3.interactRange then
                    if K3.ringMsgType == "helpNotify" then
                        helpNotify(K3.messages.pressToRing:format(data.label))
                    elseif K3.ringMsgType == "3D-Text" then
                        esxDrawText3D(item.coords, K3.messages.pressToRing:format(data.label))
                    end

                    if IsControlJustPressed(0, K3.interactKey) then
                        ESX.TriggerServerCallback('k3_jobBells:status', function(success)
                            if success then
                                dbg("Success ringing the bell")
                            else
                                dbg("Failed ringing the bell")
                            end
                        end, item.job, data.label)                        
                    end

                end
            end
        end

        if not inRange then
            Wait(1000)
        else
            Wait(1)
        end
    end
end)