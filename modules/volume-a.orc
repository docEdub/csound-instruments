/*
 *  volume-a.orc
 *
 *  Stereo input and output volume module.
 */

{{DeclareModule 'Volume_A'}}

/// Stereo input and output volume.
/// @param 1 Channel prefix used for host automation parameters.
/// @param 2 A-rate input left signal.
/// @param 2 A-rate input right signal.
/// @out A-rate output signals.
///
opcode AF_Module_{{ModuleName}}, aa, Saa
    S_channelPrefix, a_in_l, a_in_r xin
    i_channelIndex = {{hostValueGet}}:i(S_channelPrefix)

    if ({{moduleGet:k 'Enabled'}} == {{false}}) then
        a_out_l = a_in_l
        a_out_r = a_in_r
        kgoto end
    endif

    k_amp = {{moduleGet:k 'Amp'}}

    a_out_l = a_in_l * k_amp
    a_out_r = a_in_r * k_amp

end:
    xout(a_out_l, a_out_r)
endop
