<CsoundSynthesizer>
<CsOptions>
{{CsOptions}}
{{HostOptions}}
--messagelevel=0
 -+msg_color=false
</CsOptions>
<CsInstruments>

 {{Enable-LogTrace false}}
 {{Enable-LogDebug false}}

sr = {{sr}}
ksmps = {{ksmps}}
nchnls = 1


{{DeclareTests_Start 'AF_Module_PolyphonyControl_B_Tests'}}
    {{Test "GivenAllValuesAreSetToDefault_WhenNote1Starts_Note1StateShouldEqualOn"}}
    {{Test "GivenAllValuesAreSetToDefault_WhenNote1Ends_Note1StateShouldEqualOff"}}
    {{Test "GivenSoftMaxIs2AndNote1IsPlaying_WhenNote2Starts_Note1StateShouldEqualOn"}}
    {{Test "GivenSoftMaxIs1AndNote1IsPlaying_WhenNote2Starts_Note1StateShouldEqualSoftOff"}}
{{DeclareTests_End}}


{{CsInstruments}}

{{InitializeModule "AF_Module_PolyphonyControl_B" "Module"}}


instr Reset
    {{LogTrace_i '("Reset ...")'}}

    if (active:k(2) != 0) then
        {{LogTrace_k '("Reset - waiting for MIDI notes to finish ...")'}}
        kgoto end
    endif

    {{hostValueSet}}("Module::SoftMax",         {{PolyphonyControl_B.ChannelDefault.SoftMax}})
    {{hostValueSet}}("Module::HardMax",         {{PolyphonyControl_B.ChannelDefault.HardMax}})
    {{hostValueSet}}("Module::SoftOffFadeTime", {{PolyphonyControl_B.ChannelDefault.SoftOffFadeTime}})
    {{hostValueSet}}("Module::KeepHighNote",    {{PolyphonyControl_B.ChannelDefault.KeepHighNote}})
    {{hostValueSet}}("Module::KeepLowNote",     {{PolyphonyControl_B.ChannelDefault.KeepLowNote}})

    gi_noteId init 0

    {{LogTrace_k '("Reset - done")'}}
    turnoff()
end:
endin


massign 0, 2
instr 2
    gi_noteId += 1
    i_noteId = gi_noteId

    {{LogTrace_i '("instr 2: i_noteId = %d ...", i_noteId)'}}
    {{LogTrace_k '("instr 2: i_noteId = %d ...", i_noteId)'}}

    ; xtratim(1)

    k_state = AF_Module_PolyphonyControl_B("Module")

    S_channel init " "
    {{hostValueSet}}(sprintfk("Note.%d.state", i_noteId), k_state)
endin


instr GivenAllValuesAreSetToDefault_WhenNote1Starts_Note1StateShouldEqualOn
    {{LogTrace_i '("%s ...", nstrstr(p1))'}}

    ki init 0
    ki += 1

    if (ki == 1) then
        midiTesting_noteOn(1, 1, 127)
    endif

    if (ki == 2) then
        {{CHECK_EQUAL_k '{+{PolyphonyControl_B.State.On}+}' '{+{hostValueGet}+}:k("Note.1.state")'}}
    endif

    if (ki == 3) then
        midiTesting_noteOff(1, 1)
        turnoff()
    endif
endin


instr GivenAllValuesAreSetToDefault_WhenNote1Ends_Note1StateShouldEqualOff
    {{LogTrace_i '("%s ...", nstrstr(p1))'}}

    ki init 0
    ki += 1

    if (ki == 1) then
        midiTesting_noteOn(1, 1, 127)
    endif

    if (ki == 2) then
        midiTesting_noteOff(1, 1)
    endif

    if (ki == 3) then
        {{CHECK_EQUAL_k '{+{PolyphonyControl_B.State.Off}+}' '{+{hostValueGet}+}:k("Note.1.state")'}}
        turnoff()
    endif
endin


instr GivenSoftMaxIs2AndNote1IsPlaying_WhenNote2Starts_Note1StateShouldEqualOn
    {{LogTrace_i '("%s ...", nstrstr(p1))'}}

    ki init 0
    ki += 1

    if (ki == 1) then
        {{hostValueSet}}("Module::SoftMax", 2)
        midiTesting_noteOn(1, 1, 127)
    endif

    if (ki == 2) then
        midiTesting_noteOn(1, 2, 127)
    endif

    if (ki == 3) then
        {{CHECK_EQUAL_k '{+{PolyphonyControl_B.State.On}+}' '{+{hostValueGet}+}:k("Note.1.state")'}}
    endif

    if (ki == 4) then
        midiTesting_noteOff(1, 1)
        midiTesting_noteOff(1, 2)
        turnoff()
    endif
endin


instr GivenSoftMaxIs1AndNote1IsPlaying_WhenNote2Starts_Note1StateShouldEqualSoftOff
    {{LogTrace_i '("%s ...", nstrstr(p1))'}}

    ki init 0
    ki += 1

    if (ki == 1) then
        {{hostValueSet}}("Module::SoftMax", 1)
        midiTesting_noteOn(1, 1, 127)
    endif

    if (ki == 2) then
        midiTesting_noteOn(1, 2, 127)
    endif

    if (ki == 3) then
        {{CHECK_EQUAL_k '{+{PolyphonyControl_B.State.SoftOff}+}' '{+{hostValueGet}+}:k("Note.1.state")'}}
    endif

    if (ki == 4) then
        midiTesting_noteOff(1, 1)
        midiTesting_noteOff(1, 2)
        turnoff()
    endif
endin


</CsInstruments>
<CsScore>

{{CsScore}}

</CsScore>
<CsoundSynthesizer>
