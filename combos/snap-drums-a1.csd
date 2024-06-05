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

#define AlwaysOnInstrumentNumber #2#

instr $AlwaysOnInstrumentNumber

endin


// Start at 1 second to give the host time to set it's values.
scoreline_i("i$AlwaysOnInstrumentNumber 1 -1")


{{InitializeModule "SnapTrigger_A"  "Main::SnapTrigger_1"}}


</CsInstruments>
<CsScore>

{{CsScore}}

</CsScore>
</CsoundSynthesizer>

{{Cabbage}}
