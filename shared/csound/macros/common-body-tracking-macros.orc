
#define BodyTracking_arrayLength    #78#

#define BodyTracking_startIndex     # 0#
#define BodyTracking_startValue     # 1#

#define BodyTracking_endIndex       #79#
#define BodyTracking_endValue       #-1#

#define BodyTracking_minValue               #-0.999 #
#define BodyTracking_maxValue               # 0.999 #
#define BodyTracking_minValue_withEpsilon   #-0.9999#
#define BodyTracking_maxValue_withEpsilon   # 0.9999#

/// region IndexOf ...

#define IndexOf_Wrist_x                     # 0#
#define IndexOf_Wrist_y                     # 1#
#define IndexOf_Wrist_z                     # 2#
#define IndexOf_1_metacarpal_x              # 3#
#define IndexOf_1_metacarpal_y              # 4#
#define IndexOf_1_metacarpal_z              # 5#
#define IndexOf_1_phalanxProximal_x         # 6#
#define IndexOf_1_phalanxProximal_y         # 7#
#define IndexOf_1_phalanxProximal_z         # 8#
#define IndexOf_1_phalanxDistal_x           # 9#
#define IndexOf_1_phalanxDistal_y           #10#
#define IndexOf_1_phalanxDistal_z           #11#
#define IndexOf_1_tip_x                     #12#
#define IndexOf_1_tip_y                     #13#
#define IndexOf_1_tip_z                     #14#
#define IndexOf_2_metacarpal_x              #15#
#define IndexOf_2_metacarpal_y              #16#
#define IndexOf_2_metacarpal_z              #17#
#define IndexOf_2_phalanxProximal_x         #18#
#define IndexOf_2_phalanxProximal_y         #19#
#define IndexOf_2_phalanxProximal_z         #20#
#define IndexOf_2_phalanxIntermediate_x     #21#
#define IndexOf_2_phalanxIntermediate_y     #22#
#define IndexOf_2_phalanxIntermediate_z     #23#
#define IndexOf_2_phalanxDistal_x           #24#
#define IndexOf_2_phalanxDistal_y           #25#
#define IndexOf_2_phalanxDistal_z           #26#
#define IndexOf_2_tip_x                     #27#
#define IndexOf_2_tip_y                     #28#
#define IndexOf_2_tip_z                     #29#
#define IndexOf_3_metacarpal_x              #30#
#define IndexOf_3_metacarpal_y              #31#
#define IndexOf_3_metacarpal_z              #32#
#define IndexOf_3_phalanxProximal_x         #33#
#define IndexOf_3_phalanxProximal_y         #34#
#define IndexOf_3_phalanxProximal_z         #35#
#define IndexOf_3_phalanxIntermediate_x     #36#
#define IndexOf_3_phalanxIntermediate_y     #37#
#define IndexOf_3_phalanxIntermediate_z     #38#
#define IndexOf_3_phalanxDistal_x           #39#
#define IndexOf_3_phalanxDistal_y           #40#
#define IndexOf_3_phalanxDistal_z           #41#
#define IndexOf_3_tip_x                     #42#
#define IndexOf_3_tip_y                     #43#
#define IndexOf_3_tip_z                     #44#
#define IndexOf_4_metacarpal_x              #45#
#define IndexOf_4_metacarpal_y              #46#
#define IndexOf_4_metacarpal_z              #47#
#define IndexOf_4_phalanxProximal_x         #48#
#define IndexOf_4_phalanxProximal_y         #49#
#define IndexOf_4_phalanxProximal_z         #50#
#define IndexOf_4_phalanxIntermediate_x     #51#
#define IndexOf_4_phalanxIntermediate_y     #52#
#define IndexOf_4_phalanxIntermediate_z     #53#
#define IndexOf_4_phalanxDistal_x           #54#
#define IndexOf_4_phalanxDistal_y           #55#
#define IndexOf_4_phalanxDistal_z           #56#
#define IndexOf_4_tip_x                     #57#
#define IndexOf_4_tip_y                     #58#
#define IndexOf_4_tip_z                     #59#
#define IndexOf_5_metacarpal_x              #60#
#define IndexOf_5_metacarpal_y              #61#
#define IndexOf_5_metacarpal_z              #62#
#define IndexOf_5_phalanxProximal_x         #63#
#define IndexOf_5_phalanxProximal_y         #64#
#define IndexOf_5_phalanxProximal_z         #65#
#define IndexOf_5_phalanxIntermediate_x     #66#
#define IndexOf_5_phalanxIntermediate_y     #67#
#define IndexOf_5_phalanxIntermediate_z     #68#
#define IndexOf_5_phalanxDistal_x           #69#
#define IndexOf_5_phalanxDistal_y           #70#
#define IndexOf_5_phalanxDistal_z           #71#
#define IndexOf_5_tip_x                     #72#
#define IndexOf_5_tip_y                     #73#
#define IndexOf_5_tip_z                     #74#
#define IndexOf_Head_x                      #75#
#define IndexOf_Head_y                      #76#
#define IndexOf_Head_z                      #77#

/// endregion
/// region WebSocketPath ...

#define WebSocketPath_LWrist                    #"/hands/left/wrist/position"#
#define WebSocketPath_RWrist                    #"/hands/right/wrist/position"#

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

#define WebSocketPath_Head_position             #"/head/position"#
#define WebSocketPath_Head_rotation             #"/head/rotation"#

/// endregion
