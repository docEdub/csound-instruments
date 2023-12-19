/*
 *  envelope-a.orc
 *
 *  Envelope generator module with exponential attack, decay, and release segments using the `mxadsr` opcode.
 */

{{DeclareModule 'Envelope_A'}}

/// Generates an exponential ADSR envelope using the `mxadsr` opcode.
/// @param 1 Channel prefix used for host automation parameters.
/// @out A-rate envelope.
///
opcode AF_Module_{{ModuleName}}, a, S
    S_channelPrefix xin
    i_channelIndex = {{hostValueGet}}:i(S_channelPrefix)

    if ({{moduleGet:k 'Enabled'}} == {{false}}) then
        a_out = 1
        kgoto end
    endif

    i_a = {{moduleGet:i 'Attack'}}
    i_d = {{moduleGet:i 'Decay'}}
    i_s = {{moduleGet:i 'Sustain'}}
    i_r = {{moduleGet:i 'Release'}}

    a_out = mxadsr:a(i_a, i_d, i_s, i_r) - 0.001;

end:
    xout(a_out)
endop
