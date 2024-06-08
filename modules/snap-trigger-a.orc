/*
 *  lfo-a.orc
 *
 *  Snap trigger generator module.
 */

{{DeclareModule 'SnapTrigger_A'}}

{{Enable-LogTrace false}}
{{Enable-LogDebug true}}

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

    k_hand                  = {{moduleGet:k 'Hand'}}
    k_distanceThreshold     = {{moduleGet:k 'DistanceThreshold'}}

    k_checkForSnap init $false
    k_isTriggered = $false

    a_bodyTrackingData = inch(k_hand)
    k_bodyTrackingIndex init -1
    k_bodyTrackingData[] init $BodyTracking_arrayLength
    ki = 0
    while (ki < ksmps) do
        k_bodyTrackingValue = vaget(ki, a_bodyTrackingData)
        if (k_bodyTrackingValue > $BodyTracking_maxValue_withEpsilon) then
            k_bodyTrackingIndex = 0
        elseif (k_bodyTrackingValue < $BodyTracking_minValue_withEpsilon) then
            k_bodyTrackingIndex = -1
            k_checkForSnap = $true
        elseif (k_bodyTrackingIndex >= 0 && k_bodyTrackingIndex < $BodyTracking_arrayLength) then
            k_bodyTrackingData[k_bodyTrackingIndex] = k_bodyTrackingValue
            k_bodyTrackingIndex += 1
        endif
        ki += 1
    od

    // Only check for snap after whole array of body tracking data is received.
    if (k_checkForSnap == $false) then
        kgoto end
    endif
    k_checkForSnap = $true

    k_finger_1[] init 3
    k_finger_3[] init 3
    k_finger_4[] init 3

    k_finger_1[$x] = k_bodyTrackingData[$IndexOf_1_tip_x]
    k_finger_1[$y] = k_bodyTrackingData[$IndexOf_1_tip_y]
    k_finger_1[$z] = k_bodyTrackingData[$IndexOf_1_tip_z]

    k_finger_3[$x] = k_bodyTrackingData[$IndexOf_3_tip_x]
    k_finger_3[$y] = k_bodyTrackingData[$IndexOf_3_tip_y]
    k_finger_3[$z] = k_bodyTrackingData[$IndexOf_3_tip_z]

    k_finger_4[$x] = k_bodyTrackingData[$IndexOf_4_tip_x]
    k_finger_4[$y] = k_bodyTrackingData[$IndexOf_4_tip_y]
    k_finger_4[$z] = k_bodyTrackingData[$IndexOf_4_tip_z]

    ; {{LogDebug_k '("1:(%.3f, %.3f, %.3f) 3:(%.3f, %.3f, %.3f) 4:(%.3f, %.3f, %.3f)", k_finger_1[$x], k_finger_1[$y], k_finger_1[$z], k_finger_3[$x], k_finger_3[$y], k_finger_3[$z], k_finger_4[$x], k_finger_4[$y], k_finger_4[$z])'}}

    k_3to1_distance = DaGLMath_Vec3_distance(k_finger_3, k_finger_1)
    k_3to4_distance = DaGLMath_Vec3_distance(k_finger_3, k_finger_4)

    ; {{LogDebug_k '("k_3to1_distance = %f, k_3to4_distance = %f)", k_3to1_distance, k_3to4_distance)'}}

    k_isPrimed init $false

    if (k_isPrimed == $true) then
        if (k_3to4_distance < k_distanceThreshold) then
            k_isTriggered = $true
        endif
    endif

    if (k_3to1_distance < k_distanceThreshold) then
        k_isPrimed = $true
    else
        k_isPrimed = $false
    endif

    if (changed2(k_isPrimed) == $true) then
        {{LogDebug_k '("k_isPrimed = %d", k_isPrimed)'}}
    endif
    if (changed2(k_isTriggered) == $true) then
        {{LogDebug_k '("k_isTriggered = %d", k_isTriggered)'}}
    endif
end:
    xout(k_isTriggered)
endop


{{/with}}
