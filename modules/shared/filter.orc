{{includeGuardStart}}

{{include "csound-module/opcodes/moduleGet.orc"}}

/// @internal
opcode _af_shared_filter_frequency, k, S[][][]ii[]p
    S_channels[][][], i_instanceIndex, i_channelIndexes[], i_isMidi xin

    i_lagTime = kr / sr

    k_hostFrequency         = moduleGet:k(S_channels, i_instanceIndex, i_channelIndexes[0])
    k_hostEnvelopeAmount    = moduleGet:k(S_channels, i_instanceIndex, i_channelIndexes[1])
    i_hostEnvelopeAttack    = moduleGet:i(S_channels, i_instanceIndex, i_channelIndexes[2])
    i_hostEnvelopeDecay     = moduleGet:i(S_channels, i_instanceIndex, i_channelIndexes[3])
    i_hostEnvelopeSustain   = moduleGet:i(S_channels, i_instanceIndex, i_channelIndexes[4])
    i_hostEnvelopeRelease   = moduleGet:i(S_channels, i_instanceIndex, i_channelIndexes[5])
    k_keyTracking           = moduleGet:k(S_channels, i_instanceIndex, i_channelIndexes[6])

    k_frequency = lag(k_hostFrequency, i_lagTime)
    k_frequency = expcurve(k_frequency, 10)

    k_envelopeAmount = lag(k_hostEnvelopeAmount, i_lagTime)
    k_envelopeAmount = expcurve(k_envelopeAmount, 10)
    k_envelopeAmount = min(k_frequency + k_envelopeAmount, 1) - k_frequency

    // Apply cutoff envelope.
    if (i_isMidi == $true) then
        k_envelope = madsr:k(i_hostEnvelopeAttack, i_hostEnvelopeDecay, i_hostEnvelopeSustain, i_hostEnvelopeRelease) * k_envelopeAmount
    else
        k_envelope = adsr:k(i_hostEnvelopeAttack, i_hostEnvelopeDecay, i_hostEnvelopeSustain, i_hostEnvelopeRelease) * k_envelopeAmount
    endif
    k_frequency += expcurve(k_envelope, 10)

    // Convert k_frequency from range [0, 1] to [0, 20000].
    k_frequency *= 20000

    // Apply key tracking.
    if (k_keyTracking > 0) then
        i_refCps = cpsmidinn(60)
        i_noteCps = cpsmidinn(notnum()) // TODO: Fix this for when i_isMidi = $false
        k_frequency *= i_noteCps / i_refCps
        k_frequency = min(k_frequency, 20000)
    endif

    xout(k_frequency)
endop

{{includeGuardEnd}}
