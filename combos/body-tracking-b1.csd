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

/// region Macros

#define I_Init              #2#
#define I_SetInitialPose    #3#
#define I_SendPoseOffsets   #4#
#define I_PassThrough       #5#
#define I_AlwaysOn          #6#

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

#define metro_OneTickEverySecond        #1.0#
#define metro_OneTickEveryFiveSeconds   #0.2#
#define metro_OneTickEveryTenSeconds    #0.1#
#define metro_SkipFirstTick             #0.00000001#

#define x #0#
#define y #1#
#define z #2#

/// endregion
/// region Global variables

gk_websocketPort init 12345

gk_initialHead_position[] init 3
gk_initialHead_rotation[] init 3
gk_initialL1_tip[] init 3
gk_initialR1_tip[] init 3
gk_initialPose_transform[] init 16

gk_Head_position[] init 3
gk_Head_rotation[] init 3

gS_websocketPaths_L[] init 80
gS_websocketPaths_R[] init 80

gS_websocketPaths_L[ 1] = $WebSocketPath_L1_metacarpal // x
gS_websocketPaths_L[ 2] = $WebSocketPath_L1_metacarpal // y
gS_websocketPaths_L[ 3] = $WebSocketPath_L1_metacarpal // z
gS_websocketPaths_L[ 4] = $WebSocketPath_L1_phalanxProximal // x
gS_websocketPaths_L[ 5] = $WebSocketPath_L1_phalanxProximal // y
gS_websocketPaths_L[ 6] = $WebSocketPath_L1_phalanxProximal // z
gS_websocketPaths_L[ 7] = $WebSocketPath_L1_phalanxDistal // x
gS_websocketPaths_L[ 8] = $WebSocketPath_L1_phalanxDistal // y
gS_websocketPaths_L[ 9] = $WebSocketPath_L1_phalanxDistal // z
gS_websocketPaths_L[10] = $WebSocketPath_L1_tip // x
gS_websocketPaths_L[11] = $WebSocketPath_L1_tip // y
gS_websocketPaths_L[12] = $WebSocketPath_L1_tip // z
gS_websocketPaths_L[13] = $WebSocketPath_L2_metacarpal // x
gS_websocketPaths_L[14] = $WebSocketPath_L2_metacarpal // y
gS_websocketPaths_L[15] = $WebSocketPath_L2_metacarpal // z
gS_websocketPaths_L[16] = $WebSocketPath_L2_phalanxProximal // x
gS_websocketPaths_L[17] = $WebSocketPath_L2_phalanxProximal // y
gS_websocketPaths_L[18] = $WebSocketPath_L2_phalanxProximal // z
gS_websocketPaths_L[19] = $WebSocketPath_L2_phalanxIntermediate // x
gS_websocketPaths_L[20] = $WebSocketPath_L2_phalanxIntermediate // y
gS_websocketPaths_L[21] = $WebSocketPath_L2_phalanxIntermediate // z
gS_websocketPaths_L[22] = $WebSocketPath_L2_phalanxDistal // x
gS_websocketPaths_L[23] = $WebSocketPath_L2_phalanxDistal // y
gS_websocketPaths_L[24] = $WebSocketPath_L2_phalanxDistal // z
gS_websocketPaths_L[25] = $WebSocketPath_L2_tip // x
gS_websocketPaths_L[26] = $WebSocketPath_L2_tip // y
gS_websocketPaths_L[27] = $WebSocketPath_L2_tip // z
gS_websocketPaths_L[28] = $WebSocketPath_L3_metacarpal // x
gS_websocketPaths_L[29] = $WebSocketPath_L3_metacarpal // y
gS_websocketPaths_L[30] = $WebSocketPath_L3_metacarpal // z
gS_websocketPaths_L[31] = $WebSocketPath_L3_phalanxProximal // x
gS_websocketPaths_L[32] = $WebSocketPath_L3_phalanxProximal // y
gS_websocketPaths_L[33] = $WebSocketPath_L3_phalanxProximal // z
gS_websocketPaths_L[34] = $WebSocketPath_L3_phalanxIntermediate // x
gS_websocketPaths_L[35] = $WebSocketPath_L3_phalanxIntermediate // y
gS_websocketPaths_L[36] = $WebSocketPath_L3_phalanxIntermediate // z
gS_websocketPaths_L[37] = $WebSocketPath_L3_phalanxDistal // x
gS_websocketPaths_L[38] = $WebSocketPath_L3_phalanxDistal // y
gS_websocketPaths_L[39] = $WebSocketPath_L3_phalanxDistal // z
gS_websocketPaths_L[40] = $WebSocketPath_L3_tip // x
gS_websocketPaths_L[41] = $WebSocketPath_L3_tip // y
gS_websocketPaths_L[42] = $WebSocketPath_L3_tip // z
gS_websocketPaths_L[43] = $WebSocketPath_L4_metacarpal // x
gS_websocketPaths_L[44] = $WebSocketPath_L4_metacarpal // y
gS_websocketPaths_L[45] = $WebSocketPath_L4_metacarpal // z
gS_websocketPaths_L[46] = $WebSocketPath_L4_phalanxProximal // x
gS_websocketPaths_L[47] = $WebSocketPath_L4_phalanxProximal // y
gS_websocketPaths_L[48] = $WebSocketPath_L4_phalanxProximal // z
gS_websocketPaths_L[49] = $WebSocketPath_L4_phalanxIntermediate // x
gS_websocketPaths_L[50] = $WebSocketPath_L4_phalanxIntermediate // y
gS_websocketPaths_L[51] = $WebSocketPath_L4_phalanxIntermediate // z
gS_websocketPaths_L[52] = $WebSocketPath_L4_phalanxDistal // x
gS_websocketPaths_L[53] = $WebSocketPath_L4_phalanxDistal // y
gS_websocketPaths_L[54] = $WebSocketPath_L4_phalanxDistal // z
gS_websocketPaths_L[55] = $WebSocketPath_L4_tip // x
gS_websocketPaths_L[56] = $WebSocketPath_L4_tip // y
gS_websocketPaths_L[57] = $WebSocketPath_L4_tip // z
gS_websocketPaths_L[58] = $WebSocketPath_L5_metacarpal // x
gS_websocketPaths_L[59] = $WebSocketPath_L5_metacarpal // y
gS_websocketPaths_L[60] = $WebSocketPath_L5_metacarpal // z
gS_websocketPaths_L[61] = $WebSocketPath_L5_phalanxProximal // x
gS_websocketPaths_L[62] = $WebSocketPath_L5_phalanxProximal // y
gS_websocketPaths_L[63] = $WebSocketPath_L5_phalanxProximal // z
gS_websocketPaths_L[64] = $WebSocketPath_L5_phalanxIntermediate // x
gS_websocketPaths_L[65] = $WebSocketPath_L5_phalanxIntermediate // y
gS_websocketPaths_L[66] = $WebSocketPath_L5_phalanxIntermediate // z
gS_websocketPaths_L[67] = $WebSocketPath_L5_phalanxDistal // x
gS_websocketPaths_L[68] = $WebSocketPath_L5_phalanxDistal // y
gS_websocketPaths_L[69] = $WebSocketPath_L5_phalanxDistal // z
gS_websocketPaths_L[70] = $WebSocketPath_L5_tip // x
gS_websocketPaths_L[71] = $WebSocketPath_L5_tip // y
gS_websocketPaths_L[72] = $WebSocketPath_L5_tip // z
gS_websocketPaths_L[73] = $WebSocketPath_Head_position // x
gS_websocketPaths_L[74] = $WebSocketPath_Head_position // y
gS_websocketPaths_L[75] = $WebSocketPath_Head_position // z

gS_websocketPaths_R[ 1] = $WebSocketPath_R1_metacarpal // x
gS_websocketPaths_R[ 2] = $WebSocketPath_R1_metacarpal // y
gS_websocketPaths_R[ 3] = $WebSocketPath_R1_metacarpal // z
gS_websocketPaths_R[ 4] = $WebSocketPath_R1_phalanxProximal // x
gS_websocketPaths_R[ 5] = $WebSocketPath_R1_phalanxProximal // y
gS_websocketPaths_R[ 6] = $WebSocketPath_R1_phalanxProximal // z
gS_websocketPaths_R[ 7] = $WebSocketPath_R1_phalanxDistal // x
gS_websocketPaths_R[ 8] = $WebSocketPath_R1_phalanxDistal // y
gS_websocketPaths_R[ 9] = $WebSocketPath_R1_phalanxDistal // z
gS_websocketPaths_R[10] = $WebSocketPath_R1_tip // x
gS_websocketPaths_R[11] = $WebSocketPath_R1_tip // y
gS_websocketPaths_R[12] = $WebSocketPath_R1_tip // z
gS_websocketPaths_R[13] = $WebSocketPath_R2_metacarpal // x
gS_websocketPaths_R[14] = $WebSocketPath_R2_metacarpal // y
gS_websocketPaths_R[15] = $WebSocketPath_R2_metacarpal // z
gS_websocketPaths_R[16] = $WebSocketPath_R2_phalanxProximal // x
gS_websocketPaths_R[17] = $WebSocketPath_R2_phalanxProximal // y
gS_websocketPaths_R[18] = $WebSocketPath_R2_phalanxProximal // z
gS_websocketPaths_R[19] = $WebSocketPath_R2_phalanxIntermediate // x
gS_websocketPaths_R[20] = $WebSocketPath_R2_phalanxIntermediate // y
gS_websocketPaths_R[21] = $WebSocketPath_R2_phalanxIntermediate // z
gS_websocketPaths_R[22] = $WebSocketPath_R2_phalanxDistal // x
gS_websocketPaths_R[23] = $WebSocketPath_R2_phalanxDistal // y
gS_websocketPaths_R[24] = $WebSocketPath_R2_phalanxDistal // z
gS_websocketPaths_R[25] = $WebSocketPath_R2_tip // x
gS_websocketPaths_R[26] = $WebSocketPath_R2_tip // y
gS_websocketPaths_R[27] = $WebSocketPath_R2_tip // z
gS_websocketPaths_R[28] = $WebSocketPath_R3_metacarpal // x
gS_websocketPaths_R[29] = $WebSocketPath_R3_metacarpal // y
gS_websocketPaths_R[30] = $WebSocketPath_R3_metacarpal // z
gS_websocketPaths_R[31] = $WebSocketPath_R3_phalanxProximal // x
gS_websocketPaths_R[32] = $WebSocketPath_R3_phalanxProximal // y
gS_websocketPaths_R[33] = $WebSocketPath_R3_phalanxProximal // z
gS_websocketPaths_R[34] = $WebSocketPath_R3_phalanxIntermediate // x
gS_websocketPaths_R[35] = $WebSocketPath_R3_phalanxIntermediate // y
gS_websocketPaths_R[36] = $WebSocketPath_R3_phalanxIntermediate // z
gS_websocketPaths_R[37] = $WebSocketPath_R3_phalanxDistal // x
gS_websocketPaths_R[38] = $WebSocketPath_R3_phalanxDistal // y
gS_websocketPaths_R[39] = $WebSocketPath_R3_phalanxDistal // z
gS_websocketPaths_R[40] = $WebSocketPath_R3_tip // x
gS_websocketPaths_R[41] = $WebSocketPath_R3_tip // y
gS_websocketPaths_R[42] = $WebSocketPath_R3_tip // z
gS_websocketPaths_R[43] = $WebSocketPath_R4_metacarpal // x
gS_websocketPaths_R[44] = $WebSocketPath_R4_metacarpal // y
gS_websocketPaths_R[45] = $WebSocketPath_R4_metacarpal // z
gS_websocketPaths_R[46] = $WebSocketPath_R4_phalanxProximal // x
gS_websocketPaths_R[47] = $WebSocketPath_R4_phalanxProximal // y
gS_websocketPaths_R[48] = $WebSocketPath_R4_phalanxProximal // z
gS_websocketPaths_R[49] = $WebSocketPath_R4_phalanxIntermediate // x
gS_websocketPaths_R[50] = $WebSocketPath_R4_phalanxIntermediate // y
gS_websocketPaths_R[51] = $WebSocketPath_R4_phalanxIntermediate // z
gS_websocketPaths_R[52] = $WebSocketPath_R4_phalanxDistal // x
gS_websocketPaths_R[53] = $WebSocketPath_R4_phalanxDistal // y
gS_websocketPaths_R[54] = $WebSocketPath_R4_phalanxDistal // z
gS_websocketPaths_R[55] = $WebSocketPath_R4_tip // x
gS_websocketPaths_R[56] = $WebSocketPath_R4_tip // y
gS_websocketPaths_R[57] = $WebSocketPath_R4_tip // z
gS_websocketPaths_R[58] = $WebSocketPath_R5_metacarpal // x
gS_websocketPaths_R[59] = $WebSocketPath_R5_metacarpal // y
gS_websocketPaths_R[60] = $WebSocketPath_R5_metacarpal // z
gS_websocketPaths_R[61] = $WebSocketPath_R5_phalanxProximal // x
gS_websocketPaths_R[62] = $WebSocketPath_R5_phalanxProximal // y
gS_websocketPaths_R[63] = $WebSocketPath_R5_phalanxProximal // z
gS_websocketPaths_R[64] = $WebSocketPath_R5_phalanxIntermediate // x
gS_websocketPaths_R[65] = $WebSocketPath_R5_phalanxIntermediate // y
gS_websocketPaths_R[66] = $WebSocketPath_R5_phalanxIntermediate // z
gS_websocketPaths_R[67] = $WebSocketPath_R5_phalanxDistal // x
gS_websocketPaths_R[68] = $WebSocketPath_R5_phalanxDistal // y
gS_websocketPaths_R[69] = $WebSocketPath_R5_phalanxDistal // z
gS_websocketPaths_R[70] = $WebSocketPath_R5_tip // x
gS_websocketPaths_R[71] = $WebSocketPath_R5_tip // y
gS_websocketPaths_R[72] = $WebSocketPath_R5_tip // z
gS_websocketPaths_R[73] = $WebSocketPath_Head_rotation // x
gS_websocketPaths_R[74] = $WebSocketPath_Head_rotation // y
gS_websocketPaths_R[75] = $WebSocketPath_Head_rotation // z

/// endregion
/// region UDOs

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


/// endregion
/// region Instruments


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


instr $I_SetInitialPose
    i_websocketPort = i(gk_websocketPort)

    k_L1_tip[] init 3
    k_L2_tip[] init 3
    k_R1_tip[] init 3
    k_R2_tip[] init 3

    k_L1_tip = websocket_getArray_k(i_websocketPort, $WebSocketPath_L1_tip)
    k_L2_tip = websocket_getArray_k(i_websocketPort, $WebSocketPath_L2_tip)
    k_R1_tip = websocket_getArray_k(i_websocketPort, $WebSocketPath_R1_tip)
    k_R2_tip = websocket_getArray_k(i_websocketPort, $WebSocketPath_R2_tip)

    k_L1to2[] = k_L2_tip - k_L1_tip
    k_R1to2[] = k_R2_tip - k_R1_tip
    k_pinchDistanceL = sqrt(k_L1to2[0] * k_L1to2[0]) + sqrt(k_L1to2[1] * k_L1to2[1]) + sqrt(k_L1to2[2] * k_L1to2[2])
    k_pinchDistanceR = sqrt(k_R1to2[0] * k_R1to2[0]) + sqrt(k_R1to2[1] * k_R1to2[1]) + sqrt(k_R1to2[2] * k_R1to2[2])

    k_tick init 1
    if (metro($metro_OneTickEverySecond) == $true) then
        {{LogDebug_k '("SetInitialPose[%d]: L1 tip = [%.3f, %.3f, %.3f], L2 tip = [%.3f, %.3f, %.3f], R1 tip = [%.3f, %.3f, %.3f], R2 tip = [%.3f, %.3f, %.3f]", k_tick, k_L1_tip[0], k_L1_tip[1], k_L1_tip[2], k_L2_tip[0], k_L2_tip[1], k_L2_tip[2], k_R1_tip[0], k_R1_tip[1], k_R1_tip[2], k_R2_tip[0], k_R2_tip[1], k_R2_tip[2])'}}
        {{LogDebug_k '("SetInitialPose[%d]: Left pinch distance = %.3f, Right pinch distance = %.3f", k_tick, k_pinchDistanceL, k_pinchDistanceR)'}}
        k_tick += 1
    endif

    if (k_pinchDistanceL < $PinchDistanceThreshold && k_pinchDistanceR < $PinchDistanceThreshold) then
        cabbageSetValue($Channel_SetInitialPoseButton, k($false))
    endif

    k_setInitialPose = cabbageGetValue:k($Channel_SetInitialPoseButton)
    if (k_setInitialPose == $false) then
        k_headPosition[] init 3
        k_headRotation[] init 3

        k_headPosition = websocket_getArray_k(i_websocketPort, $WebSocketPath_Head_position)
        k_headRotation = websocket_getArray_k(i_websocketPort, $WebSocketPath_Head_rotation)

        gk_initialHead_position = k_headPosition
        gk_initialHead_rotation = k_headRotation

        gk_initialL1_tip = k_L1_tip
        gk_initialR1_tip = k_R1_tip

        updateInitialPoseTransform()
        setInitialPoseChannelValues()
        printInitialPoseValues()

        turnoff()
    endif
endin


instr $I_SendPoseOffsets
    i_websocketPort = i(gk_websocketPort)

    ki init 0
    kj init -1

    if (ki == 80) then
        ki = 0
        kj = -1
    endif

    if (ki == 0) then
        outall(a(1))

    elseif (ki == 79) then
        outall(a(-1))

    elseif (ki <= 75) then
        k_coord = kj % 3

        k_rawCoords_L[] init 3
        k_rawCoords_R[] init 3
        k_xformedCoords_L[] init 3
        k_xformedCoords_R[] init 3

        if (k_coord == 0) then
            k_rawCoords_L = websocket_getArray_k(i_websocketPort, gS_websocketPaths_L[ki])
            k_rawCoords_R = websocket_getArray_k(i_websocketPort, gS_websocketPaths_R[ki])

            k_xformedCoords_L = DaGLMath_Mat4_multiplyVec3(k_rawCoords_L, gk_initialPose_transform)
            k_xformedCoords_R = DaGLMath_Mat4_multiplyVec3(k_rawCoords_R, gk_initialPose_transform)
        endif

        outs(a(limit(k_xformedCoords_L[k_coord], -0.999, 0.999)), a(limit(k_xformedCoords_R[k_coord], -0.999, 0.999)))

    else
        outall(a(0))

    endif

    ki += 1
    kj += 1

    k_setInitialPose = cabbageGetValue:k($Channel_SetInitialPoseButton)
    if (k_setInitialPose == $true) then
        turnoff()
    endif

    k_isRecording = chnget:k("IS_RECORDING")
    if (k_isRecording == $false) then
        turnoff()
    endif
endin


instr $I_PassThrough
    outs(inch(1), inch(2))

    k_isRecording = chnget:k("IS_RECORDING")
    if (k_isRecording == $true) then
        turnoff()
    endif
endin


instr $I_AlwaysOn
    k_iteration init 0

    k_setInitialPose = cabbageGetValue:k($Channel_SetInitialPoseButton)
    k_isRecording = chnget:k("IS_RECORDING")
    if (changed2(k_setInitialPose) == $true || changed2(k_isRecording) == $true || k_iteration == 0) then
        {{LogDebug_k '("k_setInitialPose = %d", k_setInitialPose)'}}
        {{LogDebug_k '("k_isRecording    = %d", k_isRecording)'}}


        if (k_setInitialPose == $true) then
            event("i", $I_SetInitialPose, 0, -1)
        else
            if (k_isRecording == $true) then
                event("i", $I_SendPoseOffsets, 0, -1)
            else
                event("i", $I_PassThrough, 0, -1)
            endif
        endif
    endif

    k_iteration += 1
endin


/// endregion


// Start at 1 second to give the host time to set it's values.
scoreline_i("i$I_Init 1 -1")
scoreline_i("i$I_AlwaysOn 1 -1")

</CsInstruments>
<CsScore>

{{CsScore}}

</CsScore>
</CsoundSynthesizer>

{{Cabbage}}
