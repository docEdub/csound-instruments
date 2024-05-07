/*
 *  grain3-a.orc
 */

{{DeclareModule 'Grain3_A'}}

{{#with Grain3_A}}

// Generate grain window tables using GEN20.
gi_windowTypeTableNumbers[] init {{eval '(Object.keys(global.json["Grain3_A"].WindowType).length + 1)'}}
ii = 1
while (ii < lenarray(gi_windowTypeTableNumbers)) do
    gi_windowTypeTableNumbers[ii] = ftgen(0, 0, 16384, 20, ii)
    ii += 1
od


opcode {{Module_public}}, a, Sk
    S_channelPrefix, k_sourceTableNumber xin
    i_instanceIndex = {{hostValueGet}}:i(S_channelPrefix)

    {{LogDebug_i '("Grain3: S_sourceFilename = %s", S_sourceFilename)'}}

    if ({{moduleGet:k 'Enabled'}} == $false) then
        a_out = 0
        kgoto end
    endif

    i_maxDuration = {{moduleGet:i 'MaxDuration'}}
    i_maxDensity = {{moduleGet:i 'MaxDensity'}}
    i_windowType = {{moduleGet:i 'Window'}}

    k_frequency = {{moduleGet:k 'Frequency'}}
    k_phase = {{moduleGet:k 'Phase'}}
    k_duration = {{moduleGet:k 'Duration'}}
    k_density = {{moduleGet:k 'Density'}}
    k_randomFrequencyVariation = {{moduleGet:k 'RandomFrequencyVariation'}}
    k_randomPhaseVariation = {{moduleGet:k 'RandomPhaseVariation'}}

    a_out = grain3:a(k_frequency, k_phase, k_frequency, k_phase, k_duration, k_density, i_maxDensity * i_maxDuration, k_sourceTableNumber, gi_windowTypeTableNumbers[i_windowType], 0, 0)

end:
    xout(a_out)
endop


{{/with}}
