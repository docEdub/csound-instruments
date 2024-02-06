/*
 *  polyphony-control-b.orc
 *
 *  Polyphony control module with soft and hard thresholds.
 */

{{DeclareModule 'PolyphonyControl_B' '{ "hasAlwaysOnInstrument": "true", "hasCustomInitialization": "true" }'}}

{{#with PolyphonyControl_B}}

{{Enable-LogTrace false}}
{{Enable-LogDebug false}}


gk_{{Module_private}}_Instance[][] init 1, {{InstanceMemberCount}}
gk_{{Module_private}}_Instance_NoteKeyOnCount[][] init 1, 128
gk_{{Module_private}}_Note[][][] init 1, {{MaxNoteCount}}, {{NoteMemberCount}}


#define Instance                                # gk_{{Module_private}}_Instance[i_instanceIndex] #
#define NoteKeyOnCount                          # gk_{{Module_private}}_Instance_NoteKeyOnCount[i_instanceIndex] #
#define Note                                    # gk_{{Module_private}}_Note[i_instanceIndex][k_noteIndex] #

#define Instance_getNextNoteId()                # {{Module_private}}_Instance_getNextNoteId(i_instanceIndex) #
#define Instance_getNextNoteIndex()             # {{Module_private}}_Instance_getNextNoteIndex(i_instanceIndex) #
#define Instance_updateHighAndLowNoteNumbers()  # {{Module_private}}_Instance_updateHighAndLowNoteNumbers(i_instanceIndex) #

#define Note_initialize()                       # {{Module_private}}_Note_initialize(i_instanceIndex) #
#define Note_updateState(k_currentState)        # {{Module_private}}_Note_updateState(i_instanceIndex, k_noteIndex, k_currentState) #


opcode {{Module_public}}_log_notes, 0, S
    S_channelPrefix xin
    i_instanceIndex = {{hostValueGet}}:i(S_channelPrefix)

    k_noteIndex = 0
    while ($Note[{{Note.Id}}] != -1) do
        {{LogDebug_k '("Note[%d]: id = %d, state = %d", k_noteIndex, $Note[{+{Note.Id}+}], $Note[{+{Note.State}+}])'}}
        k_noteIndex += 1
    od
endop


opcode {{Module_private}}_Instance_getNextNoteId, k, i
    i_instanceIndex xin

    k_noteId = $Instance[{{Instance.NextNoteId}}]
    $Instance[{{Instance.NextNoteId}}] = k_noteId + 1

    xout(k_noteId)
endop


opcode {{Module_private}}_Instance_getNextNoteIndex, k, i
    i_instanceIndex xin
    k_noteIndex init -1

    k_noteIndex = $Instance[{{Instance.NoteCount}}]
    $Instance[{{Instance.NoteCount}}] = k_noteIndex + 1

    xout(k_noteIndex)
endop


opcode {{Module_private}}_Instance_updateHighAndLowNoteNumbers, 0, i
    i_instanceIndex xin

    k_highNoteNumber = -1
    k_lowNoteNumber = 129

    if ($Instance[{{Instance.KeepHighNote}}] == $true) then
        k_noteIndex = 0
        while ($Note[{{Note.Id}}] != -1) do
            k_noteNumber = $Note[{{Note.Number}}]
            k_highNoteNumber = max(k_highNoteNumber, k_noteNumber)
            k_noteIndex += 1
        od
    endif

    if ($Instance[{{Instance.KeepLowNote}}] == $true) then
        k_noteIndex = 0
        while ($Note[{{Note.Id}}] != -1) do
            k_noteNumber = $Note[{{Note.Number}}]
            k_lowNoteNumber = min(k_lowNoteNumber, k_noteNumber)
            k_noteIndex += 1
        od
    endif

    $Instance[{{Instance.HighNoteNumber}}] = k_highNoteNumber
    $Instance[{{Instance.LowNoteNumber}}] = k_lowNoteNumber
    {{LogDebug_k '("Instance[%d].HighNoteNumber = %d", i_instanceIndex, $Instance[{+{Instance.HighNoteNumber}+}])'}}
    {{LogDebug_k '("Instance[%d].LowNoteNumber = %d", i_instanceIndex, $Instance[{+{Instance.LowNoteNumber}+}])'}}
endop


opcode {{Module_private}}_Note_initialize, k, i
    i_instanceIndex xin

    k_noteId init -1
    k_noteIndex init -1

    $Note[{{Note.Duration}}] = timeinsts()

    k_initialized init $false
    if (k_initialized == $false) then
        k_initialized = $true

        $Instance[{{Instance.SoftMax}}]             = {{moduleGet:k 'SoftMax'}}
        $Instance[{{Instance.HardMax}}]             = {{moduleGet:k 'HardMax'}}
        $Instance[{{Instance.KeepHighNote}}]        = {{moduleGet:k 'KeepHighNote'}}
        $Instance[{{Instance.KeepLowNote}}]         = {{moduleGet:k 'KeepLowNote'}}
        $Instance[{{Instance.KeepDuplicateNotes}}]  = {{moduleGet:k 'KeepDuplicateNotes'}}

        k_noteId = $Instance_getNextNoteId()
        k_noteIndex = $Instance_getNextNoteIndex()

        $Note[{{Note.Id}}]                      = k_noteId
        $Note[{{Note.Number}}]                  = notnum()
        $Note[{{Note.Velocity}}]                = veloc()
        $Note[{{Note.State}}]                   = {{State.Initialized}}
        $Note[{{Note.Amp}}]                     = 1
        $Note[{{Note.CountsTowardHardOff}}]     = $true
        $Note[{{Note.CountsTowardSoftOff}}]     = $true
        $Note[{{Note.CountsTowardKeyCount}}]    = $true
    else
        // If the note got moved down in the note array, update its index.
        while ($Note[{{Note.Id}}] != k_noteId) do
            k_noteIndex -= 1
            {{LogDebug_k '("Note[%d]: id = %d, index-- = %d", k_noteIndex, $Note[{+{Note.Id}+}], k_noteIndex)'}}
            if (k_noteIndex < 0) then
                {{LogError_k '("AF_Module_PolyphonyControl_B: note id %d not found", k_noteId)'}}
                kgoto end
            endif
        od
    endif

end:
    xout(k_noteIndex)
endop


opcode {{Module_private}}_Note_exitState_on, 0, ik
    i_instanceIndex, k_noteIndex xin
endop


opcode {{Module_private}}_Note_enterState_on, 0, ikk
    i_instanceIndex, k_noteIndex, k_currentState xin

    if (k_currentState != {{State.On}}) then
        // Init.
        {{LogTrace_k '("Note[%d].enterState_on", k_noteIndex)'}}
        $IncrementArrayItem($Instance[{{Instance.HardOffActiveNoteCount}}])
        $IncrementArrayItem($Instance[{{Instance.SoftOffActiveNoteCount}}])
        {{LogDebug_k '("Instance[%d].HardOffActiveNoteCount++ = %d", i_instanceIndex, $Instance[{+{Instance.HardOffActiveNoteCount}+}])'}}
        {{LogDebug_k '("Instance[%d].SoftOffActiveNoteCount++ = %d", i_instanceIndex, $Instance[{+{Instance.SoftOffActiveNoteCount}+}])'}}
        $Instance[{{Instance.UpdateHardOffNotes}}] = $true
        $Instance[{{Instance.UpdateSoftOffNotes}}] = $true
    endif
endop


opcode {{Module_private}}_Note_exitState_softOn, 0, ik
    i_instanceIndex, k_noteIndex xin
endop


opcode {{Module_private}}_Note_enterState_softOn, 0, ikk
    i_instanceIndex, k_noteIndex, k_currentState xin

    k_amp init 0
    k_ampDelta init 0

    if (k_currentState != {{State.SoftOn}}) then
        // Init.
        {{LogTrace_k '("Note[%d].enterState_softOn", k_noteIndex)'}}

        if ($Note[{{Note.CountsTowardHardOff}}] == $false) then
            $Note[{{Note.CountsTowardHardOff}}] = $true
            $IncrementArrayItem($Instance[{{Instance.HardOffActiveNoteCount}}])
            {{LogDebug_k '("Instance[%d].HardOffActiveNoteCount++ = %d", i_instanceIndex, $Instance[{+{Instance.HardOffActiveNoteCount}+}])'}}
            $Instance[{{Instance.UpdateHardOffNotes}}] = $true
        endif

        $Note[{{Note.CountsTowardSoftOff}}] = $true
        $IncrementArrayItem($Instance[{{Instance.SoftOffActiveNoteCount}}])
        {{LogDebug_k '("Instance[%d].SoftOffActiveNoteCount++ = %d", i_instanceIndex, $Instance[{+{Instance.SoftOffActiveNoteCount}+}])'}}
        $Instance[{{Instance.UpdateSoftOffNotes}}] = $true

        {{LogTrace_k '("Note[%d].Amp = %f", k_noteIndex, $Note[{+{Note.Amp}+}])'}}
        k_amp = $Note[{{Note.Amp}}]
        k_ampDelta = (k(1) - k_amp) / (kr * {{moduleGet:k 'SoftOnFadeTime'}})
    endif

    k_amp += k_ampDelta
    if (k_amp >= 1) then
        k_amp = 1
        $Note[{{Note.State}}] = {{State.On}}
        {{LogDebug_k '("Note[%d].State = State.On", k_noteIndex)'}}
    endif
    $Note[{{Note.Amp}}] = k_amp
    ; {{LogTrace_k '("Note[%d].Amp = %f", k_noteIndex, $Note[{+{Note.Amp}+}])'}}
endop


opcode {{Module_private}}_Note_exitState_softOff, 0, ik
    i_instanceIndex, k_noteIndex xin
endop


opcode {{Module_private}}_Note_enterState_softOff, 0, ikk
    i_instanceIndex, k_noteIndex, k_currentState xin

    k_amp init 0
    k_ampDelta init 0

    if (k_currentState != {{State.SoftOff}}) then
        {{LogTrace_k '("Note[%d].enterState_softOff", k_noteIndex)'}}
        $Note[{{Note.CountsTowardSoftOff}}] = $false
        $DecrementArrayItem($Instance[{{Instance.SoftOffActiveNoteCount}}])
        {{LogDebug_k '("Instance[%d].SoftOffActiveNoteCount-- = %d", i_instanceIndex, $Instance[{+{Instance.SoftOffActiveNoteCount}+}])'}}

        {{LogTrace_k '("Note[%d].Amp = %f", k_noteIndex, $Note[{+{Note.Amp}+}])'}}
        k_amp = $Note[{{Note.Amp}}]
        k_ampDelta = k_amp / (kr * {{moduleGet:k 'SoftOffFadeTime'}})
    endif

    k_amp -= k_ampDelta
    if (k_amp <= 0) then
        k_amp = 0
        $Note[{{Note.State}}] = {{State.Muted}}
        {{LogDebug_k '("Note[%d].State = State.Muted", k_noteIndex)'}}
    endif
    $Note[{{Note.Amp}}] = k_amp
    ; {{LogTrace_k '("Note[%d].Amp = %f", k_noteIndex, $Note[{+{Note.Amp}+}])'}}
endop


opcode {{Module_private}}_Note_exitState_hardOff, 0, ik
    i_instanceIndex, k_noteIndex xin
endop


opcode {{Module_private}}_Note_enterState_hardOff, 0, ikk
    i_instanceIndex, k_noteIndex, k_currentState xin

    if (k_currentState != {{State.HardOff}}) then
        {{LogTrace_k '("Note[%d].enterState_hardOff", k_noteIndex)'}}
        $Note[{{Note.CountsTowardHardOff}}] = $false
        $DecrementArrayItem($Instance[{{Instance.HardOffActiveNoteCount}}])
        {{LogDebug_k '("Instance[%d].HardOffActiveNoteCount-- = %d", i_instanceIndex, $Instance[{+{Instance.HardOffActiveNoteCount}+}])'}}

        if ($Note[{{Note.CountsTowardSoftOff}}] == $true) then
            $Note[{{Note.CountsTowardSoftOff}}] = $false
            $DecrementArrayItem($Instance[{{Instance.SoftOffActiveNoteCount}}])
            {{LogDebug_k '("Instance[%d].SoftOffActiveNoteCount-- = %d", i_instanceIndex, $Instance[{+{Instance.SoftOffActiveNoteCount}+}])'}}
        endif
    else
        $Note[{{Note.State}}] = {{State.Muted}}
        {{LogDebug_k '("Note[%d].State = State.Muted", k_noteIndex)'}}
    endif

    $Note[{{Note.Amp}}] = 0
    {{LogTrace_k '("Note[%d].Amp = %f", k_noteIndex, $Note[{+{Note.Amp}+}])'}}
endop


opcode {{Module_private}}_Note_exitState_off, 0, ik
    i_instanceIndex, k_noteIndex xin
endop


opcode {{Module_private}}_Note_enterState_muted, 0, ikk
    i_instanceIndex, k_noteIndex, k_currentState xin

    if (k_currentState != {{State.Muted}}) then
        {{LogTrace_k '("Note[%d].enterState_muted", k_noteIndex)'}}
    endif
endop


opcode {{Module_private}}_Note_exitState_muted, 0, ik
    i_instanceIndex, k_noteIndex xin
endop


opcode {{Module_private}}_Note_enterState_off, 0, ikk
    i_instanceIndex, k_noteIndex, k_currentState xin

    if (k_currentState != {{State.Off}}) then
        // Init.
        {{LogTrace_k '("Note[%d].enterState_off", k_noteIndex)'}}
        if ($Note[{{Note.CountsTowardHardOff}}] == $true) then
            $Note[{{Note.CountsTowardHardOff}}] = $false
            $DecrementArrayItem($Instance[{{Instance.HardOffActiveNoteCount}}])
            {{LogDebug_k '("Instance[%d].HardOffActiveNoteCount-- = %d", i_instanceIndex, $Instance[{+{Instance.HardOffActiveNoteCount}+}])'}}
        endif
        if ($Note[{{Note.CountsTowardSoftOff}}] == $true) then
            $Note[{{Note.CountsTowardSoftOff}}] = $false
            $DecrementArrayItem($Instance[{{Instance.SoftOffActiveNoteCount}}])
            {{LogDebug_k '("Instance[%d].SoftOffActiveNoteCount-- = %d", i_instanceIndex, $Instance[{+{Instance.SoftOffActiveNoteCount}+}])'}}
        endif

        $Instance[{{Instance.RemoveFinishedNotes}}] = $true

        if ($Note[{{Note.Number}}] == $Instance[{{Instance.HighNoteNumber}}]) then
            $Instance[{{Instance.UpdateSoftOnHighNotes}}] = $true
        elseif ($Note[{{Note.Number}}] == $Instance[{{Instance.LowNoteNumber}}]) then
            $Instance[{{Instance.UpdateSoftOnLowNotes}}] = $true
        endif

        if ($Note[{{Note.CountsTowardKeyCount}}] == $true) then
            $Note[{{Note.CountsTowardKeyCount}}] = $false
            $DecrementArrayItem($NoteKeyOnCount[$Note[{{Note.Number}}]])
            {{LogDebug_k '("NoteKeyOnCount[%d]-- = %d", $Note[{+{Note.Number}+}], $NoteKeyOnCount[$Note[{+{Note.Number}+}]])'}}
        endif

    endif
endop


opcode {{Module_private}}_Note_updateState, 0, ikk
    i_instanceIndex, k_noteIndex, k_currentState xin

    k_newState = $Note[{{Note.State}}]

    if (k_newState != k_currentState) then
        if (k_currentState == {{State.On}}) then
            {{Module_private}}_Note_exitState_on(i_instanceIndex, k_noteIndex)
        elseif (k_currentState == {{State.SoftOn}}) then
            {{Module_private}}_Note_exitState_softOn(i_instanceIndex, k_noteIndex)
        elseif (k_currentState == {{State.SoftOff}}) then
            {{Module_private}}_Note_exitState_softOff(i_instanceIndex, k_noteIndex)
        elseif (k_currentState == {{State.HardOff}}) then
            {{Module_private}}_Note_exitState_hardOff(i_instanceIndex, k_noteIndex)
        elseif (k_currentState == {{State.Muted}}) then
            {{Module_private}}_Note_exitState_muted(i_instanceIndex, k_noteIndex)
        elseif (k_currentState == {{State.Off}}) then
            {{Module_private}}_Note_exitState_off(i_instanceIndex, k_noteIndex)
        endif
    endif

    if (k_newState == {{State.On}}) then
        {{Module_private}}_Note_enterState_on(i_instanceIndex, k_noteIndex, k_currentState)
    elseif (k_newState == {{State.SoftOn}}) then
        {{Module_private}}_Note_enterState_softOn(i_instanceIndex, k_noteIndex, k_currentState)
    elseif (k_newState == {{State.SoftOff}}) then
        {{Module_private}}_Note_enterState_softOff(i_instanceIndex, k_noteIndex, k_currentState)
    elseif (k_newState == {{State.HardOff}}) then
        {{Module_private}}_Note_enterState_hardOff(i_instanceIndex, k_noteIndex, k_currentState)
    elseif (k_newState == {{State.Muted}}) then
        {{Module_private}}_Note_enterState_muted(i_instanceIndex, k_noteIndex, k_currentState)
    elseif (k_newState == {{State.Off}}) then
        {{Module_private}}_Note_enterState_off(i_instanceIndex, k_noteIndex, k_currentState)
    endif
endop


/// Main module opcode.
/// @return k variable indicating the current polyphony state of the note.
///
/// NB: This needs to be called after any relevant envelopes with extended release segments are initialized.
///
opcode {{Module_public}}, k, S
    S_channelPrefix xin
    i_instanceIndex = {{hostValueGet}}:i(S_channelPrefix)

    k_noteIndex = $Note_initialize()
    k_currentState init {{State.Initialized}}

    if (k_currentState == {{State.Initialized}}) then
        if ($Instance[{{Instance.KeepDuplicateNotes}}] == $false) then
            if ($NoteKeyOnCount[$Note[{{Note.Number}}]] > 0) then
                $Note[{{Note.CountsTowardKeyCount}}] = $false
                $Note[{{Note.State}}] = {{State.Off}}
                {{LogDebug_k '("Note[%d].State = State.Off", k_noteIndex)'}}
            endif
        endif
        if ($Note[{{Note.CountsTowardKeyCount}}] == $true) then
            $Note[{{Note.State}}] = {{State.On}}
            $IncrementArrayItem($NoteKeyOnCount[$Note[{{Note.Number}}]])
            {{LogDebug_k '("Note[%d].State = State.On", k_noteIndex)'}}
        endif
    endif

    if (release() == $true && $Note[{{Note.CountsTowardKeyCount}}] == $true) then
        $Note[{{Note.CountsTowardKeyCount}}] = $false
        $DecrementArrayItem($NoteKeyOnCount[$Note[{{Note.Number}}]])
        {{LogDebug_k '("NoteKeyOnCount[%d]-- = %d", $Note[{+{Note.Number}+}], $NoteKeyOnCount[$Note[{+{Note.Number}+}]])'}}
    endif

    if (lastcycle() == $true) then
        $Note[{{Note.State}}] = {{State.Off}}
        {{LogDebug_k '("Note[%d].State = State.Off", k_noteIndex)'}}
    endif

    $Note_updateState(k_currentState)
    k_currentState = $Note[{{Note.State}}]
end:
    ; {{LogDebug_k '("Note[%d]: id = %d, k_currentState = %d", k_noteIndex, $Note[{+{Note.Id}+}], k_currentState)'}}
    xout(k_currentState)
endop


opcode {{Module_public}}_audioProcessing, a, Sa
    S_channelPrefix, a_in xin
    i_instanceIndex = {{hostValueGet}}:i(S_channelPrefix)

    xout(a_in)
endop


instr {{Module_private}}_alwayson
    S_channelPrefix = p4
    i_instanceIndex = {{hostValueGet}}:i(S_channelPrefix)

    {{LogTrace_i '("AF_Module_PolyphonyControl_B_alwayson: i_instanceIndex = %d", i_instanceIndex)'}}

    // Update variables used when processing multiple flags.
    if ($Instance[{{Instance.UpdateHardOffNotes}}] == $true || $Instance[{{Instance.UpdateSoftOffNotes}}] == $true) then
        k_softOffActiveNoteCount = $Instance[{{Instance.SoftOffActiveNoteCount}}]
        {{LogDebug_k '("k_softOffActiveNoteCount = %d", k_softOffActiveNoteCount)'}}
        k_updateHighAndLowNoteNumbers = $true
    endif
    if ($Instance[{{Instance.UpdateHardOffNotes}}] == $true \
            || $Instance[{{Instance.UpdateSoftOnHighNotes}}] == $true \
            || $Instance[{{Instance.UpdateSoftOnLowNotes}}] == $true) then
        k_hardMax = $Instance[{{Instance.HardMax}}]
        k_hardOffActiveNoteCount = $Instance[{{Instance.HardOffActiveNoteCount}}]
        {{LogDebug_k '("k_hardMax = %d, k_hardOffActiveNoteCount = %d", k_hardMax, k_hardOffActiveNoteCount)'}}
    endif
    if ($Instance[{{Instance.UpdateSoftOffNotes}}] == $true \
            || $Instance[{{Instance.UpdateSoftOnHighNotes}}] == $true \
            || $Instance[{{Instance.UpdateSoftOnLowNotes}}] == $true) then
        k_softMax = $Instance[{{Instance.SoftMax}}]
        k_softOffActiveNoteCount = $Instance[{{Instance.SoftOffActiveNoteCount}}]
        {{LogDebug_k '("k_softMax = %d, k_softOffActiveNoteCount = %d", k_softMax, k_softOffActiveNoteCount)'}}
    endif

    if ($Instance[{{Instance.UpdateHardOffNotes}}] == $true) then
        $Instance[{{Instance.UpdateHardOffNotes}}] = $false

        if (k_hardMax < k_hardOffActiveNoteCount) then
            $Instance_updateHighAndLowNoteNumbers()
            k_updateHighAndLowNoteNumbers = $false

            k_noteIndex = 0
            while ($Note[{{Note.Id}}] != -1 && k_hardMax < k_hardOffActiveNoteCount) do
                if ($Note[{{Note.State}}] != {{State.HardOff}} \
                        && $Note[{{Note.Number}}] != $Instance[{{Instance.HighNoteNumber}}] \
                        && $Note[{{Note.Number}}] != $Instance[{{Instance.LowNoteNumber}}]) then
                    $Note[{{Note.State}}] = {{State.HardOff}}
                    {{LogDebug_k '("Note[%d].State = State.HardOff", k_noteIndex)'}}

                    k_hardOffActiveNoteCount -= 1
                    k_softOffActiveNoteCount -= 1
                    {{LogDebug_k '("k_hardOffActiveNoteCount = %d", k_hardOffActiveNoteCount)'}}
                    {{LogDebug_k '("k_softOffActiveNoteCount = %d", k_softOffActiveNoteCount)'}}
                endif
                k_noteIndex += 1
            od

            // Turn off duplicate low notes if the hard threshold is still exceeded.
            if (k_hardMax < k_hardOffActiveNoteCount) then
                k_noteIndex = 0
                k_skippedOldestLowNote = $false
                while ($Note[{{Note.Id}}] != -1 && k_skippedOldestLowNote = $false) do
                    if ($Note[{{Note.State}}] != {{State.HardOff}} \
                            && $Note[{{Note.Number}}] == $Instance[{{Instance.LowNoteNumber}}]) then
                        k_skippedOldestLowNote = $true
                    endif
                    k_noteIndex += 1
                od
                while ($Note[{{Note.Id}}] != -1 && k_hardMax < k_hardOffActiveNoteCount) do
                    if ($Note[{{Note.State}}] != {{State.HardOff}} \
                            && $Note[{{Note.Number}}] == $Instance[{{Instance.LowNoteNumber}}]) then
                        $Note[{{Note.State}}] = {{State.HardOff}}
                        {{LogDebug_k '("Note[%d].State = State.HardOff", k_noteIndex)'}}

                        k_hardOffActiveNoteCount -= 1
                        k_softOffActiveNoteCount -= 1
                        {{LogDebug_k '("k_hardOffActiveNoteCount = %d", k_hardOffActiveNoteCount)'}}
                        {{LogDebug_k '("k_softOffActiveNoteCount = %d", k_softOffActiveNoteCount)'}}
                    endif
                    k_noteIndex += 1
                od
            endif

            // Turn off duplicate high notes if the hard threshold is still exceeded.
            if (k_hardMax < k_hardOffActiveNoteCount) then
                k_noteIndex = 0
                k_skippedOldestHighNote = $false
                while ($Note[{{Note.Id}}] != -1 && k_skippedOldestHighNote = $false) do
                    if ($Note[{{Note.State}}] != {{State.HardOff}} \
                            && $Note[{{Note.Number}}] == $Instance[{{Instance.HighNoteNumber}}]) then
                        k_skippedOldestHighNote = $true
                    endif
                    k_noteIndex += 1
                od
                while ($Note[{{Note.Id}}] != -1 && k_hardMax < k_hardOffActiveNoteCount) do
                    if ($Note[{{Note.State}}] != {{State.HardOff}} \
                            && $Note[{{Note.Number}}] == $Instance[{{Instance.HighNoteNumber}}]) then
                        $Note[{{Note.State}}] = {{State.HardOff}}
                        {{LogDebug_k '("Note[%d].State = State.HardOff", k_noteIndex)'}}

                        k_hardOffActiveNoteCount -= 1
                        k_softOffActiveNoteCount -= 1
                        {{LogDebug_k '("k_hardOffActiveNoteCount = %d", k_hardOffActiveNoteCount)'}}
                        {{LogDebug_k '("k_softOffActiveNoteCount = %d", k_softOffActiveNoteCount)'}}
                    endif
                    k_noteIndex += 1
                od
            endif
        endif
    endif

    if ($Instance[{{Instance.UpdateSoftOffNotes}}] == $true) then
        $Instance[{{Instance.UpdateSoftOffNotes}}] = $false

        if (k_softMax < k_softOffActiveNoteCount) then
            if (k_updateHighAndLowNoteNumbers == $true) then
                $Instance_updateHighAndLowNoteNumbers()
                k_updateHighAndLowNoteNumbers = $false
            endif

            k_noteIndex = 0
            while ($Note[{{Note.Id}}] != -1 && k_softMax < k_softOffActiveNoteCount) do
                if ($Note[{{Note.State}}] != {{State.SoftOff}} \
                        && $Note[{{Note.State}}] != {{State.HardOff}} \
                        && $Note[{{Note.Number}}] != $Instance[{{Instance.HighNoteNumber}}] \
                        && $Note[{{Note.Number}}] != $Instance[{{Instance.LowNoteNumber}}]) then
                    $Note[{{Note.State}}] = {{State.SoftOff}}
                    {{LogDebug_k '("Note[%d].State = State.SoftOff", k_noteIndex)'}}

                    k_softOffActiveNoteCount -= 1
                    {{LogDebug_k '("k_softOffActiveNoteCount = %d", k_softOffActiveNoteCount)'}}
                endif
                k_noteIndex += 1
            od
        endif
    endif

    if ($Instance[{{Instance.RemoveFinishedNotes}}] == $true) then
        $Instance[{{Instance.RemoveFinishedNotes}}] = $false

        {{LogDebug_k '("Before removing finished notes ...")'}}
        k_noteIndex = 0
        while ($Note[{{Note.Id}}] != -1) do
            {{LogDebug_k '("    Note[%d]: id = %d, state = %d", k_noteIndex, $Note[{+{Note.Id}+}], $Note[{+{Note.State}+}])'}}
            k_noteIndex += 1
        od

        // Move active notes down in the note array to fill gaps left by inactive notes.
        k_activeNoteIndex = 0
        k_noteIndex = 0
        while ($Note[{{Note.Id}}] != -1) do
            if ($Note[{{Note.State}}] != {{State.Off}}) then
                if (k_activeNoteIndex != k_noteIndex) then
                    {{LogDebug_k '("k_activeNoteIndex = %d, k_noteIndex = %d", k_activeNoteIndex, k_noteIndex)'}}
                    k_noteMemberIndex = 0
                    while (k_noteMemberIndex < {{NoteMemberCount}}) do
                        gk_{{Module_private}}_Note[i_instanceIndex][k_activeNoteIndex][k_noteMemberIndex] = $Note[k_noteMemberIndex]
                        k_noteMemberIndex += 1
                    od
                endif
                k_activeNoteIndex += 1
            endif
            k_noteIndex += 1
        od

        // Clear the rest of the note array.
        k_noteIndex = k_activeNoteIndex
        while ($Note[{{Note.Id}}] != -1) do
            $Note[{{Note.Id}}] = -1
            k_noteIndex += 1
        od

        $Instance[{{Instance.NoteCount}}] = k_activeNoteIndex

        {{LogDebug_k '("After removing finished notes ...")'}}
        k_noteIndex = 0
        while ($Note[{{Note.Id}}] != -1) do
            {{LogDebug_k '("    Note[%d]: id = %d, state = %d", k_noteIndex, $Note[{+{Note.Id}+}], $Note[{+{Note.State}+}])'}}
            k_noteIndex += 1
        od

        k_updateHighAndLowNoteNumbers = $true
    endif

    if ($Instance[{{Instance.UpdateSoftOnHighNotes}}] == $true) then
        $Instance[{{Instance.UpdateSoftOnHighNotes}}] = $false

        if (k_updateHighAndLowNoteNumbers == $true) then
            $Instance_updateHighAndLowNoteNumbers()
            k_updateHighAndLowNoteNumbers = $false
        endif

        k_noteIndex = 0
        while ($Note[{{Note.Id}}] != -1) do
            k_noteState = $Note[{{Note.State}}]
            if (k_noteState == {{State.Muted}} || k_noteState == {{State.SoftOff}} || k_noteState == {{State.HardOff}}) then
                if ($Note[{{Note.Number}}] == $Instance[{{Instance.HighNoteNumber}}]) then
                    $Note[{{Note.State}}] = {{State.SoftOn}}
                    {{LogDebug_k '("Note[%d].State = State.SoftOn", k_noteIndex)'}}

                    if ($Note[{{Note.CountsTowardHardOff}}] == $false) then
                        k_hardOffActiveNoteCount += 1
                        {{LogDebug_k '("k_hardOffActiveNoteCount = %d", k_hardOffActiveNoteCount)'}}
                    endif

                    k_softOffActiveNoteCount += 1
                    {{LogDebug_k '("k_softOffActiveNoteCount = %d", k_softOffActiveNoteCount)'}}
                endif
            endif
            k_noteIndex += 1
        od
    endif

    if ($Instance[{{Instance.UpdateSoftOnLowNotes}}] == $true) then
        $Instance[{{Instance.UpdateSoftOnLowNotes}}] = $false

        if (k_updateHighAndLowNoteNumbers == $true) then
            $Instance_updateHighAndLowNoteNumbers()
        endif

        k_noteIndex = 0
        while ($Note[{{Note.Id}}] != -1) do
            k_noteState = $Note[{{Note.State}}]
            if (k_noteState == {{State.Muted}} || k_noteState == {{State.SoftOff}} || k_noteState == {{State.HardOff}}) then
                if ($Note[{{Note.Number}}] == $Instance[{{Instance.LowNoteNumber}}]) then
                    $Note[{{Note.State}}] = {{State.SoftOn}}
                    {{LogDebug_k '("Note[%d].State = State.SoftOn", k_noteIndex)'}}

                    k_hardOffActiveNoteCount += 1
                    k_softOffActiveNoteCount += 1
                    {{LogDebug_k '("k_hardOffActiveNoteCount = %d", k_hardOffActiveNoteCount)'}}
                    {{LogDebug_k '("k_softOffActiveNoteCount = %d", k_softOffActiveNoteCount)'}}
                endif
            endif
            k_noteIndex += 1
        od
    endif
endin


instr {{Module_private}}_customInit
    S_channelPrefix = p4
    i_instanceIndex = {{hostValueGet}}:i(S_channelPrefix)

    {{LogTrace_i '("{+{Module_private}+}_customInit: i_instanceIndex = %d", i_instanceIndex)'}}

    i_arrayLength = 1

    if (lenarray(gk_{{Module_private}}_Instance, 0) <= i_instanceIndex) then
        i_arrayLength = i_instanceIndex + 1
        gk_{{Module_private}}_Instance[][] init i_arrayLength, {{InstanceMemberCount}}
        gk_{{Module_private}}_Note[][][] init i_arrayLength, {{MaxNoteCount}}, {{NoteMemberCount}}
    endif

    k_instanceIndex = 0
    while (k_instanceIndex < i_arrayLength) do
        k_noteIndex = 0
        while (k_noteIndex < {{MaxNoteCount}}) do
            gk_{{Module_private}}_Note[k_instanceIndex][k_noteIndex][{{Note.Id}}] = -1
            k_noteIndex += 1
        od
        k_instanceIndex += 1
    od

    turnoff()
    {{LogTrace_i '("{+{Module_private}+}_customInit: global array lengths = %d", lenarray(gk_{+{Module_private}+}_Instance, 0))'}}
endin


#undef Instance
#undef NoteKeyOnCount
#undef Note

#undef Instance_getNextNoteId
#undef Instance_getNextNoteIndex
#undef Instance_updateHighAndLowNoteNumbers

#undef Note_initialize
#undef Note_updateState

{{/with}}
