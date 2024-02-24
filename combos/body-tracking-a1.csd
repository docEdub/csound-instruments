-<CsoundSynthesizer>
<CsOptions>
{{CsOptions}}
{{HostOptions}}
; --messagelevel=0
</CsOptions>
<CsInstruments>

{{Enable-LogTrace false}}
{{Enable-LogDebug true}}

sr = {{sr}}
ksmps = 1
nchnls = 64

{{CsInstruments}}


gk_websocketPort init 12345


instr AF_BodyTracking_A1_alwayson
    i_websocketPort = i(gk_websocketPort)

    ; k_isRecording init $false
    ; k_isRecording = chnget:k("IS_RECORDING")
    ; if (changed2(k_isRecording) == $true) then
    ;     {{LogDebug_k '("k_isRecording = %d", k_isRecording)'}}
    ; endif

    ; k_isPlaying init $false
    ; k_isPlaying = chnget:k("IS_PLAYING")
    ; if (changed2(k_isPlaying) == $true) then
    ;     {{LogDebug_k '("k_isPlaying = %d", k_isPlaying)'}}
    ; endif

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

    ; if (k_isRecording == $true || k_isPlaying == $false) then
        k_leftWrist = websocket_getArray_k(i_websocketPort, "/hands/left/wrist/position")

        k_leftTip1 = websocket_getArray_k(i_websocketPort, "/hands/left/finger/1/tip/position")

        k_leftTip2 = websocket_getArray_k(i_websocketPort, "/hands/left/finger/2/tip/position")

        k_leftTip3 = websocket_getArray_k(i_websocketPort, "/hands/left/finger/3/tip/position")

        k_leftTip4 = websocket_getArray_k(i_websocketPort, "/hands/left/finger/4/tip/position")

        k_leftTip5 = websocket_getArray_k(i_websocketPort, "/hands/left/finger/5/tip/position")


        k_rightWrist = websocket_getArray_k(i_websocketPort, "/hands/right/wrist/position")
        ; if (changed:k(k_rightWrist[0], k_rightWrist[1], k_rightWrist[2]) == $true) then
        ;     {{LogDebug_k '("k_rightWrist = [%f, %f, %f]", k_rightWrist[0], k_rightWrist[1], k_rightWrist[2])'}}
        ; endif

        k_rightTip1 = websocket_getArray_k(i_websocketPort, "/hands/right/finger/1/tip/position")

        k_rightTip2 = websocket_getArray_k(i_websocketPort, "/hands/right/finger/2/tip/position")

        k_rightTip3 = websocket_getArray_k(i_websocketPort, "/hands/right/finger/3/tip/position")

        k_rightTip4 = websocket_getArray_k(i_websocketPort, "/hands/right/finger/4/tip/position")

        k_rightTip5 = websocket_getArray_k(i_websocketPort, "/hands/right/finger/5/tip/position")

        k_headPosition = websocket_getArray_k(i_websocketPort, "/head/position")

        k_headRotation = websocket_getArray_k(i_websocketPort, "/head/rotation")
    ; else
    ;     // Get recorded body tracking data from host.

    ;     k_leftWrist[0] = inch(1)
    ;     k_leftWrist[1] = inch(2)
    ;     k_leftWrist[2] = inch(3)

    ;     k_leftTip1[0] = inch(4)
    ;     k_leftTip1[1] = inch(5)
    ;     k_leftTip1[2] = inch(6)

    ;     k_leftTip2[0] = inch(7)
    ;     k_leftTip2[1] = inch(8)
    ;     k_leftTip2[2] = inch(9)

    ;     k_leftTip3[0] = inch(10)
    ;     k_leftTip3[1] = inch(11)
    ;     k_leftTip3[2] = inch(12)

    ;     k_leftTip4[0] = inch(13)
    ;     k_leftTip4[1] = inch(14)
    ;     k_leftTip4[2] = inch(15)

    ;     k_leftTip5[0] = inch(16)
    ;     k_leftTip5[1] = inch(17)
    ;     k_leftTip5[2] = inch(18)

    ;     k_rightWrist[0] = inch(19)
    ;     k_rightWrist[1] = inch(20)
    ;     k_rightWrist[2] = inch(21)

    ;     k_rightTip1[0] = inch(22)
    ;     k_rightTip1[1] = inch(23)
    ;     k_rightTip1[2] = inch(24)

    ;     k_rightTip2[0] = inch(25)
    ;     k_rightTip2[1] = inch(26)
    ;     k_rightTip2[2] = inch(27)

    ;     k_rightTip3[0] = inch(28)
    ;     k_rightTip3[1] = inch(29)
    ;     k_rightTip3[2] = inch(30)

    ;     k_rightTip4[0] = inch(31)
    ;     k_rightTip4[1] = inch(32)
    ;     k_rightTip4[2] = inch(33)

    ;     k_rightTip5[0] = inch(34)
    ;     k_rightTip5[1] = inch(35)
    ;     k_rightTip5[2] = inch(36)

    ;     k_headPosition[0] = inch(37)
    ;     k_headPosition[1] = inch(38)
    ;     k_headPosition[2] = inch(39)

    ;     k_headRotation[0] = inch(40)
    ;     k_headRotation[1] = inch(41)
    ;     k_headRotation[2] = inch(42)
    ; endif

    // Send body tracking data to audio output so host can record it and show its output during playback.

    outch(1, k_leftWrist[0])
    outch(2, k_leftWrist[1])
    outch(3, k_leftWrist[2])

    outch(4, k_leftTip1[0])
    outch(5, k_leftTip1[1])
    outch(6, k_leftTip1[2])

    outch(7, k_leftTip2[0])
    outch(8, k_leftTip2[1])
    outch(9, k_leftTip2[2])

    outch(10, k_leftTip3[0])
    outch(11, k_leftTip3[1])
    outch(12, k_leftTip3[2])

    outch(13, k_leftTip4[0])
    outch(14, k_leftTip4[1])
    outch(15, k_leftTip4[2])

    outch(16, k_leftTip5[0])
    outch(17, k_leftTip5[1])
    outch(18, k_leftTip5[2])

    outch(19, k_rightWrist[0])
    outch(20, k_rightWrist[1])
    outch(21, k_rightWrist[2])

    outch(22, k_rightTip1[0])
    outch(23, k_rightTip1[1])
    outch(24, k_rightTip1[2])

    outch(25, k_rightTip2[0])
    outch(26, k_rightTip2[1])
    outch(27, k_rightTip2[2])

    outch(28, k_rightTip3[0])
    outch(29, k_rightTip3[1])
    outch(30, k_rightTip3[2])

    outch(31, k_rightTip4[0])
    outch(32, k_rightTip4[1])
    outch(33, k_rightTip4[2])

    outch(34, k_rightTip5[0])
    outch(35, k_rightTip5[1])
    outch(36, k_rightTip5[2])

    outch(37, k_headPosition[0])
    outch(38, k_headPosition[1])
    outch(39, k_headPosition[2])

    outch(40, k_headRotation[0])
    outch(41, k_headRotation[1])
    outch(42, k_headRotation[2])

    // Send recorded body tracking data to host as MIDI NRPN messages.

    ; if (changed2:k(k_leftWrist[0], k_leftWrist[1], k_leftWrist[2]) == $true) then
    ;     {{LogDebug_k '("k_leftWrist = [%f, %f, %f]", k_leftWrist[0], k_leftWrist[1], k_leftWrist[2])'}}
    ; endif
endin


// Start at 1 second to give the host time to set it's values.
scoreline_i("i\"AF_BodyTracking_A1_alwayson\" 1 -1")


</CsInstruments>
<CsScore>

{{CsScore}}

</CsScore>
</CsoundSynthesizer>

{{Cabbage}}
