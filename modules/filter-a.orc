/*
 *  filter-a.orc
 *
 *  Filter module with high, and low pass options implemented using the `K35_hpf` and `K35_lpf opcodes.
 */

{{DeclareModule 'Filter_A'}}

/// Filter module with high, and low pass options implemented using the `K35_hpf` and `K35_lpf opcodes.
/// @param 1 String channel prefix used for host automation parameters.
/// @param 2 A-rate input signal.
/// @out A-rate envelope.
///
opcode AF_Module_{{ModuleName}}, a, Sa
    S_channelPrefix, a_in xin
    i_channelIndex = {{hostValueGet}}:i(S_channelPrefix)

    i_lagTime = kr / sr

    if ({{moduleGet:k 'Enabled'}} == {{false}}) then
        a_out = a_in
        kgoto end
    endif

    k_hostFilterType        = {{moduleGet:k 'FilterType'}}
    k_hostCutoff            = {{moduleGet:k 'Cutoff'}}
    k_hostQ                 = {{moduleGet:k 'Q'}}

    k_hostProcessingType    = {{moduleGet:k 'ProcessingType'}}
    k_hostSaturation        = {{moduleGet:k 'Saturation'}}

    k_hostEnvelopeAmount    = {{moduleGet:k 'EnvelopeAmount'}}
    i_hostEnvelopeAttack    = {{moduleGet:i 'EnvelopeAttack'}}
    i_hostEnvelopeDecay     = {{moduleGet:i 'EnvelopeDecay'}}
    i_hostEnvelopeSustain   = {{moduleGet:i 'EnvelopeSustain'}}
    i_hostEnvelopeRelease   = {{moduleGet:i 'EnvelopeRelease'}}

    k_cutoff = lag(k_hostCutoff, i_lagTime)
    k_cutoff = expcurve(k_cutoff, 10)

    k_envelopeAmount = lag(k_hostEnvelopeAmount, i_lagTime)
    k_envelopeAmount = expcurve(k_envelopeAmount, 10)
    k_envelopeAmount = min(k_cutoff + k_envelopeAmount, 1) - k_cutoff

    // Apply cutoff envelope.
    k_envelope = madsr:k(i_hostEnvelopeAttack, i_hostEnvelopeDecay, i_hostEnvelopeSustain, i_hostEnvelopeRelease) * k_envelopeAmount
    k_cutoff += expcurve(k_envelope, 10)

    // Convert cutoff from range [0, 1] to [0, 20000].
    k_cutoff *= 20000

    if (k_hostFilterType == {{Filter_A.FilterType.LowPass}}) then
        a_out = K35_lpf:a(a_in, k_cutoff, k_hostQ, k_hostProcessingType, k_hostSaturation)
    elseif (k_hostFilterType == {{Filter_A.FilterType.HighPass}}) then
        a_out = K35_hpf:a(a_in, k_cutoff, k_hostQ, k_hostProcessingType, k_hostSaturation)
    endif

end:
    xout(a_out)
endop
