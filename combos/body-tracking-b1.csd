-<CsoundSynthesizer>
<CsOptions>
{{CsOptions}}
{{HostOptions}}
--messagelevel=0
</CsOptions>
<CsInstruments>

{{Enable-LogTrace false}}
{{Enable-LogDebug true}}

sr = {{sr}}
ksmps = 1
nchnls = 2
nchnls_i = 2

{{CsInstruments}}

#define I_MidiNote #2#
#define I_SetInitialPose #3#
#define I_SendPoseOffsets #4#
#define I_AlwaysOn #5#

massign 0, $I_MidiNote
pgmassign 0, 0

gk_websocketPort init 12345


instr $I_MidiNote
endin


instr $I_SetInitialPose
    k_tick init 0
    if (metro(1) == $true) then
        {{LogDebug_k '("SetInitialPose: k_tick = %d ...", k_tick)'}}
        k_tick += 1
    endif

    k_setInitialPose = cabbageGetValue:k("Set initial pose")
    if (k_setInitialPose == $false) then
        turnoff()
    endif
endin


instr $I_SendPoseOffsets
    k_tick init 0
    if (metro(1) == $true) then
        {{LogDebug_k '("SendPoseOffsets: k_tick = %d ...", k_tick)'}}
        k_tick += 1
    endif

    k_setInitialPose = cabbageGetValue:k("Set initial pose")
    if (k_setInitialPose == $true) then
        turnoff()
    endif
endin


instr $I_AlwaysOn
    i_websocketPort = i(gk_websocketPort)

    k_iteration init 0

    k_setInitialPose = cabbageGetValue:k("Set initial pose")
    if (changed2(k_setInitialPose) == $true || k_iteration == 0) then
        {{LogDebug_k '("k_setInitialPose = %d", k_setInitialPose)'}}

        if (k_setInitialPose == $true) then
            event("i", $I_SetInitialPose, 0, -1)
        else
            event("i", $I_SendPoseOffsets, 0, -1)
        endif
    endif

    k_iteration += 1
endin


// Start at 1 second to give the host time to set it's values.
scoreline_i("i$I_AlwaysOn 1 -1")

</CsInstruments>
<CsScore>

{{CsScore}}

</CsScore>
</CsoundSynthesizer>

{{Cabbage}}
