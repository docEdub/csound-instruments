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

#define I_Init #2#
#define I_SetInitialPose #3#
#define I_SendPoseOffsets #4#
#define I_AlwaysOn #5#

#define Channel_SetInitialPoseButton #"Set initial pose"#

#define Channel_InitialHead_position_x #"Initial head position x"#
#define Channel_InitialHead_position_y #"Initial head position y"#
#define Channel_InitialHead_position_z #"Initial head position z"#
#define Channel_InitialHead_rotation_x #"Initial head rotation x"#
#define Channel_InitialHead_rotation_y #"Initial head rotation y"#
#define Channel_InitialHead_rotation_z #"Initial head rotation z"#

#define Channel_InitialLeftThumbTip_x #"Initial left thumb tip x"#
#define Channel_InitialLeftThumbTip_y #"Initial left thumb tip y"#
#define Channel_InitialLeftThumbTip_z #"Initial left thumb tip z"#

#define Channel_InitialRightThumbTip_x #"Initial right thumb tip x"#
#define Channel_InitialRightThumbTip_y #"Initial right thumb tip y"#
#define Channel_InitialRightThumbTip_z #"Initial right thumb tip z"#

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

#define x #0#
#define y #1#
#define z #2#


gk_websocketPort init 12345

gk_initialHead_position[] init 3
gk_initialHead_rotation[] init 3
gk_initialL1_tip[] init 3
gk_initialR1_tip[] init 3
gk_initialPose_transform[] init 16

gk_Head_position[] init 3
gk_Head_rotation[] init 3
gk_L1_tip[] init 3
gk_L2_tip[] init 3
gk_R1_tip[] init 3
gk_R2_tip[] init 3


opcode updateInitialPoseTransform, 0, 0
    // Calculate initial pose transform's translation and rotation.
    k_translation[] = (gk_initialL1_tip + gk_initialR1_tip) / 2
    k_rotation[] = fillarray(0, 0, 0)
    k_rotation[2] = taninv2(gk_initialR1_tip[1] - gk_initialL1_tip[1], gk_initialR1_tip[0] - gk_initialL1_tip[0])

    // Update global pose transform.
    gk_initialPose_transform = DaGLMath_Mat4_fromEulerAnglesXYZ(-k_rotation)
    gk_initialPose_transform[12] = -k_translation[0]
    gk_initialPose_transform[13] = -k_translation[1]
    gk_initialPose_transform[14] = -k_translation[2]
endop


opcode setInitialPoseChannelValues, 0, 0
    cabbageSetValue($Channel_InitialHead_position_x, gk_initialHead_position[$x])
    cabbageSetValue($Channel_InitialHead_position_y, gk_initialHead_position[$y])
    cabbageSetValue($Channel_InitialHead_position_z, gk_initialHead_position[$z])

    cabbageSetValue($Channel_InitialHead_rotation_x, gk_initialHead_rotation[$x])
    cabbageSetValue($Channel_InitialHead_rotation_y, gk_initialHead_rotation[$y])
    cabbageSetValue($Channel_InitialHead_rotation_z, gk_initialHead_rotation[$z])

    cabbageSetValue($Channel_InitialLeftThumbTip_x, gk_initialL1_tip[$x])
    cabbageSetValue($Channel_InitialLeftThumbTip_y, gk_initialL1_tip[$y])
    cabbageSetValue($Channel_InitialLeftThumbTip_z, gk_initialL1_tip[$z])

    cabbageSetValue($Channel_InitialRightThumbTip_x, gk_initialR1_tip[$x])
    cabbageSetValue($Channel_InitialRightThumbTip_y, gk_initialR1_tip[$y])
    cabbageSetValue($Channel_InitialRightThumbTip_z, gk_initialR1_tip[$z])
endop


opcode printInitialPoseValues, 0, 0
    k_translation[] = (gk_initialL1_tip + gk_initialR1_tip) / 2
    k_rotation[] = fillarray(0, 0, 0)
    k_rotation[2] = taninv2(gk_initialR1_tip[1] - gk_initialL1_tip[1], gk_initialR1_tip[0] - gk_initialL1_tip[0])

    {{LogInfo_k '("Translation = [%.3f, %.3f, %.3f]", k_translation[0], k_translation[1], k_translation[2])'}}
    {{LogInfo_k '("Rotation = %.3f", 360 * (k_rotation[2] / (2 * $M_PI)))'}}

    {{LogInfo_k '("Initial head position: [%.3f, %.3f, %.3f]", gk_initialHead_position[0], gk_initialHead_position[1], gk_initialHead_position[2])'}}
    {{LogInfo_k '("Initial head rotation: [%.3f, %.3f, %.3f]", gk_initialHead_rotation[0], gk_initialHead_rotation[1], gk_initialHead_rotation[2])'}}
    {{LogInfo_k '("Initial pose transform:")'}}
    {{LogInfo_k '("    %.3f, %.3f, %.3f, %.3f", gk_initialPose_transform[0], gk_initialPose_transform[1], gk_initialPose_transform[2], gk_initialPose_transform[3])'}}
    {{LogInfo_k '("    %.3f, %.3f, %.3f, %.3f", gk_initialPose_transform[4], gk_initialPose_transform[5], gk_initialPose_transform[6], gk_initialPose_transform[7])'}}
    {{LogInfo_k '("    %.3f, %.3f, %.3f, %.3f", gk_initialPose_transform[8], gk_initialPose_transform[9], gk_initialPose_transform[10], gk_initialPose_transform[11])'}}
    {{LogInfo_k '("    %.3f, %.3f, %.3f, %.3f", gk_initialPose_transform[12], gk_initialPose_transform[13], gk_initialPose_transform[14], gk_initialPose_transform[15])'}}
endop


instr $I_Init
    gk_initialHead_position[$x] = cabbageGetValue($Channel_InitialHead_position_x)
    gk_initialHead_position[$y] = cabbageGetValue($Channel_InitialHead_position_y)
    gk_initialHead_position[$z] = cabbageGetValue($Channel_InitialHead_position_z)
    gk_initialHead_rotation[$x] = cabbageGetValue($Channel_InitialHead_rotation_x)
    gk_initialHead_rotation[$y] = cabbageGetValue($Channel_InitialHead_rotation_y)
    gk_initialHead_rotation[$z] = cabbageGetValue($Channel_InitialHead_rotation_z)

    gk_initialL1_tip[] = fillarray(cabbageGetValue($Channel_InitialLeftThumbTip_x), cabbageGetValue($Channel_InitialLeftThumbTip_y), cabbageGetValue($Channel_InitialLeftThumbTip_z))
    gk_initialR1_tip[] = fillarray(cabbageGetValue($Channel_InitialRightThumbTip_x), cabbageGetValue($Channel_InitialRightThumbTip_y), cabbageGetValue($Channel_InitialRightThumbTip_z))

    updateInitialPoseTransform()
    printInitialPoseValues()

    turnoff()
endin


instr $I_AlwaysOn
    i_websocketPort = i(gk_websocketPort)

    gk_Head_position = websocket_getArray_k(i_websocketPort, $WebSocketPath_Head_position)
    gk_Head_rotation = websocket_getArray_k(i_websocketPort, $WebSocketPath_Head_rotation)

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

    k_setInitialPose = cabbageGetValue:k($Channel_SetInitialPoseButton)
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


instr $I_SetInitialPose
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
        gk_initialHead_position = gk_Head_position
        gk_initialHead_rotation = gk_Head_rotation
        gk_initialL1_tip = gk_L1_tip
        gk_initialR1_tip = gk_R1_tip

        updateInitialPoseTransform()
        setInitialPoseChannelValues()
        printInitialPoseValues()

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


// Start at 1 second to give the host time to set it's values.
scoreline_i("i$I_Init 1 -1")
scoreline_i("i$I_AlwaysOn 1 -1")

</CsInstruments>
<CsScore>

{{CsScore}}

</CsScore>
</CsoundSynthesizer>

{{Cabbage}}
