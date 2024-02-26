-<CsoundSynthesizer>
<CsOptions>
{{CsOptions}}
{{HostOptions}}
-Q0
--messagelevel=0
</CsOptions>
<CsInstruments>

{{Enable-LogTrace false}}
{{Enable-LogDebug false}}

sr = {{sr}}
ksmps = 1
nchnls = 42

{{CsInstruments}}


gk_websocketPort init 12345


opcode sendBodyTrackingMidiMessage, 0, iik
    i_midiChannel, i_bodyTrackingId, k_value xin

    i_bodyTrackingId_msb = int(i_bodyTrackingId / 128)
    i_bodyTrackingId_lsb = i_bodyTrackingId % 128

    k_value_scaled = 16383 * (limit:k(k_value, -1, 1) + 1) / 2
    if (changed2:k(k_value_scaled) == $true) then
        k_value_msb = int(k_value_scaled / 128)
        k_value_lsb = k_value_scaled % 128

        midiout(176, i_midiChannel, 99, i_bodyTrackingId_msb)
        midiout(176, i_midiChannel, 98, i_bodyTrackingId_lsb)
        midiout(176, i_midiChannel, 6, k_value_msb)
        midiout(176, i_midiChannel, 38, k_value_lsb)

        ; {{LogDebug_k '("MIDI: %d %d %d = %f", i_midiChannel, i_bodyTrackingId, k_value_scaled, k_value)'}}
    endif
endop


instr AF_BodyTracking_A1_alwayson
    i_websocketPort = i(gk_websocketPort)

    k_isRecording init $false
    k_isRecording = chnget:k("IS_RECORDING")
    if (changed2(k_isRecording) == $true) then
        ; {{LogDebug_k '("k_isRecording = %d", k_isRecording)'}}
    endif

    k_isPlaying init $false
    k_isPlaying = chnget:k("IS_PLAYING")
    if (changed2(k_isPlaying) == $true) then
        ; {{LogDebug_k '("k_isPlaying = %d", k_isPlaying)'}}
    endif

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

    k_trackedLeftWrist[] init 3
    k_trackedRightWrist[] init 3

    if (k_isRecording == $true || k_isPlaying == $false) then
        k_trackedLeftWrist = websocket_getArray_k(i_websocketPort, "/hands/left/wrist/position")
        k_trackedRightWrist = websocket_getArray_k(i_websocketPort, "/hands/right/wrist/position")

        // When recording starts or playback stops, the `changed2` opcode will always return `true`, so we make it
        // return `true` twice in a row before considering body tracking to be active.
        if (k_isBodyTrackingActive < 2) then
            if (changed2:k( \
                    k_trackedLeftWrist[0], k_trackedLeftWrist[1], k_trackedLeftWrist[2], \
                    k_trackedRightWrist[0], k_trackedRightWrist[1], k_trackedRightWrist[2]) == $true) then
                k_isBodyTrackingActive += 1
                ; {{LogDebug_k '("k_isBodyTrackingActive = %d", k_isBodyTrackingActive)'}}
            endif
        endif
    elseif (k_isBodyTrackingActive != $false) then
        k_isBodyTrackingActive = $false
        ; {{LogDebug_k '("k_isBodyTrackingActive = %d", k_isBodyTrackingActive)'}}
    endif

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
    else
        // Get recorded body tracking data from host.

        k_leftWrist[0] = inch(1)
        k_leftWrist[1] = inch(2)
        k_leftWrist[2] = inch(3)

        k_leftTip1[0] = inch(4)
        k_leftTip1[1] = inch(5)
        k_leftTip1[2] = inch(6)

        k_leftTip2[0] = inch(7)
        k_leftTip2[1] = inch(8)
        k_leftTip2[2] = inch(9)

        k_leftTip3[0] = inch(10)
        k_leftTip3[1] = inch(11)
        k_leftTip3[2] = inch(12)

        k_leftTip4[0] = inch(13)
        k_leftTip4[1] = inch(14)
        k_leftTip4[2] = inch(15)

        k_leftTip5[0] = inch(16)
        k_leftTip5[1] = inch(17)
        k_leftTip5[2] = inch(18)

        k_rightWrist[0] = inch(19)
        k_rightWrist[1] = inch(20)
        k_rightWrist[2] = inch(21)

        k_rightTip1[0] = inch(22)
        k_rightTip1[1] = inch(23)
        k_rightTip1[2] = inch(24)

        k_rightTip2[0] = inch(25)
        k_rightTip2[1] = inch(26)
        k_rightTip2[2] = inch(27)

        k_rightTip3[0] = inch(28)
        k_rightTip3[1] = inch(29)
        k_rightTip3[2] = inch(30)

        k_rightTip4[0] = inch(31)
        k_rightTip4[1] = inch(32)
        k_rightTip4[2] = inch(33)

        k_rightTip5[0] = inch(34)
        k_rightTip5[1] = inch(35)
        k_rightTip5[2] = inch(36)

        k_headPosition[0] = inch(37)
        k_headPosition[1] = inch(38)
        k_headPosition[2] = inch(39)

        k_headRotation[0] = inch(40)
        k_headRotation[1] = inch(41)
        k_headRotation[2] = inch(42)
    endif

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

    // TODO: Send recorded body tracking data to host as MIDI NRPN messages.

    ; if (changed2:k(k_leftWrist[0], k_leftWrist[1], k_leftWrist[2]) == $true) then
    ;     {{LogDebug_k '("k_leftWrist = [%f, %f, %f]", k_leftWrist[0], k_leftWrist[1], k_leftWrist[2])'}}
    ; endif

    sendBodyTrackingMidiMessage(1, 0, k_leftWrist[0])
    sendBodyTrackingMidiMessage(1, 1, k_leftWrist[1])
    sendBodyTrackingMidiMessage(1, 2, k_leftWrist[2])

    sendBodyTrackingMidiMessage(1, 3, k_leftTip1[0])
    sendBodyTrackingMidiMessage(1, 4, k_leftTip1[1])
    sendBodyTrackingMidiMessage(1, 5, k_leftTip1[2])

    sendBodyTrackingMidiMessage(1, 6, k_leftTip2[0])
    sendBodyTrackingMidiMessage(1, 7, k_leftTip2[1])
    sendBodyTrackingMidiMessage(1, 8, k_leftTip2[2])

    sendBodyTrackingMidiMessage(1, 9, k_leftTip3[0])
    sendBodyTrackingMidiMessage(1, 10, k_leftTip3[1])
    sendBodyTrackingMidiMessage(1, 11, k_leftTip3[2])

    sendBodyTrackingMidiMessage(1, 12, k_leftTip4[0])
    sendBodyTrackingMidiMessage(1, 13, k_leftTip4[1])
    sendBodyTrackingMidiMessage(1, 14, k_leftTip4[2])

    sendBodyTrackingMidiMessage(1, 15, k_leftTip5[0])
    sendBodyTrackingMidiMessage(1, 16, k_leftTip5[1])
    sendBodyTrackingMidiMessage(1, 17, k_leftTip5[2])

    sendBodyTrackingMidiMessage(1, 18, k_rightWrist[0])
    sendBodyTrackingMidiMessage(1, 19, k_rightWrist[1])
    sendBodyTrackingMidiMessage(1, 20, k_rightWrist[2])

    sendBodyTrackingMidiMessage(1, 21, k_rightTip1[0])
    sendBodyTrackingMidiMessage(1, 22, k_rightTip1[1])
    sendBodyTrackingMidiMessage(1, 23, k_rightTip1[2])

    sendBodyTrackingMidiMessage(1, 24, k_rightTip2[0])
    sendBodyTrackingMidiMessage(1, 25, k_rightTip2[1])
    sendBodyTrackingMidiMessage(1, 26, k_rightTip2[2])

    sendBodyTrackingMidiMessage(1, 27, k_rightTip3[0])
    sendBodyTrackingMidiMessage(1, 28, k_rightTip3[1])
    sendBodyTrackingMidiMessage(1, 29, k_rightTip3[2])

    sendBodyTrackingMidiMessage(1, 30, k_rightTip4[0])
    sendBodyTrackingMidiMessage(1, 31, k_rightTip4[1])
    sendBodyTrackingMidiMessage(1, 32, k_rightTip4[2])

    sendBodyTrackingMidiMessage(1, 33, k_rightTip5[0])
    sendBodyTrackingMidiMessage(1, 34, k_rightTip5[1])
    sendBodyTrackingMidiMessage(1, 35, k_rightTip5[2])

    sendBodyTrackingMidiMessage(1, 36, k_headPosition[0])
    sendBodyTrackingMidiMessage(1, 37, k_headPosition[1])
    sendBodyTrackingMidiMessage(1, 38, k_headPosition[2])

    sendBodyTrackingMidiMessage(1, 39, k_headRotation[0])
    sendBodyTrackingMidiMessage(1, 40, k_headRotation[1])
    sendBodyTrackingMidiMessage(1, 41, k_headRotation[2])
endin


// Start at 1 second to give the host time to set it's values.
scoreline_i("i\"AF_BodyTracking_A1_alwayson\" 1 -1")


</CsInstruments>
<CsScore>

{{CsScore}}

</CsScore>
</CsoundSynthesizer>

{{Cabbage}}
