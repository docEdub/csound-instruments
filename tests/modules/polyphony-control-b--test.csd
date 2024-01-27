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


{{DeclareTests_Start}}
    {{Test "Note1ShouldEnterSoftOffStateWhenSoftMaxIs1AndNote2Starts"}}
{{DeclareTests_End}}


{{CsInstruments}}

{{InitializeModule "AF_Module_PolyphonyControl_B" "PolyphonyControl_Test"}}


instr Reset
    {{LogTrace_i '("Reset ...")'}}

    gi_noteId init 0

    {{LogTrace_k '("Reset - done")'}}
    turnoff()
endin


massign 0, 2
instr 2
    {{LogTrace_i '("%s.%d ...", nstrstr(p1), frac(p1) * 10)'}}

    gi_noteId += 1
    i_noteId = gi_noteId

    k_state = AF_Module_PolyphonyControl_B("PolyphonyControl_Test")
    ; k_state = {{eval "(Constants.PolyphonyControl_B.State.SoftOff)"}}

    S_channel init " "
    S_channel = sprintfk("Note.%d.state", i_noteId)
    {{LogDebug_k '("S_channel = %s", S_channel)'}}
    {{hostValueSet}}(S_channel, k_state)
endin


instr Note1ShouldEnterSoftOffStateWhenSoftMaxIs1AndNote2Starts
    {{LogTrace_i '("%s ...", nstrstr(p1))'}}

    i_testIndex = p4
    {{hostValueSet}}("PolyphonyControl_Test::SoftMax", 1)

    ki init 0
    ki += 1

    if (ki == 1) then
        midiTesting_noteOn(1, 1, 127)
        midiTesting_noteOn(1, 2, 127)
    endif

    if (ki == 2) then
        {{CHECK_EQUAL_k '{+{eval "(Constants.PolyphonyControl_B.State.SoftOff)"}+}' '{+{hostValueGet}+}:k("Note.1.state")'}}
    endif

    if (ki == 3) then
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
