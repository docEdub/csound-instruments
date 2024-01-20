/*
 *  polyphony-control-a.orc
 *
 *  Polyphony control module with soft and hard thresholds.
 */

{{DeclareModule 'PolyphonyControl_A' '{ "hasAlwaysOnInstrument": "true", "hasCustomInitialization": "true" }'}}


gk_AF_Module_{{ModuleName}}_activeNotes[][] init 1, 128
gk_AF_Module_{{ModuleName}}_keepHighNote[] init 1
gk_AF_Module_{{ModuleName}}_keepLowNote[] init 1
gk_AF_Module_{{ModuleName}}_highNote[] init 1
gk_AF_Module_{{ModuleName}}_lowNote[] init 1
gk_AF_Module_{{ModuleName}}_hardOffActiveNoteCount[] init 1
gk_AF_Module_{{ModuleName}}_softOffActiveNoteCount[] init 1


opcode _af_module_{{ModuleName}}_updateHighNote, 0, i
    i_instanceIndex xin

    k_currentHighNote = gk_AF_Module_{{ModuleName}}_highNote[i_instanceIndex]

    ki = 128
    while (ki > 0) do
        ki -= 1
        if (gk_AF_Module_{{ModuleName}}_activeNotes[i_instanceIndex][ki] > 0) then
            kgoto end
        endif
    od

end:
    if (k_currentHighNote != ki) then
        gk_AF_Module_{{ModuleName}}_highNote[i_instanceIndex] = ki
    endif

    ; {{LogDebug_k '("PolyphonyControl_A[%d]: High note = %d", i_instanceIndex, gk_AF_Module_PolyphonyControl_A_highNote[i_instanceIndex])'}}
endop


opcode _af_module_{{ModuleName}}_updateLowNote, 0, i
    i_instanceIndex xin

    k_currentLowNote = gk_AF_Module_{{ModuleName}}_lowNote[i_instanceIndex]

    ki = 0
    while (ki < 128) do
        if (gk_AF_Module_{{ModuleName}}_activeNotes[i_instanceIndex][ki] > 0) then
            kgoto end
        endif
        ki += 1
    od
end:
    if (k_currentLowNote != ki) then
        gk_AF_Module_{{ModuleName}}_lowNote[i_instanceIndex] = ki
    endif

    ; {{LogDebug_k '("PolyphonyControl_A[%d]: Low note = %d", i_instanceIndex, gk_AF_Module_PolyphonyControl_A_lowNote[i_instanceIndex])'}}
endop


/// NB: This needs to be called after any relevant envelopes with extended release segments are initialized.
///
opcode AF_Module_{{ModuleName}}, k, S
    S_channelPrefix xin
    i_instanceIndex = {{hostValueGet}}:i(S_channelPrefix)

    k_state init {{PolyphonyControl_A.State.Inactive}}

    if ({{moduleGet:k 'Enabled'}} == {{false}}) then
        kgoto end
    endif

    i_noteNumber = notnum()
    k_initialized init {{false}} // NB: Set to `true` at end of opcode.
    if (k_initialized == {{false}}) then
        ; {{LogDebug_k '("PolyphonyControl_A[%d]: Note %d on", i_instanceIndex, i_noteNumber)'}}
        gk_AF_Module_{{ModuleName}}_hardOffActiveNoteCount[i_instanceIndex] = gk_AF_Module_{{ModuleName}}_hardOffActiveNoteCount[i_instanceIndex] + 1
        gk_AF_Module_{{ModuleName}}_softOffActiveNoteCount[i_instanceIndex] = gk_AF_Module_{{ModuleName}}_softOffActiveNoteCount[i_instanceIndex] + 1
        gk_AF_Module_{{ModuleName}}_activeNotes[i_instanceIndex][i_noteNumber] = gk_AF_Module_{{ModuleName}}_activeNotes[i_instanceIndex][i_noteNumber] + 1
        _af_module_{{ModuleName}}_updateHighNote(i_instanceIndex)
        _af_module_{{ModuleName}}_updateLowNote(i_instanceIndex)
    endif

    k_released = release()

    i_softMax           = {{moduleGet:i 'SoftMax'}}
    i_hardMax           = {{moduleGet:i 'HardMax'}}
    i_softOffFadeTime   = {{moduleGet:i 'SoftOffFadeTime'}}

    k_hardTurnoffActivated init {{false}}
    k_softTurnoffActivated init {{false}}

    // If hard off was activated on the last k-pass, set state to `Off`.
    if (k_hardTurnoffActivated == {{true}}) then
        k_state = {{PolyphonyControl_A.State.Off}}
    endif

    // Return if state is `Off`.
    if (k_state == {{PolyphonyControl_A.State.Off}}) then
        kgoto end
    endif

    if (k_initialized == {{false}}) then
        k_skip = {{true}}
    else
        k_skip = {{false}}
        if (k_released == {{false}}) then
            if (gk_AF_Module_{{ModuleName}}_keepHighNote[i_instanceIndex] == {{true}} \
                    && gk_AF_Module_{{ModuleName}}_highNote[i_instanceIndex] == i_noteNumber \
                    && gk_AF_Module_{{ModuleName}}_activeNotes[i_instanceIndex][i_noteNumber] == 1) then
                k_skip = {{true}}
            elseif (gk_AF_Module_{{ModuleName}}_keepLowNote[i_instanceIndex] == {{true}} \
                        && gk_AF_Module_{{ModuleName}}_lowNote[i_instanceIndex] == i_noteNumber \
                        && gk_AF_Module_{{ModuleName}}_activeNotes[i_instanceIndex][i_noteNumber] == 1) then
                k_skip = {{true}}
            endif
        endif
    endif

    ; if (k_skip == {{true}}) then
    ;     {{LogDebug_k '("PolyphonyControl_A[%d]: Note %d skipped", i_instanceIndex, i_noteNumber)'}}
    ; endif

    if (k_skip == {{false}}) then
        k_hardOffActiveNoteCount = gk_AF_Module_{{ModuleName}}_hardOffActiveNoteCount[i_instanceIndex]
        k_softOffActiveNoteCount = gk_AF_Module_{{ModuleName}}_softOffActiveNoteCount[i_instanceIndex]

        if (k_hardOffActiveNoteCount > i_hardMax) then
            ; {{LogTrace_k '("PolyphonyControl_A[%d]: Note %d hard off activated", i_instanceIndex, i_noteNumber)'}}
            k_hardTurnoffActivated = {{true}}
            gk_AF_Module_{{ModuleName}}_hardOffActiveNoteCount[i_instanceIndex] = k_hardOffActiveNoteCount - 1
            if (k_softTurnoffActivated == {{false}}) then
                gk_AF_Module_{{ModuleName}}_softOffActiveNoteCount[i_instanceIndex] = k_softOffActiveNoteCount - 1
            endif
            k_state = {{PolyphonyControl_A.State.HardOff}}
        elseif (k_softTurnoffActivated == {{false}} && k_softOffActiveNoteCount > i_softMax) then
            ; {{LogTrace_k '("PolyphonyControl_A[%d]: Note %d soft off activated", i_instanceIndex, i_noteNumber)'}}
            k_softTurnoffActivated = {{true}}
            gk_AF_Module_{{ModuleName}}_softOffActiveNoteCount[i_instanceIndex] = k_softOffActiveNoteCount - 1
            k_state = {{PolyphonyControl_A.State.SoftOff}}
        endif

        if (k_softTurnoffActivated == {{true}}) then
            k_fadeOutTime init i_softOffFadeTime
            k_fadeOutTime -= gi_secondsPerKPass
            if (k_fadeOutTime <= 0) then
                ; {{LogTrace_k '("PolyphonyControl_A[%d]: Note %d soft off fade done", i_instanceIndex, i_noteNumber)'}}
                k_state = {{PolyphonyControl_A.State.Off}}
            endif
        endif
    endif

    if (k_state == {{PolyphonyControl_A.State.Off}} || lastcycle() == {{true}}) then
        if (k_hardTurnoffActivated == {{false}}) then
            gk_AF_Module_{{ModuleName}}_hardOffActiveNoteCount[i_instanceIndex] = k_hardOffActiveNoteCount - 1
        endif
        if (k_softTurnoffActivated == {{false}}) then
            gk_AF_Module_{{ModuleName}}_softOffActiveNoteCount[i_instanceIndex] = k_softOffActiveNoteCount - 1
        endif
    endif

end:
    k_deinitialized init {{false}}
    if (k_deinitialized == {{false}} && (k_released == {{true}} || k_state == {{PolyphonyControl_A.State.Off}} || k_hardTurnoffActivated == {{true}} || k_softTurnoffActivated == {{true}})) then
        ; {{LogDebug_k '("PolyphonyControl_A[%d]: Note %d off", i_instanceIndex, i_noteNumber)'}}
        gk_AF_Module_{{ModuleName}}_activeNotes[i_instanceIndex][i_noteNumber] = gk_AF_Module_{{ModuleName}}_activeNotes[i_instanceIndex][i_noteNumber] - 1
        _af_module_{{ModuleName}}_updateHighNote(i_instanceIndex)
        _af_module_{{ModuleName}}_updateLowNote(i_instanceIndex)
        if (k_released == {{true}} && k_state == {{PolyphonyControl_A.State.SoftOn}}) then
            k_state = {{PolyphonyControl_A.State.Inactive}}
        endif
        k_deinitialized = {{true}}
    endif

    if (k_state == {{PolyphonyControl_A.State.Off}} && k_released == {{false}}) then
        k_softOnActivated = {{false}}
        if (gk_AF_Module_{{ModuleName}}_highNote[i_instanceIndex] < i_noteNumber) then
            k_softOnActivated = {{true}}
        endif
        if (gk_AF_Module_{{ModuleName}}_lowNote[i_instanceIndex] > i_noteNumber) then
            k_softOnActivated = {{true}}
        endif
        if (k_softOnActivated == {{true}}) then
            ; {{LogTrace_k '("PolyphonyControl_A[%d]: Note %d soft on activated", i_instanceIndex, i_noteNumber)'}}
            k_state = {{PolyphonyControl_A.State.SoftOn}}
            gk_AF_Module_{{ModuleName}}_activeNotes[i_instanceIndex][i_noteNumber] = gk_AF_Module_{{ModuleName}}_activeNotes[i_instanceIndex][i_noteNumber] + 1
            gk_AF_Module_{{ModuleName}}_hardOffActiveNoteCount[i_instanceIndex] = gk_AF_Module_{{ModuleName}}_hardOffActiveNoteCount[i_instanceIndex] + 1
            gk_AF_Module_{{ModuleName}}_softOffActiveNoteCount[i_instanceIndex] = gk_AF_Module_{{ModuleName}}_softOffActiveNoteCount[i_instanceIndex] + 1
            _af_module_{{ModuleName}}_updateHighNote(i_instanceIndex)
            _af_module_{{ModuleName}}_updateLowNote(i_instanceIndex)
            k_fadeOutTime = i_softOffFadeTime
        endif
    endif

    if (k_state == {{PolyphonyControl_A.State.SoftOn}}) then
        k_hardTurnoffActivated = {{false}}
        k_softTurnoffActivated = {{false}}
        k_softOnActivated = {{false}}
        k_deinitialized = {{false}}

        k_fadeInTime init i_softOffFadeTime
        k_fadeInTime -= gi_secondsPerKPass
        if (k_fadeInTime <= 0) then
            ; {{LogTrace_k '("PolyphonyControl_A[%d]: Note %d soft on fade done", i_instanceIndex, i_noteNumber)'}}
            k_state = {{PolyphonyControl_A.State.Inactive}}
        endif
    endif

    k_initialized = {{true}}

    xout(k_state)
endop


opcode AF_Module_{{ModuleName}}_audioProcessing, a, Sak
    S_channelPrefix, a_out, k_state xin
    i_instanceIndex = {{hostValueGet}}:i(S_channelPrefix)

    i_softFadeTime = {{moduleGet:i 'SoftOffFadeTime'}}
    i_fadeAmount = 1 / (kr * i_softFadeTime)

    k_previousState init {{PolyphonyControl_A.State.Inactive}}
    k_amp init 1
    k_fadeAmount init i_fadeAmount

    if (k_state == {{PolyphonyControl_A.State.HardOff}}) then
        k_off init {{false}}

        // Search the audio output buffer for the first zero crossing.
        ki = 1
        k_prevSample = vaget(0, a_out)
        if (k_prevSample == 0) then
            k_off = {{true}}
        endif
        while (k_off == {{false}} && ki < ksmps) do
            k_sample = vaget(ki, a_out)
            if ((k_sample < 0 && k_prevSample > 0) || (k_sample > 0 && k_prevSample < 0) || k_sample == 0) then
                k_off = {{true}}
            endif
            ki += 1
        od
        if (k_off == {{true}}) then
            // Clear the rest of the audio output buffer.
            while (ki < ksmps) do
                vaset(0, ki, a_out)
                ki += 1
            od
        endif
        k_amp = 0
    elseif (k_state == {{PolyphonyControl_A.State.SoftOff}}) then
        if (k_state != k_previousState) then
            k_fadeAmount = k_amp * i_fadeAmount
            ; {{LogDebug_k '("PolyphonyControl_A[%d]: Note %d soft off amp = %f, fade amount = -%f", i_instanceIndex, notnum(), k_amp, k_fadeAmount)'}}
        endif
        // Fade out ...
        k_amp -= k_fadeAmount
        k_amp = max(0, k_amp)
        ; {{LogDebug_k '("PolyphonyControl_A[%d]: Note %d soft off amp = %f", i_instanceIndex, notnum(), k_amp)'}}

        a_amp = a(k_amp)
        a_out *= a_amp
    elseif (k_state == {{PolyphonyControl_A.State.SoftOn}} && release() == {{false}}) then
        if (k_state != k_previousState) then
            k_fadeAmount = (k(1) - k_amp) * i_fadeAmount
            ; {{LogDebug_k '("PolyphonyControl_A[%d]: Note %d soft on amp = %f, fade amount = +%f", i_instanceIndex, notnum(), k_amp, k_fadeAmount)'}}
        endif
        k_amp += k_fadeAmount
        k_amp = min(k_amp, 1)
        ; {{LogDebug_k '("PolyphonyControl_A[%d]: Note %d soft on amp = %f", i_instanceIndex, notnum(), k_amp)'}}

        a_amp = a(k_amp)
        a_out *= a_amp
    endif

    k_previousState = k_state

    xout(a_out)
endop


instr AF_Module_{{ModuleName}}_alwayson
    S_channelPrefix = p4
    i_instanceIndex = {{hostValueGet}}:i(S_channelPrefix)

    ; {{LogTrace_i '("AF_Module_PolyphonyControl_A_alwayson: i_instanceIndex = %d", i_instanceIndex)'}}

    gk_AF_Module_{{ModuleName}}_keepHighNote[i_instanceIndex]   = {{moduleGet:k 'KeepHighNote'}}
    gk_AF_Module_{{ModuleName}}_keepLowNote[i_instanceIndex]    = {{moduleGet:k 'KeepLowNote'}}
endin


instr AF_Module_{{ModuleName}}_customInit
    S_channelPrefix = p4
    i_instanceIndex = {{hostValueGet}}:i(S_channelPrefix)

    ; {{LogTrace_i '("AF_Module_PolyphonyControl_A_customInit: i_instanceIndex = %d", i_instanceIndex)'}}

    if (i_instanceIndex <= lenarray(gk_AF_Module_{{ModuleName}}_softOffActiveNoteCount)) then
        i_arrayLength = i_instanceIndex + 1
        gk_AF_Module_{{ModuleName}}_activeNotes[][] init i_arrayLength, 128
        gk_AF_Module_{{ModuleName}}_keepHighNote[] init i_arrayLength
        gk_AF_Module_{{ModuleName}}_keepLowNote[] init i_arrayLength
        gk_AF_Module_{{ModuleName}}_highNote[] init i_arrayLength
        gk_AF_Module_{{ModuleName}}_lowNote[] init i_arrayLength
        gk_AF_Module_{{ModuleName}}_softOffActiveNoteCount[] init i_arrayLength
        gk_AF_Module_{{ModuleName}}_hardOffActiveNoteCount[] init i_arrayLength
    endif

    ; {{LogTrace_i '("AF_Module_PolyphonyControl_A_customInit: global array lengths = %d", lenarray(gk_AF_Module_PolyphonyControl_A_softOffActiveNoteCount))'}}
endin
