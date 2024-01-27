<CsoundSynthesizer>
<CsOptions>
{{CsOptions}}
{{HostOptions}}
--messagelevel=0
 -+msg_color=false
</CsOptions>
<CsInstruments>

sr = {{sr}}
ksmps = {{ksmps}}
nchnls = 1


{{DeclareTests_Start 'AF_Module_PolyphonyControl_B_Tests'}}
    {{Test "GivenSoftMaxIs1AndNote1IsPlaying_WhenNote2Starts_Note1StateShouldEqualSoftOff"}}
{{DeclareTests_End}}


{{CsInstruments}}

{{InitializeModule "AF_Module_PolyphonyControl_B" "Module"}}


instr Reset
    {{LogTrace_i '("Reset ...")'}}

    {{hostValueSet}}("Module::SoftMax",         {{PolyphonyControl_B.ChannelDefault.SoftMax}})
    {{hostValueSet}}("Module::HardMax",         {{PolyphonyControl_B.ChannelDefault.HardMax}})
    {{hostValueSet}}("Module::SoftOffFadeTime", {{PolyphonyControl_B.ChannelDefault.SoftOffFadeTime}})
    {{hostValueSet}}("Module::KeepHighNote",    {{PolyphonyControl_B.ChannelDefault.KeepHighNote}})
    {{hostValueSet}}("Module::KeepLowNote",     {{PolyphonyControl_B.ChannelDefault.KeepLowNote}})

    gi_noteId init 0

    {{LogTrace_k '("Reset - done")'}}
    turnoff()
endin


massign 0, 2
instr 2
    {{LogTrace_i '("%s.%d ...", nstrstr(p1), frac(p1) * 10)'}}

    gi_noteId += 1
    i_noteId = gi_noteId

    k_state = AF_Module_PolyphonyControl_B("Module")
    ; k_state = {{eval "(Constants.PolyphonyControl_B.State.SoftOff)"}}

    S_channel init " "
    S_channel = sprintfk("Note.%d.state", i_noteId)
    {{LogDebug_k '("S_channel = %s", S_channel)'}}
    {{hostValueSet}}(S_channel, k_state)
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
