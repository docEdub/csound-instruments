/*
 *  volume-a.orc
 *
 *  Volume module.
 */

{{DeclareModule 'Volume_A'}}

/// Volume.
/// @param 1 Channel prefix used for host automation parameters.
/// @out k-rate amp output.
///
opcode {{Module_public}}, k, S
    S_channelPrefix xin
    i_instanceIndex = {{hostValueGet}}:i(S_channelPrefix)

    if ({{moduleGet:k 'Enabled'}} == $false) then
        k_out = 1
        kgoto end
    endif

    if ({{moduleGet:k 'Mute'}} == $true) then
        k_out = 0
        kgoto end
    endif

    k_out = {{moduleGet:k 'Amp'}}

end:
    xout(k_out)
endop
