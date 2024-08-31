K3 = {}

K3.debug = true -- Debug Prints into the console
K3.interactRange = 2 -- The range in which the player can interact with the bell
K3.interactKey = 38 -- The key to interact with the bell (https://docs.fivem.net/docs/game-references/controls/)
K3.ringMsgType = "helpNotify" -- The type of message that will be displayed when the player is in range of the bell (helpNotify or 3D-Text)
K3.cooldown = 120 -- Cooldown in seconds
K3.giveID = false -- Gives player ID when ringing the bell to job members

K3.jobs = {
    police = {
        label = "Police", -- Job label
        coords = { -- Add more coords if you want
            vector3(441.0, -982.0, 30.0),
        },

        minGrade = 0, -- Minimum grade to be able to ring the bell
        
        marker = { -- Marker settings (https://docs.fivem.net/docs/game-references/markers/)
            type = 1, 
            size = {x = 1.0, y = 1.0, z = 1.0},
            color = {r = 0, g = 0, b = 255, a = 100},
            upAndDown = true,
            drawDistance = 10.0,
        },
    },

    ambulance = {
        label = "Ambulance",
        coords = {
            vector3(441.0, -982.0, 30.0),
        },

        minGrade = 0,
         
        marker = {
            type = 1,
            size = {x = 1.0, y = 1.0, z = 1.0},
            color = {r = 0, g = 0, b = 255, a = 100},
            upAndDown = true,
            drawDistance = 10.0,
        },
    },

}

K3.messages = {
    pressToRing = "Press ~INPUT_CONTEXT~ to ring the bell: %s",
    rungBell = "You have rung the %s bell",
    bellOnCooldown = "The bell is on cooldown",
    notifyJob = "The Job Bell has been rung",
}


function notify(source, message)
    TriggerClientEvent('esx:showNotification', source, message)
end

function helpNotify(message)
    ESX.ShowHelpNotification(message)
end

function esxDrawText3D(coords, message) -- 3D Text for ESX (value 0.5 is the size of the text, 4 is the font) change it if you want
    ESX.Game.Utils.DrawText3D(coords, message, 0.5, 1)
end


function dbg (msg)
    if K3.debug then
        local info = debug.getinfo(2, 'Sl')
        local source = info.short_src:match("[^/]+$")
        print(('^3[K3-jobBell]^0 %s (%s:%s)'):format(msg, source, info.currentline))
    end
end




