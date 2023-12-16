/*
 *  filter-01.orc
 *
 *  Filter module with high, and low pass options implemented using the `K35_hpf` and `K35_lpf opcodes.
 */

/// Filter module with high, and low pass options implemented using the `K35_hpf` and `K35_lpf opcodes.
/// @param 1 String channel prefix used for the host automation parameters.
/// @param 2 A-rate input signal.
/// @out A-rate envelope.
///
opcode AF_filter_01_module, a, Sa
    SChannelPrefix, aIn xin
    iLagTime = kr / sr

    if ({{getHostValue}}:i(strcat(SChannelPrefix, "_enabled")) == {{false}}) then
        aOut = aIn
        goto end
    endif

    kHost_filter_type       = {{getHostValue}}:k(strcat(SChannelPrefix, "_filter_type"))
    kHost_cutoff            = {{getHostValue}}:k(strcat(SChannelPrefix, "_cutoff"))
    kHost_q                 = {{getHostValue}}:k(strcat(SChannelPrefix, "_q"))
    kHost_processing_type   = {{getHostValue}}:k(strcat(SChannelPrefix, "_processing_type"))
    kHost_saturation        = {{getHostValue}}:k(strcat(SChannelPrefix, "_saturation"))
    kHost_envelope_amount   = {{getHostValue}}:k(strcat(SChannelPrefix, "_envelope_amount"))
    iHost_envelope_attack   = {{getHostValue}}:i(strcat(SChannelPrefix, "_envelope_attack"))
    iHost_envelope_decay    = {{getHostValue}}:i(strcat(SChannelPrefix, "_envelope_decay"))
    iHost_envelope_sustain  = {{getHostValue}}:i(strcat(SChannelPrefix, "_envelope_sustain"))
    iHost_envelope_release  = {{getHostValue}}:i(strcat(SChannelPrefix, "_envelope_release"))

    kCutoff = lag(kHost_cutoff, iLagTime)
    kCutoff = expcurve(kCutoff, 10)

    kEnvelopeAmount = lag(kHost_envelope_amount, iLagTime)
    kEnvelopeAmount = expcurve(kEnvelopeAmount, 10)
    kEnvelopeAmount = min(kCutoff + kEnvelopeAmount, 1) - kCutoff
    ; {{LogDebug_k '("kEnvelopeAmount = %f", kEnvelopeAmount)'}}

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
