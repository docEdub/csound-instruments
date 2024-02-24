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
nchnls = 64

{{CsInstruments}}


gk_websocketPort init 12345


instr AF_Effect_A1_alwayson
    i_websocketPort = i(gk_websocketPort)

    k_leftWrist[] init 3
    k_leftWrist = websocket_getArray_k(i_websocketPort, "/hands/left/wrist/position")
    ; if (changed:k(k_leftWrist[0], k_leftWrist[1], k_leftWrist[2]) == $true) then
    ;     {{LogInfo_k '("k_leftWrist = [%f, %f, %f]", k_leftWrist[0], k_leftWrist[1], k_leftWrist[2])'}}
    ; endif

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
    ; if (changed:k(k_rightWrist[0], k_rightWrist[1], k_rightWrist[2]) == $true) then
    ;     {{LogInfo_k '("k_rightWrist = [%f, %f, %f]", k_rightWrist[0], k_rightWrist[1], k_rightWrist[2])'}}
    ; endif

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

    outch(33, k_rightWrist[0])
    outch(34, k_rightWrist[1])
    outch(35, k_rightWrist[2])

    outch(36, k_rightTip1[0])
    outch(37, k_rightTip1[1])
    outch(38, k_rightTip1[2])

    outch(39, k_rightTip2[0])
    outch(40, k_rightTip2[1])
    outch(41, k_rightTip2[2])

    outch(42, k_rightTip3[0])
    outch(43, k_rightTip3[1])
    outch(44, k_rightTip3[2])

    outch(45, k_rightTip4[0])
    outch(46, k_rightTip4[1])
    outch(47, k_rightTip4[2])

    outch(48, k_rightTip5[0])
    outch(49, k_rightTip5[1])
    outch(50, k_rightTip5[2])
endin


// Start at 1 second to give the host time to set it's values.
scoreline_i("i\"AF_Effect_A1_alwayson\" 1 -1")


</CsInstruments>
<CsScore>

{{CsScore}}

</CsScore>
</CsoundSynthesizer>

{{Cabbage}}
