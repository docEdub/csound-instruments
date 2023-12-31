-<CsoundSynthesizer>
<CsOptions>
{{CsOptions}}
{{HostOptions}}
--messagelevel=0
--nodisplays
</CsOptions>
<CsInstruments>

sr = {{sr}}
ksmps = {{ksmps}}
nchnls = 2
nchnls_i = 2

{{CsInstruments}}

massign 0, 2
pgmassign 0, 0


ga_out_l init 0
ga_out_r init 0

instr AF_Combo_A1_alwayson
    // XR hands and head tracking ...

    k_leftWristX = AF_Module_BodyTracking_A("XR::BodyTracking", {{BodyTracking_A.Channel.LeftWristX}})
    k_leftWristY = AF_Module_BodyTracking_A("XR::BodyTracking", {{BodyTracking_A.Channel.LeftWristY}})
    k_leftWristZ = AF_Module_BodyTracking_A("XR::BodyTracking", {{BodyTracking_A.Channel.LeftWristZ}})

    k_rightWristX = AF_Module_BodyTracking_A("XR::BodyTracking", {{BodyTracking_A.Channel.RightWristX}})
    k_rightWristY = AF_Module_BodyTracking_A("XR::BodyTracking", {{BodyTracking_A.Channel.RightWristY}})
    k_rightWristZ = AF_Module_BodyTracking_A("XR::BodyTracking", {{BodyTracking_A.Channel.RightWristZ}})

    k_leftFingerTip1X = AF_Module_BodyTracking_A("XR::BodyTracking", {{BodyTracking_A.Channel.LeftFingerTip1X}})
    k_leftFingerTip1Y = AF_Module_BodyTracking_A("XR::BodyTracking", {{BodyTracking_A.Channel.LeftFingerTip1Y}})
    k_leftFingerTip5X = AF_Module_BodyTracking_A("XR::BodyTracking", {{BodyTracking_A.Channel.LeftFingerTip5X}})
    k_leftFingerTip5Y = AF_Module_BodyTracking_A("XR::BodyTracking", {{BodyTracking_A.Channel.LeftFingerTip5Y}})

    k_rightFingerTip1X = AF_Module_BodyTracking_A("XR::BodyTracking", {{BodyTracking_A.Channel.RightFingerTip1X}})
    k_rightFingerTip1Y = AF_Module_BodyTracking_A("XR::BodyTracking", {{BodyTracking_A.Channel.RightFingerTip1Y}})
    k_rightFingerTip5X = AF_Module_BodyTracking_A("XR::BodyTracking", {{BodyTracking_A.Channel.RightFingerTip5X}})
    k_rightFingerTip5Y = AF_Module_BodyTracking_A("XR::BodyTracking", {{BodyTracking_A.Channel.RightFingerTip5Y}})

    k_headPositionX = AF_Module_BodyTracking_A("XR::BodyTracking", {{BodyTracking_A.Channel.HeadPositionX}})
    k_headPositionY = AF_Module_BodyTracking_A("XR::BodyTracking", {{BodyTracking_A.Channel.HeadPositionY}})
    k_headPositionZ = AF_Module_BodyTracking_A("XR::BodyTracking", {{BodyTracking_A.Channel.HeadPositionZ}})
    ; if (changed2(k_leftWristX, k_leftWristY, k_leftWristZ, k_headPositionX, k_headPositionY, k_headPositionZ) == {{true}}) then
    ;     {{LogDebug_k '("left wrist = [%.3f, %.3f, %.3f], head position = [%.3f, %.3f, %.3f]", k_leftWristX, k_leftWristY, k_leftWristZ, k_headPositionX, k_headPositionY, k_headPositionZ)'}}
    ; endif

    k_synth2_filterFreq_mod = limit(k_leftWristX * 2, 0, 1)
    {{hostValueSet}}("Synth_2::Filter_1::Frequency::mod", k_synth2_filterFreq_mod)
    ; if (changed2(k_synth2_filterFreq_mod) == {{true}}) then
    ;     {{LogDebug_k '("synth2 filter freq mod = %.3f", k_synth2_filterFreq_mod)'}}
    ; endif

    k_synth2_filterEnv_mod = limit((k_rightWristX - 0.5) * 4, 0, 1)
    {{hostValueSet}}("Synth_2::Filter_1::EnvelopeAmount::mod", k_synth2_filterEnv_mod)
    ; if (changed2(k_synth2_filterEnv_mod) == {{true}}) then
    ;     {{LogDebug_k '("synth2 filter env mod = %.3f", k_synth2_filterEnv_mod)'}}
    ; endif

    k_synth2_source1_subAmp_mod = limit(abs(k_leftFingerTip5Y - k_leftFingerTip1Y) * 7, 0, 1)
    {{hostValueSet}}("Synth_2::Source_1::SubAmp::mod", k_synth2_source1_subAmp_mod)
    ; if (changed2(k_synth2_source1_subAmp_mod) == {{true}}) then
    ;     {{LogDebug_k '("synth2 source1 sub amp mod = %.3f", k_synth2_source1_subAmp_mod)'}}
    ; endif

    k_synth2_filter_q_mod = limit(abs(k_rightFingerTip5Y - k_rightFingerTip1Y) * 70, 1, 7.5)
    {{hostValueSet}}("Synth_2::Filter_1::Q::mod", k_synth2_filter_q_mod)
    ; if (changed2(k_synth2_filter_q_mod) == {{true}}) then
    ;     {{LogDebug_k '("synth2 filter q mod = %.3f", k_synth2_filter_q_mod)'}}
    ; endif

    k_synth2_volumeAmp_mod = lag(max(k_leftWristY, k_rightWristY), 2)
    {{hostValueSet}}("Synth_2::Volume_1::Amp::mod", k_synth2_volumeAmp_mod)
    ; if (changed2(k_synth2_volumeAmp_mod) == {{true}}) then
    ;     {{LogDebug_k '("synth2 volume amp mod = %.3f", k_synth2_volumeAmp_mod)'}}
    ; endif

    k_piano_reverbAmp_mod = min(0, -((min(round((k_headPositionY + k_headPositionZ) * 3 * 1000) / 1000, 1.5)) - 0.5) * 2)
    {{hostValueSet}}("Master_FX::PianoReverb_1::Amp::mod", k_piano_reverbAmp_mod) ; Range = [ 0.0, -0.5... ]
    ; if (changed2(k_piano_reverbAmp_mod) == {{true}}) then
    ;     {{LogDebug_k '("piano reverb amp mod = %.3f", k_piano_reverbAmp_mod)'}}
    ; endif

    k_reverb_cutoff_mod = limit:k(round(k_headPositionX * 1000) / 1000, 0, 1)
    {{hostValueSet}}("Master_FX::Reverb_1::Cutoff::mod", k_reverb_cutoff_mod) ; Range = [ 0.0, 1.0 ]
    ; if (changed2(k_reverb_cutoff_mod) == {{true}}) then
    ;     {{LogDebug_k '("reverb cutoff mod = %.3f", k_reverb_cutoff_mod)'}}
    ; endif

    // Piano FX ...

    a_piano_l inch 1

    a_piano_l = AF_Module_DelayMono_A("Piano_FX::Delay_1", a_piano_l)
    a_piano_l, a_piano_r AF_Module_DelayStereo_A "Piano_FX::Delay_2", a_piano_l

    k_piano_amp = AF_Module_Volume_A:k("Piano_FX::Volume_1")
    a_piano_l *= k_piano_amp
    a_piano_r *= k_piano_amp

    // Common ...

    k_lfo_g1 = AF_Module_LFO_A:k("Common::LFO_G1")
    k_pw_1 = (k_lfo_g1 / 2 + 0.5) * 0.45 + 0.05
    {{hostValueSet}}("Synth_2::Source_1::Osc1PulseWidth::mod", 0.5 - k_pw_1) ; Range = [ 0.50, 0.05 ]

    k_lfo_g2 = AF_Module_LFO_A:k("Common::LFO_G2")
    k_pw_2 = (k_lfo_g2 / 2 + 0.5) * 0.45 + 0.05
    {{hostValueSet}}("Synth_2::Source_2::Osc1PulseWidth::mod", 0.5 - k_pw_2) ; Range = [ 0.50, 0.05 ]

    k_lfo_g3 = AF_Module_LFO_A:k("Common::LFO_G3")
    {{hostValueSet}}("Synth_2::Source_3::Osc1Semi::mod", k_lfo_g3 * 0.5) ; Range = [ -0.5, 0.5 ]

    k_lfo_g4 = AF_Module_LFO_A:k("Common::LFO_G4")
    {{hostValueSet}}("Synth_2::Source_4::Osc1Semi::mod", k_lfo_g4 * 0.5) ; Range = [ -0.5, 0.5 ]

    // Synth 2 ...

    k_synth2_amp = AF_Module_Volume_A:k("Synth_2::Volume_1")
    ga_out_l *= k_synth2_amp
    ga_out_r *= k_synth2_amp

    // Master FX ...

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
endin

// Start at 1 second to give the host time to set it's values.
scoreline_i("i\"AF_Combo_A1_alwayson\" 1 -1")


instr 2
    AF_Module_BodyTracking_A_onMidiNote("XR::BodyTracking")

    a_source_1 = AF_Module_Source_A("Synth_2::Source_1")
    a_source_2 = AF_Module_Source_A("Synth_2::Source_2")
    a_source_3 = AF_Module_Source_A("Synth_2::Source_3")
    a_source_4 = AF_Module_Source_A("Synth_2::Source_4")
    a_out = sum(a_source_1, a_source_2, a_source_3, a_source_4)

    a_out = AF_Module_Filter_A("Synth_2::Filter_1", a_out)
    a_out *= AF_Module_Envelope_A("Synth_2::Envelope_1")

    vincr(ga_out_l, a_out)
    vincr(ga_out_r, a_out)
endin

{{InitializeModule "AF_Module_BodyTracking_A"   "XR::BodyTracking"}}

{{InitializeModule "AF_Module_DelayMono_A"      "Piano_FX::Delay_1"}}
{{InitializeModule "AF_Module_DelayStereo_A"    "Piano_FX::Delay_2"}}
{{InitializeModule "AF_Module_Volume_A"         "Piano_FX::Volume_1"}}

{{InitializeModule "AF_Module_LFO_A"            "Common::LFO_G1"}}
{{InitializeModule "AF_Module_LFO_A"            "Common::LFO_G2"}}
{{InitializeModule "AF_Module_LFO_A"            "Common::LFO_G3"}}
{{InitializeModule "AF_Module_LFO_A"            "Common::LFO_G4"}}

{{InitializeModule "AF_Module_Source_A"         "Synth_2::Source_1"}}
{{InitializeModule "AF_Module_Source_A"         "Synth_2::Source_2"}}
{{InitializeModule "AF_Module_Source_A"         "Synth_2::Source_3"}}
{{InitializeModule "AF_Module_Source_A"         "Synth_2::Source_4"}}
{{InitializeModule "AF_Module_Envelope_A"       "Synth_2::Envelope_1"}}
{{InitializeModule "AF_Module_Filter_A"         "Synth_2::Filter_1"}}
{{InitializeModule "AF_Module_Volume_A"         "Synth_2::Volume_1"}}

{{InitializeModule "AF_Module_Volume_A"         "Master_FX::PianoReverb_1"}}
{{InitializeModule "AF_Module_Volume_A"         "Master_FX::Synth1Reverb_1"}}
{{InitializeModule "AF_Module_Volume_A"         "Master_FX::Synth2Reverb_1"}}
{{InitializeModule "AF_Module_Reverb_A"         "Master_FX::Reverb_1"}}


</CsInstruments>
<CsScore>

{{CsScore}}

</CsScore>
</CsoundSynthesizer>

{{Cabbage}}
