<CsoundSynthesizer>
<CsOptions>

--messagelevel=0
--nodisplays
--nosound

</CsOptions>
<CsInstruments>

sr = 48000
kr = 1
0dbfs = 1

instr 1
    k_steepness = p4
    k_x1 = expcurve(0, k_steepness)
    k_x2 = expcurve(0.25, k_steepness)
    k_x3 = expcurve(0.5, k_steepness)
    k_x4 = expcurve(0.75, k_steepness)
    k_x5 = expcurve(1, k_steepness)

    printsk("\n")
    printsk("steepness = %f\n", k_steepness)
    printsk("    0.00: %f\n", k_x1)
    printsk("    0.25: %f\n", k_x2)
    printsk("    0.50: %f\n", k_x3)
    printsk("    0.75: %f\n", k_x4)
    printsk("    1.00: %f\n", k_x5)
    printsk("\n")

    turnoff()
endin

</CsInstruments>
<CsScore>

i 1 0 1 100
i 1 0 1 10
i 1 0 1 1
i 1 0 1 0.1

</CsScore>
<CsoundSynthesizer>
