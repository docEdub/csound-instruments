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

gS_websocketPaths_L[] init $BodyTracking_arrayLength
gS_websocketPaths_R[] init $BodyTracking_arrayLength

gS_websocketPaths_L[$IndexOf_Wrist_x                ] = $WebSocketPath_LWrist
gS_websocketPaths_L[$IndexOf_Wrist_y                ] = $WebSocketPath_LWrist
gS_websocketPaths_L[$IndexOf_Wrist_z                ] = $WebSocketPath_LWrist
gS_websocketPaths_L[$IndexOf_1_metacarpal_x         ] = $WebSocketPath_L1_metacarpal
gS_websocketPaths_L[$IndexOf_1_metacarpal_y         ] = $WebSocketPath_L1_metacarpal
gS_websocketPaths_L[$IndexOf_1_metacarpal_z         ] = $WebSocketPath_L1_metacarpal
gS_websocketPaths_L[$IndexOf_1_phalanxProximal_x    ] = $WebSocketPath_L1_phalanxProximal
gS_websocketPaths_L[$IndexOf_1_phalanxProximal_y    ] = $WebSocketPath_L1_phalanxProximal
gS_websocketPaths_L[$IndexOf_1_phalanxProximal_z    ] = $WebSocketPath_L1_phalanxProximal
gS_websocketPaths_L[$IndexOf_1_phalanxDistal_x      ] = $WebSocketPath_L1_phalanxDistal
gS_websocketPaths_L[$IndexOf_1_phalanxDistal_y      ] = $WebSocketPath_L1_phalanxDistal
gS_websocketPaths_L[$IndexOf_1_phalanxDistal_z      ] = $WebSocketPath_L1_phalanxDistal
gS_websocketPaths_L[$IndexOf_1_tip_x                ] = $WebSocketPath_L1_tip
gS_websocketPaths_L[$IndexOf_1_tip_y                ] = $WebSocketPath_L1_tip
gS_websocketPaths_L[$IndexOf_1_tip_z                ] = $WebSocketPath_L1_tip
gS_websocketPaths_L[$IndexOf_2_metacarpal_x         ] = $WebSocketPath_L2_metacarpal
gS_websocketPaths_L[$IndexOf_2_metacarpal_y         ] = $WebSocketPath_L2_metacarpal
gS_websocketPaths_L[$IndexOf_2_metacarpal_z         ] = $WebSocketPath_L2_metacarpal
gS_websocketPaths_L[$IndexOf_2_phalanxProximal_x    ] = $WebSocketPath_L2_phalanxProximal
gS_websocketPaths_L[$IndexOf_2_phalanxProximal_y    ] = $WebSocketPath_L2_phalanxProximal
gS_websocketPaths_L[$IndexOf_2_phalanxProximal_z    ] = $WebSocketPath_L2_phalanxProximal
gS_websocketPaths_L[$IndexOf_2_phalanxIntermediate_x] = $WebSocketPath_L2_phalanxIntermediate
gS_websocketPaths_L[$IndexOf_2_phalanxIntermediate_y] = $WebSocketPath_L2_phalanxIntermediate
gS_websocketPaths_L[$IndexOf_2_phalanxIntermediate_z] = $WebSocketPath_L2_phalanxIntermediate
gS_websocketPaths_L[$IndexOf_2_phalanxDistal_x      ] = $WebSocketPath_L2_phalanxDistal
gS_websocketPaths_L[$IndexOf_2_phalanxDistal_y      ] = $WebSocketPath_L2_phalanxDistal
gS_websocketPaths_L[$IndexOf_2_phalanxDistal_z      ] = $WebSocketPath_L2_phalanxDistal
gS_websocketPaths_L[$IndexOf_2_tip_x                ] = $WebSocketPath_L2_tip
gS_websocketPaths_L[$IndexOf_2_tip_y                ] = $WebSocketPath_L2_tip
gS_websocketPaths_L[$IndexOf_2_tip_z                ] = $WebSocketPath_L2_tip
gS_websocketPaths_L[$IndexOf_3_metacarpal_x         ] = $WebSocketPath_L3_metacarpal
gS_websocketPaths_L[$IndexOf_3_metacarpal_y         ] = $WebSocketPath_L3_metacarpal
gS_websocketPaths_L[$IndexOf_3_metacarpal_z         ] = $WebSocketPath_L3_metacarpal
gS_websocketPaths_L[$IndexOf_3_phalanxProximal_x    ] = $WebSocketPath_L3_phalanxProximal
gS_websocketPaths_L[$IndexOf_3_phalanxProximal_y    ] = $WebSocketPath_L3_phalanxProximal
gS_websocketPaths_L[$IndexOf_3_phalanxProximal_z    ] = $WebSocketPath_L3_phalanxProximal
gS_websocketPaths_L[$IndexOf_3_phalanxIntermediate_x] = $WebSocketPath_L3_phalanxIntermediate
gS_websocketPaths_L[$IndexOf_3_phalanxIntermediate_y] = $WebSocketPath_L3_phalanxIntermediate
gS_websocketPaths_L[$IndexOf_3_phalanxIntermediate_z] = $WebSocketPath_L3_phalanxIntermediate
gS_websocketPaths_L[$IndexOf_3_phalanxDistal_x      ] = $WebSocketPath_L3_phalanxDistal
gS_websocketPaths_L[$IndexOf_3_phalanxDistal_y      ] = $WebSocketPath_L3_phalanxDistal
gS_websocketPaths_L[$IndexOf_3_phalanxDistal_z      ] = $WebSocketPath_L3_phalanxDistal
gS_websocketPaths_L[$IndexOf_3_tip_x                ] = $WebSocketPath_L3_tip
gS_websocketPaths_L[$IndexOf_3_tip_y                ] = $WebSocketPath_L3_tip
gS_websocketPaths_L[$IndexOf_3_tip_z                ] = $WebSocketPath_L3_tip
gS_websocketPaths_L[$IndexOf_4_metacarpal_x         ] = $WebSocketPath_L4_metacarpal
gS_websocketPaths_L[$IndexOf_4_metacarpal_y         ] = $WebSocketPath_L4_metacarpal
gS_websocketPaths_L[$IndexOf_4_metacarpal_z         ] = $WebSocketPath_L4_metacarpal
gS_websocketPaths_L[$IndexOf_4_phalanxProximal_x    ] = $WebSocketPath_L4_phalanxProximal
gS_websocketPaths_L[$IndexOf_4_phalanxProximal_y    ] = $WebSocketPath_L4_phalanxProximal
gS_websocketPaths_L[$IndexOf_4_phalanxProximal_z    ] = $WebSocketPath_L4_phalanxProximal
gS_websocketPaths_L[$IndexOf_4_phalanxIntermediate_x] = $WebSocketPath_L4_phalanxIntermediate
gS_websocketPaths_L[$IndexOf_4_phalanxIntermediate_y] = $WebSocketPath_L4_phalanxIntermediate
gS_websocketPaths_L[$IndexOf_4_phalanxIntermediate_z] = $WebSocketPath_L4_phalanxIntermediate
gS_websocketPaths_L[$IndexOf_4_phalanxDistal_x      ] = $WebSocketPath_L4_phalanxDistal
gS_websocketPaths_L[$IndexOf_4_phalanxDistal_y      ] = $WebSocketPath_L4_phalanxDistal
gS_websocketPaths_L[$IndexOf_4_phalanxDistal_z      ] = $WebSocketPath_L4_phalanxDistal
gS_websocketPaths_L[$IndexOf_4_tip_x                ] = $WebSocketPath_L4_tip
gS_websocketPaths_L[$IndexOf_4_tip_y                ] = $WebSocketPath_L4_tip
gS_websocketPaths_L[$IndexOf_4_tip_z                ] = $WebSocketPath_L4_tip
gS_websocketPaths_L[$IndexOf_5_metacarpal_x         ] = $WebSocketPath_L5_metacarpal
gS_websocketPaths_L[$IndexOf_5_metacarpal_y         ] = $WebSocketPath_L5_metacarpal
gS_websocketPaths_L[$IndexOf_5_metacarpal_z         ] = $WebSocketPath_L5_metacarpal
gS_websocketPaths_L[$IndexOf_5_phalanxProximal_x    ] = $WebSocketPath_L5_phalanxProximal
gS_websocketPaths_L[$IndexOf_5_phalanxProximal_y    ] = $WebSocketPath_L5_phalanxProximal
gS_websocketPaths_L[$IndexOf_5_phalanxProximal_z    ] = $WebSocketPath_L5_phalanxProximal
gS_websocketPaths_L[$IndexOf_5_phalanxIntermediate_x] = $WebSocketPath_L5_phalanxIntermediate
gS_websocketPaths_L[$IndexOf_5_phalanxIntermediate_y] = $WebSocketPath_L5_phalanxIntermediate
gS_websocketPaths_L[$IndexOf_5_phalanxIntermediate_z] = $WebSocketPath_L5_phalanxIntermediate
gS_websocketPaths_L[$IndexOf_5_phalanxDistal_x      ] = $WebSocketPath_L5_phalanxDistal
gS_websocketPaths_L[$IndexOf_5_phalanxDistal_y      ] = $WebSocketPath_L5_phalanxDistal
gS_websocketPaths_L[$IndexOf_5_phalanxDistal_z      ] = $WebSocketPath_L5_phalanxDistal
gS_websocketPaths_L[$IndexOf_5_tip_x                ] = $WebSocketPath_L5_tip
gS_websocketPaths_L[$IndexOf_5_tip_y                ] = $WebSocketPath_L5_tip
gS_websocketPaths_L[$IndexOf_5_tip_z                ] = $WebSocketPath_L5_tip
gS_websocketPaths_L[$IndexOf_Head_x                 ] = $WebSocketPath_Head_position
gS_websocketPaths_L[$IndexOf_Head_y                 ] = $WebSocketPath_Head_position
gS_websocketPaths_L[$IndexOf_Head_z                 ] = $WebSocketPath_Head_position

gS_websocketPaths_R[$IndexOf_Wrist_x                ] = $WebSocketPath_RWrist
gS_websocketPaths_R[$IndexOf_Wrist_y                ] = $WebSocketPath_RWrist
gS_websocketPaths_R[$IndexOf_Wrist_z                ] = $WebSocketPath_RWrist
gS_websocketPaths_R[$IndexOf_1_metacarpal_x         ] = $WebSocketPath_R1_metacarpal
gS_websocketPaths_R[$IndexOf_1_metacarpal_y         ] = $WebSocketPath_R1_metacarpal
gS_websocketPaths_R[$IndexOf_1_metacarpal_z         ] = $WebSocketPath_R1_metacarpal
gS_websocketPaths_R[$IndexOf_1_phalanxProximal_x    ] = $WebSocketPath_R1_phalanxProximal
gS_websocketPaths_R[$IndexOf_1_phalanxProximal_y    ] = $WebSocketPath_R1_phalanxProximal
gS_websocketPaths_R[$IndexOf_1_phalanxProximal_z    ] = $WebSocketPath_R1_phalanxProximal
gS_websocketPaths_R[$IndexOf_1_phalanxDistal_x      ] = $WebSocketPath_R1_phalanxDistal
gS_websocketPaths_R[$IndexOf_1_phalanxDistal_y      ] = $WebSocketPath_R1_phalanxDistal
gS_websocketPaths_R[$IndexOf_1_phalanxDistal_z      ] = $WebSocketPath_R1_phalanxDistal
gS_websocketPaths_R[$IndexOf_1_tip_x                ] = $WebSocketPath_R1_tip
gS_websocketPaths_R[$IndexOf_1_tip_y                ] = $WebSocketPath_R1_tip
gS_websocketPaths_R[$IndexOf_1_tip_z                ] = $WebSocketPath_R1_tip
gS_websocketPaths_R[$IndexOf_2_metacarpal_x         ] = $WebSocketPath_R2_metacarpal
gS_websocketPaths_R[$IndexOf_2_metacarpal_y         ] = $WebSocketPath_R2_metacarpal
gS_websocketPaths_R[$IndexOf_2_metacarpal_z         ] = $WebSocketPath_R2_metacarpal
gS_websocketPaths_R[$IndexOf_2_phalanxProximal_x    ] = $WebSocketPath_R2_phalanxProximal
gS_websocketPaths_R[$IndexOf_2_phalanxProximal_y    ] = $WebSocketPath_R2_phalanxProximal
gS_websocketPaths_R[$IndexOf_2_phalanxProximal_z    ] = $WebSocketPath_R2_phalanxProximal
gS_websocketPaths_R[$IndexOf_2_phalanxIntermediate_x] = $WebSocketPath_R2_phalanxIntermediate
gS_websocketPaths_R[$IndexOf_2_phalanxIntermediate_y] = $WebSocketPath_R2_phalanxIntermediate
gS_websocketPaths_R[$IndexOf_2_phalanxIntermediate_z] = $WebSocketPath_R2_phalanxIntermediate
gS_websocketPaths_R[$IndexOf_2_phalanxDistal_x      ] = $WebSocketPath_R2_phalanxDistal
gS_websocketPaths_R[$IndexOf_2_phalanxDistal_y      ] = $WebSocketPath_R2_phalanxDistal
gS_websocketPaths_R[$IndexOf_2_phalanxDistal_z      ] = $WebSocketPath_R2_phalanxDistal
gS_websocketPaths_R[$IndexOf_2_tip_x                ] = $WebSocketPath_R2_tip
gS_websocketPaths_R[$IndexOf_2_tip_y                ] = $WebSocketPath_R2_tip
gS_websocketPaths_R[$IndexOf_2_tip_z                ] = $WebSocketPath_R2_tip
gS_websocketPaths_R[$IndexOf_3_metacarpal_x         ] = $WebSocketPath_R3_metacarpal
gS_websocketPaths_R[$IndexOf_3_metacarpal_y         ] = $WebSocketPath_R3_metacarpal
gS_websocketPaths_R[$IndexOf_3_metacarpal_z         ] = $WebSocketPath_R3_metacarpal
gS_websocketPaths_R[$IndexOf_3_phalanxProximal_x    ] = $WebSocketPath_R3_phalanxProximal
gS_websocketPaths_R[$IndexOf_3_phalanxProximal_y    ] = $WebSocketPath_R3_phalanxProximal
gS_websocketPaths_R[$IndexOf_3_phalanxProximal_z    ] = $WebSocketPath_R3_phalanxProximal
gS_websocketPaths_R[$IndexOf_3_phalanxIntermediate_x] = $WebSocketPath_R3_phalanxIntermediate
gS_websocketPaths_R[$IndexOf_3_phalanxIntermediate_y] = $WebSocketPath_R3_phalanxIntermediate
gS_websocketPaths_R[$IndexOf_3_phalanxIntermediate_z] = $WebSocketPath_R3_phalanxIntermediate
gS_websocketPaths_R[$IndexOf_3_phalanxDistal_x      ] = $WebSocketPath_R3_phalanxDistal
gS_websocketPaths_R[$IndexOf_3_phalanxDistal_y      ] = $WebSocketPath_R3_phalanxDistal
gS_websocketPaths_R[$IndexOf_3_phalanxDistal_z      ] = $WebSocketPath_R3_phalanxDistal
gS_websocketPaths_R[$IndexOf_3_tip_x                ] = $WebSocketPath_R3_tip
gS_websocketPaths_R[$IndexOf_3_tip_y                ] = $WebSocketPath_R3_tip
gS_websocketPaths_R[$IndexOf_3_tip_z                ] = $WebSocketPath_R3_tip
gS_websocketPaths_R[$IndexOf_4_metacarpal_x         ] = $WebSocketPath_R4_metacarpal
gS_websocketPaths_R[$IndexOf_4_metacarpal_y         ] = $WebSocketPath_R4_metacarpal
gS_websocketPaths_R[$IndexOf_4_metacarpal_z         ] = $WebSocketPath_R4_metacarpal
gS_websocketPaths_R[$IndexOf_4_phalanxProximal_x    ] = $WebSocketPath_R4_phalanxProximal
gS_websocketPaths_R[$IndexOf_4_phalanxProximal_y    ] = $WebSocketPath_R4_phalanxProximal
gS_websocketPaths_R[$IndexOf_4_phalanxProximal_z    ] = $WebSocketPath_R4_phalanxProximal
gS_websocketPaths_R[$IndexOf_4_phalanxIntermediate_x] = $WebSocketPath_R4_phalanxIntermediate
gS_websocketPaths_R[$IndexOf_4_phalanxIntermediate_y] = $WebSocketPath_R4_phalanxIntermediate
gS_websocketPaths_R[$IndexOf_4_phalanxIntermediate_z] = $WebSocketPath_R4_phalanxIntermediate
gS_websocketPaths_R[$IndexOf_4_phalanxDistal_x      ] = $WebSocketPath_R4_phalanxDistal
gS_websocketPaths_R[$IndexOf_4_phalanxDistal_y      ] = $WebSocketPath_R4_phalanxDistal
gS_websocketPaths_R[$IndexOf_4_phalanxDistal_z      ] = $WebSocketPath_R4_phalanxDistal
gS_websocketPaths_R[$IndexOf_4_tip_x                ] = $WebSocketPath_R4_tip
gS_websocketPaths_R[$IndexOf_4_tip_y                ] = $WebSocketPath_R4_tip
gS_websocketPaths_R[$IndexOf_4_tip_z                ] = $WebSocketPath_R4_tip
gS_websocketPaths_R[$IndexOf_5_metacarpal_x         ] = $WebSocketPath_R5_metacarpal
gS_websocketPaths_R[$IndexOf_5_metacarpal_y         ] = $WebSocketPath_R5_metacarpal
gS_websocketPaths_R[$IndexOf_5_metacarpal_z         ] = $WebSocketPath_R5_metacarpal
gS_websocketPaths_R[$IndexOf_5_phalanxProximal_x    ] = $WebSocketPath_R5_phalanxProximal
gS_websocketPaths_R[$IndexOf_5_phalanxProximal_y    ] = $WebSocketPath_R5_phalanxProximal
gS_websocketPaths_R[$IndexOf_5_phalanxProximal_z    ] = $WebSocketPath_R5_phalanxProximal
gS_websocketPaths_R[$IndexOf_5_phalanxIntermediate_x] = $WebSocketPath_R5_phalanxIntermediate
gS_websocketPaths_R[$IndexOf_5_phalanxIntermediate_y] = $WebSocketPath_R5_phalanxIntermediate
gS_websocketPaths_R[$IndexOf_5_phalanxIntermediate_z] = $WebSocketPath_R5_phalanxIntermediate
gS_websocketPaths_R[$IndexOf_5_phalanxDistal_x      ] = $WebSocketPath_R5_phalanxDistal
gS_websocketPaths_R[$IndexOf_5_phalanxDistal_y      ] = $WebSocketPath_R5_phalanxDistal
gS_websocketPaths_R[$IndexOf_5_phalanxDistal_z      ] = $WebSocketPath_R5_phalanxDistal
gS_websocketPaths_R[$IndexOf_5_tip_x                ] = $WebSocketPath_R5_tip
gS_websocketPaths_R[$IndexOf_5_tip_y                ] = $WebSocketPath_R5_tip
gS_websocketPaths_R[$IndexOf_5_tip_z                ] = $WebSocketPath_R5_tip
gS_websocketPaths_R[$IndexOf_Head_x                 ] = $WebSocketPath_Head_rotation
gS_websocketPaths_R[$IndexOf_Head_y                 ] = $WebSocketPath_Head_rotation
gS_websocketPaths_R[$IndexOf_Head_z                 ] = $WebSocketPath_Head_rotation

/// endregion
/// region UDOs

opcode updateInitialPoseTransform, 0, 0
    // Calculate initial pose transform's translation and rotation.
    k_translation[] = (gk_initialL1_tip + gk_initialR1_tip) / 2
    k_rotation[] = fillarray(0, 0, 0)
    k_rotation[2] = taninv2(gk_initialR1_tip[$y] - gk_initialL1_tip[$y], gk_initialR1_tip[$x] - gk_initialL1_tip[$x])

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
    k_rotation[2] = taninv2(gk_initialR1_tip[$y] - gk_initialL1_tip[$y], gk_initialR1_tip[$x] - gk_initialL1_tip[$x])

    {{LogInfo_k '("Translation = [%.3f, %.3f, %.3f]", k_translation[$x], k_translation[$y], k_translation[$z])'}}
    {{LogInfo_k '("Rotation = %.3f", 360 * (k_rotation[2] / (2 * $M_PI)))'}}

    {{LogInfo_k '("Initial head position: [%.3f, %.3f, %.3f]", gk_initialHead_position[$x], gk_initialHead_position[$y], gk_initialHead_position[$z])'}}
    {{LogInfo_k '("Initial head rotation: [%.3f, %.3f, %.3f]", gk_initialHead_rotation[$x], gk_initialHead_rotation[$y], gk_initialHead_rotation[$z])'}}
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
    k_pinchDistanceL = sqrt(k_L1to2[$x] * k_L1to2[$x]) + sqrt(k_L1to2[$y] * k_L1to2[$y]) + sqrt(k_L1to2[$z] * k_L1to2[$z])
    k_pinchDistanceR = sqrt(k_R1to2[$x] * k_R1to2[$x]) + sqrt(k_R1to2[$y] * k_R1to2[$y]) + sqrt(k_R1to2[$z] * k_R1to2[$z])

    k_tick init 1
    if (metro($metro_OneTickEverySecond) == $true) then
        {{LogDebug_k '("SetInitialPose[%d]: L1 tip = [%.3f, %.3f, %.3f], L2 tip = [%.3f, %.3f, %.3f], R1 tip = [%.3f, %.3f, %.3f], R2 tip = [%.3f, %.3f, %.3f]", k_tick, k_L1_tip[$x], k_L1_tip[$y], k_L1_tip[$z], k_L2_tip[$x], k_L2_tip[$y], k_L2_tip[$z], k_R1_tip[$x], k_R1_tip[$y], k_R1_tip[$z], k_R2_tip[$x], k_R2_tip[$y], k_R2_tip[$z])'}}
        {{LogDebug_k '("SetInitialPose[%d]: Left pinch distance = %.3f, Right pinch distance = %.3f", k_tick, k_pinchDistanceL, k_pinchDistanceR)'}}
        k_tick += 1
    endif

    k_pinchDetected init $false
    if (k_pinchDistanceL < $PinchDistanceThreshold && k_pinchDistanceR < $PinchDistanceThreshold) then
        k_pinchDetected = $true
    endif

    // Only update the initial pose if a pinch is detected.
    // This allows the user to press the "Set initial pose" button again to cancel the operation.
    if (k_pinchDetected == $true) then
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

        // Turn the "Set initial pose" button off programmatically.
        cabbageSetValue($Channel_SetInitialPoseButton, k($false))
    endif

    k_setInitialPose = cabbageGetValue:k($Channel_SetInitialPoseButton)
    if (k_setInitialPose == $false) then
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

    if (ki == $BodyTracking_startIndex) then
        outall(a($BodyTracking_startValue))

    elseif (ki == $BodyTracking_endIndex) then
        outall(a($BodyTracking_endValue))

    elseif (ki <= $BodyTracking_arrayLength) then
        k_coord = kj % 3

        k_rawCoords_L[] init 3
        k_rawCoords_R[] init 3
        k_xformedCoords_L[] init 3
        k_xformedCoords_R[] init 3

        if (k_coord == 0) then
            k_rawCoords_L = websocket_getArray_k(i_websocketPort, gS_websocketPaths_L[kj])
            k_rawCoords_R = websocket_getArray_k(i_websocketPort, gS_websocketPaths_R[kj])

            k_xformedCoords_L = DaGLMath_Mat4_multiplyVec3(k_rawCoords_L, gk_initialPose_transform)
            k_xformedCoords_R = DaGLMath_Mat4_multiplyVec3(k_rawCoords_R, gk_initialPose_transform)
        endif

        // NB: The tracked values are limited to the range [-0.999, 0.999] to prevent the values from bleeding into the
        // -1 and 1 being used to indicate the start and end of the tracking data embedded in the audio signal.
        outs(a(limit(k_xformedCoords_L[k_coord], $BodyTracking_minValue, $BodyTracking_maxValue)), a(limit(k_xformedCoords_R[k_coord], $BodyTracking_minValue, $BodyTracking_maxValue)))

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
    k_isPlaying = chnget:k("IS_PLAYING")
    if (k_isRecording == $false && k_isPlaying == $true) then
        turnoff()
    endif
endin


instr $I_PassThrough
    outs(inch(1), inch(2))

    k_isRecording = chnget:k("IS_RECORDING")
    k_isPlaying = chnget:k("IS_PLAYING")
    if (k_isRecording == $true || k_isPlaying == $false) then
        turnoff()
    endif
endin


instr $I_AlwaysOn
    k_iteration init 0

    k_setInitialPose = cabbageGetValue:k($Channel_SetInitialPoseButton)
    k_isRecording = chnget:k("IS_RECORDING")
    k_isPlaying = chnget:k("IS_PLAYING")
    if (changed2(k_setInitialPose) == $true || changed2(k_isRecording) == $true || changed2(k_isPlaying) == $true || k_iteration == 0) then
        {{LogDebug_k '("k_setInitialPose = %d", k_setInitialPose)'}}
        {{LogDebug_k '("k_isRecording    = %d", k_isRecording)'}}
        {{LogDebug_k '("k_isPlaying      = %d", k_isPlaying)'}}

        if (k_setInitialPose == $true) then
            event("i", $I_SetInitialPose, 0, -1)
        else
            if (k_isRecording == $true || k_isPlaying == $false) then
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
