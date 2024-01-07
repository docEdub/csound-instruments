<CsoundSynthesizer>
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

    // Master FX ...

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
    a_out *= AF_Module_Volume_A("Synth_2::Volume_1")

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


</CsInstruments>
<CsScore>

{{CsScore}}

</CsScore>
</CsoundSynthesizer>

{{Cabbage}}
