
/*
 *  envelope-01.orc
 *
 *  Envelope generator module with exponential attack, decay, and release segments using the `mxadsr` opcode.
 */

/// Generates an exponential ADSR envelope using the `mxadsr` opcode.
/// @param 1 Channel prefix used for the host automation parameters.
/// @out A-rate envelope.
///
opcode AF_envelope_01_module, a, S
    SChannelPrefix xin

    if ({{getHostValue}}:i(strcat(SChannelPrefix, "_enabled")) == {{false}}) then
        aOut = 1
        goto end
    endif

    iA = {{getHostValue}}:i(strcat(SChannelPrefix, "_attack"))
    iD = {{getHostValue}}:i(strcat(SChannelPrefix, "_decay"))
    iS = {{getHostValue}}:i(strcat(SChannelPrefix, "_sustain"))
    iR = {{getHostValue}}:i(strcat(SChannelPrefix, "_release"))

    aOut = mxadsr:a(iA, iD, iS, iR);

end:
    xout(aOut)
endop
