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
    aOut = _oscillator_component_()
    outall(aOut)
endin

alwayson("_oscillator_component_")

</CsInstruments>
<CsScore>

{{CsScore}}

</CsScore>
</CsoundSynthesizer>

{{Cabbage}}
