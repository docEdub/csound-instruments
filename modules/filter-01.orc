/*
 *  filter-01.orc
 *
 *  Filter module with high, and low pass options implemented using the `K35_hpf` and `K35_lpf opcodes.
 */

gS_filter_01_module_channels[][] init 1, {{eval '(Object.keys(constants.filter_01.channel).length)'}}
gi_filter_01_module_instance_count init 0

/// @internal
opcode _filter_01_module_get, i, ii
    iInstanceIndex, iChannelIndex xin
    xout({{getHostValue}}:i(gS_filter_01_module_channels[iInstanceIndex][iChannelIndex - 1]))
endop

/// @internal
opcode _filter_01_module_get, k, ii
    iInstanceIndex, iChannelIndex xin
    xout({{getHostValue}}:k(gS_filter_01_module_channels[iInstanceIndex][iChannelIndex - 1]))
endop

/// @internal
opcode _filter_01_module_set, 0, iik
    iInstanceIndex, iChannelIndex, kValue xin
    {{setHostValue}}(gS_filter_01_module_channels[iInstanceIndex][iChannelIndex - 1], kValue)
endop

/// Filter module with high, and low pass options implemented using the `K35_hpf` and `K35_lpf opcodes.
/// @param 1 String channel prefix used for host automation parameters.
/// @param 2 A-rate input signal.
/// @out A-rate envelope.
///
opcode AF_filter_01_module, a, Sa
    SChannelPrefix, aIn xin
    iLagTime = kr / sr

    ii = {{getHostValue}}:i(SChannelPrefix)

    if (_filter_01_module_get:k(ii, {{filter_01.channel.Enabled}}) == {{false}}) then
        aOut = aIn
        kgoto end
    endif

    kHost_filter_type       = _filter_01_module_get:k(ii, {{filter_01.channel.FilterType}})
    kHost_cutoff            = _filter_01_module_get:k(ii, {{filter_01.channel.Cutoff}})
    kHost_q                 = _filter_01_module_get:k(ii, {{filter_01.channel.Q}})
    kHost_processing_type   = _filter_01_module_get:k(ii, {{filter_01.channel.ProcessingType}})
    kHost_saturation        = _filter_01_module_get:k(ii, {{filter_01.channel.Saturation}})
    kHost_envelope_amount   = _filter_01_module_get:k(ii, {{filter_01.channel.EnvelopeAmount}})
    iHost_envelope_attack   = _filter_01_module_get:i(ii, {{filter_01.channel.EnvelopeAttack}})
    iHost_envelope_decay    = _filter_01_module_get:i(ii, {{filter_01.channel.EnvelopeDecay}})
    iHost_envelope_sustain  = _filter_01_module_get:i(ii, {{filter_01.channel.EnvelopeSustain}})
    iHost_envelope_release  = _filter_01_module_get:i(ii, {{filter_01.channel.EnvelopeRelease}})

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

/// Initialization instrument for the `filter_01` module.
/// @param 4 Channel prefix used for host automation parameters. Should match the channel prefix used for the `AF_filter_01_module` opcode.
///
instr AF_filter_01_module
    SChannelPrefix = p4

    iModuleInstanceIndex = gi_filter_01_module_instance_count
    gi_filter_01_module_instance_count += 1

    // Initialize the channel array using the channel object keys declared in filter-01.ui.json.
    SChannelSuffixes[] = fillarray({{eval '(asStrings(Object.keys(constants.filter_01.channel)))'}})

    // Grow the global channels array if needed.
    if (lenarray:i(gS_filter_01_module_channels) < gi_filter_01_module_instance_count) then
        S_filter_01_module_channels[][] init gi_filter_01_module_instance_count, lenarray(SChannelSuffixes)
        ii = 0
        until (ii == iModuleInstanceIndex) do
            ij = 0
            until (ij == lenarray(SChannelSuffixes)) do
                S_filter_01_module_channels[ii][ij] = gS_filter_01_module_channels[ii][ij]
                ij += 1
            od
            ii += 1
        od

        SChannel = strcat(SChannelPrefix, "_")
        ii = 0
        until (ii == lenarray(SChannelSuffixes)) do
            S_filter_01_module_channels[iModuleInstanceIndex][ii] = strcat(SChannel, SChannelSuffixes[ii])
            ii += 1
        od

        gS_filter_01_module_channels = S_filter_01_module_channels
    else
        SChannel = strcat(SChannelPrefix, "_")
        ii = 0
        until (ii == lenarray(SChannelSuffixes)) do
            gS_filter_01_module_channels[iModuleInstanceIndex][ii] = strcat(SChannel, SChannelSuffixes[ii])
            ii += 1
        od
    endif

    // Set the instance index channel value for the module's UDO.
    {{setHostValue}}(SChannelPrefix, iModuleInstanceIndex)
end:
endin
