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


ga_out_l init 0
ga_out_r init 0

instr AF_Synth_A1_alwayson
    k_lfo_g1 = AF_Module_LFO_A:k("LFO_G1")
    {{hostValueSet}}("Source_1::OscMix::mod", k_lfo_g1 / 2 + 0.5)

    ga_out_l = AF_Module_DelayMono_A("Delay_1", ga_out_l)
    ga_out_l, ga_out_r AF_Module_Reverb_A "Reverb_1", ga_out_l, ga_out_r

    k_volume = AF_Module_Volume_A("Volume_1")
    ga_out_l *= k_volume
    ga_out_r *= k_volume

    outs(ga_out_l, ga_out_r)
    clear(ga_out_l, ga_out_r)
endin

// Start at 1 second to give the host time to set it's values.
scoreline_i("i\"AF_Synth_A1_alwayson\" 1 -1")


instr 2
    a_source_1 = AF_Module_Source_A("Source_1")
    a_source_2 = AF_Module_Source_A("Source_2")
    a_source_3 = AF_Module_Source_A("Source_3")
    a_out = sum(a_source_1, a_source_2, a_source_3)

    a_out = AF_Module_Filter_A("Filter_1", a_out)
    a_envelope_1 = AF_Module_Envelope_A("Envelope_1")

    a_lfo_l1 = AF_Module_LFO_A("LFO_L1")

    vincr(ga_out_l, a_out * a_envelope_1 * a_lfo_l1)
endin


{{InitializeModule "AF_Module_LFO_A"        "LFO_G1"}}
{{InitializeModule "AF_Module_LFO_A"        "LFO_L1"}}
{{InitializeModule "AF_Module_Source_A"     "Source_1"}}
{{InitializeModule "AF_Module_Source_A"     "Source_2"}}
{{InitializeModule "AF_Module_Source_A"     "Source_3"}}
{{InitializeModule "AF_Module_DelayMono_A"  "Delay_1"}}
{{InitializeModule "AF_Module_Envelope_A"   "Envelope_1"}}
{{InitializeModule "AF_Module_Filter_A"     "Filter_1"}}
{{InitializeModule "AF_Module_Reverb_A"     "Reverb_1"}}
{{InitializeModule "AF_Module_Volume_A"     "Volume_1"}}


</CsInstruments>
<CsScore>

{{CsScore}}

</CsScore>
</CsoundSynthesizer>

{{Cabbage}}
