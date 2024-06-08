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

#define I_AlwaysOnInstrumentNumber  #2#
#define I_DrumInstrumentNumber      #3#


gi_unused = vco2init(31)


instr $I_AlwaysOnInstrumentNumber
    k_trigger = AF_Module_SnapTrigger_A("Main::SnapTrigger_1")
    if (k_trigger == $true && changed2(k_trigger) == $true) then
        event("i", $I_DrumInstrumentNumber, 0, 0.01)
    endif
endin


instr $I_DrumInstrumentNumber
    // Drum sound
    outall(vco2(0.5, 440))
endin


// Start at 1 second to give the host time to set it's values.
scoreline_i("i$I_AlwaysOnInstrumentNumber 1 -1")


{{InitializeModule "SnapTrigger_A"  "Main::SnapTrigger_1"}}


</CsInstruments>
<CsScore>

{{CsScore}}

</CsScore>
</CsoundSynthesizer>

{{Cabbage}}
