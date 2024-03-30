-<CsoundSynthesizer>
<CsOptions>
{{CsOptions}}
{{HostOptions}}
--messagelevel=0
</CsOptions>
<CsInstruments>

{{Enable-LogTrace false}}
{{Enable-LogDebug false}}

sr = {{sr}}
ksmps = 1
nchnls = 2
nchnls_i = 2

{{CsInstruments}}


gk_websocketPort init 12345


instr AF_BodyTracking_A1_alwayson
    i_websocketPort = i(gk_websocketPort)

    k_isRecording init $false
    k_isPlaying init $false

    k_trackedLeftWrist[] init 3
    k_trackedRightWrist[] init 3

    k_isBodyTrackingActive init $false

    k_leftWrist[] init 3
    k_leftTip1[] init 3
    k_leftTip2[] init 3
    k_leftTip3[] init 3
    k_leftTip4[] init 3
    k_leftTip5[] init 3
    k_rightWrist[] init 3
    k_rightTip1[] init 3
    k_rightTip2[] init 3
    k_rightTip3[] init 3
    k_rightTip4[] init 3
    k_rightTip5[] init 3
    k_headPosition[] init 3
    k_headRotation[] init 3

    k_currentBodyTrackingValues[] init 42


    k_isRecording = chnget:k("IS_RECORDING")
    if (changed2(k_isRecording) == $true) then
        {{LogDebug_k '("k_isRecording = %d", k_isRecording)'}}
    endif

    k_isPlaying = chnget:k("IS_PLAYING")
    if (changed2(k_isPlaying) == $true) then
        {{LogDebug_k '("k_isPlaying = %d", k_isPlaying)'}}
    endif

    ; if (k_isRecording == $true || k_isPlaying == $false) then
    ;     k_trackedLeftWrist = websocket_getArray_k(i_websocketPort, "/hands/left/wrist/position")
    ;     k_trackedRightWrist = websocket_getArray_k(i_websocketPort, "/hands/right/wrist/position")

    ;     // When recording starts or playback stops, the `changed2` opcode will always return `true`, so we make it
    ;     // return `true` twice in a row before considering body tracking to be active.
    ;     if (k_isBodyTrackingActive < 2) then
    ;         if (changed2:k( \
    ;                 k_trackedLeftWrist[0], k_trackedLeftWrist[1], k_trackedLeftWrist[2], \
    ;                 k_trackedRightWrist[0], k_trackedRightWrist[1], k_trackedRightWrist[2]) == $true) then
    ;             k_isBodyTrackingActive += 1
    ;             {{LogDebug_k '("k_isBodyTrackingActive = %d", k_isBodyTrackingActive)'}}
    ;         endif
    ;     endif
    ; elseif (k_isBodyTrackingActive != $false) then
    ;     k_isBodyTrackingActive = $false
    ;     {{LogDebug_k '("k_isBodyTrackingActive = %d", k_isBodyTrackingActive)'}}
    ; endif
    k_isBodyTrackingActive = 2

    if (k_isBodyTrackingActive == 2) then
        k_leftWrist[0] = k_trackedLeftWrist[0]
        k_leftWrist[1] = k_trackedLeftWrist[1]
        k_leftWrist[2] = k_trackedLeftWrist[2]
        k_rightWrist[0] = k_trackedRightWrist[0]
        k_rightWrist[1] = k_trackedRightWrist[1]
        k_rightWrist[2] = k_trackedRightWrist[2]

        k_leftTip1 = websocket_getArray_k(i_websocketPort, "/hands/left/finger/1/tip/position")
        k_leftTip2 = websocket_getArray_k(i_websocketPort, "/hands/left/finger/2/tip/position")
        k_leftTip3 = websocket_getArray_k(i_websocketPort, "/hands/left/finger/3/tip/position")
        k_leftTip4 = websocket_getArray_k(i_websocketPort, "/hands/left/finger/4/tip/position")
        k_leftTip5 = websocket_getArray_k(i_websocketPort, "/hands/left/finger/5/tip/position")

        k_rightTip1 = websocket_getArray_k(i_websocketPort, "/hands/right/finger/1/tip/position")
        k_rightTip2 = websocket_getArray_k(i_websocketPort, "/hands/right/finger/2/tip/position")
        k_rightTip3 = websocket_getArray_k(i_websocketPort, "/hands/right/finger/3/tip/position")
        k_rightTip4 = websocket_getArray_k(i_websocketPort, "/hands/right/finger/4/tip/position")
        k_rightTip5 = websocket_getArray_k(i_websocketPort, "/hands/right/finger/5/tip/position")

        k_headPosition = websocket_getArray_k(i_websocketPort, "/head/position")
        k_headRotation = websocket_getArray_k(i_websocketPort, "/head/rotation")

        ; if (changed2:k(k_headPosition[0], k_headPosition[1], k_headPosition[2]) == $true) then
        ;     {{LogDebug_k '("k_headPosition = [%f %f %f]", k_headPosition[0], k_headPosition[1], k_headPosition[2])'}}
        ; endif
        ; if (changed2:k(k_headRotation[0], k_headRotation[1], k_headRotation[2]) == $true) then
        ;     {{LogDebug_k '("k_headRotation = [%f %f %f]", k_headRotation[0], k_headRotation[1], k_headRotation[2])'}}
        ; endif

        k_currentBodyTrackingValues[0] = k_leftWrist[0]
        k_currentBodyTrackingValues[1] = k_leftWrist[1]
        k_currentBodyTrackingValues[2] = k_leftWrist[2]

        k_currentBodyTrackingValues[3] = k_leftTip1[0]
        k_currentBodyTrackingValues[4] = k_leftTip1[1]
        k_currentBodyTrackingValues[5] = k_leftTip1[2]

        k_currentBodyTrackingValues[6] = k_leftTip2[0]
        k_currentBodyTrackingValues[7] = k_leftTip2[1]
        k_currentBodyTrackingValues[8] = k_leftTip2[2]

        k_currentBodyTrackingValues[9] = k_leftTip3[0]
        k_currentBodyTrackingValues[10] = k_leftTip3[1]
        k_currentBodyTrackingValues[11] = k_leftTip3[2]

        k_currentBodyTrackingValues[12] = k_leftTip4[0]
        k_currentBodyTrackingValues[13] = k_leftTip4[1]
        k_currentBodyTrackingValues[14] = k_leftTip4[2]

        k_currentBodyTrackingValues[15] = k_leftTip5[0]
        k_currentBodyTrackingValues[16] = k_leftTip5[1]
        k_currentBodyTrackingValues[17] = k_leftTip5[2]

        k_currentBodyTrackingValues[18] = k_rightWrist[0]
        k_currentBodyTrackingValues[19] = k_rightWrist[1]
        k_currentBodyTrackingValues[20] = k_rightWrist[2]

        k_currentBodyTrackingValues[21] = k_rightTip1[0]
        k_currentBodyTrackingValues[22] = k_rightTip1[1]
        k_currentBodyTrackingValues[23] = k_rightTip1[2]

        k_currentBodyTrackingValues[24] = k_rightTip2[0]
        k_currentBodyTrackingValues[25] = k_rightTip2[1]
        k_currentBodyTrackingValues[26] = k_rightTip2[2]

        k_currentBodyTrackingValues[27] = k_rightTip3[0]
        k_currentBodyTrackingValues[28] = k_rightTip3[1]
        k_currentBodyTrackingValues[29] = k_rightTip3[2]

        k_currentBodyTrackingValues[30] = k_rightTip4[0]
        k_currentBodyTrackingValues[31] = k_rightTip4[1]
        k_currentBodyTrackingValues[32] = k_rightTip4[2]

        k_currentBodyTrackingValues[33] = k_rightTip5[0]
        k_currentBodyTrackingValues[34] = k_rightTip5[1]
        k_currentBodyTrackingValues[35] = k_rightTip5[2]

        k_currentBodyTrackingValues[36] = k_headPosition[0]
        k_currentBodyTrackingValues[37] = k_headPosition[1]
        k_currentBodyTrackingValues[38] = k_headPosition[2]

        k_currentBodyTrackingValues[39] = k_headRotation[0]
        k_currentBodyTrackingValues[40] = k_headRotation[1]
        k_currentBodyTrackingValues[41] = k_headRotation[2]

        k_bodyTrackingIndex init -1
        if (k_bodyTrackingIndex == -1) then
            out(a(1))
            k_bodyTrackingIndex = 0
        elseif (k_bodyTrackingIndex >= 42) then
            out(a(-1))
            k_bodyTrackingIndex = -1
        else
            out(a(k_currentBodyTrackingValues[k_bodyTrackingIndex]))
            k_bodyTrackingIndex += 1
        endif
    else
        out(inch(1))
    endif
endin


// Start at 1 second to give the host time to set it's values.
scoreline_i("i\"AF_BodyTracking_A1_alwayson\" 1 -1")

</CsInstruments>
<CsScore>

{{CsScore}}

</CsScore>
</CsoundSynthesizer>

{{Cabbage}}
