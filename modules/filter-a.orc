/*
 *  filter-a.orc
 *
 *  Filter module with high, and low pass options implemented using the `K35_hpf` and `K35_lpf opcodes.
 */

{{DeclareModule 'Filter_A'}}

{{#with Filter_A}}


gi_{{Module_private}}_frequencyChannelMap[] = fillarray(
    {{Channel.Frequency}},
    {{Channel.EnvelopeAmount}},
    {{Channel.EnvelopeAttack}},
    {{Channel.EnvelopeDecay}},
    {{Channel.EnvelopeSustain}},
    {{Channel.EnvelopeRelease}},
    {{Channel.KeyTracking}})

/// Filter module with high, and low pass options implemented using the `K35_hpf` and `K35_lpf opcodes.
/// @param 1 String channel prefix used for host automation parameters.
/// @param 2 A-rate input signal.
/// @out A-rate envelope.
///
opcode {{Module_public}}, a, Sa
    S_channelPrefix, a_in xin
    i_instanceIndex = {{hostValueGet}}:i(S_channelPrefix)

    if ({{moduleGet:k 'Enabled'}} == $false) then
        a_out = a_in
        kgoto end
    endif

    k_hostFilterType        = {{moduleGet:k 'FilterType'}}
    k_hostQ                 = {{moduleGet:k 'Q'}}

    k_hostProcessingType    = {{moduleGet:k 'ProcessingType'}}
    k_hostSaturation        = {{moduleGet:k 'Saturation'}}

    k_frequency = _af_shared_filter_frequency:k(gS_{{Module_private}}_channels, i_instanceIndex, gi_{{Module_private}}_frequencyChannelMap)

    if (k_hostFilterType == {{FilterType.LowPass}}) then
        a_out = K35_lpf:a(a_in, k_frequency, k_hostQ, k_hostProcessingType, k_hostSaturation)
    elseif (k_hostFilterType == {{FilterType.HighPass}}) then
        a_out = K35_hpf:a(a_in, k_frequency, k_hostQ, k_hostProcessingType, k_hostSaturation)
    endif

end:
    xout(a_out)
endop


{{/with}}
