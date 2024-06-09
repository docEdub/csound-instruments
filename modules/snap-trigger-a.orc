/*
 *  lfo-a.orc
 *
 *  Snap trigger generator module.
 */

{{DeclareModule 'SnapTrigger_A'}}

{{Enable-LogTrace false}}
{{Enable-LogDebug false}}

{{#with SnapTrigger_A}}

{{include "shared/csound/macros/common-body-tracking-macros.orc"}}
{{include "shared/csound/macros/common-math-defines.orc"}}


/// Returns `$true` if a finger snap is detected.
/// @param 1 Channel prefix used for host automation parameters.
/// @out K-rate Generated value.
///
opcode {{Module_public}}, k, S
    S_channelPrefix xin
    i_instanceIndex = {{hostValueGet}}:i(S_channelPrefix)

    if ({{moduleGet:k 'Enabled'}} == $false) then
        k_out = 1
        kgoto end
    endif

    k_handChirality         = {{moduleGet:k 'HandChirality'}}
    k_distanceThreshold     = {{moduleGet:k 'DistanceThreshold'}}
    k_palmToHeadDotMin      = {{moduleGet:k 'PalmToHeadDotMin'}}
    k_finger3ToHeadDotMax   = {{moduleGet:k 'Finger3ToHeadDotMax'}}
    k_handSpeedMax          = {{moduleGet:k 'HandSpeedMax'}}
    k_deduplicationTime     = {{moduleGet:k 'DeduplicationTime'}}

    k_lastTriggerTime init 0
    k_time = timeinsts()
    if (k_time - k_lastTriggerTime < k_deduplicationTime) then
        kgoto end
    endif

    k_isPrimed init $false
    k_isTriggered = $false

    a_bodyTrackingData_L = inch(1)
    a_bodyTrackingData_R = inch(2)

    k_bodyTrackingIndex init -1
    k_bodyTrackingData_L[] init $BodyTracking_arrayLength
    k_bodyTrackingData_R[] init $BodyTracking_arrayLength
    ki = 0
    while (ki < ksmps) do
        k_bodyTrackingValue_L = vaget(ki, a_bodyTrackingData_L)
        k_bodyTrackingValue_R = vaget(ki, a_bodyTrackingData_R)
        if (k_bodyTrackingValue_L > $BodyTracking_maxValue_withEpsilon) then
            k_bodyTrackingIndex = 0
        elseif (k_bodyTrackingValue_L < $BodyTracking_minValue_withEpsilon) then
            k_bodyTrackingIndex = -1
        elseif (k_bodyTrackingIndex >= 0 && k_bodyTrackingIndex < $BodyTracking_arrayLength) then
            k_bodyTrackingData_L[k_bodyTrackingIndex] = k_bodyTrackingValue_L
            k_bodyTrackingData_R[k_bodyTrackingIndex] = k_bodyTrackingValue_R
            k_bodyTrackingIndex += 1
        endif
        ki += 1
    od

    k_bodyTrackingData[] init $BodyTracking_arrayLength
    if (k_handChirality == {{HandChirality.Left}}) then
        k_bodyTrackingData = k_bodyTrackingData_L
    else
        k_bodyTrackingData = k_bodyTrackingData_R
    endif

    // For filtering out snaps when wrist is moving quickly.
    k_wrist[] init 3
    k_wrist_previous[] init 3
    k_wrist_previous = k_wrist
    k_wrist[$x] = k_bodyTrackingData[$IndexOf_Wrist_x]
    k_wrist[$y] = k_bodyTrackingData[$IndexOf_Wrist_y]
    k_wrist[$z] = k_bodyTrackingData[$IndexOf_Wrist_z]

    // For filtering out snaps when middle finger is moving quickly side to side.
    k_finger_3_tip_x init 0
    k_finger_3_tip_x_previous = k_finger_3_tip_x
    k_finger_3_tip_x = k_bodyTrackingData[$IndexOf_3_tip_x]

    // Disable snap when hand is not facing head since it makes snap detection unreliable.
    k_hand_normal[] init 3
    k_headToHand_normal[] init 3

    k_finger_2_knuckle[] init 3
    k_finger_2_knuckle[$x] = k_bodyTrackingData[$IndexOf_2_phalanxProximal_x]
    k_finger_2_knuckle[$y] = k_bodyTrackingData[$IndexOf_2_phalanxProximal_y]
    k_finger_2_knuckle[$z] = k_bodyTrackingData[$IndexOf_2_phalanxProximal_z]

    k_finger_3_knuckle[] init 3
    k_finger_3_knuckle[$x] = k_bodyTrackingData[$IndexOf_3_phalanxProximal_x]
    k_finger_3_knuckle[$y] = k_bodyTrackingData[$IndexOf_3_phalanxProximal_y]
    k_finger_3_knuckle[$z] = k_bodyTrackingData[$IndexOf_3_phalanxProximal_z]

    k_hand_normal = DaGLMath_Vec3_triangleNormal(k_wrist, k_finger_2_knuckle, k_finger_3_knuckle)
    DaGLMath_Vec3_normalizeInPlace(k_hand_normal)

    k_head_position[] init 3
    k_head_position[$x] = k_bodyTrackingData_L[$IndexOf_Head_x]
    k_head_position[$y] = k_bodyTrackingData_L[$IndexOf_Head_y]
    k_head_position[$z] = k_bodyTrackingData_L[$IndexOf_Head_z]

    k_headToHand_normal[] init 3
    k_headToHand_normal[$x] = k_head_position[$x] - k_wrist[$x]
    k_headToHand_normal[$y] = k_head_position[$y] - k_wrist[$y]
    k_headToHand_normal[$z] = k_head_position[$z] - k_wrist[$z]
    DaGLMath_Vec3_normalizeInPlace(k_headToHand_normal)

    k_handToHead_dot = DaGLMath_Vec3_dot(k_hand_normal, k_headToHand_normal)
    if (k_handChirality == {{HandChirality.Left}}) then
        k_handToHead_dot = -k_handToHead_dot
    endif
    ; {{LogDebug_k '("k_handToHead_dot = %f", k_handToHead_dot)'}}

    if (k_handToHead_dot < k_palmToHeadDotMin) then
        {{LogTrace_k '("Hand is not facing head.")'}}
        kgoto end
    endif

    k_finger_3_tip[] init 3
    k_finger_3_tip[$x] = k_bodyTrackingData[$IndexOf_3_tip_x]
    k_finger_3_tip[$y] = k_bodyTrackingData[$IndexOf_3_tip_y]
    k_finger_3_tip[$z] = k_bodyTrackingData[$IndexOf_3_tip_z]

    k_finger_1_tip[] init 3
    k_finger_1_tip[$x] = k_bodyTrackingData[$IndexOf_1_tip_x]
    k_finger_1_tip[$y] = k_bodyTrackingData[$IndexOf_1_tip_y]
    k_finger_1_tip[$z] = k_bodyTrackingData[$IndexOf_1_tip_z]

    // Disable snap when wrist is moving quickly since it makes snap detection unreliable.
    k_wrist_speed init 0
    k_wrist_speed = lag(DaGLMath_Vec3_distance(k_wrist, k_wrist_previous) * kr, 0.5)
    ; {{LogDebug_k '("k_wrist_speed = %f, k_wrist = [%.3f, %.3f, %.3f]", k_wrist_speed, k_wrist[$x], k_wrist[$y], k_wrist[$z])'}}

    if (k_wrist_speed > k_handSpeedMax) then
        {{LogTrace_k '("Wrist is moving too quickly.")'}}
        kgoto end
    endif

    // Disable snap when middle finger is moving quickly side to side since it makes snap detection unreliable.
    k_finger_3_tip_x_speed = lag((abs(k_finger_3_tip_x - k_finger_3_tip_x_previous)) * kr, 0.5)
    k_finger_3_tip_x_previous = k_finger_3_tip_x
    ; {{LogDebug_k '("k_finger_3_tip_x_speed = %f", k_finger_3_tip_x_speed)'}}

    if (k_finger_3_tip_x_speed > k_handSpeedMax) then
        {{LogTrace_k '("Middle finger is moving too quickly side to side.")'}}
        kgoto end
    endif

    // Disable snap if 1st and 4th fingers are next to each other
    k_finger_4_tip[] init 3
    k_finger_4_tip[$x] = k_bodyTrackingData[$IndexOf_4_tip_x]
    k_finger_4_tip[$y] = k_bodyTrackingData[$IndexOf_4_tip_y]
    k_finger_4_tip[$z] = k_bodyTrackingData[$IndexOf_4_tip_z]

    k_1to4_tip_distance = DaGLMath_Vec3_distance(k_finger_1_tip, k_finger_4_tip)
    if (k_1to4_tip_distance < k_distanceThreshold) then
        {{LogTrace_k '("1st and 4th fingers are too close.")'}}
        kgoto end
    endif

    // Detect snap.
    k_3to4_tip_distance = DaGLMath_Vec3_distance(k_finger_3_tip, k_finger_4_tip)

    if (k_isPrimed == $true) then
        if (k_3to4_tip_distance < k_distanceThreshold) then
            k_isTriggered = $true
            k_lastTriggerTime = k_time
        endif
    endif

    k_3to1_tip_distance = DaGLMath_Vec3_distance(k_finger_3_tip, k_finger_1_tip)
    if (k_3to1_tip_distance < k_distanceThreshold) then
        k_isPrimed = $true
    else
        k_isPrimed = $false
    endif

    if (k_isPrimed == $true) then
        // Disable snap when 3rd finger is facing head since it makes headset think 3rd and 4th finger are close to each
        // other and gives false positives.
        k_finger_3_intermediate[] init 3
        k_finger_3_intermediate[$x] = k_bodyTrackingData[$IndexOf_3_phalanxIntermediate_x]
        k_finger_3_intermediate[$y] = k_bodyTrackingData[$IndexOf_3_phalanxIntermediate_y]
        k_finger_3_intermediate[$z] = k_bodyTrackingData[$IndexOf_3_phalanxIntermediate_z]

        k_finger_3_normal[] init 3
        k_finger_3_normal[$x] = k_finger_3_intermediate[$x] - k_finger_3_knuckle[$x]
        k_finger_3_normal[$y] = k_finger_3_intermediate[$y] - k_finger_3_knuckle[$y]
        k_finger_3_normal[$z] = k_finger_3_intermediate[$z] - k_finger_3_knuckle[$z]
        DaGLMath_Vec3_normalizeInPlace(k_finger_3_normal)

        k_headToFinger3_normal[] init 3
        k_headToFinger3_normal[$x] = k_head_position[$x] - k_finger_3_tip[$x]
        k_headToFinger3_normal[$y] = k_head_position[$y] - k_finger_3_tip[$y]
        k_headToFinger3_normal[$z] = k_head_position[$z] - k_finger_3_tip[$z]
        DaGLMath_Vec3_normalizeInPlace(k_headToFinger3_normal)

        k_finger3ToHead_dot = DaGLMath_Vec3_dot(k_finger_3_normal, k_headToFinger3_normal)
        {{LogDebug_k '("k_finger3ToHead_dot = %f", k_finger3ToHead_dot)'}}

        if (k_finger3ToHead_dot > k_finger3ToHeadDotMax) then
            {{LogTrace_k '("3rd finger is facing head.")'}}
            k_isPrimed = $false
        endif
    endif

    ; if (changed2(k_isPrimed) == $true) then
    ;     {{LogDebug_k '("k_isPrimed = %d", k_isPrimed)'}}
    ; endif
    ; if (changed2(k_isTriggered) == $true) then
    ;     {{LogDebug_k '("k_isTriggered = %d", k_isTriggered)'}}
    ; endif
end:
    xout(k_isTriggered)
endop


{{/with}}
