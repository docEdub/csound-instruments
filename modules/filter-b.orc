/*
 *  filter-b.orc
 *
 *  Filter module with several options implemented using the `zdf_2pole` opcode.
 */

{{DeclareModule 'Filter_B'}}

gi_AF_Module_{{ModuleName}}_frequencyChannelMap[] = fillarray(
    {{Filter_B.Channel.Frequency}},
    {{Filter_B.Channel.EnvelopeAmount}},
    {{Filter_B.Channel.EnvelopeAttack}},
    {{Filter_B.Channel.EnvelopeDecay}},
    {{Filter_B.Channel.EnvelopeSustain}},
    {{Filter_B.Channel.EnvelopeRelease}},
    {{Filter_B.Channel.KeyTracking}})

/// Filter module with several options implemented using the `zdf_2pole` opcode.
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

    i_hostFilterType        = {{moduleGet:i 'FilterType'}}
    k_hostQ                 = {{moduleGet:k 'Q'}}

    k_frequency = _af_filter_frequency:k(gS_AF_Module_{{ModuleName}}_channels, i_instanceIndex, gi_AF_Module_{{ModuleName}}_frequencyChannelMap)
    i_mode = \
        i_hostFilterType == {{Filter_B.FilterType.LowPass}} ? {{zdf_2pole.Mode.LowPass}} : \
        i_hostFilterType == {{Filter_B.FilterType.HighPass}} ? {{zdf_2pole.Mode.HighPass}} : \
        i_hostFilterType == {{Filter_B.FilterType.BandPass}} ? {{zdf_2pole.Mode.BandPass}} : \
        i_hostFilterType == {{Filter_B.FilterType.UnityGainBandPass}} ? {{zdf_2pole.Mode.UnityGainBandPass}} : \
        i_hostFilterType == {{Filter_B.FilterType.Notch}} ? {{zdf_2pole.Mode.Notch}} : \
        i_hostFilterType == {{Filter_B.FilterType.AllPass}} ? {{zdf_2pole.Mode.AllPass}} : \
        i_hostFilterType == {{Filter_B.FilterType.Peak}} ? {{zdf_2pole.Mode.Peak}} : \
        -1

    a_out = zdf_2pole(a_in, k_frequency, k_hostQ, i_mode)

end:
    xout(a_out)
endop
