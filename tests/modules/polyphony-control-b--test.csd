<CsoundSynthesizer>
<CsOptions>
{{CsOptions}}
{{HostOptions}}
--messagelevel=0
 -+msg_color=false
</CsOptions>
<CsInstruments>

{{#with PolyphonyControl_B}}

{{Enable-LogTrace false}}
{{Enable-LogDebug false}}

sr = {{sr}}
ksmps = {{ksmps}}
nchnls = 1


{{DeclareTests_Start 'PolyphonyControl_B'}}
    {{Test "GivenAllValuesAreDefault_WhenNote1Starts_Note1StateShouldEqualOn"}}
    {{Test "GivenAllValuesAreDefault_WhenNote1Ends_Note1StateShouldEqualOff"}}
    {{Test "GivenHardMaxIs1AndNote1IsPlaying_WhenNote2Starts_Note1StateShouldEqualHardOff_AtNote2StartKPlus2"}}
    {{Test "GivenHardMaxIs1AndNote1IsPlaying_WhenNote2Starts_Note1StateShouldEqualHardOff_AtNote2StartKPlus3"}}
    {{Test "GivenHardMaxIs1AndNote1IsPlaying_WhenNote2Starts_Note2StateShouldEqualOn_AtNote2StartKPlus2"}}
    {{Test "GivenHardMaxIs1AndNote1IsPlaying_WhenNote2StartsAndStops_Note1StateShouldEqualHardOff_AtNote2StartKPlus2"}}
    {{Test "GivenHardMaxIs1AndNote1IsPlaying_WhenNote2StartsAndStops_Note1StateShouldEqualMuted_AtNote2StartKPlus3"}}
    {{Test "GivenHardMaxIs2AndNote1IsPlaying_WhenNote2Starts_Note1StateShouldEqualOn"}}
    {{Test "GivenHardMaxIs1AndSoftMaxIs1AndNote1IsPlaying_WhenNote2Starts_Note1StateShouldEqualHardOff"}}
    {{Test "GivenHardMaxIs2AndSoftMaxIs1AndNote1IsPlaying_WhenNotes2And3Start_Note1StateShouldEqualHardOff"}}
    {{Test "GivenHardMaxIs2AndSoftMaxIs1AndNote1IsPlaying_WhenNotes2And3Start_Note2StateShouldEqualSoftOff"}}
    {{Test "GivenSoftMaxIs1AndNote1IsPlaying_WhenNote2Starts_Note1StateShouldEqualSoftOff"}}
    {{Test "GivenSoftMaxIs1AndNote1IsPlaying_WhenNote2Starts_Note1StateShouldEqualMuted_AfterDefaultSoftOffFadeTime"}}
    {{Test "GivenSoftMaxIs2AndNote1IsPlaying_WhenNote2Starts_Note1StateShouldEqualOn"}}
    {{Test "GivenSoftMaxIs2AndNotes1And2ArePlaying_WhenNote3Starts_Note1StateShouldEqualSoftOff"}}
    {{Test "GivenReleaseTimeIs1_WhenNote1Ends_Note1StateShouldEqualOff_After1Second"}}
    {{Test "GivenReleaseTimeIs1_WhenNote1Ends_Note1StateShouldEqualOn"}}
{{DeclareTests_End}}


{{CsInstruments}}

{{InitializeModule "PolyphonyControl_B" "Module"}}


instr Reset
    {{LogTrace_i '("Reset ...")'}}

    if (active:k(2) != 0) then
        {{LogTrace_k '("Reset - waiting for MIDI notes to finish ...")'}}
        kgoto end
    endif

    {{hostValueSet}}("Note.releaseTime",        0);

    {{hostValueSet}}("Module::SoftMax",         {{ChannelDefault.SoftMax}})
    {{hostValueSet}}("Module::HardMax",         {{ChannelDefault.HardMax}})
    {{hostValueSet}}("Module::SoftOffFadeTime", {{ChannelDefault.SoftOffFadeTime}})
    {{hostValueSet}}("Module::KeepHighNote",    {{ChannelDefault.KeepHighNote}})
    {{hostValueSet}}("Module::KeepLowNote",     {{ChannelDefault.KeepLowNote}})

    gi_noteId init 0

    {{LogTrace_k '("Reset - done")'}}
    turnoff()
end:
endin


massign 0, 2
instr 2
    gi_noteId += 1

    i_noteId = gi_noteId
    i_releaseTime = {{hostValueGet}}:i("Note.releaseTime")

    {{LogTrace_i '("instr 2: i_noteId = %d, i_releaseTime = %f ...", i_noteId, i_releaseTime)'}}

    xtratim(i_releaseTime)

    k_state = AF_Module_PolyphonyControl_B("Module")
    {{hostValueSet}}(sprintfk("Note.%d.state", i_noteId), k_state)
endin


instr GivenAllValuesAreDefault_WhenNote1Starts_Note1StateShouldEqualOn
    {{LogTrace_i '("%s ...", nstrstr(p1))'}}

    ki init 0
    ki += 1

    if (ki == 1) then
        midiTesting_noteOn(1, 1, 127)
    elseif (ki == 2) then
        {{CHECK_EQUAL_k '{+{State.On}+}' '{+{hostValueGet}+}:k("Note.1.state")'}}
        midiTesting_noteOff(1, 1)
        turnoff()
    endif
endin


instr GivenAllValuesAreDefault_WhenNote1Ends_Note1StateShouldEqualOff
    {{LogTrace_i '("%s ...", nstrstr(p1))'}}

    ki init 0
    ki += 1

    if (ki == 1) then
        midiTesting_noteOn(1, 1, 127)
    elseif (ki == 2) then
        midiTesting_noteOff(1, 1)
    elseif (ki == 3) then
        {{CHECK_EQUAL_k '{+{State.Off}+}' '{+{hostValueGet}+}:k("Note.1.state")'}}
        turnoff()
    endif
endin


instr GivenHardMaxIs1AndNote1IsPlaying_WhenNote2Starts_Note1StateShouldEqualHardOff_AtNote2StartKPlus2
    {{LogTrace_i '("%s ...", nstrstr(p1))'}}

    ki init 0
    ki += 1

    if (ki == 1) then
        {{hostValueSet}}("Module::HardMax", 1)
        midiTesting_noteOn(1, 1, 127)
    elseif (ki == 2) then
        midiTesting_noteOn(1, 2, 127)
    elseif (ki == 4) then
        {{CHECK_EQUAL_k '{+{State.HardOff}+}' '{+{hostValueGet}+}:k("Note.1.state")'}}
        midiTesting_noteOff(1, 1)
        midiTesting_noteOff(1, 2)
        turnoff()
    endif
endin


instr GivenHardMaxIs1AndNote1IsPlaying_WhenNote2Starts_Note1StateShouldEqualHardOff_AtNote2StartKPlus3
    {{LogTrace_i '("%s ...", nstrstr(p1))'}}

    ki init 0
    ki += 1

    if (ki == 1) then
        {{hostValueSet}}("Module::HardMax", 1)
        midiTesting_noteOn(1, 1, 127)
    elseif (ki == 2) then
        midiTesting_noteOn(1, 2, 127)
    elseif (ki == 5) then
        {{CHECK_EQUAL_k '{+{State.Muted}+}' '{+{hostValueGet}+}:k("Note.1.state")'}}
        midiTesting_noteOff(1, 1)
        midiTesting_noteOff(1, 2)
        turnoff()
    endif
endin


instr GivenHardMaxIs1AndNote1IsPlaying_WhenNote2Starts_Note2StateShouldEqualOn_AtNote2StartKPlus2
    {{LogTrace_i '("%s ...", nstrstr(p1))'}}

    ki init 0
    ki += 1

    if (ki == 1) then
        {{hostValueSet}}("Module::HardMax", 1)
        midiTesting_noteOn(1, 1, 127)
    elseif (ki == 2) then
        midiTesting_noteOn(1, 2, 127)
    elseif (ki == 4) then
        {{CHECK_EQUAL_k '{+{State.On}+}' '{+{hostValueGet}+}:k("Note.2.state")'}}
        midiTesting_noteOff(1, 1)
        midiTesting_noteOff(1, 2)
        turnoff()
    endif
endin


instr GivenHardMaxIs1AndNote1IsPlaying_WhenNote2StartsAndStops_Note1StateShouldEqualHardOff_AtNote2StartKPlus2
    {{LogTrace_i '("%s ...", nstrstr(p1))'}}

    ki init 0
    ki += 1

    if (ki == 1) then
        {{hostValueSet}}("Module::HardMax", 1)
        midiTesting_noteOn(1, 1, 127)
    elseif (ki == 2) then
        midiTesting_noteOn(1, 2, 127)
    elseif (ki == 3) then
        midiTesting_noteOff(1, 2)
    elseif (ki == 4) then
        {{CHECK_EQUAL_k '{+{State.HardOff}+}' '{+{hostValueGet}+}:k("Note.1.state")'}}
        midiTesting_noteOff(1, 1)
        turnoff()
    endif
endin


instr GivenHardMaxIs1AndNote1IsPlaying_WhenNote2StartsAndStops_Note1StateShouldEqualMuted_AtNote2StartKPlus3
    {{LogTrace_i '("%s ...", nstrstr(p1))'}}

    ki init 0
    ki += 1

    if (ki == 1) then
        {{hostValueSet}}("Module::HardMax", 1)
        midiTesting_noteOn(1, 1, 127)
    elseif (ki == 2) then
        midiTesting_noteOn(1, 2, 127)
    elseif (ki == 3) then
        midiTesting_noteOff(1, 2)
    elseif (ki == 5) then
        {{CHECK_EQUAL_k '{+{State.Muted}+}' '{+{hostValueGet}+}:k("Note.1.state")'}}
        midiTesting_noteOff(1, 1)
        turnoff()
    endif
endin


instr GivenHardMaxIs2AndNote1IsPlaying_WhenNote2Starts_Note1StateShouldEqualOn
    {{LogTrace_i '("%s ...", nstrstr(p1))'}}

    ki init 0
    ki += 1

    if (ki == 1) then
        {{hostValueSet}}("Module::HardMax", 2)
        midiTesting_noteOn(1, 1, 127)
    elseif (ki == 2) then
        midiTesting_noteOn(1, 2, 127)
    elseif (ki == 3) then
        {{CHECK_EQUAL_k '{+{State.On}+}' '{+{hostValueGet}+}:k("Note.1.state")'}}
        midiTesting_noteOff(1, 1)
        midiTesting_noteOff(1, 2)
        turnoff()
    endif
endin


instr GivenHardMaxIs1AndSoftMaxIs1AndNote1IsPlaying_WhenNote2Starts_Note1StateShouldEqualHardOff
    {{LogTrace_i '("%s ...", nstrstr(p1))'}}

    ki init 0
    ki += 1

    if (ki == 1) then
        {{hostValueSet}}("Module::HardMax", 1)
        {{hostValueSet}}("Module::SoftMax", 1)
        midiTesting_noteOn(1, 1, 127)
    elseif (ki == 2) then
        midiTesting_noteOn(1, 2, 127)
    elseif (ki == 4) then
        {{CHECK_EQUAL_k '{+{State.HardOff}+}' '{+{hostValueGet}+}:k("Note.1.state")'}}
        midiTesting_noteOff(1, 1)
        midiTesting_noteOff(1, 2)
        turnoff()
    endif
endin


instr GivenHardMaxIs2AndSoftMaxIs1AndNote1IsPlaying_WhenNotes2And3Start_Note1StateShouldEqualHardOff
    {{LogTrace_i '("%s ...", nstrstr(p1))'}}

    ki init 0
    ki += 1

    if (ki == 1) then
        {{hostValueSet}}("Module::HardMax", 2)
        {{hostValueSet}}("Module::SoftMax", 1)
        midiTesting_noteOn(1, 1, 127)
    elseif (ki == 2) then
        midiTesting_noteOn(1, 2, 127)
        midiTesting_noteOn(1, 3, 127)
    elseif (ki == 4) then
        {{CHECK_EQUAL_k '{+{State.HardOff}+}' '{+{hostValueGet}+}:k("Note.1.state")'}}
        midiTesting_noteOff(1, 1)
        midiTesting_noteOff(1, 2)
        midiTesting_noteOff(1, 3)
        turnoff()
    endif
endin


instr GivenHardMaxIs2AndSoftMaxIs1AndNote1IsPlaying_WhenNotes2And3Start_Note2StateShouldEqualSoftOff
    {{LogTrace_i '("%s ...", nstrstr(p1))'}}

    ki init 0
    ki += 1

    if (ki == 1) then
        {{hostValueSet}}("Module::HardMax", 2)
        {{hostValueSet}}("Module::SoftMax", 1)
        midiTesting_noteOn(1, 1, 127)
    elseif (ki == 2) then
        midiTesting_noteOn(1, 2, 127)
        midiTesting_noteOn(1, 3, 127)
    elseif (ki == 4) then
        {{CHECK_EQUAL_k '{+{State.SoftOff}+}' '{+{hostValueGet}+}:k("Note.2.state")'}}
        midiTesting_noteOff(1, 1)
        midiTesting_noteOff(1, 2)
        midiTesting_noteOff(1, 3)
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
    elseif (ki == 2) then
        midiTesting_noteOn(1, 2, 127)
    elseif (ki == 4) then
        {{CHECK_EQUAL_k '{+{State.SoftOff}+}' '{+{hostValueGet}+}:k("Note.1.state")'}}
        midiTesting_noteOff(1, 1)
        midiTesting_noteOff(1, 2)
        turnoff()
    endif
endin


instr GivenSoftMaxIs1AndNote1IsPlaying_WhenNote2Starts_Note1StateShouldEqualMuted_AfterDefaultSoftOffFadeTime
    {{LogTrace_i '("%s ...", nstrstr(p1))'}}

    ki init 0
    k_noteSoftOffStartTime init 0
    k_softOffFadeTime init {{hostValueGet}}:i("Module::SoftOffFadeTime")

    ki += 1

    if (ki == 1) then
        {{hostValueSet}}("Module::SoftMax", 1)
        midiTesting_noteOn(1, 1, 127)
    elseif (ki == 2) then
        midiTesting_noteOn(1, 2, 127)
    elseif (ki == 3) then
        k_noteSoftOffStartTime = times()
    elseif (ki >= 4) then
        if (times() - k_noteSoftOffStartTime >= k_softOffFadeTime) then
            {{CHECK_EQUAL_k '{+{State.Muted}+}' '{+{hostValueGet}+}:k("Note.1.state")'}}
            midiTesting_noteOff(1, 1)
            midiTesting_noteOff(1, 2)
            turnoff()
        endif
    endif
endin


instr GivenSoftMaxIs2AndNote1IsPlaying_WhenNote2Starts_Note1StateShouldEqualOn
    {{LogTrace_i '("%s ...", nstrstr(p1))'}}

    ki init 0
    ki += 1

    if (ki == 1) then
        {{hostValueSet}}("Module::SoftMax", 2)
        midiTesting_noteOn(1, 1, 127)
    elseif (ki == 2) then
        midiTesting_noteOn(1, 2, 127)
    elseif (ki == 3) then
        {{CHECK_EQUAL_k '{+{State.On}+}' '{+{hostValueGet}+}:k("Note.1.state")'}}
        midiTesting_noteOff(1, 1)
        midiTesting_noteOff(1, 2)
        turnoff()
    endif
endin


instr GivenSoftMaxIs2AndNotes1And2ArePlaying_WhenNote3Starts_Note1StateShouldEqualSoftOff
    {{LogTrace_i '("%s ...", nstrstr(p1))'}}

    ki init 0
    ki += 1

    if (ki == 1) then
        {{hostValueSet}}("Module::SoftMax", 2)
        midiTesting_noteOn(1, 1, 127)
        midiTesting_noteOn(1, 2, 127)
    elseif (ki == 2) then
        midiTesting_noteOn(1, 3, 127)
    elseif (ki == 4) then
        {{CHECK_EQUAL_k '{+{State.SoftOff}+}' '{+{hostValueGet}+}:k("Note.1.state")'}}
        midiTesting_noteOff(1, 1)
        midiTesting_noteOff(1, 2)
        midiTesting_noteOff(1, 3)
        turnoff()
    endif
endin


instr GivenReleaseTimeIs1_WhenNote1Ends_Note1StateShouldEqualOff_After1Second
    {{LogTrace_i '("%s ...", nstrstr(p1))'}}

    ki init 0
    ki += 1

    k_noteOffTime init 0

    if (ki == 1) then
        {{hostValueSet}}("Note.releaseTime", 1)
        midiTesting_noteOn(1, 1, 127)
    elseif (ki == 2) then
        midiTesting_noteOff(1, 1)
        k_noteOffTime = times()
    elseif (ki >= 3) then
        if (times() - k_noteOffTime >= 1) then
            {{CHECK_EQUAL_k '{+{State.Off}+}' '{+{hostValueGet}+}:k("Note.1.state")'}}
            turnoff()
        endif
    endif
endin


instr GivenReleaseTimeIs1_WhenNote1Ends_Note1StateShouldEqualOn
    {{LogTrace_i '("%s ...", nstrstr(p1))'}}

    ki init 0
    ki += 1

    if (ki == 1) then
        {{hostValueSet}}("Note.releaseTime", 1)
        midiTesting_noteOn(1, 1, 127)
    elseif (ki == 2) then
        midiTesting_noteOff(1, 1)
    elseif (ki == 3) then
        {{CHECK_EQUAL_k '{+{State.On}+}' '{+{hostValueGet}+}:k("Note.1.state")'}}
        turnoff()
    endif
endin

{{/with}}

</CsInstruments>
<CsScore>

{{CsScore}}

</CsScore>
<CsoundSynthesizer>
