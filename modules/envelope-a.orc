/*
 *  envelope-a.orc
 *
 *  ADSR envelope generator module with linear attack and decay segments, and an exponential release segment.
 */

{{DeclareModule 'Envelope_A'}}

/// Generates an ADSR envelope with linear attack and decay segments, and an exponential release segment.
/// @param 1 Channel prefix used for host automation parameters.
/// @param 2 Optional flag indicating whether the module is controlled by MIDI (default = true).
/// @out k-rate envelope.
///
opcode {{Module_public}}, k, Sp
    S_channelPrefix, i_isMidi xin
    i_instanceIndex = {{hostValueGet}}:i(S_channelPrefix)

    if ({{moduleGet:k 'Enabled'}} == $false) then
        k_out = 1
        kgoto end
    endif

    i_a = {{moduleGet:i 'Attack'}}
    i_d = {{moduleGet:i 'Decay'}}
    i_s = {{moduleGet:i 'Sustain'}}
    i_r = {{moduleGet:i 'Release'}} * 2

    k_out init 0

    if (release() == $false) then
        // Linear attack and decay segments.
        if (i_isMidi == $true) then
            k_out = madsr:k(i_a, i_d, i_s, 0);
        else
            k_out = adsr:k(i_a, i_d, i_s, 0);
        endif
    else
        // Exponential release segment.
        k_releaseStartAmp init -1
        if (k_releaseStartAmp == -1) then
            k_releaseStartAmp = k_out
        endif
        k_releaseDecay = expsegr(1.001, 1, 1.001, i_r, 0.001) - 0.001
        k_out = k_releaseDecay * k_releaseStartAmp
    endif

end:
    xout(k_out)
endop


/// Generates an ADSR envelope with linear attack and decay segments, and an exponential release segment.
/// @param 1 Channel prefix used for host automation parameters.
/// @param 2 Optional flag indicating whether the module is controlled by MIDI (default = true).
/// @out A-rate envelope.
///
opcode {{Module_public}}, a, Sp
    S_channelPrefix, i_isMidi xin
    i_instanceIndex = {{hostValueGet}}:i(S_channelPrefix)

    if ({{moduleGet:k 'Enabled'}} == $false) then
        a_out = 1
        kgoto end
    endif

    i_a = {{moduleGet:i 'Attack'}}
    i_d = {{moduleGet:i 'Decay'}}
    i_s = {{moduleGet:i 'Sustain'}}
    i_r = {{moduleGet:i 'Release'}}

    a_out init 0

    if (release() == $false) then
        // Linear attack and decay segments.
        if (i_isMidi == $true) then
            a_out = madsr:a(i_a, i_d, i_s, 0);
        else
            a_out = adsr:a(i_a, i_d, i_s, 0);
        endif
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
