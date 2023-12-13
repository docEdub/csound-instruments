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
    aOscillator = _oscillator_component_()
    a_audio_source_2 = _oscillator_component_on_channel_("audio_source_2")
    outall(aOscillator + a_audio_source_2)
endin

alwayson("_oscillator_component_")
alwayson("_oscillator_component_on_channel_", "audio_source_2")

</CsInstruments>
<CsScore>

{{CsScore}}

</CsScore>
</CsoundSynthesizer>

{{Cabbage}}
