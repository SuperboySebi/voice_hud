local microphoneEnabled   = true
local isCurrentlySpeaking = false
local voiceDistance = nil
local runLoop 		= true

RegisterNetEvent('SaltyChat_MicStateChanged')
AddEventHandler('SaltyChat_MicStateChanged', function(IsMicrophoneMuted)
	microphoneEnabled = not IsMicrophoneMuted
end)

RegisterNetEvent('SaltyChat_TalkStateChanged')
AddEventHandler('SaltyChat_TalkStateChanged', function(isTalking)
	isCurrentlySpeaking = isTalking
end) 

RegisterNetEvent('SaltyChat_VoiceRangeChanged')
AddEventHandler('SaltyChat_VoiceRangeChanged', function(voiceRange)
    voiceDistance = voiceRange
end)

Citizen.CreateThread(function()
    voiceDistance = exports["saltychat"]:GetVoiceRange()

    while true do
        Citizen.Wait(100)

		if runLoop then
			SendNUIMessage({
				action = "updateStatusHud",
				show = not IsRadarHidden(),          
				voiceRange = (microphoneEnabled and tostring(voiceDistance) .. Config.MeterText) or Config.MicOffText,
                micEnabled = microphoneEnabled
            })

			if not IsRadarHidden() then
				SendNUIMessage({
					action     = "updatespeech",
					speaking   = isCurrentlySpeaking,
                    micEnabled = microphoneEnabled
				})
			end
		end
    end
end)

RegisterNetEvent("voice_hud:client:enableHud")
AddEventHandler("voice_hud:client:enableHud", function()
	runLoop = true
	SendNUIMessage({ show = runLoop })
end)

RegisterNetEvent("voice_hud:client:disableHud")
AddEventHandler("voice_hud:client:disableHud", function()
	runLoop = false
	SendNUIMessage({ show = runLoop })
end)