<CsoundSynthesizer>
<CsOptions>
{{CsOptions}}
{{HostOptions}}
--messagelevel=0
</CsOptions>
<CsInstruments>

{{Enable-LogTrace true}}
{{Enable-LogDebug true}}

sr = {{sr}}
ksmps = {{ksmps}}
nchnls = 2
nchnls_i = 2

{{CsInstruments}}

#define AlwaysOnInstrumentNumber #2#
#define MidiNoteInstrumentNumber #3#
#define SynthNoteInstrumentNumber #100#

massign 0, $MidiNoteInstrumentNumber
pgmassign 0, 0

gk_leftVolume init 0
gk_leftNoteNumber init 0
gk_rightVolume init 0
gk_rightNoteNumber init 0

ga_out init 0

gi_synthNoteIsOn[] init 128
gS_synthNoteOnScoreLines[] init 128

gk_synthNoteVolume[] init 128

ii = 0
while (ii < 128) do
    gS_synthNoteOnScoreLines[ii] = sprintf("i %d.%03d 0 -1 %d", $SynthNoteInstrumentNumber, ii, ii)
    ii += 1
od


instr $AlwaysOnInstrumentNumber
    // Clear synth note volumes. They will be reset by the MIDI note instrument every k-pass.
    ki = 0
    while (ki < 128) do
        gk_synthNoteVolume[ki] = 0
        ki += 1
    od

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


    k_leftAngle = abs(taninv2(k_leftFingerTip5Y - k_leftFingerTip1Y, k_leftFingerTip5X - k_leftFingerTip1X))
    k_rightAngle = abs(taninv2(k_rightFingerTip5Y - k_rightFingerTip1Y, k_rightFingerTip1X - k_rightFingerTip5X))
    ; {{LogDebug_k '("Left angle: %f, Right angle: %f", k_leftAngle, k_rightAngle)'}}

    i_volumeScale = 0.333333
    i_volumeMax = 0.5
    i_volumeLagTime_up = 15
    i_volumeLagTimedown = 60
    gk_leftVolume = k(1) - limit(k_leftAngle * i_volumeScale, i_volumeMax, 1)
    gk_rightVolume = k(1) - limit(k_rightAngle * i_volumeScale, i_volumeMax, 1)
    ; {{LogDebug_k '("Left volume: %f, Right volume: %f", gk_leftVolume, gk_rightVolume)'}}

    i_noteNumber_min = 0
    i_noteNumber_max = 127
    i_leftNoteNumber_range = 60 - i_noteNumber_min
    i_rightNoteNumber_range = i_noteNumber_max - 60
    gk_leftNoteNumber = lag(k(60) + k_leftFingerTip3X * i_leftNoteNumber_range, 1)
    gk_rightNoteNumber = lag(k(60) + k_rightFingerTip3X * i_rightNoteNumber_range, 1)
    ; {{LogDebug_k '("Left note number(%f): %f, Right note number(%f): %f", k_leftFingerTip3X, gk_leftNoteNumber, k_rightFingerTip3X, gk_rightNoteNumber)'}}

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

    ga_out *= k_synth2_amp
    ga_out = AF_Module_DelayMono_A("Synth_2::Delay_1", ga_out)


    // Master FX ...

    k_synth2Mix = AF_Module_Volume_A:k("Master_FX::Synth2Mix_1")

    ga_out *= k_synth2Mix

    ; k_synth1ReverbAmp = AF_Module_Volume_A:k("Master_FX::Synth1Reverb_1")
    ; k_synth2ReverbAmp = AF_Module_Volume_A:k("Master_FX::Synth2Reverb_1")

    ; a_reverbIn_l = ga_out * k_synth2ReverbAmp
    ; a_reverbIn_r = ga_out_r * k_synth2ReverbAmp

    ; a_reverbOut_l, a_reverbOut_r AF_Module_Reverb_A "Master_FX::Reverb_1", a_reverbIn_l, a_reverbIn_r

    ; vincr(ga_out_l, a_reverbOut_l)
    ; vincr(ga_out_r, a_reverbOut_r)


    // Output ...

    outs(ga_out, ga_out)
    clear(ga_out)


    // UI updates ...

    processSelectedChannels()
    updateModVisibilityChannels()
endin


// Start at 1 second to give the host time to set it's values.
scoreline_i("i$AlwaysOnInstrumentNumber 1 -1")


instr $MidiNoteInstrumentNumber
    ; i_noteNumber = notnum() + AF_Module_MidiKeyTranspose_A:i("Common::KeyTranspose_G1")

    ; i_isInMidiKeyRange = AF_Module_MidiKeyRange_A:i("Common::KeyRange_G1", i_noteNumber)
    ; if (i_isInMidiKeyRange == $false) then
    ;     ; {{LogTrace_i '("Note %d is out of range.", i_noteNumber)'}}
    ;     goto end
    ; endif

    i_noteNumber = notnum()

    if (gi_synthNoteIsOn[i_noteNumber] == $false) then
        gi_synthNoteIsOn[i_noteNumber] = $true
        scoreline_i(gS_synthNoteOnScoreLines[i_noteNumber])
    endif

    if (gk_synthNoteVolume[i_noteNumber] < 1) then
        gk_synthNoteVolume[i_noteNumber] = gk_synthNoteVolume[i_noteNumber] + AF_Module_Envelope_A:k("Synth_2::Envelope_1")
    endif
end:
endin


instr $SynthNoteInstrumentNumber
    i_noteNumber = p4

    k_noteVolume = gk_synthNoteVolume[i_noteNumber]
    k_lastNoteVolume = 0
    if (k_noteVolume == 0 && k_lastNoteVolume == 0) then
        kgoto end
    endif
    k_lastNoteVolume = k_noteVolume

    k_noteNumber = i_noteNumber
    a_source_1 = AF_Module_Source_A("Synth_2::Source_1", k_noteNumber)
    a_source_2 = AF_Module_Source_A("Synth_2::Source_2", k_noteNumber)
    a_source_3 = AF_Module_Source_A("Synth_2::Source_3", k_noteNumber)
    a_source_4 = AF_Module_Source_A("Synth_2::Source_4", k_noteNumber)
    a_out = sum(a_source_1, a_source_2, a_source_3, a_source_4)
    a_out = dcblock2(a_out, ksmps)

    if (i_noteNumber < 60) then
        k_noteNumberProximity = gk_leftNoteNumber
        k_noteRotationVolume = gk_leftVolume
    else
        k_noteNumberProximity = gk_rightNoteNumber
        k_noteRotationVolume = gk_rightVolume
    endif
    k_handProximityVolume = lagud((k(1) - min(1, abs(k_noteNumberProximity - i_noteNumber) / 18)), 2, 20)
    k_handRotationVolume = lagud(limit((k_noteRotationVolume - 0.333) * 2, 0, 1), 10, 20)
    k_volume = min((k_handProximityVolume * 0.1) + (expcurve(k_handRotationVolume * 0.25 * k_handProximityVolume , 3)), 1)
    ; {{LogDebug_k '("Hand proximity volume: %f, Hand rotation volume: %f", k_handProximityVolume, k_handRotationVolume)'}}

    a_out *= a(k_volume)
    a_out *= a(min:k(gk_synthNoteVolume[i_noteNumber], 1))

    vincr(ga_out, a_out)
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
{{InitializeModule "DelayMono_A"          "Synth_2::Delay_1"}}

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
