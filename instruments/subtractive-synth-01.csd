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

// Assign all MIDI channels to instr 2.
massign 0, 2

// Disable MIDI program change messages.
// NB: The Apple Logic DAW sends MIDI program change messages on each MIDI track at startup. If they are not disabled,
// Csound will route MIDI messages to instruments other than the one set using 'massign'.
pgmassign 0, 0

instr 2
    aOut = _oscillator_component_()
    outall(aOut * 0.1)
endin

alwayson("_oscillator_component_")

</CsInstruments>
<CsScore>

{{CsScore}}

</CsScore>
</CsoundSynthesizer>

{{Cabbage}}
