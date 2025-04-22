local QBCore = exports['qb-core']:GetCoreObject()

local rc0delogs = "" -- Discord log için webhook url buraya.

RegisterCommand("pm", function(source, args, rawCommand)
    local src = source                  
    local targetId = tonumber(args[1])   
    local msg = table.concat(args, " ", 2) 

    if not targetId or not msg or msg == "" then
        TriggerClientEvent('QBCore:Notify', src, "Kullanım : /pm (id) (mesaj)", "error")
        return
    end

    local targetPlayer = QBCore.Functions.GetPlayer(targetId)

    if targetPlayer then
        local senderName = GetPlayerName(src)
        local receiverName = GetPlayerName(targetId)

        TriggerClientEvent('chat:addMessage', src, {
            color = { 255, 0, 0 },
            multiline = true,
            args = { "[Mesaj Gönderildi]", senderName .. " → " .. receiverName .. ": " .. msg }
        })

        TriggerClientEvent('chat:addMessage', targetId, {
            color = { 255, 0, 0 },
            multiline = true,
            args = { "[Mesaj]", senderName .. ": " .. msg }
        })

        TriggerClientEvent('QBCore:Notify', src, "Mesaj gönderildi!", "success")
        TriggerClientEvent('QBCore:Notify', targetId, "Yeni bir özel mesajın var!", "primary")

        -- print("[PM] " .. senderName .. " (" .. src .. ") → " .. receiverName .. " (" .. targetId .. "): " .. msg) -- Console test print

        sendToDiscord("Rc0de Studio", 
            "**Gönderici :** " .. senderName .. " (" .. src .. ")\n" ..
            "**Teslim Alan :** " .. receiverName .. " (" .. targetId .. ")\n" ..
            "**Mesaj İçeriği :** " .. msg, 8388736) 
    else
        TriggerClientEvent('QBCore:Notify', src, "Oyuncu bulunamadı!", "error")
    end
end, false)

function sendToDiscord(title, message, color)
    local embedData = {
        {
            ["title"] = title,
            ["description"] = message,
            ["color"] = color, 
            ["footer"] = {
                ["text"] = os.date("%Y-%m-%d %H:%M:%S"),
            }
        }
    }
    
    PerformHttpRequest(rc0delogs, function(err, text, headers) end, 'POST', json.encode({username = "ReaineR C0deworks", embeds = embedData}), { ['Content-Type'] = 'application/json' })
end
