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

gSFilterChannelNames[][] init 20, 4
gkBandwidthMultiplier init 1
gaInput init 0

ii = 0
while (ii < lenarray(gSFilterChannelNames)) do
    gSFilterChannelNames[ii][0] = sprintf("filter-%d-enabled", ii + 1)
    gSFilterChannelNames[ii][1] = sprintf("filter-%d-ratio", ii + 1)
    gSFilterChannelNames[ii][2] = sprintf("filter-%d-bandwidth", ii + 1)
    gSFilterChannelNames[ii][3] = sprintf("filter-%d-amplitude", ii + 1)
    ii += 1
od

{{CsInstruments}}

instr 2
    iHighPassCutoffFrequency = 120
    iLowPassCutoffFrequency = 10000

    gaInput = pinkish(1)
    gaInput = butlp(gaInput, iLowPassCutoffFrequency)
    gaInput = butlp(gaInput, iLowPassCutoffFrequency)
    gaInput = buthp(gaInput, iHighPassCutoffFrequency)
    gaInput = buthp(gaInput, iHighPassCutoffFrequency)

    gkBandwidthMultiplier = {{getHostValue}}:k("filter-bandwidth-multiplier")
endin

instr 3
    ii = 0
    while (ii < lenarray(gSFilterChannelNames)) do
        event_i("i", 4 + ii / 100, 0, -1, ii)
        ii += 1
    od
    turnoff
endin

instr 4
    ki = p4

    iFundamentalFrequency = cpsmidinn(36)
    iResonMode = 0

    kFilterEnabled = {{getHostValue}}:k(gSFilterChannelNames[ki][0])
    if (kFilterEnabled == {{true}}) then
        kFilterRatio = {{getHostValue}}:k(gSFilterChannelNames[ki][1])
        kFilterBandwidth = {{getHostValue}}:k(gSFilterChannelNames[ki][2])
        kFilterAmplitude = {{getHostValue}}:k(gSFilterChannelNames[ki][3])
        outall(reson(gaInput, kFilterRatio * iFundamentalFrequency, gkBandwidthMultiplier * kFilterBandwidth, iResonMode) * kFilterAmplitude * 0.001)
    endif
endin

</CsInstruments>
<CsScore>

{{CsScore}}

i2 0 -1
i3 0 -1

</CsScore>
</CsoundSynthesizer>

{{Cabbage}}
