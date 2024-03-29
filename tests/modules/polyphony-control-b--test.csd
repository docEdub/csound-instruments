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

{{CsInstruments}}


#define DefaultMidiChannel # 1 #
#define DefaultVelocity  # 127 #

#define Key1    # 1 #
#define Key2    # 2 #
#define Key3    # 3 #

#define HighNoteKey     # 127 #
#define MidHighNoteKey  #  96 #
#define MidNoteKey      #  64 #
#define MidLowNoteKey   #  32 #
#define LowNoteKey      #   1 #

#define NoteOn(key)     # midiTesting_noteOn($DefaultMidiChannel, $key, $DefaultVelocity) #
#define NoteOff(key)    # midiTesting_noteOff($DefaultMidiChannel, $key) #


{{InitializeModule "PolyphonyControl_B" "Module"}}

{{#CsoundTestGroup "PolyphonyControl_B"}}


instr Reset
    {{LogTrace_i '("Reset ...")'}}

    if (active:k(2) != 0) then
        {{LogTrace_k '("Reset - waiting for MIDI notes to finish ...")'}}
        kgoto end
    endif

    {{hostValueSet}}("Note.releaseTime",        0);

    {{hostValueSet}}("Module::Enabled",             $true)
    {{hostValueSet}}("Module::SoftMax",             {{ChannelDefault.SoftMax}})
    {{hostValueSet}}("Module::HardMax",             {{ChannelDefault.HardMax}})
    {{hostValueSet}}("Module::SoftOffFadeTime",     {{ChannelDefault.SoftOffFadeTime}})
    {{hostValueSet}}("Module::SoftOnFadeTime",      {{ChannelDefault.SoftOnFadeTime}})
    {{hostValueSet}}("Module::KeepHighNote",        {{ChannelDefault.KeepHighNote}})
    {{hostValueSet}}("Module::KeepLowNote",         {{ChannelDefault.KeepLowNote}})
    {{hostValueSet}}("Module::KeepDuplicateNotes",  {{ChannelDefault.KeepDuplicateNotes}})

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

    k_polyphonyControlNoteIndex = AF_Module_PolyphonyControl_B_noteIndex("Module")
    k_state = AF_Module_PolyphonyControl_B_state("Module", k_polyphonyControlNoteIndex)
    {{hostValueSet}}(sprintfk("Note.%d.state", i_noteId), k_state)
endin


{{#CsoundTest "GivenAllValuesAreDefault_WhenNote1Starts_Note1StateShouldEqualOn"
    solo=false
    mute=false
}}
    ki init 0
    ki += 1

    if (ki == 1) then
        $NoteOn($Key1)
    elseif (ki == 2) then
        {{CHECK_EQUAL_k '{+{State.On}+}' '{+{hostValueGet}+}:k("Note.1.state")'}}
        $NoteOff($Key1)
        turnoff()
    endif
{{/CsoundTest}}


{{#CsoundTest "GivenAllValuesAreDefault_WhenNote1Ends_Note1StateShouldEqualOff"
    solo=false
    mute=false
}}
    ki init 0
    ki += 1

    if (ki == 1) then
        $NoteOn($Key1)
    elseif (ki == 2) then
        $NoteOff($Key1)
    elseif (ki == 3) then
        {{CHECK_EQUAL_k '{+{State.Off}+}' '{+{hostValueGet}+}:k("Note.1.state")'}}
        turnoff()
    endif
{{/CsoundTest}}


{{#CsoundTest "GivenReleaseTimeIs1_WhenNote1Ends_Note1StateShouldEqualOffAfter1Second"
    solo=false
    mute=false
}}
    ki init 0
    ki += 1

    k_noteOffTime init 0

    if (ki == 1) then
        {{hostValueSet}}("Note.releaseTime", 1)
        $NoteOn($Key1)
    elseif (ki == 2) then
        $NoteOff($Key1)
        k_noteOffTime = times()
    elseif (ki >= 3) then
        if (times() - k_noteOffTime >= 1) then
            {{CHECK_EQUAL_k '{+{State.Off}+}' '{+{hostValueGet}+}:k("Note.1.state")'}}
            turnoff()
        endif
    endif
{{/CsoundTest}}


{{#CsoundTest "GivenReleaseTimeIs1_WhenNote1Ends_Note1StateShouldEqualOn"
    solo=false
    mute=false
}}
    ki init 0
    ki += 1

    if (ki == 1) then
        {{hostValueSet}}("Note.releaseTime", 1)
        $NoteOn($Key1)
    elseif (ki == 2) then
        $NoteOff($Key1)
    elseif (ki == 3) then
        {{CHECK_EQUAL_k '{+{State.On}+}' '{+{hostValueGet}+}:k("Note.1.state")'}}
        turnoff()
    endif
{{/CsoundTest}}


{{#CsoundTest "GivenHardMaxIs1AndNote1IsOn_WhenNote2StartsAtK2_Note1StateShouldEqualHardOffAtK4"
    solo=false
    mute=false
}}
    ki init 0
    ki += 1

    if (ki == 1) then
        {{hostValueSet}}("Module::HardMax", 1)
        $NoteOn($Key1)
    elseif (ki == 2) then
        $NoteOn($Key2)
    elseif (ki == 4) then
        {{CHECK_EQUAL_k '{+{State.HardOff}+}' '{+{hostValueGet}+}:k("Note.1.state")'}}
        $NoteOff($Key1)
        $NoteOff($Key2)
        turnoff()
    endif
{{/CsoundTest}}


{{#CsoundTest "GivenHardMaxIs1AndNote1IsOn_WhenNote2StartsAtK2_Note1StateShouldEqualMutedAtK5"
    solo=false
    mute=false
}}
    ki init 0
    ki += 1

    if (ki == 1) then
        {{hostValueSet}}("Module::HardMax", 1)
        $NoteOn($Key1)
    elseif (ki == 2) then
        $NoteOn($Key2)
    elseif (ki == 5) then
        {{CHECK_EQUAL_k '{+{State.Muted}+}' '{+{hostValueGet}+}:k("Note.1.state")'}}
        $NoteOff($Key1)
        $NoteOff($Key2)
        turnoff()
    endif
{{/CsoundTest}}


{{#CsoundTest "GivenHardMaxIs1AndNote1IsOn_WhenNote2StartsAtK2_Note2StateShouldEqualOnAtK4"
    solo=false
    mute=false
}}
    ki init 0
    ki += 1

    if (ki == 1) then
        {{hostValueSet}}("Module::HardMax", 1)
        $NoteOn($Key1)
    elseif (ki == 2) then
        $NoteOn($Key2)
    elseif (ki == 4) then
        {{CHECK_EQUAL_k '{+{State.On}+}' '{+{hostValueGet}+}:k("Note.2.state")'}}
        $NoteOff($Key1)
        $NoteOff($Key2)
        turnoff()
    endif
{{/CsoundTest}}


{{#CsoundTest "GivenHardMaxIs1AndNote1IsOn_WhenNote2StartsAtK2AndStopsAtK3_Note1StateShouldEqualHardOffAtK4"
    solo=false
    mute=false
}}
    ki init 0
    ki += 1

    if (ki == 1) then
        {{hostValueSet}}("Module::HardMax", 1)
        $NoteOn($Key1)
    elseif (ki == 2) then
        $NoteOn($Key2)
    elseif (ki == 3) then
        $NoteOff($Key2)
    elseif (ki == 4) then
        {{CHECK_EQUAL_k '{+{State.HardOff}+}' '{+{hostValueGet}+}:k("Note.1.state")'}}
        $NoteOff($Key1)
        turnoff()
    endif
{{/CsoundTest}}


{{#CsoundTest "GivenHardMaxIs1AndNote1IsOn_WhenNote2StartsAtK2AndStopsAtK3_Note1StateShouldEqualMutedAtK5"
    solo=false
    mute=false
}}
    ki init 0
    ki += 1

    if (ki == 1) then
        {{hostValueSet}}("Module::HardMax", 1)
        $NoteOn($Key1)
    elseif (ki == 2) then
        $NoteOn($Key2)
    elseif (ki == 3) then
        $NoteOff($Key2)
    elseif (ki == 5) then
        {{CHECK_EQUAL_k '{+{State.Muted}+}' '{+{hostValueGet}+}:k("Note.1.state")'}}
        $NoteOff($Key1)
        turnoff()
    endif
{{/CsoundTest}}


{{#CsoundTest "GivenHardMaxIs2AndNote1IsOn_WhenNote2StartsAtK2_Note1StateShouldEqualOnAtK4"
    solo=false
    mute=false
}}
    ki init 0
    ki += 1

    if (ki == 1) then
        {{hostValueSet}}("Module::HardMax", 2)
        $NoteOn($Key1)
    elseif (ki == 2) then
        $NoteOn($Key2)
    elseif (ki == 4) then
        {{CHECK_EQUAL_k '{+{State.On}+}' '{+{hostValueGet}+}:k("Note.1.state")'}}
        $NoteOff($Key1)
        $NoteOff($Key2)
        turnoff()
    endif
{{/CsoundTest}}


{{#CsoundTest "GivenHardMaxIs1AndSoftMaxIs1AndNote1IsOn_WhenNote2StartsAtK2_Note1StateShouldEqualHardOffAtK4"
    solo=false
    mute=false
}}
    ki init 0
    ki += 1

    if (ki == 1) then
        {{hostValueSet}}("Module::HardMax", 1)
        {{hostValueSet}}("Module::SoftMax", 1)
        $NoteOn($Key1)
    elseif (ki == 2) then
        $NoteOn($Key2)
    elseif (ki == 4) then
        {{CHECK_EQUAL_k '{+{State.HardOff}+}' '{+{hostValueGet}+}:k("Note.1.state")'}}
        $NoteOff($Key1)
        $NoteOff($Key2)
        turnoff()
    endif
{{/CsoundTest}}


{{#CsoundTest "GivenHardMaxIs2AndSoftMaxIs1AndNote1IsOn_WhenNotes2And3StartAtK2_Note1StateShouldEqualHardOffAtK4"
    solo=false
    mute=false
}}
    ki init 0
    ki += 1

    if (ki == 1) then
        {{hostValueSet}}("Module::HardMax", 2)
        {{hostValueSet}}("Module::SoftMax", 1)
        $NoteOn($Key1)
    elseif (ki == 2) then
        $NoteOn($Key2)
        $NoteOn($Key3)
    elseif (ki == 4) then
        {{CHECK_EQUAL_k '{+{State.HardOff}+}' '{+{hostValueGet}+}:k("Note.1.state")'}}
        $NoteOff($Key1)
        $NoteOff($Key2)
        $NoteOff($Key3)
        turnoff()
    endif
{{/CsoundTest}}


{{#CsoundTest "GivenHardMaxIs2AndSoftMaxIs1AndNote1IsOn_WhenNotes2And3StartAtK2_Note2StateShouldEqualSoftOffAtK4"
    solo=false
    mute=false
}}
    ki init 0
    ki += 1

    if (ki == 1) then
        {{hostValueSet}}("Module::HardMax", 2)
        {{hostValueSet}}("Module::SoftMax", 1)
        $NoteOn($Key1)
    elseif (ki == 2) then
        $NoteOn($Key2)
        $NoteOn($Key3)
    elseif (ki == 4) then
        {{CHECK_EQUAL_k '{+{State.SoftOff}+}' '{+{hostValueGet}+}:k("Note.2.state")'}}
        $NoteOff($Key1)
        $NoteOff($Key2)
        $NoteOff($Key3)
        turnoff()
    endif
{{/CsoundTest}}


{{#CsoundTest "GivenSoftMaxIs1AndNote1IsOn_WhenNote2StartsAtK2_Note1StateShouldEqualSoftOffAtK4"
    solo=false
    mute=false
}}
    ki init 0
    ki += 1

    if (ki == 1) then
        {{hostValueSet}}("Module::SoftMax", 1)
        $NoteOn($Key1)
    elseif (ki == 2) then
        $NoteOn($Key2)
    elseif (ki == 4) then
        {{CHECK_EQUAL_k '{+{State.SoftOff}+}' '{+{hostValueGet}+}:k("Note.1.state")'}}
        $NoteOff($Key1)
        $NoteOff($Key2)
        turnoff()
    endif
{{/CsoundTest}}


{{#CsoundTest "GivenSoftMaxIs1AndNote1IsOn_WhenNote2Starts_Note1StateShouldEqualMuted_AfterDefaultSoftOffFadeTime"
    solo=false
    mute=false
}}
    ki init 0
    k_noteSoftOffStartTime init 0
    k_softOffFadeTime init {{hostValueGet}}:i("Module::SoftOffFadeTime")

    ki += 1

    if (ki == 1) then
        {{hostValueSet}}("Module::SoftMax", 1)
        $NoteOn($Key1)
    elseif (ki == 2) then
        $NoteOn($Key2)
    elseif (ki == 3) then
        k_noteSoftOffStartTime = times()
    elseif (ki >= 4) then
        if (times() - k_noteSoftOffStartTime >= k_softOffFadeTime) then
            {{CHECK_EQUAL_k '{+{State.Muted}+}' '{+{hostValueGet}+}:k("Note.1.state")'}}
            $NoteOff($Key1)
            $NoteOff($Key2)
            turnoff()
        endif
    endif
{{/CsoundTest}}


{{#CsoundTest "GivenSoftMaxIs1AndSoftOffFadeTimeIs2AndNote1IsOn_WhenNote2Starts_Note1StateShouldEqualMuted_AfterGivenSoftOffFadeTime"
    solo=false
    mute=false
}}
    ki init 0
    k_noteSoftOffStartTime init 0

    i_softOffFadeTime = 2
    {{hostValueSet}}("Module::SoftOffFadeTime", i_softOffFadeTime)

    ki += 1

    if (ki == 1) then
        {{hostValueSet}}("Module::SoftMax", 1)
        $NoteOn($Key1)
    elseif (ki == 2) then
        $NoteOn($Key2)
    elseif (ki == 3) then
        k_noteSoftOffStartTime = times()
    elseif (ki >= 4) then
        if (times() - k_noteSoftOffStartTime >= i_softOffFadeTime) then
            {{CHECK_EQUAL_k '{+{State.Muted}+}' '{+{hostValueGet}+}:k("Note.1.state")'}}
            $NoteOff($Key1)
            $NoteOff($Key2)
            turnoff()
        endif
    endif
{{/CsoundTest}}


{{#CsoundTest "GivenSoftMaxIs2AndNote1IsOn_WhenNote2StartsAtK2_Note1StateShouldEqualOnAtK4"
    solo=false
    mute=false
}}
    ki init 0
    ki += 1

    if (ki == 1) then
        {{hostValueSet}}("Module::SoftMax", 2)
        $NoteOn($Key1)
    elseif (ki == 2) then
        $NoteOn($Key2)
    elseif (ki == 4) then
        {{CHECK_EQUAL_k '{+{State.On}+}' '{+{hostValueGet}+}:k("Note.1.state")'}}
        $NoteOff($Key1)
        $NoteOff($Key2)
        turnoff()
    endif
{{/CsoundTest}}


{{#CsoundTest "GivenSoftMaxIs2AndNotes1And2AreOn_WhenNote3StartsAtK2_Note1StateShouldEqualSoftOffAtK4"
    solo=false
    mute=false
}}
    ki init 0
    ki += 1

    if (ki == 1) then
        {{hostValueSet}}("Module::SoftMax", 2)
        $NoteOn($Key1)
        $NoteOn($Key2)
    elseif (ki == 2) then
        $NoteOn($Key3)
    elseif (ki == 4) then
        {{CHECK_EQUAL_k '{+{State.SoftOff}+}' '{+{hostValueGet}+}:k("Note.1.state")'}}
        $NoteOff($Key1)
        $NoteOff($Key2)
        $NoteOff($Key3)
        turnoff()
    endif
{{/CsoundTest}}


{{#CsoundTest "GivenHardMaxIs1AndKeepHighNoteIsTrueAndHighNoteIsOn_WhenMidNoteStartsAtK2_HighNoteStateShouldEqualOnAtK4"
    solo=false
    mute=false
}}
    ki init 0
    ki += 1

    if (ki == 1) then
        {{hostValueSet}}("Module::HardMax", 1)
        {{hostValueSet}}("Module::KeepHighNote", $true)
        $NoteOn($HighNoteKey)
    elseif (ki == 2) then
        $NoteOn($MidNoteKey)
    elseif (ki == 4) then
        {{CHECK_EQUAL_k '{+{State.On}+}' '{+{hostValueGet}+}:k("Note.1.state")'}}
        $NoteOff($HighNoteKey)
        $NoteOff($MidNoteKey)
        turnoff()
    endif
{{/CsoundTest}}


{{#CsoundTest "GivenHardMaxIs1AndKeepHighNoteIsTrueAndHighNoteIsOn_WhenMidNoteStartsAtK2_MidNoteStateShouldEqualHardOffAtK4"
    solo=false
    mute=false
}}
    ki init 0
    ki += 1

    if (ki == 1) then
        {{hostValueSet}}("Module::HardMax", 1)
        {{hostValueSet}}("Module::KeepHighNote", $true)
        $NoteOn($HighNoteKey)
    elseif (ki == 2) then
        $NoteOn($MidNoteKey)
    elseif (ki == 4) then
        {{CHECK_EQUAL_k '{+{State.HardOff}+}' '{+{hostValueGet}+}:k("Note.2.state")'}}
        $NoteOff($HighNoteKey)
        $NoteOff($MidNoteKey)
        turnoff()
    endif
{{/CsoundTest}}


{{#CsoundTest "GivenHardMaxIs1AndKeepHighNoteIsTrueAndHighNoteIsOn_WhenMidNoteIsOnAtK2AndHighNoteIsOffAtK4_MidNoteStateShouldEqualSoftOnAtK6"
    solo=false
    mute=false
}}
    ki init 0
    ki += 1

    if (ki == 1) then
        {{hostValueSet}}("Module::HardMax", 1)
        {{hostValueSet}}("Module::KeepHighNote", $true)
        $NoteOn($HighNoteKey)
    elseif (ki == 2) then
        $NoteOn($MidNoteKey)
    elseif (ki == 4) then
        $NoteOff($HighNoteKey)
    elseif (ki == 6) then
        {{CHECK_EQUAL_k '{+{State.SoftOn}+}' '{+{hostValueGet}+}:k("Note.2.state")'}}
        $NoteOff($MidNoteKey)
        turnoff()
    endif
{{/CsoundTest}}


{{#CsoundTest "GivenHardMaxIs1AndKeepLowNoteIsTrueAndLowNoteIsOn_WhenMidNoteStartsAtK2_LowNoteStateShouldEqualOnAtK4"
    solo=false
    mute=false
}}
    ki init 0
    ki += 1

    if (ki == 1) then
        {{hostValueSet}}("Module::HardMax", 1)
        {{hostValueSet}}("Module::KeepLowNote", $true)
        $NoteOn($LowNoteKey)
    elseif (ki == 2) then
        $NoteOn($MidNoteKey)
    elseif (ki == 4) then
        {{CHECK_EQUAL_k '{+{State.On}+}' '{+{hostValueGet}+}:k("Note.1.state")'}}
        $NoteOff($LowNoteKey)
        $NoteOff($MidNoteKey)
        turnoff()
    endif
{{/CsoundTest}}


{{#CsoundTest "GivenHardMaxIs1AndKeepLowNoteIsTrueAndLowNoteIsOn_WhenMidNoteStartsAtK2_MidNoteStateShouldEqualHardOffAtK4"
    solo=false
    mute=false
}}
    ki init 0
    ki += 1

    if (ki == 1) then
        {{hostValueSet}}("Module::HardMax", 1)
        {{hostValueSet}}("Module::KeepLowNote", $true)
        $NoteOn($LowNoteKey)
    elseif (ki == 2) then
        $NoteOn($MidNoteKey)
    elseif (ki == 4) then
        {{CHECK_EQUAL_k '{+{State.HardOff}+}' '{+{hostValueGet}+}:k("Note.2.state")'}}
        $NoteOff($LowNoteKey)
        $NoteOff($MidNoteKey)
        turnoff()
    endif
{{/CsoundTest}}


{{#CsoundTest "GivenHardMaxIs1AndKeepLowNoteIsTrueAndLowNoteIsOn_WhenMidNoteIsOnAtK2AndLowNoteIsOffAtK4_MidNoteStateShouldEqualSoftOnAtK6"
    solo=false
    mute=false
}}
    ki init 0
    ki += 1

    if (ki == 1) then
        {{hostValueSet}}("Module::HardMax", 1)
        {{hostValueSet}}("Module::KeepLowNote", $true)
        $NoteOn($LowNoteKey)
    elseif (ki == 2) then
        $NoteOn($MidNoteKey)
    elseif (ki == 4) then
        $NoteOff($LowNoteKey)
    elseif (ki == 6) then
        {{CHECK_EQUAL_k '{+{State.SoftOn}+}' '{+{hostValueGet}+}:k("Note.2.state")'}}
        $NoteOff($MidNoteKey)
        turnoff()
    endif
{{/CsoundTest}}


{{#CsoundTest "GivenHardMaxIs1AndKeepHighNoteIsTrue_WhenMidNoteStateEntersSoftOn_MidNoteStateShouldEqualOn_AfterDefaultSoftOnFadeTime"
    solo=false
    mute=false
}}
    k_noteSoftOnStartTime init 0
    k_softOnFadeTime init {{hostValueGet}}:i("Module::SoftOnFadeTime")

    ki init 0
    ki += 1

    if (ki == 1) then
        {{hostValueSet}}("Module::HardMax", 1)
        {{hostValueSet}}("Module::KeepHighNote", $true)
        $NoteOn($HighNoteKey)
    elseif (ki == 2) then
        $NoteOn($MidNoteKey)
    elseif (ki == 3) then
        $NoteOff($HighNoteKey)
    elseif (ki == 5) then
        {{CHECK_EQUAL_k '{+{State.SoftOn}+}' '{+{hostValueGet}+}:k("Note.2.state")'}}
        k_noteSoftOnStartTime = times()
    elseif (ki >= 6) then
        if (times() - k_noteSoftOnStartTime >= k_softOnFadeTime) then
            {{CHECK_EQUAL_k '{+{State.On}+}' '{+{hostValueGet}+}:k("Note.2.state")'}}
            $NoteOff($MidNoteKey)
            turnoff()
        endif
    endif
{{/CsoundTest}}


{{#CsoundTest "GivenHardMaxIs1AndKeepLowNoteIsTrue_WhenMidNoteStateEntersSoftOn_MidNoteStateShouldEqualOn_AfterDefaultSoftOnFadeTime"
    solo=false
    mute=false
}}
    k_noteSoftOnStartTime init 0
    k_softOnFadeTime init {{hostValueGet}}:i("Module::SoftOnFadeTime")

    ki init 0
    ki += 1

    if (ki == 1) then
        {{hostValueSet}}("Module::HardMax", 1)
        {{hostValueSet}}("Module::KeepLowNote", $true)
        $NoteOn($LowNoteKey)
    elseif (ki == 2) then
        $NoteOn($MidNoteKey)
    elseif (ki == 3) then
        $NoteOff($LowNoteKey)
    elseif (ki == 5) then
        {{CHECK_EQUAL_k '{+{State.SoftOn}+}' '{+{hostValueGet}+}:k("Note.2.state")'}}
        k_noteSoftOnStartTime = times()
    elseif (ki >= 6) then
        if (times() - k_noteSoftOnStartTime >= k_softOnFadeTime) then
            {{CHECK_EQUAL_k '{+{State.On}+}' '{+{hostValueGet}+}:k("Note.2.state")'}}
            $NoteOff($MidNoteKey)
            turnoff()
        endif
    endif
{{/CsoundTest}}


{{#CsoundTest "GivenHardMaxIs1AndKeepHighAndLowNotesIsTrueAndHighAndLowNotesAreOn_WhenMidNoteStartsAtK2_HighAndLowNoteStatesShouldEqualOnAtK4"
    solo=false
    mute=false
}}
    ki init 0
    ki += 1

    if (ki == 1) then
        {{hostValueSet}}("Module::HardMax", 1)
        {{hostValueSet}}("Module::KeepHighNote", $true)
        {{hostValueSet}}("Module::KeepLowNote", $true)
        $NoteOn($HighNoteKey)
        $NoteOn($LowNoteKey)
    elseif (ki == 2) then
        $NoteOn($MidNoteKey)
    elseif (ki == 4) then
        {{CHECK_EQUAL_k '{+{State.On}+}' '{+{hostValueGet}+}:k("Note.1.state")'}}
        {{CHECK_EQUAL_k '{+{State.On}+}' '{+{hostValueGet}+}:k("Note.2.state")'}}
        $NoteOff($HighNoteKey)
        $NoteOff($LowNoteKey)
        $NoteOff($MidNoteKey)
        turnoff()
    endif
{{/CsoundTest}}


{{#CsoundTest "GivenHardMaxIs1AndKeepHighAndLowNotesIsTrueAndHighAndLowNotesAreOn_WhenMidNoteStartsAtK2_MidNoteStateShouldEqualHardOffAtK4"
    solo=false
    mute=false
}}
    ki init 0
    ki += 1

    if (ki == 1) then
        {{hostValueSet}}("Module::HardMax", 1)
        {{hostValueSet}}("Module::KeepHighNote", $true)
        {{hostValueSet}}("Module::KeepLowNote", $true)
        $NoteOn($HighNoteKey)
        $NoteOn($LowNoteKey)
    elseif (ki == 2) then
        $NoteOn($MidNoteKey)
    elseif (ki == 4) then
        {{CHECK_EQUAL_k '{+{State.HardOff}+}' '{+{hostValueGet}+}:k("Note.3.state")'}}
        $NoteOff($HighNoteKey)
        $NoteOff($LowNoteKey)
        $NoteOff($MidNoteKey)
        turnoff()
    endif
{{/CsoundTest}}


{{#CsoundTest "GivenHardMaxIs1AndKeepHighAndLowNotesIsTrueAndHighAndLowNotesAreOn_WhenMidNoteStartsAtK2_MidNoteStateShouldEqualMutedAtK5"
    solo=false
    mute=false
}}
    ki init 0
    ki += 1

    if (ki == 1) then
        {{hostValueSet}}("Module::HardMax", 1)
        {{hostValueSet}}("Module::KeepHighNote", $true)
        {{hostValueSet}}("Module::KeepLowNote", $true)
        $NoteOn($HighNoteKey)
        $NoteOn($LowNoteKey)
    elseif (ki == 2) then
        $NoteOn($MidNoteKey)
    elseif (ki == 5) then
        {{CHECK_EQUAL_k '{+{State.Muted}+}' '{+{hostValueGet}+}:k("Note.3.state")'}}
        $NoteOff($HighNoteKey)
        $NoteOff($LowNoteKey)
        $NoteOff($MidNoteKey)
        turnoff()
    endif
{{/CsoundTest}}


{{#CsoundTest "GivenHardMaxIs1AndKeepHighAndLowNotesIsTrueAndHighAndLowNotesAreOn_WhenMidNoteIsOnAtK2AndHighNoteIsOffAtK4_MidNoteStateShouldEqualSoftOnAtK6"
    solo=false
    mute=false
}}
    ki init 0
    ki += 1

    if (ki == 1) then
        {{hostValueSet}}("Module::HardMax", 1)
        {{hostValueSet}}("Module::KeepHighNote", $true)
        {{hostValueSet}}("Module::KeepLowNote", $true)
        $NoteOn($HighNoteKey)
        $NoteOn($LowNoteKey)
    elseif (ki == 2) then
        $NoteOn($MidNoteKey)
    elseif (ki == 4) then
        $NoteOff($HighNoteKey)
    elseif (ki == 6) then
        {{CHECK_EQUAL_k '{+{State.SoftOn}+}' '{+{hostValueGet}+}:k("Note.3.state")'}}
        $NoteOff($LowNoteKey)
        $NoteOff($MidNoteKey)
        turnoff()
    endif
{{/CsoundTest}}


{{#CsoundTest "GivenHardMaxIs1AndKeepHighAndLowNotesIsTrueAndHighAndLowNotesAreOn_WhenMidNoteIsOnAtK2AndLowNoteIsOffAtK4_MidNoteStateShouldEqualSoftOnAtK6"
    solo=false
    mute=false
}}
    ki init 0
    ki += 1

    if (ki == 1) then
        {{hostValueSet}}("Module::HardMax", 1)
        {{hostValueSet}}("Module::KeepHighNote", $true)
        {{hostValueSet}}("Module::KeepLowNote", $true)
        $NoteOn($HighNoteKey)
        $NoteOn($LowNoteKey)
    elseif (ki == 2) then
        $NoteOn($MidNoteKey)
    elseif (ki == 4) then
        $NoteOff($LowNoteKey)
    elseif (ki == 6) then
        {{CHECK_EQUAL_k '{+{State.SoftOn}+}' '{+{hostValueGet}+}:k("Note.3.state")'}}
        $NoteOff($HighNoteKey)
        $NoteOff($MidNoteKey)
        turnoff()
    endif
{{/CsoundTest}}


{{#CsoundTest "GivenHardMaxIs1AndKeepHighAndLowNotesIsTrueAndHighAndLowNotesAreOn_WhenMidNoteIsOnAtK2AndHighAndLowNotesAreOffAtK4_MidNoteStateShouldEqualSoftOnAtK6"
    solo=false
    mute=false
}}
    ki init 0
    ki += 1

    if (ki == 1) then
        {{hostValueSet}}("Module::HardMax", 1)
        {{hostValueSet}}("Module::KeepHighNote", $true)
        {{hostValueSet}}("Module::KeepLowNote", $true)
        $NoteOn($HighNoteKey)
        $NoteOn($LowNoteKey)
    elseif (ki == 2) then
        $NoteOn($MidNoteKey)
    elseif (ki == 4) then
        $NoteOff($LowNoteKey)
        $NoteOff($HighNoteKey)
    elseif (ki == 6) then
        {{CHECK_EQUAL_k '{+{State.SoftOn}+}' '{+{hostValueGet}+}:k("Note.3.state")'}}
        $NoteOff($MidNoteKey)
        turnoff()
    endif
{{/CsoundTest}}


{{#CsoundTest "GivenHardMaxIs1AndKeepHighAndLowNotesIsTrueAndHighAndLowNotesAreOn_WhenMidAndMidHighNotesAreOnAtK2AndHighNoteIsOffAtK4_MidHighNoteStateShouldEqualSoftOnAtK6"
    solo=false
    mute=false
}}
    ki init 0
    ki += 1

    if (ki == 1) then
        {{hostValueSet}}("Module::HardMax", 1)
        {{hostValueSet}}("Module::KeepHighNote", $true)
        {{hostValueSet}}("Module::KeepLowNote", $true)
        $NoteOn($HighNoteKey)
        $NoteOn($LowNoteKey)
    elseif (ki == 2) then
        $NoteOn($MidNoteKey)
        $NoteOn($MidHighNoteKey)
    elseif (ki == 4) then
        $NoteOff($HighNoteKey)
    elseif (ki == 6) then
        {{CHECK_EQUAL_k '{+{State.SoftOn}+}' '{+{hostValueGet}+}:k("Note.4.state")'}}
        $NoteOff($LowNoteKey)
        $NoteOff($MidNoteKey)
        $NoteOff($MidHighNoteKey)
        turnoff()
    endif
{{/CsoundTest}}


{{#CsoundTest "GivenHardMaxIs1AndKeepHighAndLowNotesIsTrueAndHighAndLowNotesAreOn_WhenMidAndMidHighNotesAreOnAtK2AndHighNoteIsOffAtK4_MidNoteStateShouldEqualMutedAtK6"
    solo=false
    mute=false
}}
    ki init 0
    ki += 1

    if (ki == 1) then
        {{hostValueSet}}("Module::HardMax", 1)
        {{hostValueSet}}("Module::KeepHighNote", $true)
        {{hostValueSet}}("Module::KeepLowNote", $true)
        $NoteOn($HighNoteKey)
        $NoteOn($LowNoteKey)
    elseif (ki == 2) then
        $NoteOn($MidNoteKey)
        $NoteOn($MidHighNoteKey)
    elseif (ki == 4) then
        $NoteOff($HighNoteKey)
    elseif (ki == 6) then
        {{CHECK_EQUAL_k '{+{State.Muted}+}' '{+{hostValueGet}+}:k("Note.3.state")'}}
        $NoteOff($LowNoteKey)
        $NoteOff($MidNoteKey)
        $NoteOff($MidHighNoteKey)
        turnoff()
    endif
{{/CsoundTest}}


{{#CsoundTest "GivenHardMaxIs1AndKeepHighAndLowNotesIsTrueAndHighAndLowNotesAreOn_WhenMidAndMidLowNotesAreOnAtK2AndLowNoteIsOffAtK4_MidLowNoteStateShouldEqualSoftOnAtK6"
    solo=false
    mute=false
}}
    ki init 0
    ki += 1

    if (ki == 1) then
        {{hostValueSet}}("Module::HardMax", 1)
        {{hostValueSet}}("Module::KeepHighNote", $true)
        {{hostValueSet}}("Module::KeepLowNote", $true)
        $NoteOn($HighNoteKey)
        $NoteOn($LowNoteKey)
    elseif (ki == 2) then
        $NoteOn($MidNoteKey)
        $NoteOn($MidLowNoteKey)
    elseif (ki == 4) then
        $NoteOff($LowNoteKey)
    elseif (ki == 6) then
        {{CHECK_EQUAL_k '{+{State.SoftOn}+}' '{+{hostValueGet}+}:k("Note.4.state")'}}
        $NoteOff($HighNoteKey)
        $NoteOff($MidNoteKey)
        $NoteOff($MidLowNoteKey)
        turnoff()
    endif
{{/CsoundTest}}


{{#CsoundTest "GivenHardMaxIs1AndKeepHighAndLowNotesIsTrueAndHighAndLowNotesAreOn_WhenMidAndMidLowNotesAreOnAtK2AndLowNoteIsOffAtK4_MidNoteStateShouldEqualMutedAtK6"
    solo=false
    mute=false
}}
    ki init 0
    ki += 1

    if (ki == 1) then
        {{hostValueSet}}("Module::HardMax", 1)
        {{hostValueSet}}("Module::KeepHighNote", $true)
        {{hostValueSet}}("Module::KeepLowNote", $true)
        $NoteOn($HighNoteKey)
        $NoteOn($LowNoteKey)
    elseif (ki == 2) then
        $NoteOn($MidNoteKey)
        $NoteOn($MidLowNoteKey)
    elseif (ki == 4) then
        $NoteOff($LowNoteKey)
    elseif (ki == 6) then
        {{CHECK_EQUAL_k '{+{State.Muted}+}' '{+{hostValueGet}+}:k("Note.3.state")'}}
        $NoteOff($HighNoteKey)
        $NoteOff($MidNoteKey)
        $NoteOff($MidLowNoteKey)
        turnoff()
    endif
{{/CsoundTest}}


{{#CsoundTest "GivenSoftMaxIs1AndKeepHighNoteIsTrueAndHighNoteIsOn_WhenMidNoteStartsAtK2_HighNoteStateShouldEqualOnAtK4"
    solo=false
    mute=false
}}
    ki init 0
    ki += 1

    if (ki == 1) then
        {{hostValueSet}}("Module::SoftMax", 1)
        {{hostValueSet}}("Module::KeepHighNote", $true)
        $NoteOn($HighNoteKey)
    elseif (ki == 2) then
        $NoteOn($MidNoteKey)
    elseif (ki == 4) then
        {{CHECK_EQUAL_k '{+{State.On}+}' '{+{hostValueGet}+}:k("Note.1.state")'}}
        $NoteOff($HighNoteKey)
        $NoteOff($MidNoteKey)
        turnoff()
    endif
{{/CsoundTest}}


{{#CsoundTest "GivenSoftMaxIs1AndKeepHighNoteIsTrueAndHighNoteIsOn_WhenMidNoteStartsAtK2_MidNoteStateShouldEqualSoftOffAtK4"
    solo=false
    mute=false
}}
    ki init 0
    ki += 1

    if (ki == 1) then
        {{hostValueSet}}("Module::SoftMax", 1)
        {{hostValueSet}}("Module::KeepHighNote", $true)
        $NoteOn($HighNoteKey)
    elseif (ki == 2) then
        $NoteOn($MidNoteKey)
    elseif (ki == 4) then
        {{CHECK_EQUAL_k '{+{State.SoftOff}+}' '{+{hostValueGet}+}:k("Note.2.state")'}}
        $NoteOff($HighNoteKey)
        $NoteOff($MidNoteKey)
        turnoff()
    endif
{{/CsoundTest}}


{{#CsoundTest "GivenSoftMaxIs1AndKeepHighNoteIsTrueAndHighNoteIsOn_WhenMidNoteIsOnAtK2AndHighNoteIsOffAtK4_MidNoteStateShouldEqualSoftOnAtK6"
    solo=false
    mute=false
}}
    ki init 0
    ki += 1

    if (ki == 1) then
        {{hostValueSet}}("Module::SoftMax", 1)
        {{hostValueSet}}("Module::KeepHighNote", $true)
        $NoteOn($HighNoteKey)
    elseif (ki == 2) then
        $NoteOn($MidNoteKey)
    elseif (ki == 4) then
        $NoteOff($HighNoteKey)
    elseif (ki == 6) then
        {{CHECK_EQUAL_k '{+{State.SoftOn}+}' '{+{hostValueGet}+}:k("Note.2.state")'}}
        $NoteOff($MidNoteKey)
        turnoff()
    endif
{{/CsoundTest}}


{{#CsoundTest "GivenSoftMaxIs1AndKeepLowNoteIsTrueAndLowNoteIsOn_WhenMidNoteStartsAtK2_LowNoteStateShouldEqualOnAtK4"
    solo=false
    mute=false
}}
    ki init 0
    ki += 1

    if (ki == 1) then
        {{hostValueSet}}("Module::SoftMax", 1)
        {{hostValueSet}}("Module::KeepLowNote", $true)
        $NoteOn($LowNoteKey)
    elseif (ki == 2) then
        $NoteOn($MidNoteKey)
    elseif (ki == 4) then
        {{CHECK_EQUAL_k '{+{State.On}+}' '{+{hostValueGet}+}:k("Note.1.state")'}}
        $NoteOff($LowNoteKey)
        $NoteOff($MidNoteKey)
        turnoff()
    endif
{{/CsoundTest}}


{{#CsoundTest "GivenSoftMaxIs1AndKeepLowNoteIsTrueAndLowNoteIsOn_WhenMidNoteStartsAtK2_MidNoteStateShouldEqualSoftOffAtK4"
    solo=false
    mute=false
}}
    ki init 0
    ki += 1

    if (ki == 1) then
        {{hostValueSet}}("Module::SoftMax", 1)
        {{hostValueSet}}("Module::KeepLowNote", $true)
        $NoteOn($LowNoteKey)
    elseif (ki == 2) then
        $NoteOn($MidNoteKey)
    elseif (ki == 4) then
        {{CHECK_EQUAL_k '{+{State.SoftOff}+}' '{+{hostValueGet}+}:k("Note.2.state")'}}
        $NoteOff($LowNoteKey)
        $NoteOff($MidNoteKey)
        turnoff()
    endif
{{/CsoundTest}}


{{#CsoundTest "GivenSoftMaxIs1AndKeepLowNoteIsTrueAndLowNoteIsOn_WhenMidNoteIsOnAtK2AndLowNoteIsOffAtK4_MidNoteStateShouldEqualSoftOnAtK6"
    solo=false
    mute=false
}}
    ki init 0
    ki += 1

    if (ki == 1) then
        {{hostValueSet}}("Module::SoftMax", 1)
        {{hostValueSet}}("Module::KeepLowNote", $true)
        $NoteOn($LowNoteKey)
    elseif (ki == 2) then
        $NoteOn($MidNoteKey)
    elseif (ki == 4) then
        $NoteOff($LowNoteKey)
    elseif (ki == 6) then
        {{CHECK_EQUAL_k '{+{State.SoftOn}+}' '{+{hostValueGet}+}:k("Note.2.state")'}}
        $NoteOff($MidNoteKey)
        turnoff()
    endif
{{/CsoundTest}}


{{#CsoundTest "GivenSoftMaxIs1AndKeepHighNoteIsTrue_WhenMidNoteStateEntersSoftOn_MidNoteStateShouldEqualOn_AfterDefaultSoftOnFadeTime"
    solo=false
    mute=false
}}
    k_noteSoftOnStartTime init 0
    k_softOnFadeTime init {{hostValueGet}}:i("Module::SoftOnFadeTime")

    ki init 0
    ki += 1

    if (ki == 1) then
        {{hostValueSet}}("Module::SoftMax", 1)
        {{hostValueSet}}("Module::KeepHighNote", $true)
        $NoteOn($HighNoteKey)
    elseif (ki == 2) then
        $NoteOn($MidNoteKey)
    elseif (ki == 3) then
        $NoteOff($HighNoteKey)
    elseif (ki == 5) then
        {{CHECK_EQUAL_k '{+{State.SoftOn}+}' '{+{hostValueGet}+}:k("Note.2.state")'}}
        k_noteSoftOnStartTime = times()
    elseif (ki >= 7) then
        if (times() - k_noteSoftOnStartTime >= k_softOnFadeTime) then
            {{CHECK_EQUAL_k '{+{State.On}+}' '{+{hostValueGet}+}:k("Note.2.state")'}}
            $NoteOff($MidNoteKey)
            turnoff()
        endif
    endif
{{/CsoundTest}}


{{#CsoundTest "GivenSoftMaxIs1AndKeepLowNoteIsTrue_WhenMidNoteStateEntersSoftOn_MidNoteStateShouldEqualOn_AfterDefaultSoftOnFadeTime"
    solo=false
    mute=false
}}
    k_noteSoftOnStartTime init 0
    k_softOnFadeTime init {{hostValueGet}}:i("Module::SoftOnFadeTime")

    ki init 0
    ki += 1

    if (ki == 1) then
        {{hostValueSet}}("Module::SoftMax", 1)
        {{hostValueSet}}("Module::KeepLowNote", $true)
        $NoteOn($LowNoteKey)
    elseif (ki == 2) then
        $NoteOn($MidNoteKey)
    elseif (ki == 3) then
        $NoteOff($LowNoteKey)
    elseif (ki == 5) then
        {{CHECK_EQUAL_k '{+{State.SoftOn}+}' '{+{hostValueGet}+}:k("Note.2.state")'}}
        k_noteSoftOnStartTime = times()
    elseif (ki >= 6) then
        if (times() - k_noteSoftOnStartTime >= k_softOnFadeTime) then
            {{CHECK_EQUAL_k '{+{State.On}+}' '{+{hostValueGet}+}:k("Note.2.state")'}}
            $NoteOff($MidNoteKey)
            turnoff()
        endif
    endif
{{/CsoundTest}}


{{#CsoundTest "GivenSoftMaxIs1AndKeepHighAndLowNotesIsTrueAndHighAndLowNotesAreOn_WhenMidNoteStartsAtK2_HighAndLowNoteStatesShouldEqualOnAtK4"
    solo=false
    mute=false
}}
    ki init 0
    ki += 1

    if (ki == 1) then
        {{hostValueSet}}("Module::SoftMax", 1)
        {{hostValueSet}}("Module::KeepHighNote", $true)
        {{hostValueSet}}("Module::KeepLowNote", $true)
        $NoteOn($HighNoteKey)
        $NoteOn($LowNoteKey)
    elseif (ki == 2) then
        $NoteOn($MidNoteKey)
    elseif (ki == 4) then
        {{CHECK_EQUAL_k '{+{State.On}+}' '{+{hostValueGet}+}:k("Note.1.state")'}}
        {{CHECK_EQUAL_k '{+{State.On}+}' '{+{hostValueGet}+}:k("Note.2.state")'}}
        $NoteOff($HighNoteKey)
        $NoteOff($LowNoteKey)
        $NoteOff($MidNoteKey)
        turnoff()
    endif
{{/CsoundTest}}


{{#CsoundTest "GivenSoftMaxIs1AndKeepHighAndLowNotesIsTrueAndHighAndLowNotesAreOn_WhenMidNoteStartsAtK2_MidNoteStateShouldEqualSoftOffAtK4"
    solo=false
    mute=false
}}
    ki init 0
    ki += 1

    if (ki == 1) then
        {{hostValueSet}}("Module::SoftMax", 1)
        {{hostValueSet}}("Module::KeepHighNote", $true)
        {{hostValueSet}}("Module::KeepLowNote", $true)
        $NoteOn($HighNoteKey)
        $NoteOn($LowNoteKey)
    elseif (ki == 2) then
        $NoteOn($MidNoteKey)
    elseif (ki == 4) then
        {{CHECK_EQUAL_k '{+{State.SoftOff}+}' '{+{hostValueGet}+}:k("Note.3.state")'}}
        $NoteOff($HighNoteKey)
        $NoteOff($LowNoteKey)
        $NoteOff($MidNoteKey)
        turnoff()
    endif
{{/CsoundTest}}


{{#CsoundTest "GivenSoftMaxIs1AndKeepHighAndLowNotesIsTrueAndHighAndLowNotesAreOn_WhenMidNoteStartsAtK2_MidNoteStateShouldEqualMuted_AfterDefaultSoftOffFadeTime"
    solo=false
    mute=false
}}
    k_noteSoftOffStartTime init 0
    k_softOffFadeTime init {{hostValueGet}}:i("Module::SoftOffFadeTime")

    ki init 0
    ki += 1

    if (ki == 1) then
        {{hostValueSet}}("Module::HardMax", 1)
        {{hostValueSet}}("Module::KeepHighNote", $true)
        {{hostValueSet}}("Module::KeepLowNote", $true)
        $NoteOn($HighNoteKey)
        $NoteOn($LowNoteKey)
    elseif (ki == 2) then
        $NoteOn($MidNoteKey)
    elseif (ki == 3) then
        k_noteSoftOffStartTime = times()
    elseif (ki >= 4) then
        if (times() - k_noteSoftOffStartTime >= k_softOffFadeTime) then
            {{CHECK_EQUAL_k '{+{State.Muted}+}' '{+{hostValueGet}+}:k("Note.3.state")'}}
            $NoteOff($HighNoteKey)
            $NoteOff($LowNoteKey)
            $NoteOff($MidNoteKey)
            turnoff()
        endif
    endif
{{/CsoundTest}}


{{#CsoundTest "GivenSoftMaxIs1AndKeepHighAndLowNotesIsTrueAndHighAndLowNotesAreOn_WhenMidNoteIsOnAtK2AndHighNoteIsOffAtK4_MidNoteStateShouldEqualSoftOnAtK6"
    solo=false
    mute=false
}}
    ki init 0
    ki += 1

    if (ki == 1) then
        {{hostValueSet}}("Module::SoftMax", 1)
        {{hostValueSet}}("Module::KeepHighNote", $true)
        {{hostValueSet}}("Module::KeepLowNote", $true)
        $NoteOn($HighNoteKey)
        $NoteOn($LowNoteKey)
    elseif (ki == 2) then
        $NoteOn($MidNoteKey)
    elseif (ki == 4) then
        $NoteOff($HighNoteKey)
    elseif (ki == 6) then
        {{CHECK_EQUAL_k '{+{State.SoftOn}+}' '{+{hostValueGet}+}:k("Note.3.state")'}}
        $NoteOff($LowNoteKey)
        $NoteOff($MidNoteKey)
        turnoff()
    endif
{{/CsoundTest}}


{{#CsoundTest "GivenSoftMaxIs1AndKeepHighAndLowNotesIsTrueAndHighAndLowNotesAreOn_WhenMidNoteIsOnAtK2AndLowNoteIsOffAtK4_MidNoteStateShouldEqualSoftOnAtK6"
    solo=false
    mute=false
}}
    ki init 0
    ki += 1

    if (ki == 1) then
        {{hostValueSet}}("Module::SoftMax", 1)
        {{hostValueSet}}("Module::KeepHighNote", $true)
        {{hostValueSet}}("Module::KeepLowNote", $true)
        $NoteOn($HighNoteKey)
        $NoteOn($LowNoteKey)
    elseif (ki == 2) then
        $NoteOn($MidNoteKey)
    elseif (ki == 4) then
        $NoteOff($LowNoteKey)
    elseif (ki == 6) then
        {{CHECK_EQUAL_k '{+{State.SoftOn}+}' '{+{hostValueGet}+}:k("Note.3.state")'}}
        $NoteOff($HighNoteKey)
        $NoteOff($MidNoteKey)
        turnoff()
    endif
{{/CsoundTest}}


{{#CsoundTest "GivenSoftMaxIs1AndKeepHighAndLowNotesIsTrueAndHighAndLowNotesAreOn_WhenMidNoteIsOnAtK2AndHighAndLowNotesAreOffAtK4_MidNoteStateShouldEqualSoftOnAtK6"
    solo=false
    mute=false
}}
    ki init 0
    ki += 1

    if (ki == 1) then
        {{hostValueSet}}("Module::SoftMax", 1)
        {{hostValueSet}}("Module::KeepHighNote", $true)
        {{hostValueSet}}("Module::KeepLowNote", $true)
        $NoteOn($HighNoteKey)
        $NoteOn($LowNoteKey)
    elseif (ki == 2) then
        $NoteOn($MidNoteKey)
    elseif (ki == 4) then
        $NoteOff($LowNoteKey)
        $NoteOff($HighNoteKey)
    elseif (ki == 6) then
        {{CHECK_EQUAL_k '{+{State.SoftOn}+}' '{+{hostValueGet}+}:k("Note.3.state")'}}
        $NoteOff($MidNoteKey)
        turnoff()
    endif
{{/CsoundTest}}


{{#CsoundTest "GivenSoftMaxIs1AndKeepHighAndLowNotesIsTrueAndHighAndLowNotesAreOn_WhenMidAndMidHighNotesAreOnAtK2AndHighNoteIsOffAtK4_MidHighNoteStateShouldEqualSoftOnAtK6"
    solo=false
    mute=false
}}
    ki init 0
    ki += 1

    if (ki == 1) then
        {{hostValueSet}}("Module::SoftMax", 1)
        {{hostValueSet}}("Module::KeepHighNote", $true)
        {{hostValueSet}}("Module::KeepLowNote", $true)
        $NoteOn($HighNoteKey)
        $NoteOn($LowNoteKey)
    elseif (ki == 2) then
        $NoteOn($MidNoteKey)
        $NoteOn($MidHighNoteKey)
    elseif (ki == 4) then
        $NoteOff($HighNoteKey)
    elseif (ki == 6) then
        {{CHECK_EQUAL_k '{+{State.SoftOn}+}' '{+{hostValueGet}+}:k("Note.4.state")'}}
        $NoteOff($LowNoteKey)
        $NoteOff($MidNoteKey)
        $NoteOff($MidHighNoteKey)
        turnoff()
    endif
{{/CsoundTest}}


{{#CsoundTest "GivenSoftMaxIs1AndKeepHighAndLowNotesIsTrueAndHighAndLowNotesAreOn_WhenMidAndMidHighNotesAreOnAtK2AndHighNoteIsOffAtK4_MidNoteStateShouldEqualMuted_AfterSoftOffFadeTime"
    solo=false
    mute=false
}}
    k_noteSoftOffStartTime init 0
    k_softOffFadeTime init {{hostValueGet}}:i("Module::SoftOffFadeTime")

    ki init 0
    ki += 1

    if (ki == 1) then
        {{hostValueSet}}("Module::SoftMax", 1)
        {{hostValueSet}}("Module::KeepHighNote", $true)
        {{hostValueSet}}("Module::KeepLowNote", $true)
        $NoteOn($HighNoteKey)
        $NoteOn($LowNoteKey)
    elseif (ki == 2) then
        $NoteOn($MidNoteKey)
        $NoteOn($MidHighNoteKey)
    elseif (ki == 4) then
        $NoteOff($HighNoteKey)
    elseif (ki == 5) then
        k_noteSoftOffStartTime = times()
    elseif (ki >= 6) then
        if (times() - k_noteSoftOffStartTime >= k_softOffFadeTime) then
            {{CHECK_EQUAL_k '{+{State.Muted}+}' '{+{hostValueGet}+}:k("Note.3.state")'}}
            $NoteOff($LowNoteKey)
            $NoteOff($MidNoteKey)
            $NoteOff($MidHighNoteKey)
            turnoff()
        endif
    endif
{{/CsoundTest}}


{{#CsoundTest "GivenSoftMaxIs1AndKeepHighAndLowNotesIsTrueAndHighAndLowNotesAreOn_WhenMidAndMidLowNotesAreOnAtK2AndLowNoteIsOffAtK4_MidLowNoteStateShouldEqualSoftOnAtK6"
    solo=false
    mute=false
}}
    ki init 0
    ki += 1

    if (ki == 1) then
        {{hostValueSet}}("Module::SoftMax", 1)
        {{hostValueSet}}("Module::KeepHighNote", $true)
        {{hostValueSet}}("Module::KeepLowNote", $true)
        $NoteOn($HighNoteKey)
        $NoteOn($LowNoteKey)
    elseif (ki == 2) then
        $NoteOn($MidNoteKey)
        $NoteOn($MidLowNoteKey)
    elseif (ki == 4) then
        $NoteOff($LowNoteKey)
    elseif (ki == 5) then
        k_noteSoftOffStartTime = times()
    elseif (ki == 6) then
        {{CHECK_EQUAL_k '{+{State.SoftOn}+}' '{+{hostValueGet}+}:k("Note.4.state")'}}
        $NoteOff($HighNoteKey)
        $NoteOff($MidNoteKey)
        $NoteOff($MidLowNoteKey)
        turnoff()
    endif
{{/CsoundTest}}


{{#CsoundTest "GivenSoftMaxIs1AndKeepHighAndLowNotesIsTrueAndHighAndLowNotesAreOn_WhenMidAndMidLowNotesAreOnAtK2AndLowNoteIsOffAtK4_MidNoteStateShouldEqualMuted_AfterSoftOffFadeTime"
    solo=false
    mute=false
}}
    k_noteSoftOffStartTime init 0
    k_softOffFadeTime init {{hostValueGet}}:i("Module::SoftOffFadeTime")

    ki init 0
    ki += 1

    if (ki == 1) then
        {{hostValueSet}}("Module::HardMax", 1)
        {{hostValueSet}}("Module::KeepHighNote", $true)
        {{hostValueSet}}("Module::KeepLowNote", $true)
        $NoteOn($HighNoteKey)
        $NoteOn($LowNoteKey)
    elseif (ki == 2) then
        $NoteOn($MidNoteKey)
        $NoteOn($MidLowNoteKey)
    elseif (ki == 4) then
        $NoteOff($LowNoteKey)
        k_noteSoftOffStartTime = times()
    elseif (ki >= 6) then
        if (times() - k_noteSoftOffStartTime >= k_softOffFadeTime) then
            {{CHECK_EQUAL_k '{+{State.Muted}+}' '{+{hostValueGet}+}:k("Note.3.state")'}}
            $NoteOff($HighNoteKey)
            $NoteOff($MidNoteKey)
            $NoteOff($MidLowNoteKey)
            turnoff()
        endif
    endif
{{/CsoundTest}}


{{#CsoundTest "GivenHardMaxIs1AndKeepHighNoteIsTrueAndHighNoteIsOn_WhenHighNote2IsOnAtK2_HighNote2StateShouldEqualHardOffAtK4"
    solo=false
    mute=false
}}
    ki init 0
    ki += 1

    if (ki == 1) then
        {{hostValueSet}}("Module::HardMax", 1)
        {{hostValueSet}}("Module::KeepHighNote", $true)
        $NoteOn($HighNoteKey)
    elseif (ki == 2) then
        $NoteOn($HighNoteKey)
    elseif (ki == 4) then
        {{CHECK_EQUAL_k '{+{State.HardOff}+}' '{+{hostValueGet}+}:k("Note.2.state")'}}
        $NoteOff($HighNoteKey)
        $NoteOff($HighNoteKey)
        turnoff()
    endif
{{/CsoundTest}}


{{#CsoundTest "GivenHardMaxIs1AndKeepLowNoteIsTrueAndLowNoteIsOn_WhenLowNote2IsOnAtK2_LowNote2StateShouldEqualHardOffAtK4"
    solo=false
    mute=false
}}
    ki init 0
    ki += 1

    if (ki == 1) then
        {{hostValueSet}}("Module::HardMax", 1)
        {{hostValueSet}}("Module::KeepLowNote", $true)
        $NoteOn($LowNoteKey)
    elseif (ki == 2) then
        $NoteOn($LowNoteKey)
    elseif (ki == 4) then
        {{CHECK_EQUAL_k '{+{State.HardOff}+}' '{+{hostValueGet}+}:k("Note.2.state")'}}
        $NoteOff($LowNoteKey)
        $NoteOff($LowNoteKey)
        turnoff()
    endif
{{/CsoundTest}}


{{#CsoundTest "GivenHardMaxIs3AndKeepHighAndLowNotesAreTrueAndHighAndLowNotesAreOn_WhenHighAndLowNotes3And4AreOnAtK2_LowNote4StateShouldEqualHardOffAtK4"
    solo=false
    mute=false
}}
    ki init 0
    ki += 1

    if (ki == 1) then
        {{hostValueSet}}("Module::HardMax", 3)
        {{hostValueSet}}("Module::KeepHighNote", $true)
        {{hostValueSet}}("Module::KeepLowNote", $true)
        $NoteOn($HighNoteKey)
        $NoteOn($LowNoteKey)
    elseif (ki == 2) then
        $NoteOn($HighNoteKey)
        $NoteOn($LowNoteKey)
    elseif (ki == 4) then
        {{CHECK_EQUAL_k '{+{State.HardOff}+}' '{+{hostValueGet}+}:k("Note.4.state")'}}
        $NoteOff($HighNoteKey)
        $NoteOff($LowNoteKey)
        $NoteOff($HighNoteKey)
        $NoteOff($LowNoteKey)
        turnoff()
    endif
{{/CsoundTest}}


{{#CsoundTest "GivenHardMaxIs3AndKeepHighAndLowNotesAreTrueAndHighAndLowNotesAreOn_WhenHighAndLowNotes3And4AreOnAtK2_HighNote3StateShouldEqualOnAtK4"
    solo=false
    mute=false
}}
    ki init 0
    ki += 1

    if (ki == 1) then
        {{hostValueSet}}("Module::HardMax", 3)
        {{hostValueSet}}("Module::KeepHighNote", $true)
        {{hostValueSet}}("Module::KeepLowNote", $true)
        $NoteOn($HighNoteKey)
        $NoteOn($LowNoteKey)
    elseif (ki == 2) then
        $NoteOn($HighNoteKey)
        $NoteOn($LowNoteKey)
    elseif (ki == 4) then
        {{CHECK_EQUAL_k '{+{State.On}+}' '{+{hostValueGet}+}:k("Note.3.state")'}}
        $NoteOff($HighNoteKey)
        $NoteOff($LowNoteKey)
        $NoteOff($HighNoteKey)
        $NoteOff($LowNoteKey)
        turnoff()
    endif
{{/CsoundTest}}


{{#CsoundTest "GivenKeepDuplicateNotesIsTrueAndNote1IsOn_WhenNote2IsOnAtK2_Note2StateShouldEqualOnAtK3"
    solo=false
    mute=false
}}
    ki init 0
    ki += 1

    if (ki == 1) then
        {{hostValueSet}}("Module::KeepDuplicateNotes", $true)
        $NoteOn($Key1)
    elseif (ki == 2) then
        $NoteOn($Key1)
    elseif (ki == 3) then
        {{CHECK_EQUAL_k '{+{State.On}+}' '{+{hostValueGet}+}:k("Note.2.state")'}}
        $NoteOff($Key1)
        $NoteOff($Key1)
        turnoff()
    endif
{{/CsoundTest}}


{{#CsoundTest "GivenKeepDuplicateNotesIsFalseAndNote1IsOn_WhenNote2IsOnAtK2_Note2StateShouldEqualMutedAtK3"
    solo=false
    mute=false
}}
    ki init 0
    ki += 1

    if (ki == 1) then
        {{hostValueSet}}("Module::KeepDuplicateNotes", $false)
        $NoteOn($Key1)
    elseif (ki == 2) then
        $NoteOn($Key1)
    elseif (ki == 3) then
        {{CHECK_EQUAL_k '{+{State.Muted}+}' '{+{hostValueGet}+}:k("Note.2.state")'}}
        $NoteOff($Key1)
        $NoteOff($Key1)
        turnoff()
    endif
{{/CsoundTest}}


{{#CsoundTest "GivenKeepDuplicateNotesIsFalseAndNote1IsOn_WhenNote1IsOffAtK2AndNote2IsOnAtK3_Note2StateShouldEqualOnAtK4"
    solo=false
    mute=false
}}
    ki init 0
    ki += 1

    if (ki == 1) then
        {{hostValueSet}}("Module::KeepDuplicateNotes", $false)
        $NoteOn($Key1)
    elseif (ki == 2) then
        $NoteOff($Key1)
    elseif (ki == 3) then
        $NoteOn($Key1)
    elseif (ki == 4) then
        {{CHECK_EQUAL_k '{+{State.On}+}' '{+{hostValueGet}+}:k("Note.2.state")'}}
        $NoteOff($Key1)
        turnoff()
    endif
{{/CsoundTest}}


{{#CsoundTest "GivenKeepDuplicateNotesIsFalseAndReleaseTimeIs1AndNote1IsOn_WhenNote1IsOffAtK2AndNote2IsOnAtK3_Note2StateShouldEqualOnAtK4"
    solo=false
    mute=false
}}
    ki init 0
    ki += 1

    if (ki == 1) then
        {{hostValueSet}}("Module::KeepDuplicateNotes", $false)
        {{hostValueSet}}("Note.releaseTime", 1);
        $NoteOn($Key1)
    elseif (ki == 2) then
        $NoteOff($Key1)
    elseif (ki == 3) then
        $NoteOn($Key1)
    elseif (ki == 4) then
        {{CHECK_EQUAL_k '{+{State.On}+}' '{+{hostValueGet}+}:k("Note.2.state")'}}
        $NoteOff($Key1)
        turnoff()
    endif
{{/CsoundTest}}

{{#CsoundTest "GivenHardMaxIs1AndKeepHighNoteIsTrueAndKeepDuplicateNotesIsFalseAndHighNote1IsOn_WhenHighNote2IsOnAtK2_HighNote2StateShouldEqualMutedAtK3"
    solo=false
    mute=false
}}
    ki init 0
    ki += 1

    if (ki == 1) then
        {{hostValueSet}}("Module::HardMax", 1)
        {{hostValueSet}}("Module::KeepHighNote", $true)
        {{hostValueSet}}("Module::KeepDuplicateNotes", $false)
        $NoteOn($HighNoteKey)
    elseif (ki == 2) then
        $NoteOn($HighNoteKey)
    elseif (ki == 3) then
        {{CHECK_EQUAL_k '{+{State.Muted}+}' '{+{hostValueGet}+}:k("Note.2.state")'}}
        $NoteOff($HighNoteKey)
        $NoteOff($HighNoteKey)
        turnoff()
    endif
{{/CsoundTest}}

{{#CsoundTest "GivenHardMaxIs1AndKeepHighNoteIsTrueAndKeepDuplicateNotesIsFalseAndHighNote1IsOnAndHighNote2IsOnAtK2_WhenHighNote1IsOffAtK4_HighNote2StateShouldEqualSoftOnAtK6"
    solo=false
    mute=false
}}
    ki init 0
    ki += 1

    if (ki == 1) then
        {{hostValueSet}}("Module::HardMax", 1)
        {{hostValueSet}}("Module::KeepHighNote", $true)
        {{hostValueSet}}("Module::KeepDuplicateNotes", $false)
        $NoteOn($HighNoteKey)
    elseif (ki == 2) then
        $NoteOn($HighNoteKey)
    elseif (ki == 4) then
        $NoteOff($HighNoteKey)
    elseif (ki == 8) then
        {{CHECK_EQUAL_k '{+{State.SoftOn}+}' '{+{hostValueGet}+}:k("Note.2.state")'}}
        $NoteOff($HighNoteKey)
        turnoff()
    endif
{{/CsoundTest}}

{{#CsoundTest "GivenHardMaxIs1AndKeepLowNoteIsTrueAndKeepDuplicateNotesIsFalseAndLowNote1IsOnAndLowNote2IsOnAtK2_WhenLowNote1IsOffAtK4_LowNote2StateShouldEqualSoftOnAtK6"
    solo=false
    mute=false
}}
    ki init 0
    ki += 1

    if (ki == 1) then
        {{hostValueSet}}("Module::HardMax", 1)
        {{hostValueSet}}("Module::KeepLowNote", $true)
        {{hostValueSet}}("Module::KeepDuplicateNotes", $false)
        $NoteOn($LowNoteKey)
    elseif (ki == 2) then
        $NoteOn($LowNoteKey)
    elseif (ki == 4) then
        $NoteOff($LowNoteKey)
    elseif (ki == 8) then
        {{CHECK_EQUAL_k '{+{State.SoftOn}+}' '{+{hostValueGet}+}:k("Note.2.state")'}}
        $NoteOff($LowNoteKey)
        turnoff()
    endif
{{/CsoundTest}}


{{/CsoundTestGroup}}

{{include "csound-test/csound-test.orc"}}

</CsInstruments>
<CsScore>

{{CsScore}}

</CsScore>
<CsoundSynthesizer>
