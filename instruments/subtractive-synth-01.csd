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

instr 2
    aOut = _oscillator_component_()
    outall(aOut)
endin

</CsInstruments>
<CsScore>

{{CsScore}}

i2 0 -1

</CsScore>
</CsoundSynthesizer>

{{Cabbage}}
