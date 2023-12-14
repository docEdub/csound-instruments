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
    a_audio_source_1 = _oscillator_component_on_channel_("audio_source_1")
    a_audio_source_2 = _oscillator_component_on_channel_("audio_source_2")
    a_audio_source_3 = _oscillator_component_on_channel_("audio_source_3")
    outall(a_audio_source_1 + a_audio_source_2 + a_audio_source_3)
endin

alwayson("_oscillator_component_on_channel_", "audio_source_1")
alwayson("_oscillator_component_on_channel_", "audio_source_2")
alwayson("_oscillator_component_on_channel_", "audio_source_3")

</CsInstruments>
<CsScore>

{{CsScore}}

</CsScore>
</CsoundSynthesizer>

{{Cabbage}}
