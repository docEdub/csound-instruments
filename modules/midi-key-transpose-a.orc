/*
 *  midi-key-transpose-a.orc
 */

{{DeclareModule 'MidiKeyTranspose_A'}}

{{#with MidiKeyTranspose_A}}


/// Returns `1` if given key is within the module's key range, otherwise returns `0`.
///
opcode {{Module_public}}, i, S
    S_channelPrefix xin
    i_instanceIndex = {{hostValueGet}}:i(S_channelPrefix)

    if ({{moduleGet:i 'Enabled'}} == $false) then
        i_offset = 0
        goto end
    endif

    i_offset = {{moduleGet:i 'Offset'}}

end:
    xout(i_offset)
endop


{{/with}}
