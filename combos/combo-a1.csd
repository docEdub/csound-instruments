<CsoundSynthesizer>
<CsOptions>
{{CsOptions}}
{{HostOptions}}
--messagelevel=0
</CsOptions>
<CsInstruments>

{{Enable-LogTrace false}}
{{Enable-LogDebug false}}

sr = {{sr}}
ksmps = {{ksmps}}
nchnls = 2
nchnls_i = 2

{{CsInstruments}}

massign 0, 2
pgmassign 0, 0


gk_cpsOffset init 0
gk_noteRiseY init 0
gi_noteRiseY_threshold init 0.2

ga_out_l init 0
ga_out_r init 0


instr AF_Combo_A1_alwayson

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

    k_leftFingerTip3Y = k_bodyTrackingData[10]

    k_leftFingerTip5X = k_bodyTrackingData[15]
    k_leftFingerTip5Y = k_bodyTrackingData[16]

    k_rightWristX = k_bodyTrackingData[18]
    k_rightWristY = k_bodyTrackingData[19]
    k_rightWristZ = k_bodyTrackingData[20]

    k_rightFingerTip1X = k_bodyTrackingData[21]
    k_rightFingerTip1Y = k_bodyTrackingData[22]

    k_rightFingerTip3Y = k_bodyTrackingData[28]

    k_rightFingerTip5X = k_bodyTrackingData[33]
    k_rightFingerTip5Y = k_bodyTrackingData[34]

    k_headPositionX = k_bodyTrackingData[36]
    k_headPositionY = k_bodyTrackingData[37]
    k_headPositionZ = k_bodyTrackingData[38]


    ; k_synth2_filterFreq_mod = limit(k_leftWristX, -1, 1) * 0.5 + 0.5
    ; AF_Module_Filter_A_setMod("Synth_2::Filter_1", {{eval '(Constants.Filter_A.Channel.Frequency)'}}, k_synth2_filterFreq_mod)

    ; k_synth2_filterEnv_mod = limit(k_rightWristX, 0, 1) * 2
    ; AF_Module_Filter_A_setMod("Synth_2::Filter_1", {{eval '(Constants.Filter_A.Channel.EnvelopeAmount)'}}, k_synth2_filterEnv_mod)

    ; k_synth2_source1_subAmp_mod = limit(abs(k_leftFingerTip5Y - k_leftFingerTip1Y) * 7, -1, 1) * 0.5 + 0.5
    ; AF_Module_Source_A_setMod("Synth_2::Source_1", {{eval '(Constants.Source_A.Channel.SubAmp)'}}, k_synth2_source1_subAmp_mod)

    ; k_synth2_filter_q_mod = limit(abs(k_rightFingerTip5Y - k_rightFingerTip1Y) * 70 * 0.5 + 0.5, 1, 7.5)
    ; AF_Module_Filter_A_setMod("Synth_2::Filter_1", {{eval '(Constants.Filter_A.Channel.Q)'}}, k_synth2_filter_q_mod)

    ; k_synth2_volumeAmp_mod = lag(limit(max(k_leftWristY, k_rightWristY), 0, 1), 2)
    ; AF_Module_Volume_A_setMod("Synth_2::Volume_1", {{eval '(Constants.Volume_A.Channel.Amp)'}}, k_synth2_volumeAmp_mod)

    ; k_piano_reverbSendAmp_mod = min(0, -((min(round((k_headPositionY + k_headPositionZ) * 3 * 1000) / 1000, 1.5)) - 0.5) * 2)
    ; AF_Module_Volume_A_setMod("Master_FX::PianoReverb_1", {{eval '(Constants.Volume_A.Channel.Amp)'}}, k_piano_reverbSendAmp_mod) ; Range = [ 0.0, -0.5... ]

    ; k_reverb_cutoff_mod = limit:k(round((k_headPositionX * 0.5 + 0.5) * 1000) / 1000, 0, 1)
    ; AF_Module_Reverb_A_setMod("Master_FX::Reverb_1", {{eval '(Constants.Reverb_A.Channel.Cutoff)'}}, k_reverb_cutoff_mod) ; Range = [ 0.0, 1.0 ]

    ; k_synth2_volumeAmp_mod = ampdb(lagud((limit(k_headPositionY, 0, 0.5) - 0) * 2, 5, 10) * 90) / 32000
    ; k_synth2_volumeAmp_mod = lagud(limit((k_headPositionZ - 0.2) * 1.25 * 5, 0, 1), 5, 5)
    ; AF_Module_Volume_A_setMod("Synth_2::Volume_1", {{eval '(Constants.Volume_A.Channel.Amp)'}}, k_synth2_volumeAmp_mod)

    gk_cpsOffset = k_rightWristX * 50
    ; {{LogDebug_k '("gk_cpsOffset = %f", gk_cpsOffset)'}}

    gk_noteRiseY = max:k(k_leftFingerTip3Y, k_rightFingerTip3Y)
    ; {{LogDebug_k '("gk_noteRiseY = %f", gk_noteRiseY)'}}

    // Piano FX ...

    a_piano_l = inch(2)

    a_piano_l = AF_Module_DelayMono_A("Piano_FX::Delay_1", a_piano_l)
    a_piano_l, a_piano_r AF_Module_DelayStereo_A "Piano_FX::Delay_2", a_piano_l

    k_piano_amp = AF_Module_Volume_A:k("Piano_FX::Volume_1")
    a_piano_l *= k_piano_amp
    a_piano_r *= k_piano_amp


    // Common ...

    k_lfo_g1 = AF_Module_LFO_A:k("Common::LFO_G1")
    k_pw_1 = (k_lfo_g1 / 2 + 0.5) * 0.45 + 0.05
    AF_Module_Source_A_setMod("Synth_2::Source_1", {{eval '(Constants.Source_A.Channel.Osc1PulseWidth)'}}, 0.5 - k_pw_1) ; Range = [ 0.50, 0.05 ]

    k_lfo_g2 = AF_Module_LFO_A:k("Common::LFO_G2")
    k_pw_2 = (k_lfo_g2 / 2 + 0.5) * 0.45 + 0.05
    AF_Module_Source_A_setMod("Synth_2::Source_2", {{eval '(Constants.Source_A.Channel.Osc1PulseWidth)'}}, 0.5 - k_pw_2) ; Range = [ 0.50, 0.05 ]

    k_lfo_g3 = AF_Module_LFO_A:k("Common::LFO_G3")
    AF_Module_Source_A_setMod("Synth_2::Source_3", {{eval '(Constants.Source_A.Channel.Osc1Semi)'}}, k_lfo_g3 * 0.5) ; Range = [ -0.5, 0.5 ]

    k_lfo_g4 = AF_Module_LFO_A:k("Common::LFO_G4")
    AF_Module_Source_A_setMod("Synth_2::Source_4", {{eval '(Constants.Source_A.Channel.Osc1Semi)'}}, k_lfo_g4 * 0.5) ; Range = [ -0.5, 0.5 ]


    // Synth 2 ...

    k_synth2_amp = AF_Module_Volume_A:k("Synth_2::Volume_1")
    k_synth2_amp += AF_Module_Offset_A:k("Synth_2::VolumeOffset_1")
    k_synth2_amp = AF_Module_Clamp_A:k("Synth_2::VolumeClamp_1", k_synth2_amp)

    ga_out_l *= k_synth2_amp
    ga_out_r *= k_synth2_amp


    // Master FX ...

    k_pianoMix = AF_Module_Volume_A:k("Master_FX::PianoMix_1")
    k_synth2Mix = AF_Module_Volume_A:k("Master_FX::Synth2Mix_1")

    a_piano_l *= k_pianoMix
    a_piano_r *= k_pianoMix
    ga_out_l *= k_synth2Mix
    ga_out_r *= k_synth2Mix

    k_pianoReverbAmp = AF_Module_Volume_A:k("Master_FX::PianoReverb_1")
    k_synth1ReverbAmp = AF_Module_Volume_A:k("Master_FX::Synth1Reverb_1")
    k_synth2ReverbAmp = AF_Module_Volume_A:k("Master_FX::Synth2Reverb_1")

    a_reverbIn_l = a_piano_l * k_pianoReverbAmp + ga_out_l * k_synth2ReverbAmp
    a_reverbIn_r = a_piano_r * k_pianoReverbAmp + ga_out_r * k_synth2ReverbAmp

    a_reverbOut_l, a_reverbOut_r AF_Module_Reverb_A "Master_FX::Reverb_1", a_reverbIn_l, a_reverbIn_r

    vincr(ga_out_l, a_reverbOut_l)
    vincr(ga_out_r, a_reverbOut_r)

    vincr(ga_out_l, a_piano_l)
    vincr(ga_out_r, a_piano_r)


    // Output ...

    outs(ga_out_l, ga_out_r)
    clear(ga_out_l, ga_out_r)


    // UI updates ...

    processSelectedChannels()
    updateModVisibilityChannels()

    k_x init 0
    k_x += 0.01
    if (k_x > 1) then
        k_x = 0
    endif
    k_y = AF_Module_FnX_A("Synth_2::NoteRise_1", k_x)
    {{LogDebug_k '("f(%f) = %f", k_x, k_y)'}}
endin


// Start at 1 second to give the host time to set it's values.
scoreline_i("i\"AF_Combo_A1_alwayson\" 1 -1")


instr 2
    k_noteRise_amp init 1
    if (k_noteRise_amp <= 0) then
        kgoto end
    endif

    i_noteNumber = notnum()
    i_noteNumber += AF_Module_MidiKeyTranspose_A:i("Common::KeyTranspose_G1")

    i_isInMidiKeyRange = AF_Module_MidiKeyRange_A:i("Common::KeyRange_G1", i_noteNumber)
    if (i_isInMidiKeyRange == $false) then
        {{LogTrace_i '("Note %d is out of range.", notnum())'}}
        goto end
    endif

    // NB: We call the envelope module UDO here so the polyphony control UDO's `lastcycle` init sees the envelope's release time.
    a_envelope = AF_Module_Envelope_A("Synth_2::Envelope_1")

    ; k_muted init $false
    k_turnedOff init $false
    if (k_turnedOff == $true) then
        kgoto end
    endif
    k_polyphonyControlNoteIndex = AF_Module_PolyphonyControl_B_noteIndex("Synth_2::Polyphony_2")
    k_polyphonyControlState = AF_Module_PolyphonyControl_B_state("Synth_2::Polyphony_2", k_polyphonyControlNoteIndex)
    if (k_polyphonyControlState == {{eval '(Constants.PolyphonyControl_B.State.Muted)'}}) then
        ; if (k_muted == $false || k_turnedOff == $true) then
        ;     k_muted = $true
        ;     {{LogTrace_k '("Synth 2 note %d muted.", notnum())'}}
        ; endif
        kgoto end
    elseif (k_polyphonyControlState == {{eval '(Constants.PolyphonyControl_B.State.Off)'}}) then
        {{LogTrace_k '("Synth 2 note %d turned off.", notnum())'}}
        k_turnedOff = $true
        ; turnoff()
        kgoto end
    endif

    ; k_isFirstPass init $true
    ; if (k_isFirstPass == $true) then
    ;     k_cpsOffsetStart = gk_cpsOffset
    ;     k_cpsOffset = 9
    ;     k_isFirstPass = $false
    ; else
    ;     k_cpsOffset = gk_cpsOffset - k_cpsOffsetStart
    ; endif
    ; {{LogDebug_k '("k_cpsOffset = %f", k_cpsOffset)'}}

    k_noteRise_current init 0
    k_noteRiseY_last init 0
    if (gk_noteRiseY > gi_noteRiseY_threshold) then
        if (k_noteRiseY_last == 0) then
            k_noteRiseY_last = gi_noteRiseY_threshold
        endif
        k_noteRise_current = max(k_noteRise_current, AF_Module_FnX_A("Synth_2::NoteRise_1", gk_noteRiseY - gi_noteRiseY_threshold))
        k_noteRiseY_last = gk_noteRiseY

        ; if (changed:k(k_noteRise_current) == 1) then
        ;     {{LogDebug_k '("gk_noteRiseY = %f", gk_noteRiseY)'}}
        ;     {{LogDebug_k '("k_noteRise_current = %f", k_noteRise_current)'}}
        ; endif
    endif

    k_noteNumber init i_noteNumber //+ 12
    k_noteNumber += k_noteRise_current
    k_noteNumber = min:k(k_noteNumber, 127)

    k_noteRise_amp = k(1) - ((k_noteNumber - i_noteNumber) / (127 - i_noteNumber)) * 2
    ; if (changed:k(k_noteRise_amp) == 1) then
    ;     {{LogDebug_k '("k_noteRise_amp = %f", k_noteRise_amp)'}}
    ; endif

    a_source_1 = AF_Module_Source_A("Synth_2::Source_1", k_noteNumber)
    a_source_2 = AF_Module_Source_A("Synth_2::Source_2", k_noteNumber)
    a_source_3 = AF_Module_Source_A("Synth_2::Source_3", k_noteNumber)
    a_source_4 = AF_Module_Source_A("Synth_2::Source_4", k_noteNumber)
    a_out = sum(a_source_1, a_source_2, a_source_3, a_source_4)

    a_out = AF_Module_Filter_A("Synth_2::Filter_1", a_out)
    a_out *= a_envelope
    a_out *= a(k_noteRise_amp)
    a_out = dcblock2(a_out, ksmps)
    a_out = AF_Module_PolyphonyControl_B_audioProcessing("Synth2::Polyphony_2", k_polyphonyControlNoteIndex, a_out)

    vincr(ga_out_l, a_out)
    vincr(ga_out_r, a_out)
end:
endin


{{InitializeModule "DelayMono_A"          "Piano_FX::Delay_1"}}
{{InitializeModule "DelayStereo_A"        "Piano_FX::Delay_2"}}
{{InitializeModule "Volume_A"             "Piano_FX::Volume_1"}}

{{InitializeModule "LFO_A"                "Common::LFO_G1"}}
{{InitializeModule "LFO_A"                "Common::LFO_G2"}}
{{InitializeModule "LFO_A"                "Common::LFO_G3"}}
{{InitializeModule "LFO_A"                "Common::LFO_G4"}}
{{InitializeModule "MidiKeyRange_A"       "Common::KeyRange_G1"}}
{{InitializeModule "MidiKeyTranspose_A"   "Common::KeyTranspose_G1"}}

{{InitializeModule "Source_A"             "Synth_2::Source_1"}}
{{InitializeModule "Source_A"             "Synth_2::Source_2"}}
{{InitializeModule "Source_A"             "Synth_2::Source_3"}}
{{InitializeModule "Source_A"             "Synth_2::Source_4"}}
{{InitializeModule "Envelope_A"           "Synth_2::Envelope_1"}}
{{InitializeModule "Filter_A"             "Synth_2::Filter_1"}}
{{InitializeModule "PolyphonyControl_B"   "Synth_2::Polyphony_2"}}
{{InitializeModule "Volume_A"             "Synth_2::Volume_1"}}
{{InitializeModule "Offset_A"             "Synth_2::VolumeOffset_1"}}
{{InitializeModule "Clamp_A"              "Synth_2::VolumeClamp_1"}}
{{InitializeModule "FnX_A"                "Synth_2::NoteRise_1"}}

{{InitializeModule "Volume_A"             "Master_FX::PianoMix_1"}}
{{InitializeModule "Volume_A"             "Master_FX::Synth2Mix_1"}}
{{InitializeModule "Volume_A"             "Master_FX::PianoReverb_1"}}
{{InitializeModule "Volume_A"             "Master_FX::Synth1Reverb_1"}}
{{InitializeModule "Volume_A"             "Master_FX::Synth2Reverb_1"}}
{{InitializeModule "Reverb_A"             "Master_FX::Reverb_1"}}


</CsInstruments>
<CsScore>

{{CsScore}}

</CsScore>
</CsoundSynthesizer>

{{Cabbage}}
