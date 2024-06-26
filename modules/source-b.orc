/*
 *  source-a.orc
 *
 *  Audio source module with one sine wave oscillator.
 *
 *  The `poscil3` opcode is used for the sine wave.
 */

{{DeclareModule 'Source_B'}}

{{#with Source_B}}


/// Generates sine wave audio using poscil3 opcode.
/// @param 1 Channel prefix used for host automation parameters.
/// @out Mono audio signal generated by the oscillator.
///
opcode {{Module_public}}, a, Sk
    S_channelPrefix, k_noteNumber xin
    i_instanceIndex = {{hostValueGet}}:i(S_channelPrefix)

    a_out = 0

    if ({{moduleGet:k 'Enabled'}} == $false) then
        kgoto end
    endif

    a_out = poscil3:a(k(1), cpsmidinn(k_noteNumber)) * 0.1

end:
    xout(a_out)
endop


{{/with}}
