/*
 *  lfo-a.orc
 *
 *  Snap trigger generator module.
 */

{{DeclareModule 'SnapTrigger_A'}}

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
        elseif (k_bodyTrackingIndex >= 0 && k_bodyTrackingIndex < $BodyTracking_arrayLength) then
            k_bodyTrackingData[k_bodyTrackingIndex] = k_bodyTrackingValue
            k_bodyTrackingIndex += 1
        endif
        ki += 1
    od

    k_finger_1[] init 3
    k_finger_3[] init 3
    k_finger_4[] init 3

    k_finger_1[$x] = k_bodyTrackingData[$IndexOf_1_tip_x]
    k_finger_1[$y] = k_bodyTrackingData[$IndexOf_1_tip_y]
    k_finger_1[$z] = k_bodyTrackingData[$IndexOf_1_tip_z]

    k_tipToTip[] init 3
    k_distance init 1
    k_isTriggered = $false

    k_isPrimed init $false
    if (k_isPrimed == $true) then
        k_finger_4[$x] = k_bodyTrackingData[$IndexOf_4_tip_x]
        k_finger_4[$y] = k_bodyTrackingData[$IndexOf_4_tip_y]
        k_finger_4[$z] = k_bodyTrackingData[$IndexOf_4_tip_z]
        k_tipToTip = k_finger_3 - k_finger_4
        k_distance = sqrt(k_tipToTip[$x] * k_tipToTip[$x] + k_tipToTip[$y] * k_tipToTip[$y] + k_tipToTip[$z] * k_tipToTip[$z])
        if (k_distance < k_distanceThreshold) then
            k_isTriggered = $true
        endif
    elseif (k_isTriggered == $false) then
        k_isPrimed = $false
        k_finger_1[$x] = k_bodyTrackingData[$IndexOf_1_tip_x]
        k_finger_1[$y] = k_bodyTrackingData[$IndexOf_1_tip_y]
        k_finger_1[$z] = k_bodyTrackingData[$IndexOf_1_tip_z]
        k_tipToTip = k_finger_3 - k_finger_1
        k_distance = sqrt(k_tipToTip[$x] * k_tipToTip[$x] + k_tipToTip[$y] * k_tipToTip[$y] + k_tipToTip[$z] * k_tipToTip[$z])
        if (k_distance < k_distanceThreshold) then
            k_isPrimed = $true
        endif
    endif

end:
    xout(k_isTriggered)
endop


{{/with}}
