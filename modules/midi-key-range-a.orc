/*
 *  midi-key-range-a.orc
 */

{{DeclareModule 'MidiKeyRange_A'}}

{{#with MidiKeyRange_A}}


/// Returns `1` if given key is within the module's key range, otherwise returns `0`.
///
opcode {{Module_public}}, i, Si
    S_channelPrefix, i_key xin
    i_instanceIndex = {{hostValueGet}}:i(S_channelPrefix)

    if ({{moduleGet:i 'Enabled'}} == $false) then
        i_out = $true
        goto end
    endif

    i_high   = {{moduleGet:i 'High'}}
    i_low  = {{moduleGet:i 'Low'}}
    if (i_low <= i_key && i_key <= i_high) then
        i_out = 1
    else
        i_out = 0
    endif

end:
    xout(i_out)
endop


{{/with}}
