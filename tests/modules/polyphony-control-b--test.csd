<CsoundSynthesizer>
<CsOptions>
{{CsOptions}}
{{HostOptions}}
--messagelevel=0
</CsOptions>
<CsInstruments>

sr = {{sr}}
ksmps = {{ksmps}}
nchnls = 1

{{CsInstruments}}


gS_tests[] = fillarray( \
    "" \
    , "Test2" \
    , "Test3" \
    , "Note1ShouldEnterSoftOffStateWhenSoftMaxIs2AndNote2Starts" \
)

gk_testInstrumentNumbers[] init lenarray(gS_tests)


instr Note1ShouldEnterSoftOffStateWhenSoftMaxIs2AndNote2Starts
    {{LogTrace_i '("%s ...", nstrstr(p1))'}}

    {{LogTrace_i '("%s - done", nstrstr(p1))'}}
    turnoff()
endin


instr InitializeInstrumentNumbers
    i_instrumentNumber = nstrnum(gS_tests[p4])
    gk_testInstrumentNumbers[p4] = i_instrumentNumber

    ki = 0
    while (ki <= p4) do
        {{LogDebug_k '("gk_testInstrumentNumbers[%d] = %d", ki, gk_testInstrumentNumbers[ki])'}}
        ki += 1
    od
    turnoff()
endin


instr Reset
    {{LogTrace_i '("Reset ...")'}}

    {{LogTrace_k '("Reset - done")'}}
    turnoff()
endin


instr RunTest
    k_initialized init {{false}}
    if (k_initialized == {{false}}) then
        k_initialized = {{true}}

        {{LogTrace_i '("RunTest starting %s", nstrstr(p4))'}}
        scoreline_i(sprintf("i%d 0 -1", p4))
    else
        if (active:k(p4) == 0) then
            turnoff()
        endif
    endif
    {{LogTrace_k '("RunTest k-pass - done")'}}
endin


instr RunTests
    {{LogTrace_k '("RunTests k-pass ...")'}}

    ii = 1
    while (ii < lenarray(gS_tests)) do
        scoreline_i(sprintf("i\"InitializeInstrumentNumbers.%4d\" 0 -1 %d", ii, ii))
        ii += 1
    od

    k_testIndex init 0
    k_resetDone init {{true}}
    k_testDone init {{true}}

    if (k_resetDone == {{false}}) then
        if (active:k(nstrnum("Reset")) == 0) then
            k_resetDone = {{true}}
            scoreline(sprintfk("i\"RunTest\" 0 -1 %d", gk_testInstrumentNumbers[k_testIndex]), k(1))
        endif
        kgoto end
    endif

    if (active:k(nstrnum("RunTest")) != 0) then
        {{LogTrace_k '("RunTest active ...")'}}
        kgoto end
    endif
    {{LogTrace_k '("RunTest - inactive")'}}

    k_testIndex += 1
    if (k_testIndex < lenarray(gS_tests)) then
        if (gk_testInstrumentNumbers[k_testIndex] > 0) then
            S_test init " "
            S_test = gS_tests[k_testIndex]
            if (strcmpk("x", strsubk(S_test, 0, 1)) == 0) then
                kgoto end
            endif

            k_resetDone = {{false}}
            scoreline("i\"Reset\" 0 -1", k(1))
        endif
    else
        scoreline("i\"Exit\" 0 -1 0", k(1))
    endif
end:
    {{LogTrace_k '("RunTests k-pass - done, k_testIndex = %d", k_testIndex)'}}
endin


instr Exit
    {{LogTrace_i '("Exiting with code %d", p4)'}}
    exitnow(p4)
endin


</CsInstruments>
<CsScore>

{{CsScore}}

i"RunTests" 0 z

</CsScore>
<CsoundSynthesizer>
