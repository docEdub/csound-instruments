/*
 *  envelope-01.orc
 *
 *  Envelope generator module with exponential attack, decay, and release segments using the `mxadsr` opcode.
 */

{{DeclareModule 'envelope_01'}}

/// Generates an exponential ADSR envelope using the `mxadsr` opcode.
/// @param 1 Channel prefix used for host automation parameters.
/// @out A-rate envelope.
///
opcode AF_{{ModuleName}}_module, a, S
    SChannelPrefix xin
    i_channelIndex = {{hostValueGet}}:i(SChannelPrefix)

    if ({{moduleGet:k 'Enabled'}} == {{false}}) then
        aOut = 1
        kgoto end
    endif

    iA = {{moduleGet:i 'Attack'}}
    iD = {{moduleGet:i 'Decay'}}
    iS = {{moduleGet:i 'Sustain'}}
    iR = {{moduleGet:i 'Release'}}

    aOut = mxadsr:a(iA, iD, iS, iR) - 0.001;

end:
    xout(aOut)
endop
