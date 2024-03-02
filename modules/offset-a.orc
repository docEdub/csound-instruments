/*
 *  offset-a.orc
 */

{{DeclareModule 'Offset_A'}}


opcode {{Module_public}}, k, S
    S_channelPrefix xin
    i_instanceIndex = {{hostValueGet}}:i(S_channelPrefix)

    if ({{moduleGet:k 'Enabled'}} == $false) then
        k_out = 0
        kgoto end
    endif

    k_out = {{moduleGet:k 'Amount'}}

end:
    xout(k_out)
endop
