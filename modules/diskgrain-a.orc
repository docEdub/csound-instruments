/*
 *  diskgrain-a.orc
 */

{{DeclareModule 'DiskGrain_A'}}

{{#with DiskGrain_A}}

// Generate grain window tables using GEN20.
gi_windowTypeTableNumbers[] init {{eval '(Object.keys(global.json["DiskGrain_A"].WindowType).length + 1)'}}
ii = 1
while (ii < lenarray(gi_windowTypeTableNumbers)) do
    gi_windowTypeTableNumbers[ii] = ftgen(0, 0, 16384, 20, ii)
    ii += 1
od


opcode {{Module_public}}, a, SS
    S_channelPrefix, S_sourceFilename xin
    i_instanceIndex = {{hostValueGet}}:i(S_channelPrefix)

    {{LogDebug_i '("DiskGrain: S_sourceFilename = %s", S_sourceFilename)'}}

    if ({{moduleGet:k 'Enabled'}} == $false) then
        a_out = 0
        kgoto end
    endif

    i_maxFrequency = {{moduleGet:i 'MaxFrequency'}}
    i_maxSize = {{moduleGet:i 'MaxSize'}}
    i_startOffset = {{moduleGet:i 'Offset'}}
    i_windowType = {{moduleGet:i 'Window'}}

    k_amp = {{moduleGet:k 'Amp'}}
    k_frequency = {{moduleGet:k 'Frequency'}}
    k_pitch = {{moduleGet:k 'Pitch'}}
    k_size = {{moduleGet:k 'Size'}}
    k_pointerRate = {{moduleGet:k 'PointerRate'}}
    k_pointerDirection = {{moduleGet:k 'PointerDirection'}}

    if (k_pointerDirection == {{eval '(Constants.DiskGrain_A.PointerDirectionType.Reverse)'}}) then
        k_pointerRate = -k_pointerRate
    endif

    a_out = diskgrain:a(S_sourceFilename, k_amp, k_frequency, k_pitch, k_size, k_pointerRate, gi_windowTypeTableNumbers[i_windowType], i_maxFrequency * i_maxSize, i_maxSize, i_startOffset)

end:
    xout(a_out)
endop


{{/with}}
