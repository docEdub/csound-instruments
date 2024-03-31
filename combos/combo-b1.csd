<CsoundSynthesizer>
<CsOptions>
{{CsOptions}}
{{HostOptions}}
; --messagelevel=0
</CsOptions>
<CsInstruments>

{{Enable-LogTrace true}}
{{Enable-LogDebug true}}

sr = {{sr}}
ksmps = {{ksmps}}
nchnls = 2
nchnls_i = 2

{{CsInstruments}}

massign 0, 2
pgmassign 0, 0


gk_fingerTip3X init 0
gi_noteRiseY_threshold init 0.2

ga_out init 0


instr AF_Combo_B1_alwayson

    // XR hands and head tracking ...

    a_bodyTrackingData = inch(1)
    k_bodyTrackingId init -1
    k_bodyTrackingData[] init 42
    ki = 0
    while (ki < ksmps) do
        k_bodyTrackingValue = vaget(ki, a_bodyTrackingData)
        if (k_bodyTrackingValue > 0.999999) then
            k_bodyTrackingId = 0
        elseif (k_bodyTrackingValue < -0.999999) then
            k_bodyTrackingId = -1
        elseif (k_bodyTrackingId >= 0 && k_bodyTrackingId < 42) then
            k_bodyTrackingData[k_bodyTrackingId] = k_bodyTrackingValue
            k_bodyTrackingId += 1
        endif
        ki += 1
    od

    k_leftWristX = k_bodyTrackingData[0]
    k_leftWristY = k_bodyTrackingData[1]
    k_leftWristZ = k_bodyTrackingData[2]

    k_leftFingerTip1X = k_bodyTrackingData[3]
    k_leftFingerTip1Y = k_bodyTrackingData[4]

    k_leftFingerTip3X = k_bodyTrackingData[9]
    k_leftFingerTip3Y = k_bodyTrackingData[10]
    k_leftFingerTip3Z = k_bodyTrackingData[11]

    k_leftFingerTip5X = k_bodyTrackingData[15]
    k_leftFingerTip5Y = k_bodyTrackingData[16]

    k_rightWristX = k_bodyTrackingData[18]
    k_rightWristY = k_bodyTrackingData[19]
    k_rightWristZ = k_bodyTrackingData[20]

    k_rightFingerTip1X = k_bodyTrackingData[21]
    k_rightFingerTip1Y = k_bodyTrackingData[22]

    k_rightFingerTip3X = k_bodyTrackingData[27]
    k_rightFingerTip3Y = k_bodyTrackingData[28]
    k_rightFingerTip3Z = k_bodyTrackingData[29]

    k_rightFingerTip5X = k_bodyTrackingData[33]
    k_rightFingerTip5Y = k_bodyTrackingData[34]

    k_headPositionX = k_bodyTrackingData[36]
    k_headPositionY = k_bodyTrackingData[37]
    k_headPositionZ = k_bodyTrackingData[38]


    k_synth_volumeAmp_mod = lag(limit(max(k_leftWristY, k_rightWristY), 0, 1), 2)
    k_synth_volumeAmp_mod += lag(limit(max(-k_leftFingerTip3Z, -k_rightFingerTip3Z), 0, 1), 2) * 3
    AF_Module_Volume_A_setMod("Synth::Volume_1", {{eval '(Constants.Volume_A.Channel.Amp)'}}, k_synth_volumeAmp_mod)

    k_synth_delayMix_mod = lag(limit(k_leftFingerTip3Y, 0, 0.3), 2)
    k_synth_delayMix_mod += lag(limit(-k_leftFingerTip3Z, 0, 0.3), 2) * 3
    AF_Module_DelayMono_A_setMod("Synth::Delay_1", {{eval '(Constants.DelayMono_A.Channel.Mix)'}}, k_synth_delayMix_mod)

    gk_noteNumberOffset = k_rightFingerTip3X
    ; {{LogDebug_k '("gk_noteNumberOffset = %f", gk_noteNumberOffset)'}}

    gk_fingerTip3X = max:k(k_leftFingerTip3X, k_rightFingerTip3X)
    ; {{LogDebug_k '("gk_fingerTip3X = %f", gk_fingerTip3X)'}}


    // Synth ...

    k_synth_amp = AF_Module_Volume_A:k("Synth::Volume_1")
    k_synth_amp += AF_Module_Offset_A:k("Synth::VolumeOffset_1")
    k_synth_amp = AF_Module_Clamp_A:k("Synth::VolumeClamp_1", k_synth_amp)

    ga_out *= k_synth_amp
    ga_out = AF_Module_DelayMono_A("Synth::Delay_1", ga_out)


    // Output ...

    outs(ga_out, ga_out)
    clear(ga_out)


    // UI updates ...

    processSelectedChannels()
    updateModVisibilityChannels()
endin


// Start at 1 second to give the host time to set it's values.
scoreline_i("i\"AF_Combo_B1_alwayson\" 1 -1")

/*
Notes:
- Note volume depends on z-penetration depth into a plane slightly angled toward the performer.
- Volume LFO depends on wrist height (or maybe 3rd finger tip height).
- Filter frequency depends on wrist angle around z axis.
    - Maybe there's a way to control a low-pass filter with left hand and a high-pass filter with right hand simultaneously?
- 8va doubling volume depends on distance between thumb tip and pinky tip?
    - Left hand controls -8va for all notes below middle C and right hand controls +8va for all notes above middle C?
*/
instr 2
    i_noteNumber = p4
    i_modifiedNoteNumber = i_noteNumber + AF_Module_MidiKeyTranspose_A:i("Synth::KeyTranspose_G1")

    {{LogTrace_i '("Note: i_modifiedNoteNumber = %d.", i_modifiedNoteNumber)'}}

    i_isInMidiKeyRange = AF_Module_MidiKeyRange_A:i("Synth::KeyRange_G1", i_modifiedNoteNumber)
    if (i_isInMidiKeyRange == $false) then
        {{LogTrace_i '("Note %d is out of range.", i_modifiedNoteNumber)'}}
        goto end
    endif

    // NB: We call the envelope module UDO here so the polyphony control UDO's `lastcycle` init sees the envelope's release time.
    a_envelope = AF_Module_Envelope_A("Synth::Envelope_1")

    k_isFirstPass init $true
    if (k_isFirstPass == $true) then
        k_noteNumberOffsetStart = gk_noteNumberOffset
        k_noteNumberOffset = 0
        k_isFirstPass = $false
    else
        k_noteNumberOffset = gk_noteNumberOffset - k_noteNumberOffsetStart
    endif

    k_noteRise_current init 0
    k_noteRiseY_last init 0
    if (gk_fingerTip3X > gi_noteRiseY_threshold) then
        if (k_noteRiseY_last == 0) then
            k_noteRiseY_last = gi_noteRiseY_threshold
        endif
        k_noteRise_current = max(k_noteRise_current, (gk_fingerTip3X - gi_noteRiseY_threshold) / 10)
        k_noteRiseY_last = gk_fingerTip3X
  endif

    k_noteNumber init i_modifiedNoteNumber //+ 12
    k_noteNumber += k_noteRise_current
    k_noteNumber = limit:k(k_noteNumber, 0, 127)
    ; {{LogTrace_k '("k_noteNumber = %f", k_noteNumber)'}}

    k_noteRise_amp init 1
    k_noteRise_amp = k(1) - ((k_noteNumber - i_modifiedNoteNumber) / (127 - i_modifiedNoteNumber)) * 2

    a_source_1 = AF_Module_Source_B("Synth::Source_1", limit:k(k_noteNumberOffset * 50 + i_modifiedNoteNumber, 0, 127))
    a_source_2 = AF_Module_Source_B("Synth::Source_2", limit:k(k_noteNumberOffset * 50 + i_modifiedNoteNumber, 0, 127))
    a_source_3 = AF_Module_Source_B("Synth::Source_3", k_noteNumber)
    a_source_4 = AF_Module_Source_B("Synth::Source_4", k_noteNumber)
    a_source_5 = AF_Module_Source_B("Synth::Source_5", k_noteNumber)
    a_out = sum(a_source_1, a_source_2, a_source_3, a_source_4, a_source_5)

    a_out *= a_envelope
    a_out *= a(k_noteRise_amp)
    a_out = dcblock2(a_out, ksmps)

    vincr(ga_out, a_out)
end:
endin


{{InitializeModule "MidiKeyRange_A"       "Synth::KeyRange_G1"}}
{{InitializeModule "MidiKeyTranspose_A"   "Synth::KeyTranspose_G1"}}

{{InitializeModule "Source_B"             "Synth::Source_1"}}
{{InitializeModule "Source_B"             "Synth::Source_2"}}
{{InitializeModule "Source_B"             "Synth::Source_3"}}
{{InitializeModule "Source_B"             "Synth::Source_4"}}
{{InitializeModule "Source_B"             "Synth::Source_5"}}
{{InitializeModule "Envelope_A"           "Synth::Envelope_1"}}

{{InitializeModule "Volume_A"             "Synth::Volume_1"}}
{{InitializeModule "Offset_A"             "Synth::VolumeOffset_1"}}
{{InitializeModule "Clamp_A"              "Synth::VolumeClamp_1"}}
{{InitializeModule "DelayMono_A"          "Synth::Delay_1"}}


</CsInstruments>
<CsScore>

{{CsScore}}

</CsScore>
</CsoundSynthesizer>

{{Cabbage}}
