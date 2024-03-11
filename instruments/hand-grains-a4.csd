<CsoundSynthesizer>
<CsOptions>
{{CsOptions}}
{{HostOptions}}
--messagelevel=0
</CsOptions>
<CsInstruments>

{{Enable-LogTrace false}}
{{Enable-LogDebug true}}

sr = {{sr}}
ksmps = {{ksmps}}
nchnls = 2
nchnls_i = 2

{{CsInstruments}}

massign 0, 2
pgmassign 0, 0


instr AF_HandGrains_A4_alwayson

    // XR hands and head tracking ...

    a_bodyTrackingData = inch(1)
    k_bodyTrackingId init -1
    k_bodyTrackingData[] init 42
    ki = 0
    while (ki < ksmps) do
        k_bodyTrackingValue = vaget(ki, a_bodyTrackingData)
        if (k_bodyTrackingValue > 0.999999) then
            k_bodyTrackingId = 0
        elseif (k_bodyTrackingValue < -0.999999) then
            k_bodyTrackingId = -1
        elseif (k_bodyTrackingId >= 0 && k_bodyTrackingId < 42) then
            k_bodyTrackingData[k_bodyTrackingId] = k_bodyTrackingValue
            k_bodyTrackingId += 1
        endif
        ki += 1
    od

    k_leftWristX = k_bodyTrackingData[0]
    k_leftWristY = k_bodyTrackingData[1]
    k_leftWristZ = k_bodyTrackingData[2]

    k_leftFingerTip1X = k_bodyTrackingData[3]
    k_leftFingerTip1Y = k_bodyTrackingData[4]
    k_leftFingerTip1Z = k_bodyTrackingData[5]

    k_leftFingerTip2X = k_bodyTrackingData[6]
    k_leftFingerTip2Y = k_bodyTrackingData[7]
    k_leftFingerTip2Z = k_bodyTrackingData[8]

    k_leftFingerTip3X = k_bodyTrackingData[9]
    k_leftFingerTip3Y = k_bodyTrackingData[10]
    k_leftFingerTip3Z = k_bodyTrackingData[11]

    k_leftFingerTip4X = k_bodyTrackingData[12]
    k_leftFingerTip4Y = k_bodyTrackingData[13]
    k_leftFingerTip4Z = k_bodyTrackingData[14]

    k_leftFingerTip5X = k_bodyTrackingData[15]
    k_leftFingerTip5Y = k_bodyTrackingData[16]
    k_leftFingerTip5Z = k_bodyTrackingData[17]

    k_rightWristX = k_bodyTrackingData[18]
    k_rightWristY = k_bodyTrackingData[19]
    k_rightWristZ = k_bodyTrackingData[20]

    k_rightFingerTip1X = k_bodyTrackingData[21]
    k_rightFingerTip1Y = k_bodyTrackingData[22]
    k_rightFingerTip1Z = k_bodyTrackingData[23]

    k_rightFingerTip2X = k_bodyTrackingData[24]
    k_rightFingerTip2Y = k_bodyTrackingData[25]
    k_rightFingerTip2Z = k_bodyTrackingData[26]

    k_rightFingerTip3X = k_bodyTrackingData[27]
    k_rightFingerTip3Y = k_bodyTrackingData[28]
    k_rightFingerTip3Z = k_bodyTrackingData[29]

    k_rightFingerTip4X = k_bodyTrackingData[30]
    k_rightFingerTip4Y = k_bodyTrackingData[31]
    k_rightFingerTip4Z = k_bodyTrackingData[32]

    k_rightFingerTip5X = k_bodyTrackingData[33]
    k_rightFingerTip5Y = k_bodyTrackingData[34]
    k_rightFingerTip5Z = k_bodyTrackingData[35]

    k_headPositionX = k_bodyTrackingData[36]
    k_headPositionY = k_bodyTrackingData[37]
    k_headPositionZ = k_bodyTrackingData[38]
endin


instr 2
    a_out = AF_Module_DiskGrain_A("Main::Grain_1", "/Users/andy/-/code/reaper-projects/2024-01-01/3-iii/3-iii--piano-sample-C4--trimmed.wav")
    outs(a_out, a_out)
endin


// Start at 1 second to give the host time to set it's values.
scoreline_i("i\"AF_HandGrains_A4_alwayson\" 1 -1")

{{InitializeModule "DiskGrain_A" "Main::Grain_1"}}


</CsInstruments>
<CsScore>

{{CsScore}}

</CsScore>
</CsoundSynthesizer>

{{Cabbage}}
