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
    outall(a_source_1 + a_source_2 + a_source_3)
endin

alwayson("AF_source_01_module", "source_1")
alwayson("AF_source_01_module", "source_2")
alwayson("AF_source_01_module", "source_3")

</CsInstruments>
<CsScore>

{{CsScore}}

</CsScore>
</CsoundSynthesizer>

{{Cabbage}}