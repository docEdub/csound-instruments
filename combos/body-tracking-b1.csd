-<CsoundSynthesizer>
<CsOptions>
{{CsOptions}}
{{HostOptions}}
--messagelevel=0
</CsOptions>
<CsInstruments>

{{Enable-LogTrace false}}
{{Enable-LogDebug false}}

sr = {{sr}}
ksmps = 1
nchnls = 2
nchnls_i = 2

{{CsInstruments}}


gk_websocketPort init 12345


instr AF_BodyTracking_B1_alwayson
    i_websocketPort = i(gk_websocketPort)
endin


// Start at 1 second to give the host time to set it's values.
scoreline_i("i\"AF_BodyTracking_B1_alwayson\" 1 -1")

</CsInstruments>
<CsScore>

{{CsScore}}

</CsScore>
</CsoundSynthesizer>

{{Cabbage}}
