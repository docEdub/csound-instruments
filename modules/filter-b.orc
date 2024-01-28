/*
 *  filter-b.orc
 *
 *  Filter module with several options implemented using the `zdf_2pole` opcode.
 */

{{DeclareModule 'Filter_B'}}

{{#with Filter_B}}


gi_{{Module_private}}_frequencyChannelMap[] = fillarray(
    {{Channel.Frequency}},
    {{Channel.EnvelopeAmount}},
    {{Channel.EnvelopeAttack}},
    {{Channel.EnvelopeDecay}},
    {{Channel.EnvelopeSustain}},
    {{Channel.EnvelopeRelease}},
    {{Channel.KeyTracking}})

/// Filter module with several options implemented using the `zdf_2pole` opcode.
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

    i_hostFilterType        = {{moduleGet:i 'FilterType'}}
    k_hostQ                 = {{moduleGet:k 'Q'}}

    k_frequency = _af_shared_filter_frequency:k(gS_{{Module_private}}_channels, i_instanceIndex, gi_{{Module_private}}_frequencyChannelMap)
    i_mode = \
        i_hostFilterType == {{FilterType.LowPass}} ? {{../zdf_2pole.Mode.LowPass}} : \
        i_hostFilterType == {{FilterType.HighPass}} ? {{../zdf_2pole.Mode.HighPass}} : \
        i_hostFilterType == {{FilterType.BandPass}} ? {{../zdf_2pole.Mode.BandPass}} : \
        i_hostFilterType == {{FilterType.UnityGainBandPass}} ? {{../zdf_2pole.Mode.UnityGainBandPass}} : \
        i_hostFilterType == {{FilterType.Notch}} ? {{../zdf_2pole.Mode.Notch}} : \
        i_hostFilterType == {{FilterType.AllPass}} ? {{../zdf_2pole.Mode.AllPass}} : \
        i_hostFilterType == {{FilterType.Peak}} ? {{../zdf_2pole.Mode.Peak}} : \
        -1

    a_out = zdf_2pole(a_in, k_frequency, k_hostQ, i_mode)

end:
    xout(a_out)
endop


{{/with}}
