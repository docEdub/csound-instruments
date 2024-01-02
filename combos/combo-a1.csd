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
endin

// Start at 1 second to give the host time to set it's values.
scoreline_i("i\"AF_Combo_A1_alwayson\" 1 -1")


instr 2
endin


</CsInstruments>
<CsScore>

{{CsScore}}

</CsScore>
</CsoundSynthesizer>

{{Cabbage}}
