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

instr 2
    a_source_1 = AF_Module_Source_A("Source_1")
    a_source_2 = AF_Module_Source_A("Source_2")
    a_source_3 = AF_Module_Source_A("Source_3")
    a_out = sum(a_source_1, a_source_2, a_source_3)

    a_out = AF_Module_Filter_A("Filter_1", a_out)
    a_envelope_1 = AF_Module_Envelope_A("Envelope_1")

    outall(a_out * a_envelope_1)
endin

{{InitializeModule "AF_Module_Source_A"     "Source_1"}}
{{InitializeModule "AF_Module_Source_A"     "Source_2"}}
{{InitializeModule "AF_Module_Source_A"     "Source_3"}}
{{InitializeModule "AF_Module_Envelope_A"   "Envelope_1"}}
{{InitializeModule "AF_Module_Filter_A"     "Filter_1"}}

</CsInstruments>
<CsScore>

{{CsScore}}

</CsScore>
</CsoundSynthesizer>

{{Cabbage}}
