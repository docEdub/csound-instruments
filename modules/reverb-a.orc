/*
 *  reverb-a.orc
 *
 *  Mono input, stereo output reverb implemented using the `reverbsc` opcode.
 */

{{DeclareModule 'Reverb_A'}}

/// Mono input, stereo output reverb implemented using the `reverbsc` opcode.
/// @param 1 Channel prefix used for host automation parameters.
/// @param 2 A-rate input signal.
/// @out A-rate output signals.
///
opcode AF_Module_{{ModuleName}}, aa, Sa
    S_channelPrefix, a_in xin
    i_instanceIndex = {{hostValueGet}}:i(S_channelPrefix)

    if ({{moduleGet:k 'Enabled'}} == {{false}}) then
        a_out_l = a_in
        a_out_r = a_in
        kgoto end
    endif

    k_size      = {{moduleGet:k 'Size'}}
    k_cutoff    = {{moduleGet:k 'Cutoff'}}
    k_mix       = {{moduleGet:k 'Mix'}}

    a_tmp init 0
    a_reverb_l, a_reverb_r reverbsc a_in, a_tmp, k_size, k_cutoff * (sr / 2)

    a_dry = a_in * (1 - k_mix)
    a_out_l = a_dry + a_reverb_l * k_mix
    a_out_r = a_dry + a_reverb_r * k_mix

end:
    xout(a_out_l, a_out_r)
endop
