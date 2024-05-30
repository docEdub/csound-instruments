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

#define WebSocketPath_L1_metacarpal             #"/hands/left/finger/1/metacarpal/position"#
#define WebSocketPath_L1_phalanxProximal        #"/hands/left/finger/1/phalanx-proximal/position"#
#define WebSocketPath_L1_phalanxDistal          #"/hands/left/finger/1/phalanx-distal/position"#
#define WebSocketPath_L1_tip                    #"/hands/left/finger/1/tip/position"#

#define WebSocketPath_L2_metacarpal             #"/hands/left/finger/2/metacarpal/position"#
#define WebSocketPath_L2_phalanxProximal        #"/hands/left/finger/2/phalanx-proximal/position"#
#define WebSocketPath_L2_phalanxIntermediate    #"/hands/left/finger/2/phalanx-intermediate/position"#
#define WebSocketPath_L2_phalanxDistal          #"/hands/left/finger/2/phalanx-distal/position"#
#define WebSocketPath_L2_tip                    #"/hands/left/finger/2/tip/position"#

#define WebSocketPath_L3_metacarpal             #"/hands/left/finger/3/metacarpal/position"#
#define WebSocketPath_L3_phalanxProximal        #"/hands/left/finger/3/phalanx-proximal/position"#
#define WebSocketPath_L3_phalanxIntermediate    #"/hands/left/finger/3/phalanx-intermediate/position"#
#define WebSocketPath_L3_phalanxDistal          #"/hands/left/finger/3/phalanx-distal/position"#
#define WebSocketPath_L3_tip                    #"/hands/left/finger/3/tip/position"#

#define WebSocketPath_L4_metacarpal             #"/hands/left/finger/4/metacarpal/position"#
#define WebSocketPath_L4_phalanxProximal        #"/hands/left/finger/4/phalanx-proximal/position"#
#define WebSocketPath_L4_phalanxIntermediate    #"/hands/left/finger/4/phalanx-intermediate/position"#
#define WebSocketPath_L4_phalanxDistal          #"/hands/left/finger/4/phalanx-distal/position"#
#define WebSocketPath_L4_tip                    #"/hands/left/finger/4/tip/position"#

#define WebSocketPath_L5_metacarpal             #"/hands/left/finger/5/metacarpal/position"#
#define WebSocketPath_L5_phalanxProximal        #"/hands/left/finger/5/phalanx-proximal/position"#
#define WebSocketPath_L5_phalanxIntermediate    #"/hands/left/finger/5/phalanx-intermediate/position"#
#define WebSocketPath_L5_phalanxDistal          #"/hands/left/finger/5/phalanx-distal/position"#
#define WebSocketPath_L5_tip                    #"/hands/left/finger/5/tip/position"#

#define WebSocketPath_R1_metacarpal             #"/hands/right/finger/1/metacarpal/position"#
#define WebSocketPath_R1_phalanxProximal        #"/hands/right/finger/1/phalanx-proximal/position"#
#define WebSocketPath_R1_phalanxDistal          #"/hands/right/finger/1/phalanx-distal/position"#
#define WebSocketPath_R1_tip                    #"/hands/right/finger/1/tip/position"#

#define WebSocketPath_R2_metacarpal             #"/hands/right/finger/2/metacarpal/position"#
#define WebSocketPath_R2_phalanxProximal        #"/hands/right/finger/2/phalanx-proximal/position"#
#define WebSocketPath_R2_phalanxIntermediate    #"/hands/right/finger/2/phalanx-intermediate/position"#
#define WebSocketPath_R2_phalanxDistal          #"/hands/right/finger/2/phalanx-distal/position"#
#define WebSocketPath_R2_tip                    #"/hands/right/finger/2/tip/position"#

#define WebSocketPath_R3_metacarpal             #"/hands/right/finger/3/metacarpal/position"#
#define WebSocketPath_R3_phalanxProximal        #"/hands/right/finger/3/phalanx-proximal/position"#
#define WebSocketPath_R3_phalanxIntermediate    #"/hands/right/finger/3/phalanx-intermediate/position"#
#define WebSocketPath_R3_phalanxDistal          #"/hands/right/finger/3/phalanx-distal/position"#
#define WebSocketPath_R3_tip                    #"/hands/right/finger/3/tip/position"#

#define WebSocketPath_R4_metacarpal             #"/hands/right/finger/4/metacarpal/position"#
#define WebSocketPath_R4_phalanxProximal        #"/hands/right/finger/4/phalanx-proximal/position"#
#define WebSocketPath_R4_phalanxIntermediate    #"/hands/right/finger/4/phalanx-intermediate/position"#
#define WebSocketPath_R4_phalanxDistal          #"/hands/right/finger/4/phalanx-distal/position"#
#define WebSocketPath_R4_tip                    #"/hands/right/finger/4/tip/position"#

#define WebSocketPath_R5_metacarpal             #"/hands/right/finger/5/metacarpal/position"#
#define WebSocketPath_R5_phalanxProximal        #"/hands/right/finger/5/phalanx-proximal/position"#
#define WebSocketPath_R5_phalanxIntermediate    #"/hands/right/finger/5/phalanx-intermediate/position"#
#define WebSocketPath_R5_phalanxDistal          #"/hands/right/finger/5/phalanx-distal/position"#
#define WebSocketPath_R5_tip                    #"/hands/right/finger/5/tip/position"#

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

gk_L1_metacarpal[] init 3
gk_L1_phalanxProximal[] init 3
gk_L1_phalanxDistal[] init 3
gk_L1_tip[] init 3

gk_L2_metacarpal[] init 3
gk_L2_phalanxProximal[] init 3
gk_L2_phalanxIntermediate[] init 3
gk_L2_phalanxDistal[] init 3
gk_L2_tip[] init 3

gk_L3_metacarpal[] init 3
gk_L3_phalanxProximal[] init 3
gk_L3_phalanxIntermediate[] init 3
gk_L3_phalanxDistal[] init 3
gk_L3_tip[] init 3

gk_L4_metacarpal[] init 3
gk_L4_phalanxProximal[] init 3
gk_L4_phalanxIntermediate[] init 3
gk_L4_phalanxDistal[] init 3
gk_L4_tip[] init 3

gk_L5_metacarpal[] init 3
gk_L5_phalanxProximal[] init 3
gk_L5_phalanxIntermediate[] init 3
gk_L5_phalanxDistal[] init 3
gk_L5_tip[] init 3

gk_R1_metacarpal[] init 3
gk_R1_phalanxProximal[] init 3
gk_R1_phalanxDistal[] init 3
gk_R1_tip[] init 3

gk_R2_metacarpal[] init 3
gk_R2_phalanxProximal[] init 3
gk_R2_phalanxIntermediate[] init 3
gk_R2_phalanxDistal[] init 3
gk_R2_tip[] init 3

gk_R3_metacarpal[] init 3
gk_R3_phalanxProximal[] init 3
gk_R3_phalanxIntermediate[] init 3
gk_R3_phalanxDistal[] init 3
gk_R3_tip[] init 3

gk_R4_metacarpal[] init 3
gk_R4_phalanxProximal[] init 3
gk_R4_phalanxIntermediate[] init 3
gk_R4_phalanxDistal[] init 3
gk_R4_tip[] init 3

gk_R5_metacarpal[] init 3
gk_R5_phalanxProximal[] init 3
gk_R5_phalanxIntermediate[] init 3
gk_R5_phalanxDistal[] init 3
gk_R5_tip[] init 3


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

    gk_Head_position            = websocket_getArray_k(i_websocketPort, $WebSocketPath_Head_position)
    gk_Head_rotation            = websocket_getArray_k(i_websocketPort, $WebSocketPath_Head_rotation)

    gk_L1_metacarpal            = websocket_getArray_k(i_websocketPort, $WebSocketPath_L1_metacarpal)
    gk_L1_phalanxProximal       = websocket_getArray_k(i_websocketPort, $WebSocketPath_L1_phalanxProximal)
    gk_L1_phalanxDistal         = websocket_getArray_k(i_websocketPort, $WebSocketPath_L1_phalanxDistal)
    gk_L1_tip                   = websocket_getArray_k(i_websocketPort, $WebSocketPath_L1_tip)
    gk_L2_metacarpal            = websocket_getArray_k(i_websocketPort, $WebSocketPath_L2_metacarpal)
    gk_L2_phalanxProximal       = websocket_getArray_k(i_websocketPort, $WebSocketPath_L2_phalanxProximal)
    gk_L2_phalanxIntermediate   = websocket_getArray_k(i_websocketPort, $WebSocketPath_L2_phalanxIntermediate)
    gk_L2_phalanxDistal         = websocket_getArray_k(i_websocketPort, $WebSocketPath_L2_phalanxDistal)
    gk_L2_tip                   = websocket_getArray_k(i_websocketPort, $WebSocketPath_L2_tip)
    gk_L3_metacarpal            = websocket_getArray_k(i_websocketPort, $WebSocketPath_L3_metacarpal)
    gk_L3_phalanxProximal       = websocket_getArray_k(i_websocketPort, $WebSocketPath_L3_phalanxProximal)
    gk_L3_phalanxIntermediate   = websocket_getArray_k(i_websocketPort, $WebSocketPath_L3_phalanxIntermediate)
    gk_L3_phalanxDistal         = websocket_getArray_k(i_websocketPort, $WebSocketPath_L3_phalanxDistal)
    gk_L3_tip                   = websocket_getArray_k(i_websocketPort, $WebSocketPath_L3_tip)
    gk_L4_metacarpal            = websocket_getArray_k(i_websocketPort, $WebSocketPath_L4_metacarpal)
    gk_L4_phalanxProximal       = websocket_getArray_k(i_websocketPort, $WebSocketPath_L4_phalanxProximal)
    gk_L4_phalanxIntermediate   = websocket_getArray_k(i_websocketPort, $WebSocketPath_L4_phalanxIntermediate)
    gk_L4_phalanxDistal         = websocket_getArray_k(i_websocketPort, $WebSocketPath_L4_phalanxDistal)
    gk_L4_tip                   = websocket_getArray_k(i_websocketPort, $WebSocketPath_L4_tip)
    gk_L5_metacarpal            = websocket_getArray_k(i_websocketPort, $WebSocketPath_L5_metacarpal)
    gk_L5_phalanxProximal       = websocket_getArray_k(i_websocketPort, $WebSocketPath_L5_phalanxProximal)
    gk_L5_phalanxIntermediate   = websocket_getArray_k(i_websocketPort, $WebSocketPath_L5_phalanxIntermediate)
    gk_L5_phalanxDistal         = websocket_getArray_k(i_websocketPort, $WebSocketPath_L5_phalanxDistal)
    gk_L5_tip                   = websocket_getArray_k(i_websocketPort, $WebSocketPath_L5_tip)

    gk_R1_metacarpal            = websocket_getArray_k(i_websocketPort, $WebSocketPath_R1_metacarpal)
    gk_R1_phalanxProximal       = websocket_getArray_k(i_websocketPort, $WebSocketPath_R1_phalanxProximal)
    gk_R1_phalanxDistal         = websocket_getArray_k(i_websocketPort, $WebSocketPath_R1_phalanxDistal)
    gk_R1_tip                   = websocket_getArray_k(i_websocketPort, $WebSocketPath_R1_tip)
    gk_R2_metacarpal            = websocket_getArray_k(i_websocketPort, $WebSocketPath_R2_metacarpal)
    gk_R2_phalanxProximal       = websocket_getArray_k(i_websocketPort, $WebSocketPath_R2_phalanxProximal)
    gk_R2_phalanxIntermediate   = websocket_getArray_k(i_websocketPort, $WebSocketPath_R2_phalanxIntermediate)
    gk_R2_phalanxDistal         = websocket_getArray_k(i_websocketPort, $WebSocketPath_R2_phalanxDistal)
    gk_R2_tip                   = websocket_getArray_k(i_websocketPort, $WebSocketPath_R2_tip)
    gk_R3_metacarpal            = websocket_getArray_k(i_websocketPort, $WebSocketPath_R3_metacarpal)
    gk_R3_phalanxProximal       = websocket_getArray_k(i_websocketPort, $WebSocketPath_R3_phalanxProximal)
    gk_R3_phalanxIntermediate   = websocket_getArray_k(i_websocketPort, $WebSocketPath_R3_phalanxIntermediate)
    gk_R3_phalanxDistal         = websocket_getArray_k(i_websocketPort, $WebSocketPath_R3_phalanxDistal)
    gk_R3_tip                   = websocket_getArray_k(i_websocketPort, $WebSocketPath_R3_tip)
    gk_R4_metacarpal            = websocket_getArray_k(i_websocketPort, $WebSocketPath_R4_metacarpal)
    gk_R4_phalanxProximal       = websocket_getArray_k(i_websocketPort, $WebSocketPath_R4_phalanxProximal)
    gk_R4_phalanxIntermediate   = websocket_getArray_k(i_websocketPort, $WebSocketPath_R4_phalanxIntermediate)
    gk_R4_phalanxDistal         = websocket_getArray_k(i_websocketPort, $WebSocketPath_R4_phalanxDistal)
    gk_R4_tip                   = websocket_getArray_k(i_websocketPort, $WebSocketPath_R4_tip)
    gk_R5_metacarpal            = websocket_getArray_k(i_websocketPort, $WebSocketPath_R5_metacarpal)
    gk_R5_phalanxProximal       = websocket_getArray_k(i_websocketPort, $WebSocketPath_R5_phalanxProximal)
    gk_R5_phalanxIntermediate   = websocket_getArray_k(i_websocketPort, $WebSocketPath_R5_phalanxIntermediate)
    gk_R5_phalanxDistal         = websocket_getArray_k(i_websocketPort, $WebSocketPath_R5_phalanxDistal)
    gk_R5_tip                   = websocket_getArray_k(i_websocketPort, $WebSocketPath_R5_tip)

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

    k_isRecording = chnget:k("IS_RECORDING")
    if (k_isRecording == $true) then
        k_L1_metacarpal[]           = DaGLMath_Mat4_multiplyVec3(gk_L1_metacarpal,          gk_initialPose_transform)
        k_L1_phalanxProximal[]      = DaGLMath_Mat4_multiplyVec3(gk_L1_phalanxProximal,     gk_initialPose_transform)
        k_L1_phalanxDistal[]        = DaGLMath_Mat4_multiplyVec3(gk_L1_phalanxDistal,       gk_initialPose_transform)
        k_L1_tip[]                  = DaGLMath_Mat4_multiplyVec3(gk_L1_tip,                 gk_initialPose_transform)

        k_L2_metacarpal[]           = DaGLMath_Mat4_multiplyVec3(gk_L2_metacarpal,          gk_initialPose_transform)
        k_L2_phalanxProximal[]      = DaGLMath_Mat4_multiplyVec3(gk_L2_phalanxProximal,     gk_initialPose_transform)
        k_L2_phalanxIntermediate[]  = DaGLMath_Mat4_multiplyVec3(gk_L2_phalanxIntermediate, gk_initialPose_transform)
        k_L2_phalanxDistal[]        = DaGLMath_Mat4_multiplyVec3(gk_L2_phalanxDistal,       gk_initialPose_transform)
        k_L2_tip[]                  = DaGLMath_Mat4_multiplyVec3(gk_L2_tip,                 gk_initialPose_transform)

        k_L3_metacarpal[]           = DaGLMath_Mat4_multiplyVec3(gk_L3_metacarpal,          gk_initialPose_transform)
        k_L3_phalanxProximal[]      = DaGLMath_Mat4_multiplyVec3(gk_L3_phalanxProximal,     gk_initialPose_transform)
        k_L3_phalanxIntermediate[]  = DaGLMath_Mat4_multiplyVec3(gk_L3_phalanxIntermediate, gk_initialPose_transform)
        k_L3_phalanxDistal[]        = DaGLMath_Mat4_multiplyVec3(gk_L3_phalanxDistal,       gk_initialPose_transform)
        k_L3_tip[]                  = DaGLMath_Mat4_multiplyVec3(gk_L3_tip,                 gk_initialPose_transform)

        k_L4_metacarpal[]           = DaGLMath_Mat4_multiplyVec3(gk_L4_metacarpal,          gk_initialPose_transform)
        k_L4_phalanxProximal[]      = DaGLMath_Mat4_multiplyVec3(gk_L4_phalanxProximal,     gk_initialPose_transform)
        k_L4_phalanxIntermediate[]  = DaGLMath_Mat4_multiplyVec3(gk_L4_phalanxIntermediate, gk_initialPose_transform)
        k_L4_phalanxDistal[]        = DaGLMath_Mat4_multiplyVec3(gk_L4_phalanxDistal,       gk_initialPose_transform)
        k_L4_tip[]                  = DaGLMath_Mat4_multiplyVec3(gk_L4_tip,                 gk_initialPose_transform)

        k_L5_metacarpal[]           = DaGLMath_Mat4_multiplyVec3(gk_L5_metacarpal,          gk_initialPose_transform)
        k_L5_phalanxProximal[]      = DaGLMath_Mat4_multiplyVec3(gk_L5_phalanxProximal,     gk_initialPose_transform)
        k_L5_phalanxIntermediate[]  = DaGLMath_Mat4_multiplyVec3(gk_L5_phalanxIntermediate, gk_initialPose_transform)
        k_L5_phalanxDistal[]        = DaGLMath_Mat4_multiplyVec3(gk_L5_phalanxDistal,       gk_initialPose_transform)
        k_L5_tip[]                  = DaGLMath_Mat4_multiplyVec3(gk_L5_tip,                 gk_initialPose_transform)

        k_R1_metacarpal[]           = DaGLMath_Mat4_multiplyVec3(gk_R1_metacarpal,          gk_initialPose_transform)
        k_R1_phalanxProximal[]      = DaGLMath_Mat4_multiplyVec3(gk_R1_phalanxProximal,     gk_initialPose_transform)
        k_R1_phalanxDistal[]        = DaGLMath_Mat4_multiplyVec3(gk_R1_phalanxDistal,       gk_initialPose_transform)
        k_R1_tip[]                  = DaGLMath_Mat4_multiplyVec3(gk_R1_tip,                 gk_initialPose_transform)

        k_R2_metacarpal[]           = DaGLMath_Mat4_multiplyVec3(gk_R2_metacarpal,          gk_initialPose_transform)
        k_R2_phalanxProximal[]      = DaGLMath_Mat4_multiplyVec3(gk_R2_phalanxProximal,     gk_initialPose_transform)
        k_R2_phalanxIntermediate[]  = DaGLMath_Mat4_multiplyVec3(gk_R2_phalanxIntermediate, gk_initialPose_transform)
        k_R2_phalanxDistal[]        = DaGLMath_Mat4_multiplyVec3(gk_R2_phalanxDistal,       gk_initialPose_transform)
        k_R2_tip[]                  = DaGLMath_Mat4_multiplyVec3(gk_R2_tip,                 gk_initialPose_transform)

        k_R3_metacarpal[]           = DaGLMath_Mat4_multiplyVec3(gk_R3_metacarpal,          gk_initialPose_transform)
        k_R3_phalanxProximal[]      = DaGLMath_Mat4_multiplyVec3(gk_R3_phalanxProximal,     gk_initialPose_transform)
        k_R3_phalanxIntermediate[]  = DaGLMath_Mat4_multiplyVec3(gk_R3_phalanxIntermediate, gk_initialPose_transform)
        k_R3_phalanxDistal[]        = DaGLMath_Mat4_multiplyVec3(gk_R3_phalanxDistal,       gk_initialPose_transform)
        k_R3_tip[]                  = DaGLMath_Mat4_multiplyVec3(gk_R3_tip,                 gk_initialPose_transform)

        k_R4_metacarpal[]           = DaGLMath_Mat4_multiplyVec3(gk_R4_metacarpal,          gk_initialPose_transform)
        k_R4_phalanxProximal[]      = DaGLMath_Mat4_multiplyVec3(gk_R4_phalanxProximal,     gk_initialPose_transform)
        k_R4_phalanxIntermediate[]  = DaGLMath_Mat4_multiplyVec3(gk_R4_phalanxIntermediate, gk_initialPose_transform)
        k_R4_phalanxDistal[]        = DaGLMath_Mat4_multiplyVec3(gk_R4_phalanxDistal,       gk_initialPose_transform)
        k_R4_tip[]                  = DaGLMath_Mat4_multiplyVec3(gk_R4_tip,                 gk_initialPose_transform)

        k_R5_metacarpal[]           = DaGLMath_Mat4_multiplyVec3(gk_R5_metacarpal,          gk_initialPose_transform)
        k_R5_phalanxProximal[]      = DaGLMath_Mat4_multiplyVec3(gk_R5_phalanxProximal,     gk_initialPose_transform)
        k_R5_phalanxIntermediate[]  = DaGLMath_Mat4_multiplyVec3(gk_R5_phalanxIntermediate, gk_initialPose_transform)
        k_R5_phalanxDistal[]        = DaGLMath_Mat4_multiplyVec3(gk_R5_phalanxDistal,       gk_initialPose_transform)
        k_R5_tip[]                  = DaGLMath_Mat4_multiplyVec3(gk_R5_tip,                 gk_initialPose_transform)

        kL[] init 80
        kR[] init 80

        kL[ 0] = 1
        kL[ 1] = k_L1_metacarpal[$x]
        kL[ 2] = k_L1_metacarpal[$y]
        kL[ 3] = k_L1_metacarpal[$z]
        kL[ 4] = k_L1_phalanxProximal[$x]
        kL[ 5] = k_L1_phalanxProximal[$y]
        kL[ 6] = k_L1_phalanxProximal[$z]
        kL[ 7] = k_L1_phalanxDistal[$x]
        kL[ 8] = k_L1_phalanxDistal[$y]
        kL[ 9] = k_L1_phalanxDistal[$z]
        kL[10] = k_L1_tip[$x]
        kL[11] = k_L1_tip[$y]
        kL[12] = k_L1_tip[$z]
        kL[13] = k_L2_metacarpal[$x]
        kL[14] = k_L2_metacarpal[$y]
        kL[15] = k_L2_metacarpal[$z]
        kL[16] = k_L2_phalanxProximal[$x]
        kL[17] = k_L2_phalanxProximal[$y]
        kL[18] = k_L2_phalanxProximal[$z]
        kL[19] = k_L2_phalanxIntermediate[$x]
        kL[20] = k_L2_phalanxIntermediate[$y]
        kL[21] = k_L2_phalanxIntermediate[$z]
        kL[22] = k_L2_phalanxDistal[$x]
        kL[23] = k_L2_phalanxDistal[$y]
        kL[24] = k_L2_phalanxDistal[$z]
        kL[25] = k_L2_tip[$x]
        kL[26] = k_L2_tip[$y]
        kL[27] = k_L2_tip[$z]
        kL[28] = k_L3_metacarpal[$x]
        kL[29] = k_L3_metacarpal[$y]
        kL[30] = k_L3_metacarpal[$z]
        kL[31] = k_L3_phalanxProximal[$x]
        kL[32] = k_L3_phalanxProximal[$y]
        kL[33] = k_L3_phalanxProximal[$z]
        kL[34] = k_L3_phalanxIntermediate[$x]
        kL[35] = k_L3_phalanxIntermediate[$y]
        kL[36] = k_L3_phalanxIntermediate[$z]
        kL[37] = k_L3_phalanxDistal[$x]
        kL[38] = k_L3_phalanxDistal[$y]
        kL[39] = k_L3_phalanxDistal[$z]
        kL[40] = k_L3_tip[$x]
        kL[41] = k_L3_tip[$y]
        kL[42] = k_L3_tip[$z]
        kL[43] = k_L4_metacarpal[$x]
        kL[44] = k_L4_metacarpal[$y]
        kL[45] = k_L4_metacarpal[$z]
        kL[46] = k_L4_phalanxProximal[$x]
        kL[47] = k_L4_phalanxProximal[$y]
        kL[48] = k_L4_phalanxProximal[$z]
        kL[49] = k_L4_phalanxIntermediate[$x]
        kL[50] = k_L4_phalanxIntermediate[$y]
        kL[51] = k_L4_phalanxIntermediate[$z]
        kL[52] = k_L4_phalanxDistal[$x]
        kL[53] = k_L4_phalanxDistal[$y]
        kL[54] = k_L4_phalanxDistal[$z]
        kL[55] = k_L4_tip[$x]
        kL[56] = k_L4_tip[$y]
        kL[57] = k_L4_tip[$z]
        kL[58] = k_L5_metacarpal[$x]
        kL[59] = k_L5_metacarpal[$y]
        kL[60] = k_L5_metacarpal[$z]
        kL[61] = k_L5_phalanxProximal[$x]
        kL[62] = k_L5_phalanxProximal[$y]
        kL[63] = k_L5_phalanxProximal[$z]
        kL[64] = k_L5_phalanxIntermediate[$x]
        kL[65] = k_L5_phalanxIntermediate[$y]
        kL[66] = k_L5_phalanxIntermediate[$z]
        kL[67] = k_L5_phalanxDistal[$x]
        kL[68] = k_L5_phalanxDistal[$y]
        kL[69] = k_L5_phalanxDistal[$z]
        kL[70] = k_L5_tip[$x]
        kL[71] = k_L5_tip[$y]
        kL[72] = k_L5_tip[$z]
        kL[73] = 0
        kL[74] = 0
        kL[75] = 0
        kL[76] = 0
        kL[77] = 0
        kL[78] = 0
        kL[79] = -1

        kR[ 0] = 1
        kR[ 1] = k_R1_metacarpal[$x]
        kR[ 2] = k_R1_metacarpal[$y]
        kR[ 3] = k_R1_metacarpal[$z]
        kR[ 4] = k_R1_phalanxProximal[$x]
        kR[ 5] = k_R1_phalanxProximal[$y]
        kR[ 6] = k_R1_phalanxProximal[$z]
        kR[ 7] = k_R1_phalanxDistal[$x]
        kR[ 8] = k_R1_phalanxDistal[$y]
        kR[ 9] = k_R1_phalanxDistal[$z]
        kR[10] = k_R1_tip[$x]
        kR[11] = k_R1_tip[$y]
        kR[12] = k_R1_tip[$z]
        kR[13] = k_R2_metacarpal[$x]
        kR[14] = k_R2_metacarpal[$y]
        kR[15] = k_R2_metacarpal[$z]
        kR[16] = k_R2_phalanxProximal[$x]
        kR[17] = k_R2_phalanxProximal[$y]
        kR[18] = k_R2_phalanxProximal[$z]
        kR[19] = k_R2_phalanxIntermediate[$x]
        kR[20] = k_R2_phalanxIntermediate[$y]
        kR[21] = k_R2_phalanxIntermediate[$z]
        kR[22] = k_R2_phalanxDistal[$x]
        kR[23] = k_R2_phalanxDistal[$y]
        kR[24] = k_R2_phalanxDistal[$z]
        kR[25] = k_R2_tip[$x]
        kR[26] = k_R2_tip[$y]
        kR[27] = k_R2_tip[$z]
        kR[28] = k_R3_metacarpal[$x]
        kR[29] = k_R3_metacarpal[$y]
        kR[30] = k_R3_metacarpal[$z]
        kR[31] = k_R3_phalanxProximal[$x]
        kR[32] = k_R3_phalanxProximal[$y]
        kR[33] = k_R3_phalanxProximal[$z]
        kR[34] = k_R3_phalanxIntermediate[$x]
        kR[35] = k_R3_phalanxIntermediate[$y]
        kR[36] = k_R3_phalanxIntermediate[$z]
        kR[37] = k_R3_phalanxDistal[$x]
        kR[38] = k_R3_phalanxDistal[$y]
        kR[39] = k_R3_phalanxDistal[$z]
        kR[40] = k_R3_tip[$x]
        kR[41] = k_R3_tip[$y]
        kR[42] = k_R3_tip[$z]
        kR[43] = k_R4_metacarpal[$x]
        kR[44] = k_R4_metacarpal[$y]
        kR[45] = k_R4_metacarpal[$z]
        kR[46] = k_R4_phalanxProximal[$x]
        kR[47] = k_R4_phalanxProximal[$y]
        kR[48] = k_R4_phalanxProximal[$z]
        kR[49] = k_R4_phalanxIntermediate[$x]
        kR[50] = k_R4_phalanxIntermediate[$y]
        kR[51] = k_R4_phalanxIntermediate[$z]
        kR[52] = k_R4_phalanxDistal[$x]
        kR[53] = k_R4_phalanxDistal[$y]
        kR[54] = k_R4_phalanxDistal[$z]
        kR[55] = k_R4_tip[$x]
        kR[56] = k_R4_tip[$y]
        kR[57] = k_R4_tip[$z]
        kR[58] = k_R5_metacarpal[$x]
        kR[59] = k_R5_metacarpal[$y]
        kR[60] = k_R5_metacarpal[$z]
        kR[61] = k_R5_phalanxProximal[$x]
        kR[62] = k_R5_phalanxProximal[$y]
        kR[63] = k_R5_phalanxProximal[$z]
        kR[64] = k_R5_phalanxIntermediate[$x]
        kR[65] = k_R5_phalanxIntermediate[$y]
        kR[66] = k_R5_phalanxIntermediate[$z]
        kR[67] = k_R5_phalanxDistal[$x]
        kR[68] = k_R5_phalanxDistal[$y]
        kR[69] = k_R5_phalanxDistal[$z]
        kR[70] = k_R5_tip[$x]
        kR[71] = k_R5_tip[$y]
        kR[72] = k_R5_tip[$z]
        kR[73] = 0
        kR[74] = 0
        kR[75] = 0
        kR[76] = 0
        kR[77] = 0
        kR[78] = 0
        kR[79] = -1

        ki init 0
        if (ki == 80) then
            ki = 0
        endif

        outch(1, a(kL[ki]))
        outch(2, a(kR[ki]))

        ki += 1
    else
        outch(1, inch(1))
        outch(2, inch(2))
    endif

    ; if (metro($metro_OneTickEverySecond) == $true) then
    ;     if (changed2(k_L1_tip) == $true || changed2(k_R1_tip) == $true) then
    ;         {{LogDebug_k '("L1 tip = [%.3f, %.3f, %.3f], R1 tip = [%.3f, %.3f, %.3f]", k_L1_tip[0], k_L1_tip[1], k_L1_tip[2], k_R1_tip[0], k_R1_tip[1], k_R1_tip[2])'}}
    ;     endif
    ; endif

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
