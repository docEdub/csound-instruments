<CsoundSynthesizer>
<CsOptions>
{{CsOptions}}
{{HostOptions}}
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
    a_source_1 = AF_source_01_module("source_1")
    a_source_2 = AF_source_01_module("source_2")
    a_source_3 = AF_source_01_module("source_3")
    aOut = sum(a_source_1, a_source_2, a_source_3)

    aOut = AF_filter_01_module("filter_1", aOut)
    a_envelope_1 = AF_envelope_01_module("envelope_1")

    outall(aOut * a_envelope_1)
endin

{{InitializeModule "AF_source_01_module" "source_1"}}
{{InitializeModule "AF_source_01_module" "source_2"}}
{{InitializeModule "AF_source_01_module" "source_3"}}

</CsInstruments>
<CsScore>

{{CsScore}}

</CsScore>
</CsoundSynthesizer>

{{Cabbage}}
