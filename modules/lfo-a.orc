/*
 *  lfo-a.orc
 *
 *  Low frequency oscillator generator module.
 */

{{DeclareModule 'LFO_A'}}

{{#with LFO_A}}


/// Generates an LFO using the `lfo` opcode.
/// @param 1 Channel prefix used for host automation parameters.
/// @out K-rate Generated value.
///
opcode {{Module_public}}, k, S
    S_channelPrefix xin
    i_instanceIndex = {{hostValueGet}}:i(S_channelPrefix)

    if ({{moduleGet:k 'Enabled'}} == $false) then
        k_out = 1
        kgoto end
    endif

    i_hostWave  = {{moduleGet:i 'Wave'}}
    k_hostAmp   = {{moduleGet:k 'Amp'}}
    k_hostRate  = {{moduleGet:k 'Rate'}}

    i_lfo_type = \
        i_hostWave == {{Wave.Sine}} ? {{../lfo.Type.Sine}} : \
        i_hostWave == {{Wave.Triangle}} ? {{../lfo.Type.Triangles}} : \
        i_hostWave == {{Wave.BiSquare}} ? {{../lfo.Type.SquareBipolar}} : \
        i_hostWave == {{Wave.UniSquare}} ? {{../lfo.Type.SquareUnipolar}} : \
        i_hostWave == {{Wave.Saw}} ? {{../lfo.Type.Sawtooth}} : \
        i_hostWave == {{Wave.SawDown}} ? {{../lfo.Type.SawtoothDown}} : \
        -1
    k_out = lfo:k(k_hostAmp, k_hostRate, i_lfo_type)

end:
    xout(k_out)
endop

/// Generates an LFO using the `lfo` opcode.
/// @param 1 Channel prefix used for host automation parameters.
/// @out A-rate Generated value.
///
opcode {{Module_public}}, a, S
    S_channelPrefix xin
    i_instanceIndex = {{hostValueGet}}:i(S_channelPrefix)

    if ({{moduleGet:k 'Enabled'}} == $false) then
        a_out = 1
        kgoto end
    endif

    i_hostWave  = {{moduleGet:i 'Wave'}}
    k_hostAmp   = {{moduleGet:k 'Amp'}}
    k_hostRate  = {{moduleGet:k 'Rate'}}

    i_lfo_type = \
        i_hostWave == {{Wave.Sine}} ? {{../lfo.Type.Sine}} : \
        i_hostWave == {{Wave.Triangle}} ? {{../lfo.Type.Triangles}} : \
        i_hostWave == {{Wave.BiSquare}} ? {{../lfo.Type.SquareBipolar}} : \
        i_hostWave == {{Wave.UniSquare}} ? {{../lfo.Type.SquareUnipolar}} : \
        i_hostWave == {{Wave.Saw}} ? {{../lfo.Type.Sawtooth}} : \
        i_hostWave == {{Wave.SawDown}} ? {{../lfo.Type.SawtoothDown}} : \
        -1
    a_out = lfo:a(k_hostAmp, k_hostRate, i_lfo_type)

end:
    xout(a_out)
endop


{{/with}}
