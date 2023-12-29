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

{{CsInstruments}}

massign 0, 2
pgmassign 0, 0


/// This synth is setup for emulating string ensembles and string machines.
/// See https://www.soundonsound.com/techniques/synthesizing-strings-string-machines.

ga_out init 0

instr AF_Synth_A2_alwayson
    k_lfo_g1 = AF_Module_LFO_A:k("LFO_G1")
    k_pw_1 = (k_lfo_g1 / 2 + 0.5) * 0.45 + 0.05
    {{hostValueSet}}("Source_1::Osc1PulseWidth::mod", 0.5 - k_pw_1) ; Range = [ 0.50, 0.05 ]

    k_lfo_g2 = AF_Module_LFO_A:k("LFO_G2")
    k_pw_2 = (k_lfo_g2 / 2 + 0.5) * 0.45 + 0.05
    {{hostValueSet}}("Source_2::Osc1PulseWidth::mod", 0.5 - k_pw_2) ; Range = [ 0.50, 0.05 ]

    k_lfo_g3 = AF_Module_LFO_A:k("LFO_G3")
    {{hostValueSet}}("Source_3::Osc1Semi::mod", k_lfo_g3 * 0.5) ; Range = [ -0.5, 0.5 ]

    k_lfo_g4 = AF_Module_LFO_A:k("LFO_G4")
    {{hostValueSet}}("Source_4::Osc1Semi::mod", k_lfo_g4 * 0.5) ; Range = [ -0.5, 0.5 ]

    ga_out = AF_Module_DelayMono_A("Delay_1", ga_out)

    outall(ga_out)
    clear(ga_out)
endin

// Start at 1 second to give the host time to set it's values.
scoreline_i("i\"AF_Synth_A2_alwayson\" 1 -1")


instr 2
    a_source_1 = AF_Module_Source_A("Source_1")
    a_source_2 = AF_Module_Source_A("Source_2")
    a_source_3 = AF_Module_Source_A("Source_3")
    a_source_4 = AF_Module_Source_A("Source_4")
    a_out = sum(a_source_1, a_source_2, a_source_3, a_source_4)

    a_out = AF_Module_Filter_A("Filter_1", a_out)
    a_out *= AF_Module_Envelope_A("Envelope_1")

    vincr(ga_out, a_out)
endin


{{InitializeModule "AF_Module_LFO_A"        "LFO_G1"}}
{{InitializeModule "AF_Module_LFO_A"        "LFO_G2"}}
{{InitializeModule "AF_Module_LFO_A"        "LFO_G3"}}
{{InitializeModule "AF_Module_LFO_A"        "LFO_G4"}}
{{InitializeModule "AF_Module_Source_A"     "Source_1"}}
{{InitializeModule "AF_Module_Source_A"     "Source_2"}}
{{InitializeModule "AF_Module_Source_A"     "Source_3"}}
{{InitializeModule "AF_Module_Source_A"     "Source_4"}}
{{InitializeModule "AF_Module_DelayMono_A"  "Delay_1"}}
{{InitializeModule "AF_Module_Envelope_A"   "Envelope_1"}}
{{InitializeModule "AF_Module_Filter_A"     "Filter_1"}}


</CsInstruments>
<CsScore>

{{CsScore}}

</CsScore>
</CsoundSynthesizer>

{{Cabbage}}
