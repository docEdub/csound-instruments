/*
 *  filter-01.orc
 *
 *  Filter module with high, and low pass options implemented using the `K35_hpf` and `K35_lpf opcodes.
 */

{{DeclareModule 'filter_01'}}

/// Filter module with high, and low pass options implemented using the `K35_hpf` and `K35_lpf opcodes.
/// @param 1 String channel prefix used for host automation parameters.
/// @param 2 A-rate input signal.
/// @out A-rate envelope.
///
opcode AF_{{ModuleName}}_module, a, Sa
    SChannelPrefix, aIn xin
    i_channelIndex = {{hostValueGet}}:i(SChannelPrefix)

    iLagTime = kr / sr

    if ({{moduleGet:k 'Enabled'}} == {{false}}) then
        aOut = aIn
        kgoto end
    endif

    kHost_filter_type       = {{moduleGet:k 'FilterType'}}
    kHost_cutoff            = {{moduleGet:k 'Cutoff'}}
    kHost_q                 = {{moduleGet:k 'Q'}}

    kHost_processing_type   = {{moduleGet:k 'ProcessingType'}}
    kHost_saturation        = {{moduleGet:k 'Saturation'}}

    kHost_envelope_amount   = {{moduleGet:k 'EnvelopeAmount'}}
    iHost_envelope_attack   = {{moduleGet:i 'EnvelopeAttack'}}
    iHost_envelope_decay    = {{moduleGet:i 'EnvelopeDecay'}}
    iHost_envelope_sustain  = {{moduleGet:i 'EnvelopeSustain'}}
    iHost_envelope_release  = {{moduleGet:i 'EnvelopeRelease'}}

    kCutoff = lag(kHost_cutoff, iLagTime)
    kCutoff = expcurve(kCutoff, 10)

    kEnvelopeAmount = lag(kHost_envelope_amount, iLagTime)
    kEnvelopeAmount = expcurve(kEnvelopeAmount, 10)
    kEnvelopeAmount = min(kCutoff + kEnvelopeAmount, 1) - kCutoff

    // Apply cutoff envelope.
    kEnvelope = madsr:k(iHost_envelope_attack, iHost_envelope_decay, iHost_envelope_sustain, iHost_envelope_release) * kEnvelopeAmount
    kCutoff += expcurve(kEnvelope, 10)

    // Convert cutoff from range [0, 1] to [0, 20000].
    kCutoff *= 20000

    if (kHost_filter_type == {{filter_01.filter_type.LowPass}}) then
        aOut = K35_lpf:a(aIn, kCutoff, kHost_q, kHost_processing_type, kHost_saturation)
    elseif (kHost_filter_type == {{filter_01.filter_type.HighPass}}) then
        aOut = K35_hpf:a(aIn, kCutoff, kHost_q, kHost_processing_type, kHost_saturation)
    endif

end:
    xout(aOut)
endop
