/*
 *  filter-a.orc
 *
 *  Filter module with high, and low pass options implemented using the `K35_hpf` and `K35_lpf opcodes.
 */

{{DeclareModule 'Filter_A'}}

gi_AF_Module_{{ModuleName}}_frequencyChannelMap[] = fillarray(
    {{Filter_A.Channel.Frequency}},
    {{Filter_A.Channel.EnvelopeAmount}},
    {{Filter_A.Channel.EnvelopeAttack}},
    {{Filter_A.Channel.EnvelopeDecay}},
    {{Filter_A.Channel.EnvelopeSustain}},
    {{Filter_A.Channel.EnvelopeRelease}},
    {{Filter_A.Channel.KeyTracking}})

/// Filter module with high, and low pass options implemented using the `K35_hpf` and `K35_lpf opcodes.
/// @param 1 String channel prefix used for host automation parameters.
/// @param 2 A-rate input signal.
/// @out A-rate envelope.
///
opcode AF_Module_{{ModuleName}}, a, Sa
    S_channelPrefix, a_in xin
    i_instanceIndex = {{hostValueGet}}:i(S_channelPrefix)

    if ({{moduleGet:k 'Enabled'}} == {{false}}) then
        a_out = a_in
        kgoto end
    endif

    k_hostFilterType        = {{moduleGet:k 'FilterType'}}
    k_hostQ                 = {{moduleGet:k 'Q'}}

    k_hostProcessingType    = {{moduleGet:k 'ProcessingType'}}
    k_hostSaturation        = {{moduleGet:k 'Saturation'}}

    k_frequency = _af_filter_frequency:k(gS_AF_Module_{{ModuleName}}_channels, i_instanceIndex, gi_AF_Module_{{ModuleName}}_frequencyChannelMap)

    if (k_hostFilterType == {{Filter_A.FilterType.LowPass}}) then
        a_out = K35_lpf:a(a_in, k_frequency, k_hostQ, k_hostProcessingType, k_hostSaturation)
    elseif (k_hostFilterType == {{Filter_A.FilterType.HighPass}}) then
        a_out = K35_hpf:a(a_in, k_frequency, k_hostQ, k_hostProcessingType, k_hostSaturation)
    endif

end:
    xout(a_out)
endop
