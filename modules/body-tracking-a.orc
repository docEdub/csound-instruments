/*
 *  body-tracking-a.orc
 *
 *  Hands and head tracking via custon websocket opcodes.
 */

{{DeclareModule 'BodyTracking_A' 'hasAlwaysOnInstrument'}}


/// @internal
gS_AF_Module_{{ModuleName}}_headsetIpAddress = "192.168.5.62" // headset
; gS_AF_Module_{{ModuleName}}_headsetIpAddress = "192.168.4.220" // local testing
gk_AF_Module_{{ModuleName}}_headsetOscSendPort init 41234
gk_AF_Module_{{ModuleName}}_headsetOscReceivePort init 41235
gk_AF_Module_{{ModuleName}}_headsetWebSocketReceivePort init 12345


/// Hands and head tracking via custom websocket opcodes.
/// @param 1 Channel prefix used for host automation parameters.
/// @param 2 Channel suffix index (see JSON "Channel" object keys).
/// @out k value for given channel suffix.
///
opcode AF_Module_{{ModuleName}}, k, Si
    S_channelPrefix, i_channelIndex xin
    i_instanceIndex = {{hostValueGet}}:i(S_channelPrefix)
    xout(_af_module_{{ModuleName}}_getHost:k(i_instanceIndex, i_channelIndex))
endop


opcode AF_Module_{{ModuleName}}_onMidiNote, 0, S
    S_channelPrefix xin
    i_instanceIndex = {{hostValueGet}}:i(S_channelPrefix)

    i_uiMode = {{moduleGet:i 'UiMode'}}
    if (i_uiMode == {{BodyTracking_A.UiMode.PianoConfig}}) then
        i_noteNumber = notnum()
        i_velocity = veloc()

        ; {{LogTrace_i '("Sending MIDI note on OSC: note = %d, velocity = %d", i_noteNumber, i_velocity)'}}
        OSCsend(k(0), gS_AF_Module_{{ModuleName}}_headsetIpAddress, i(gk_AF_Module_{{ModuleName}}_headsetOscSendPort), "/headset/frontend/note/on", "ii", i_noteNumber, i_velocity)

        k_noteOffWasSent init {{false}}
        if (k_noteOffWasSent == {{true}}) then
            kgoto end
        endif

        k_released = release()
        if (k_released == {{true}}) then
            ; {{LogTrace_k '("Sending MIDI note off OSC: note = %d", i_noteNumber)'}}
            OSCsend(k(0), gS_AF_Module_{{ModuleName}}_headsetIpAddress, i(gk_AF_Module_{{ModuleName}}_headsetOscSendPort), "/headset/frontend/note/off", "i", i_noteNumber)
            k_noteOffWasSent = {{true}}
        fi
    fi
end:
endop


instr AF_Module_{{ModuleName}}_websocketListener
    i_instanceIndex = p4

    ; {{LogTrace_i '("AF_Module_BodyTracking_A_websocketListener: instanceIndex = %d", i_instanceIndex)'}}

    ; if ({{moduleGet:k 'Enabled'}} == {{false}}) then
    ;     kgoto end
    ; endif

    i_websocketPort = i(gk_AF_Module_{{ModuleName}}_headsetWebSocketReceivePort)
    ; {{LogDebug_i '("websocket port = %d", i_websocketPort)'}}

    k_leftWrist[] init 3
    k_leftWrist = websocket_getArray_k(i_websocketPort, "/hands/left/wrist/position")

    k_leftTip1[] init 3
    k_leftTip1 = websocket_getArray_k(i_websocketPort, "/hands/left/finger/1/tip/position")

    k_leftTip2[] init 3
    k_leftTip2 = websocket_getArray_k(i_websocketPort, "/hands/left/finger/2/tip/position")

    k_leftTip3[] init 3
    k_leftTip3 = websocket_getArray_k(i_websocketPort, "/hands/left/finger/3/tip/position")

    k_leftTip4[] init 3
    k_leftTip4 = websocket_getArray_k(i_websocketPort, "/hands/left/finger/4/tip/position")

    k_leftTip5[] init 3
    k_leftTip5 = websocket_getArray_k(i_websocketPort, "/hands/left/finger/5/tip/position")

    k_rightWrist[] init 3
    k_rightWrist = websocket_getArray_k(i_websocketPort, "/hands/right/wrist/position")

    k_rightTip1[] init 3
    k_rightTip1 = websocket_getArray_k(i_websocketPort, "/hands/right/finger/1/tip/position")

    k_rightTip2[] init 3
    k_rightTip2 = websocket_getArray_k(i_websocketPort, "/hands/right/finger/2/tip/position")

    k_rightTip3[] init 3
    k_rightTip3 = websocket_getArray_k(i_websocketPort, "/hands/right/finger/3/tip/position")

    k_rightTip4[] init 3
    k_rightTip4 = websocket_getArray_k(i_websocketPort, "/hands/right/finger/4/tip/position")

    k_rightTip5[] init 3
    k_rightTip5 = websocket_getArray_k(i_websocketPort, "/hands/right/finger/5/tip/position")

    k_headPosition[] init 3
    k_headPosition = websocket_getArray_k(i_websocketPort, "/head/position")

    k_headRotation[] init 3
    k_headRotation = websocket_getArray_k(i_websocketPort, "/head/rotation")

    ; {{hostValueSet}}("/hands/left/wrist/position/x", k_leftWrist[0] / 51)
    {{moduleSet:k 'LeftWristX' 'k_leftWrist[0] / 51'}}
    {{moduleSet:k 'LeftWristY' 'k_leftWrist[1] / 51'}}
    {{moduleSet:k 'LeftWristZ' 'k_leftWrist[2] / 51'}}

    {{moduleSet:k 'LeftFingerTip1X' 'k_leftTip1[0] / 51'}}
    {{moduleSet:k 'LeftFingerTip1Y' 'k_leftTip1[1] / 51'}}
    {{moduleSet:k 'LeftFingerTip1Z' 'k_leftTip1[2] / 51'}}

    {{moduleSet:k 'LeftFingerTip2X' 'k_leftTip2[0] / 51'}}
    {{moduleSet:k 'LeftFingerTip2Y' 'k_leftTip2[1] / 51'}}
    {{moduleSet:k 'LeftFingerTip2Z' 'k_leftTip2[2] / 51'}}

    {{moduleSet:k 'LeftFingerTip3X' 'k_leftTip3[0] / 51'}}
    {{moduleSet:k 'LeftFingerTip3Y' 'k_leftTip3[1] / 51'}}
    {{moduleSet:k 'LeftFingerTip3Z' 'k_leftTip3[2] / 51'}}

    {{moduleSet:k 'LeftFingerTip4X' 'k_leftTip4[0] / 51'}}
    {{moduleSet:k 'LeftFingerTip4Y' 'k_leftTip4[1] / 51'}}
    {{moduleSet:k 'LeftFingerTip4Z' 'k_leftTip4[2] / 51'}}

    {{moduleSet:k 'LeftFingerTip5X' 'k_leftTip5[0] / 51'}}
    {{moduleSet:k 'LeftFingerTip5Y' 'k_leftTip5[1] / 51'}}
    {{moduleSet:k 'LeftFingerTip5Z' 'k_leftTip5[2] / 51'}}

    {{moduleSet:k 'RightWristX' 'k_rightWrist[0] / 51'}}
    {{moduleSet:k 'RightWristY' 'k_rightWrist[1] / 51'}}
    {{moduleSet:k 'RightWristZ' 'k_rightWrist[2] / 51'}}

    {{moduleSet:k 'RightFingerTip1X' 'k_rightTip1[0] / 51'}}
    {{moduleSet:k 'RightFingerTip1Y' 'k_rightTip1[1] / 51'}}
    {{moduleSet:k 'RightFingerTip1Z' 'k_rightTip1[2] / 51'}}

    {{moduleSet:k 'RightFingerTip2X' 'k_rightTip2[0] / 51'}}
    {{moduleSet:k 'RightFingerTip2Y' 'k_rightTip2[1] / 51'}}
    {{moduleSet:k 'RightFingerTip2Z' 'k_rightTip2[2] / 51'}}

    {{moduleSet:k 'RightFingerTip3X' 'k_rightTip3[0] / 51'}}
    {{moduleSet:k 'RightFingerTip3Y' 'k_rightTip3[1] / 51'}}
    {{moduleSet:k 'RightFingerTip3Z' 'k_rightTip3[2] / 51'}}

    {{moduleSet:k 'RightFingerTip4X' 'k_rightTip4[0] / 51'}}
    {{moduleSet:k 'RightFingerTip4Y' 'k_rightTip4[1] / 51'}}
    {{moduleSet:k 'RightFingerTip4Z' 'k_rightTip4[2] / 51'}}

    {{moduleSet:k 'RightFingerTip5X' 'k_rightTip5[0] / 51'}}
    {{moduleSet:k 'RightFingerTip5Y' 'k_rightTip5[1] / 51'}}
    {{moduleSet:k 'RightFingerTip5Z' 'k_rightTip5[2] / 51'}}

    {{moduleSet:k 'HeadPositionX' 'k_headPosition[0] / 51'}}
    {{moduleSet:k 'HeadPositionY' 'k_headPosition[1] / 51'}}
    {{moduleSet:k 'HeadPositionZ' 'k_headPosition[2] / 51'}}

    ki = 0
    while (ki < 3) do
        while (k_headRotation[ki] < 0) do
            k_headRotation[ki] = k_headRotation[ki] + $MATH_TWO_PI
        od
        ki += 1
    od
    {{moduleSet:k 'HeadRotationX' '(k_headRotation[0] % $MATH_TWO_PI) / $MATH_TWO_PI'}}
    {{moduleSet:k 'HeadRotationY' '(k_headRotation[1] % $MATH_TWO_PI) / $MATH_TWO_PI'}}
    {{moduleSet:k 'HeadRotationZ' '(k_headRotation[2] % $MATH_TWO_PI) / $MATH_TWO_PI'}}
end:
endin


instr AF_Module_{{ModuleName}}_oscListener
    i_instanceIndex = p4

    if (strlen(gS_AF_Module_{{ModuleName}}_headsetIpAddress) == 0) then
        goto end
    fi

    ; {{LogTrace_i '("OSC host = \"%s\", send port = %d, receive port = %d", gS_AF_Module_BodyTracking_A_headsetIpAddress, i(gk_AF_Module_BodyTracking_A_headsetOscSendPort), i(gk_AF_Module_BodyTracking_A_headsetOscReceivePort))'}}

    S_oscMessages[] init 3
    k_oscMessagesLength init 0
    k_oscIsDone = {{false}}

    while (k_oscIsDone == {{false}}) do
        S_oscMessages, k_oscMessagesLength OSCraw i(gk_AF_Module_{{ModuleName}}_headsetOscReceivePort)

        if (k_oscMessagesLength == 0) then
            ; {{LogTrace_k}}("OSC done\n\n")
            k_oscIsDone = {{true}}
        else
            ; {{LogTrace_k '("OSC %s(%s)[%d] received: %s", S_oscMessages[k(0)], S_oscMessages[k(1)], k_oscMessagesLength, S_oscMessages[k(2)])'}}
            if (strcmpk(S_oscMessages[k(0)], "/headset/frontend/heartbeat") == 0) then
                ; {{LogTrace_k '("OSC heartbeat received: index = %s", S_oscMessages[k(2)])'}}
                k_heartbeatIndex = intFromString_k(S_oscMessages[k(2)])
                k_uiMode = {{moduleGet:k 'UiMode'}}
                OSCsend(k_heartbeatIndex, gS_AF_Module_{{ModuleName}}_headsetIpAddress, i(gk_AF_Module_{{ModuleName}}_headsetOscSendPort), "/headset/frontend/heartbeat/received", "ii", k_heartbeatIndex, k_uiMode)
            fi
        fi
   od
end:
endin


/// Always-on instrument for this module.
/// @param 4 Channel prefix used for host automation parameters. Should match the channel prefix used for the module's UDO.
///
instr AF_Module_{{ModuleName}}_alwayson
    S_channelPrefix = p4
    i_instanceIndex = {{hostValueGet}}:i(S_channelPrefix)

    ; // Websocket settings handling ...

    ; // Set the text inputs' initial values. Runs at i-time only.
    ; S_headsetWebSocketReceivePort = sprintf("%d", i(gk_AF_Module_{{ModuleName}}_headsetWebSocketReceivePort))
    ; {{moduleSetUi:S 'WebSocketPort' '"text", S_headsetWebSocketReceivePort'}}

    ; // Check for a changed settings every 250 milliseconds.
    ; if (metro(4) == {{true}}) then
    ;     k_restartWebSocket = {{false}}

    ;     // If the port changed ...
    ;     k_headsetWebSocketReceivePort = intFromString_k({{moduleGetUi:S 'WebSocketPort' '"text"'}})
    ;     if (gk_AF_Module_{{ModuleName}}_headsetWebSocketReceivePort != k_headsetWebSocketReceivePort) then
    ;         gk_AF_Module_{{ModuleName}}_headsetWebSocketReceivePort = k_headsetWebSocketReceivePort
    ;         k_restartWebSocket = {{true}}
    ;     fi

    ;     // Restart the listener instrument if needed.
    ;     if (k_restartWebSocket == {{true}}) then
    ;         turnoff2(k(nstrnum("AF_Module_{{ModuleName}}_websocketListener")), 0, 0)
    ;         event("i", "AF_Module_{{ModuleName}}_websocketListener", 0, -1, i_instanceIndex)
    ;     fi
    ; fi

    ; // OSC settings handling ...

    ; // Set the text inputs' initial values. Runs at i-time only.
    ; S_headsetIpAddress = sprintf("%s", gS_AF_Module_{{ModuleName}}_headsetIpAddress)
    ; S_headsetOscSendPort = sprintf("%d", i(gk_AF_Module_{{ModuleName}}_headsetOscSendPort))
    ; S_headsetOscReceivePort = sprintf("%d", i(gk_AF_Module_{{ModuleName}}_headsetOscReceivePort))
    ; {{moduleSetUi:S 'HeadsetIpAddress' '"text", S_headsetIpAddress'}}
    ; {{moduleSetUi:S 'OscSendPort' '"text", S_headsetOscSendPort'}}
    ; {{moduleSetUi:S 'OscReceivePort' '"text", S_headsetOscReceivePort'}}

    ; // Check for a changed settings every 250 milliseconds.
    ; if (metro(4) == {{true}}) then
    ;     k_restartOsc = {{false}}

    ;     // If the headset IP changed ...
    ;     S_headsetIpAddress = {{moduleGetUi:S 'HeadsetIpAddress' '"text"'}}
    ;     if (strcmpk(gS_AF_Module_{{ModuleName}}_headsetIpAddress, S_headsetIpAddress) != 0) then
    ;         gS_AF_Module_{{ModuleName}}_headsetIpAddress = sprintfk("%s", S_headsetIpAddress)
    ;         k_restartOsc = {{true}}
    ;     fi

    ;     // If the send port changed ...
    ;     k_headsetOscSendPort = intFromString_k({{moduleGetUi:S 'OscSendPort' '"text"'}})
    ;     if (gk_AF_Module_{{ModuleName}}_headsetOscSendPort != k_headsetOscSendPort) then
    ;         gk_AF_Module_{{ModuleName}}_headsetOscSendPort = k_headsetOscSendPort
    ;         k_restartOsc = {{true}}
    ;     fi

    ;     // If the receive port changed ...
    ;     k_headsetOscReceivePort = intFromString_k({{moduleGetUi:S 'OscReceivePort' '"text"'}})
    ;     if (gk_AF_Module_{{ModuleName}}_headsetOscReceivePort != k_headsetOscReceivePort) then
    ;         gk_AF_Module_{{ModuleName}}_headsetOscReceivePort = k_headsetOscReceivePort
    ;         k_restartOsc = {{true}}
    ;     fi

    ;     // Restart the listener instrument if needed.
    ;     if (k_restartOsc == {{true}}) then
    ;         turnoff2(k(nstrnum("AF_Module_{{ModuleName}}_oscListener")), 0, 0)
    ;         event("i", "AF_Module_{{ModuleName}}_oscListener", 0, -1, i_instanceIndex)
    ;     fi
    ; fi

    event_i("i", "AF_Module_{{ModuleName}}_websocketListener", 0, -1, i_instanceIndex)
    event_i("i", "AF_Module_{{ModuleName}}_oscListener", 0, -1, i_instanceIndex)
    turnoff
endin
