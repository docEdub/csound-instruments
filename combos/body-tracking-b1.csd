-<CsoundSynthesizer>
<CsOptions>
{{CsOptions}}
{{HostOptions}}
--messagelevel=0
</CsOptions>
<CsInstruments>

{{Enable-LogTrace false}}
{{Enable-LogDebug true}}

sr = {{sr}}
ksmps = 1
nchnls = 2
nchnls_i = 2

{{CsInstruments}}

#define I_MidiNote #2#
#define I_SetInitialPose #3#
#define I_SendPoseOffsets #4#
#define I_AlwaysOn #5#

#define Channel_SetInitialPoseButton #"Set initial pose"#

#define WebSocketPath_Head_position #"/head/position"#
#define WebSocketPath_Head_rotation #"/head/rotation"#

#define WebSocketPath_L1_tip #"/hands/left/finger/1/tip/position"#
#define WebSocketPath_L2_tip #"/hands/left/finger/2/tip/position"#
#define WebSocketPath_R1_tip #"/hands/right/finger/1/tip/position"#
#define WebSocketPath_R2_tip #"/hands/right/finger/2/tip/position"#

#define PinchDistanceThreshold #0.015#

#define metro_OneTickEverySecond #1#
#define metro_OneTickEveryFiveSeconds #0.2#
#define metro_OneTickEveryTenSeconds #0.1#
#define metro_SkipFirstTick #0.00000001#

massign 0, $I_MidiNote
pgmassign 0, 0

gk_websocketPort init 12345
gk_initialHead_position[] init 3
gk_initialHead_rotation[] init 3
gk_initialPose_transform[] init 16

gk_L2_tip[] init 3
gk_R1_tip[] init 3
gk_L1_tip[] init 3
gk_R2_tip[] init 3

instr $I_MidiNote
endin


instr $I_SetInitialPose
    i_websocketPort = i(gk_websocketPort)

    k_L1to2[] = gk_L2_tip - gk_L1_tip
    k_R1to2[] = gk_R2_tip - gk_R1_tip
    k_pinchDistanceL = sqrt(k_L1to2[0] * k_L1to2[0]) + sqrt(k_L1to2[1] * k_L1to2[1]) + sqrt(k_L1to2[2] * k_L1to2[2])
    k_pinchDistanceR = sqrt(k_R1to2[0] * k_R1to2[0]) + sqrt(k_R1to2[1] * k_R1to2[1]) + sqrt(k_R1to2[2] * k_R1to2[2])

    k_tick init 1
    if (metro($metro_OneTickEverySecond) == $true) then
        {{LogDebug_k '("SetInitialPose[%d]: L1 tip = [%.3f, %.3f, %.3f], L2 tip = [%.3f, %.3f, %.3f], R1 tip = [%.3f, %.3f, %.3f], R2 tip = [%.3f, %.3f, %.3f]", k_tick, gk_L1_tip[0], gk_L1_tip[1], gk_L1_tip[2], gk_L2_tip[0], gk_L2_tip[1], gk_L2_tip[2], gk_R1_tip[0], gk_R1_tip[1], gk_R1_tip[2], gk_R2_tip[0], gk_R2_tip[1], gk_R2_tip[2])'}}
        {{LogDebug_k '("SetInitialPose[%d]: Left pinch distance = %.3f, Right pinch distance = %.3f", k_tick, k_pinchDistanceL, k_pinchDistanceR)'}}
        k_tick += 1
    endif

    if (k_pinchDistanceL < $PinchDistanceThreshold && k_pinchDistanceR < $PinchDistanceThreshold) then
        cabbageSetValue($Channel_SetInitialPoseButton, k($false))
    endif

    k_setInitialPose = cabbageGetValue:k($Channel_SetInitialPoseButton)
    if (k_setInitialPose == $false) then
        // Calculate initial pose transform's translation and rotation.
        k_translation[] = (gk_L1_tip + gk_R1_tip) / 2
        k_rotation[] fillarray 0, 0, 0
        k_rotation[2] = -taninv2(gk_R1_tip[1] - gk_L1_tip[1], gk_R1_tip[0] - gk_L1_tip[0])

        {{LogDebug_k '("Translation = [%.3f, %.3f, %.3f]", k_translation[0], k_translation[1], k_translation[2])'}}
        {{LogDebug_k '("Rotation = %.3f", 360 * (k_rotation[2] / (2 * $M_PI)))'}}

        // Update global pose variables.
        gk_initialHead_position = websocket_getArray_k(i_websocketPort, $WebSocketPath_Head_position)
        gk_initialHead_rotation = websocket_getArray_k(i_websocketPort, $WebSocketPath_Head_rotation)
        gk_initialPose_transform = DaGLMath_Mat4_fromEulerAnglesXYZ(k_rotation)
        gk_initialPose_transform[12] = -k_translation[0]
        gk_initialPose_transform[13] = -k_translation[1]
        gk_initialPose_transform[14] = -k_translation[2]

        {{LogDebug_k '("Initial head position: [%.3f, %.3f, %.3f]", gk_initialHead_position[0], gk_initialHead_position[1], gk_initialHead_position[2])'}}
        {{LogDebug_k '("Initial head rotation: [%.3f, %.3f, %.3f]", gk_initialHead_rotation[0], gk_initialHead_rotation[1], gk_initialHead_rotation[2])'}}
        {{LogDebug_k '("Initial pose transform:")'}}
        {{LogDebug_k '("    %.3f, %.3f, %.3f, %.3f", gk_initialPose_transform[0], gk_initialPose_transform[1], gk_initialPose_transform[2], gk_initialPose_transform[3])'}}
        {{LogDebug_k '("    %.3f, %.3f, %.3f, %.3f", gk_initialPose_transform[4], gk_initialPose_transform[5], gk_initialPose_transform[6], gk_initialPose_transform[7])'}}
        {{LogDebug_k '("    %.3f, %.3f, %.3f, %.3f", gk_initialPose_transform[8], gk_initialPose_transform[9], gk_initialPose_transform[10], gk_initialPose_transform[11])'}}
        {{LogDebug_k '("    %.3f, %.3f, %.3f, %.3f", gk_initialPose_transform[12], gk_initialPose_transform[13], gk_initialPose_transform[14], gk_initialPose_transform[15])'}}

        turnoff()
    endif
endin


instr $I_SendPoseOffsets
    ; k_tick init 1
    ; if (metro($metro_OneTickEverySecond) == $true) then
    ;     {{LogDebug_k '("SendPoseOffsets: k_tick = %d ...", k_tick)'}}
    ;     k_tick += 1
    ; endif

    k_L1_tip[] = DaGLMath_Mat4_multiplyVec3(gk_L1_tip, gk_initialPose_transform)
    k_R1_tip[] = DaGLMath_Mat4_multiplyVec3(gk_R1_tip, gk_initialPose_transform)

    if (metro($metro_OneTickEverySecond) == $true) then
        if (changed2(k_L1_tip) == $true || changed2(k_R1_tip) == $true) then
            {{LogDebug_k '("L1 tip = [%.3f, %.3f, %.3f], R1 tip = [%.3f, %.3f, %.3f]", k_L1_tip[0], k_L1_tip[1], k_L1_tip[2], k_R1_tip[0], k_R1_tip[1], k_R1_tip[2])'}}
        endif
    endif

    k_setInitialPose = cabbageGetValue:k($Channel_SetInitialPoseButton)
    if (k_setInitialPose == $true) then
        turnoff()
    endif
endin


instr $I_AlwaysOn
    i_websocketPort = i(gk_websocketPort)

    gk_L1_tip = websocket_getArray_k(i_websocketPort, $WebSocketPath_L1_tip)
    gk_L2_tip = websocket_getArray_k(i_websocketPort, $WebSocketPath_L2_tip)
    gk_R1_tip = websocket_getArray_k(i_websocketPort, $WebSocketPath_R1_tip)
    gk_R2_tip = websocket_getArray_k(i_websocketPort, $WebSocketPath_R2_tip)

    ; if (metro($metro_OneTickEverySecond) == $true) then
    ;     if (changed2(gk_L1_tip) == $true || changed2(gk_R1_tip) == $true) then
    ;         {{LogDebug_k '("L1 tip = [%.3f, %.3f, %.3f], R1 tip = [%.3f, %.3f, %.3f]", gk_L1_tip[0], gk_L1_tip[1], gk_L1_tip[2], gk_R1_tip[0], gk_R1_tip[1], gk_R1_tip[2])'}}
    ;     endif
    ; endif

    k_iteration init 0

    k_setInitialPose = cabbageGetValue:k("Set initial pose")
    if (changed2(k_setInitialPose) == $true || k_iteration == 0) then
        {{LogDebug_k '("k_setInitialPose = %d", k_setInitialPose)'}}

        if (k_setInitialPose == $true) then
            event("i", $I_SetInitialPose, 0, -1)
        else
            event("i", $I_SendPoseOffsets, 0, -1)
        endif
    endif

    k_iteration += 1
endin


// Start at 1 second to give the host time to set it's values.
scoreline_i("i$I_AlwaysOn 1 -1")

</CsInstruments>
<CsScore>

{{CsScore}}

</CsScore>
</CsoundSynthesizer>

{{Cabbage}}
