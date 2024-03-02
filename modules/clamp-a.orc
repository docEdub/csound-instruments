/*
 *  clamp-a.orc
 */

{{DeclareModule 'Clamp_A'}}

opcode {{Module_public}}, k, Sk
    S_channelPrefix, k_in xin
    i_instanceIndex = {{hostValueGet}}:i(S_channelPrefix)

    if ({{moduleGet:k 'Enabled'}} == $false) then
        k_out = k_in
        kgoto end
    endif

    k_min = {{moduleGet:k 'Min'}}
    k_max = {{moduleGet:k 'Max'}}
    k_out = limit(k_in, k_min, k_max)

end:
    xout(k_out)
endop
