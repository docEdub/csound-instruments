/*
 *  lfo-a.orc
 *
 *  Low frequency oscillator generator module.
 */

{{DeclareModule 'LFO_A'}}

/// Generates an LFO using the `lfo` opcode.
/// @param 1 Channel prefix used for host automation parameters.
/// @out K-rate Generated value.
///
opcode AF_Module_{{ModuleName}}, k, S
    S_channelPrefix xin
    i_channelIndex = {{hostValueGet}}:i(S_channelPrefix)

    if ({{moduleGet:k 'Enabled'}} == {{false}}) then
        k_out = 1
        kgoto end
    endif

    i_hostWave  = {{moduleGet:i 'Wave'}}
    k_hostAmp   = {{moduleGet:k 'Amp'}}
    k_hostRate  = {{moduleGet:k 'Rate'}}

    i_lfo_type = \
        i_hostWave == {{LFO_A.Wave.Sine}} ? {{lfo.Type.Sine}} : \
        i_hostWave == {{LFO_A.Wave.Triangle}} ? {{lfo.Type.Triangles}} : \
        i_hostWave == {{LFO_A.Wave.BiSquare}} ? {{lfo.Type.SquareBipolar}} : \
        i_hostWave == {{LFO_A.Wave.UniSquare}} ? {{lfo.Type.SquareUnipolar}} : \
        i_hostWave == {{LFO_A.Wave.Saw}} ? {{lfo.Type.Sawtooth}} : \
        i_hostWave == {{LFO_A.Wave.SawDown}} ? {{lfo.Type.SawtoothDown}} : \
        -1
    k_out = lfo:k(k_hostAmp, k_hostRate, i_lfo_type)

end:
    xout(k_out)
endop

/// Generates an LFO using the `lfo` opcode.
/// @param 1 Channel prefix used for host automation parameters.
/// @out A-rate Generated value.
///
opcode AF_Module_{{ModuleName}}, a, S
    S_channelPrefix xin
    i_channelIndex = {{hostValueGet}}:i(S_channelPrefix)

    if ({{moduleGet:k 'Enabled'}} == {{false}}) then
        a_out = 1
        kgoto end
    endif

    i_hostWave  = {{moduleGet:i 'Wave'}}
    k_hostAmp   = {{moduleGet:k 'Amp'}}
    k_hostRate  = {{moduleGet:k 'Rate'}}

    i_lfo_type = \
        i_hostWave == {{LFO_A.Wave.Sine}} ? {{lfo.Type.Sine}} : \
        i_hostWave == {{LFO_A.Wave.Triangle}} ? {{lfo.Type.Triangles}} : \
        i_hostWave == {{LFO_A.Wave.BiSquare}} ? {{lfo.Type.SquareBipolar}} : \
        i_hostWave == {{LFO_A.Wave.UniSquare}} ? {{lfo.Type.SquareUnipolar}} : \
        i_hostWave == {{LFO_A.Wave.Saw}} ? {{lfo.Type.Sawtooth}} : \
        i_hostWave == {{LFO_A.Wave.SawDown}} ? {{lfo.Type.SawtoothDown}} : \
        -1
    a_out = lfo:a(k_hostAmp, k_hostRate, i_lfo_type)

end:
    xout(a_out)
endop
