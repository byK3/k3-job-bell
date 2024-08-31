local onlinePlayers = {}
local cooldown = {}

AddEventHandler('onResourceStart', function(resourceName)
    if (GetCurrentResourceName() ~= resourceName) then return end
    for job, data in pairs(K3.jobs) do
        onlinePlayers[job] = {}
    end

    for job, data in pairs(K3.jobs) do
        cooldown[job] = {}
        cooldown[job].time = 0
    end
end)



-- === FUNCTIONS === --

local function hasJob(job,grade)
    for job, data in pairs(K3.jobs) do
        if job == job then
            if grade >= data.minGrade then
                return true
            end
        end
    end
    return false
end

local function onPlayerConnect(player, job, grade)
    if not onlinePlayers[job] then
        return
    end
    if not hasJob(job,grade) then
        return
    end
    table.insert(onlinePlayers[job], player)
end

local function onPlayerDisconnect(player, job)
    if not onlinePlayers[job] then return end

    for i, player in pairs(onlinePlayers[job]) do
        if player == player then
            table.remove(onlinePlayers[job], i)
            break
        end
    end
end

local function onlineCheck(job)
    if #onlinePlayers[job] == 0 then return false end
    return true
end

local function notifyJob(job, src)
    for i, player in pairs(onlinePlayers[job]) do
        local xPlayer = ESX.GetPlayerFromId(player)
        local sendID = K3.giveID and src or nil
        if sendID then
            notify(xPlayer.source, K3.messages.notifyJob .. " - ID: " .. src)
        else
            notify(xPlayer.source, K3.messages.notifyJob)
        end
    end
end

local function checkCooldown(job)
    if cooldown[job].time > 0 then
        return true
    end
    return false
end


-- === EVENTS === --

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded',function(xPlayer, isNew, skin)
    local xPlayer = ESX.GetPlayerFromId(source)
    local xJob = xPlayer.getJob().name
    local xGrade = xPlayer.getJob().grade
    onPlayerConnect(xPlayer.source, xJob, xGrade)
end)

RegisterNetEvent('esx:playerDropped', function(playerId, reason)
    local xPlayer = ESX.GetPlayerFromId(playerId)
    local xJob = xPlayer.getJob().name
    onPlayerDisconnect(xPlayer.source, xJob)
end)

RegisterNetEvent('k3_jobBells:status')
AddEventHandler('k3_jobBells:status', function(ringedJob, ringedLabel)
    if ringedJob == nil or ringedJob == "" or ringedJob == -1 then dbg("ringedJob is nil") return end
    local xPlayer = ESX.GetPlayerFromId(source)
    local hasCooldown = checkCooldown(ringedJob)
    if hasCooldown then
        notify(xPlayer.source, K3.messages.bellOnCooldown)
        cb(false)
        return
    end
    local hasOnline = onlineCheck(ringedJob)
    if not hasOnline then
        notify(xPlayer.source, "No one is online in this job")
        cb(false)
        return
    end
    cooldown[ringedJob].time = K3.cooldown
    notifyJob(ringedJob, xPlayer.source)
    notify(xPlayer.source, K3.messages.rungBell:format(ringedLabel))
    cb(true)
end)




-- === THREADS === --
CreateThread(function()
    while true do
        local hasCooldown = false

        for job, data in pairs(K3.jobs) do
            if cooldown[job].time > 0 then
                cooldown[job].time = cooldown[job].time - 1
                hasCooldown = true
            elseif cooldown[job].time < 0 then
                cooldown[job].time = 0
            end
        end

        Wait(hasCooldown and 1000 or 3000)
    end
end)
