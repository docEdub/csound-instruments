/*
 *  polyphony-control-b.orc
 *
 *  Polyphony control module with soft and hard thresholds.
 */

{{DeclareModule 'PolyphonyControl_B' '{ "hasAlwaysOnInstrument": "true", "hasCustomInitialization": "true" }'}}


gk_AF_Module_{{ModuleName}}_Instance[][] init 1, {{PolyphonyControl_B.InstanceMemberCount}}
gk_AF_Module_{{ModuleName}}_Note[][][] init 1, {{PolyphonyControl_B.MaxNoteCount}}, {{PolyphonyControl_B.NoteMemberCount}}


#define Instance # gk_AF_Module_{{ModuleName}}_Instance[i_instanceIndex] #
#define Instance_getNextNoteId() # _af_module_{{ModuleName}}_Instance_getNextNoteId(i_instanceIndex) #
#define Instance_getNextNoteIndex() # _af_module_{{ModuleName}}_Instance_getNextNoteIndex(i_instanceIndex) #

#define Note # gk_AF_Module_{{ModuleName}}_Note[i_instanceIndex][k_noteIndex] #
#define Note_initialize() # _af_module_{{ModuleName}}_Note_initialize(i_instanceIndex) #
#define Note_updateState() # _af_module_{{ModuleName}}_Note_updateState(i_instanceIndex, k_noteIndex) #


opcode _af_module_{{ModuleName}}_Instance_getNextNoteId, k, i
    i_instanceIndex xin

    k_noteId = $Instance[{{PolyphonyControl_B.Instance.NextNoteId}}]
    $Instance[{{PolyphonyControl_B.Instance.NextNoteId}}] = k_noteId + 1

    xout(k_noteId)
endop


opcode _af_module_{{ModuleName}}_Instance_getNextNoteIndex, k, i
    i_instanceIndex xin
    k_noteIndex init -1

    k_noteIndex = $Instance[{{PolyphonyControl_B.Instance.NoteCount}}]
    $Instance[{{PolyphonyControl_B.Instance.NoteCount}}] = k_noteIndex + 1

    xout(k_noteIndex)
endop


opcode _af_module_{{ModuleName}}_Note_initialize, k, i
    i_instanceIndex xin

    k_noteId init -1
    k_noteIndex init -1

    $Note[{{PolyphonyControl_B.Note.Duration}}] = timeinsts()

    k_initialized init {{false}}
    if (k_initialized == {{false}}) then
        k_initialized = {{true}}

        k_noteId = $Instance_getNextNoteId()
        k_noteIndex = $Instance_getNextNoteIndex()

        $Note[{{PolyphonyControl_B.Note.Id}}] = k_noteId
        $Note[{{PolyphonyControl_B.Note.NoteNumber}}] = notnum()
        $Note[{{PolyphonyControl_B.Note.Velocity}}] = veloc()
        $Note[{{PolyphonyControl_B.Note.State}}] = {{PolyphonyControl_B.State.Initialized}}
        $Note[{{PolyphonyControl_B.Note.Amp}}] = 1
    else
        // If the note got moved down in the note array, update its index.
        while ($Note[{{PolyphonyControl_B.Note.Id}}] != k_noteId) do
            k_noteIndex -= 1
            if (k_noteIndex < 0) then
                {{LogError_k '("AF_Module_PolyphonyControl_B: note id %d not found", k_noteId)'}}
                kgoto end
            endif
        od
    endif

end:
    xout(k_noteIndex)
endop


opcode _af_module_{{ModuleName}}_Note_exitState_on, 0, ik
    i_instanceIndex, k_noteIndex xin
endop


opcode _af_module_{{ModuleName}}_Note_enterState_on, 0, ik
    i_instanceIndex, k_noteIndex xin

    if ($Note[{{PolyphonyControl_B.Note.PreviousState}}] != {{PolyphonyControl_B.State.On}}) then
        $Note[{{PolyphonyControl_B.Note.PreviousState}}] = {{PolyphonyControl_B.State.On}}
    endif


endop


opcode _af_module_{{ModuleName}}_Note_exitState_softOn, 0, ik
    i_instanceIndex, k_noteIndex xin
endop


opcode _af_module_{{ModuleName}}_Note_enterState_softOn, 0, ik
    i_instanceIndex, k_noteIndex xin

    k_amp init 0
    k_ampDelta init 0

    if ($Note[{{PolyphonyControl_B.Note.PreviousState}}] != {{PolyphonyControl_B.State.SoftOn}}) then
        // Init
        k_amp = $Note[{{PolyphonyControl_B.Note.Amp}}]
        k_ampDelta = (k(1) - k_amp) / (kr * {{moduleGet:k 'SoftOnFadeTime'}})
        $Note[{{PolyphonyControl_B.Note.PreviousState}}] = {{PolyphonyControl_B.State.SoftOn}}
    else
        k_amp += k_ampDelta
        if (k_amp >= 1) then
            k_amp = 1
            $Note[{{PolyphonyControl_B.Note.State}}] = {{PolyphonyControl_B.State.On}}
        endif
        $Note[{{PolyphonyControl_B.Note.Amp}}] = k_amp
    endif
endop


opcode _af_module_{{ModuleName}}_Note_exitState_softOff, 0, ik
    i_instanceIndex, k_noteIndex xin
endop


opcode _af_module_{{ModuleName}}_Note_enterState_softOff, 0, ik
    i_instanceIndex, k_noteIndex xin

    if ($Note[{{PolyphonyControl_B.Note.PreviousState}}] != {{PolyphonyControl_B.State.SoftOff}}) then
        $Note[{{PolyphonyControl_B.Note.PreviousState}}] = {{PolyphonyControl_B.State.SoftOff}}
    endif
endop


opcode _af_module_{{ModuleName}}_Note_exitState_hardOff, 0, ik
    i_instanceIndex, k_noteIndex xin
endop


opcode _af_module_{{ModuleName}}_Note_enterState_hardOff, 0, ik
    i_instanceIndex, k_noteIndex xin

    if ($Note[{{PolyphonyControl_B.Note.PreviousState}}] != {{PolyphonyControl_B.State.HardOff}}) then
        $Note[{{PolyphonyControl_B.Note.PreviousState}}] = {{PolyphonyControl_B.State.HardOff}}
    endif
endop


opcode _af_module_{{ModuleName}}_Note_exitState_off, 0, ik
    i_instanceIndex, k_noteIndex xin
endop


opcode _af_module_{{ModuleName}}_Note_enterState_off, 0, ik
    i_instanceIndex, k_noteIndex xin

    if ($Note[{{PolyphonyControl_B.Note.PreviousState}}] != {{PolyphonyControl_B.State.Off}}) then
        $Note[{{PolyphonyControl_B.Note.PreviousState}}] = {{PolyphonyControl_B.State.Off}}
    endif
endop


opcode _af_module_{{ModuleName}}_Note_updateState, 0, ik
    i_instanceIndex, k_noteIndex xin

    k_currentState = $Note[{{PolyphonyControl_B.Note.PreviousState}}]
    k_state = $Note[{{PolyphonyControl_B.Note.State}}]

    if (k_state != k_currentState) then
        if (k_currentState == {{PolyphonyControl_B.State.On}}) then
            _af_module_{{ModuleName}}_Note_exitState_on(i_instanceIndex, k_noteIndex)
        elseif (k_currentState == {{PolyphonyControl_B.State.SoftOn}}) then
            _af_module_{{ModuleName}}_Note_exitState_softOn(i_instanceIndex, k_noteIndex)
        elseif (k_currentState == {{PolyphonyControl_B.State.SoftOff}}) then
            _af_module_{{ModuleName}}_Note_exitState_softOff(i_instanceIndex, k_noteIndex)
        elseif (k_currentState == {{PolyphonyControl_B.State.HardOff}}) then
            _af_module_{{ModuleName}}_Note_exitState_hardOff(i_instanceIndex, k_noteIndex)
        elseif (k_currentState == {{PolyphonyControl_B.State.Off}}) then
            _af_module_{{ModuleName}}_Note_exitState_off(i_instanceIndex, k_noteIndex)
        endif
    endif

    if (k_state == {{PolyphonyControl_B.State.On}}) then
        _af_module_{{ModuleName}}_Note_enterState_on(i_instanceIndex, k_noteIndex)
    elseif (k_state == {{PolyphonyControl_B.State.SoftOn}}) then
        _af_module_{{ModuleName}}_Note_enterState_softOn(i_instanceIndex, k_noteIndex)
    elseif (k_state == {{PolyphonyControl_B.State.SoftOff}}) then
        _af_module_{{ModuleName}}_Note_enterState_softOff(i_instanceIndex, k_noteIndex)
    elseif (k_state == {{PolyphonyControl_B.State.HardOff}}) then
        _af_module_{{ModuleName}}_Note_enterState_hardOff(i_instanceIndex, k_noteIndex)
    elseif (k_state == {{PolyphonyControl_B.State.Off}}) then
        _af_module_{{ModuleName}}_Note_enterState_off(i_instanceIndex, k_noteIndex)
    endif
endop


/// NB: This needs to be called after any relevant envelopes with extended release segments are initialized.
///
opcode AF_Module_{{ModuleName}}, k, S
    S_channelPrefix xin
    i_instanceIndex = {{hostValueGet}}:i(S_channelPrefix)
    k_noteIndex = $Note_initialize()

    $Note_updateState()

    xout($Note[{{PolyphonyControl_B.Note.State}}])
endop


opcode AF_Module_{{ModuleName}}_audioProcessing, a, Sa
    S_channelPrefix, a_in xin
    i_instanceIndex = {{hostValueGet}}:i(S_channelPrefix)

    xout(a_in)
endop


instr AF_Module_{{ModuleName}}_alwayson
    S_channelPrefix = p4
    i_instanceIndex = {{hostValueGet}}:i(S_channelPrefix)

    ; {{LogTrace_i '("AF_Module_PolyphonyControl_B_alwayson: i_instanceIndex = %d", i_instanceIndex)'}}

    $Instance[{{PolyphonyControl_B.Instance.KeepHighNote}}] = {{moduleGet:k 'KeepHighNote'}}
    $Instance[{{PolyphonyControl_B.Instance.KeepLowNote}}]  = {{moduleGet:k 'KeepLowNote'}}
endin


instr AF_Module_{{ModuleName}}_customInit
    S_channelPrefix = p4
    i_instanceIndex = {{hostValueGet}}:i(S_channelPrefix)

    ; {{LogTrace_i '("AF_Module_PolyphonyControl_B_customInit: i_instanceIndex = %d", i_instanceIndex)'}}

    if (i_instanceIndex <= lenarray(gk_AF_Module_{{ModuleName}}_Instance, 0)) then
        i_arrayLength = i_instanceIndex + 1
        gk_AF_Module_{{ModuleName}}_Instance[][] init i_arrayLength, {{PolyphonyControl_B.InstanceMemberCount}}
        gk_AF_Module_{{ModuleName}}_Note[][][] init i_arrayLength, {{PolyphonyControl_B.MaxNoteCount}}, {{PolyphonyControl_B.NoteMemberCount}}
    endif

    ; {{LogTrace_i '("AF_Module_PolyphonyControl_B_customInit: global array lengths = %d", lenarray(gk_AF_Module_PolyphonyControl_B_Instance_data, 0))'}}
endin


#undef Instance
#undef Instance_getNextNoteId
#undef Instance_getNextNoteIndex

#undef Note
#undef Note_initialize
#undef Note_updateState
