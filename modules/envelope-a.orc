/*
 *  envelope-a.orc
 *
 *  ADSR envelope generator module with linear attack and decay segments, and an exponential release segment.
 */

{{DeclareModule 'Envelope_A'}}

/// Generates an ADSR envelope with linear attack and decay segments, and an exponential release segment.
/// @param 1 Channel prefix used for host automation parameters.
/// @out A-rate envelope.
///
opcode AF_Module_{{ModuleName}}, a, S
    S_channelPrefix xin
    i_instanceIndex = {{hostValueGet}}:i(S_channelPrefix)

    if ({{moduleGet:k 'Enabled'}} == {{false}}) then
        a_out = 1
        kgoto end
    endif

    i_a = {{moduleGet:i 'Attack'}}
    i_d = {{moduleGet:i 'Decay'}}
    i_s = {{moduleGet:i 'Sustain'}}
    i_r = {{moduleGet:i 'Release'}}

    a_out init 0

    if (release() == {{false}}) then
        // Linear attack and decay segments.
        a_out = madsr:a(i_a, i_d, i_s, 0);
    else
        // Exponential release segment.
        k_releaseStartAmp init -1
        if (k_releaseStartAmp == -1) then
            k_releaseStartAmp = vaget(0, a_out)
        endif
        a_releaseDecay = expsegr(1.001, 1, 1.001, i_r, 0.001) - 0.001
        a_out = a_releaseDecay * k_releaseStartAmp
    endif

end:
    xout(a_out)
endop
