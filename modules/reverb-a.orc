/*
 *  reverb-a.orc
 *
 *  Stereo input and output reverb implemented using the `reverbsc` opcode.
 */

{{DeclareModule 'Reverb_A'}}

/// Stereo input and output reverb implemented using the `reverbsc` opcode.
/// @param 1 Channel prefix used for host automation parameters.
/// @param 2 A-rate input left signal.
/// @param 2 A-rate input right signal.
/// @out A-rate output signals.
///
opcode AF_Module_{{ModuleName}}, aa, Saa
    S_channelPrefix, a_in_l, a_in_r xin
    i_instanceIndex = {{hostValueGet}}:i(S_channelPrefix)

    if ({{moduleGet:k 'Enabled'}} == {{false}}) then
        a_out_l = a_in_l
        a_out_r = a_in_r
        kgoto end
    endif

    k_size      = {{moduleGet:k 'Size'}}
    k_cutoff    = {{moduleGet:k 'Cutoff'}}
    k_mix       = {{moduleGet:k 'Mix'}}

    a_reverb_l, a_reverb_r reverbsc a_in_l, a_in_r, k_size, k_cutoff * (sr / 2)

    a_dry_l = a_in_l * (1 - k_mix)
    a_dry_r = a_in_r * (1 - k_mix)
    a_out_l = a_dry_l + a_reverb_l * k_mix
    a_out_r = a_dry_r + a_reverb_r * k_mix

end:
    xout(a_out_l, a_out_r)
endop
