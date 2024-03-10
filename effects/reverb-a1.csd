<CsoundSynthesizer>
<CsOptions>
{{CsOptions}}
{{HostOptions}}
--messagelevel=0
</CsOptions>
<CsInstruments>

{{Enable-LogTrace false}}
{{Enable-LogDebug false}}

sr = {{sr}}
ksmps = {{ksmps}}
nchnls = 2
nchnls_i = 2

{{CsInstruments}}


instr AF_Reverb_A1_alwayson
    a_in_l, a_in_r inch 1, 2
    a_out_l, a_out_r AF_Module_Reverb_A "Reverb_1", a_in_l, a_in_r
    outs(a_out_l, a_out_r)

    processSelectedChannels()
    updateModVisibilityChannels()
endin


// Start at 1 second to give the host time to set it's values.
scoreline_i("i\"AF_Reverb_A1_alwayson\" 1 -1")


{{InitializeModule "Reverb_A" "Reverb_1"}}


</CsInstruments>
<CsScore>

{{CsScore}}

</CsScore>
</CsoundSynthesizer>

{{Cabbage}}
