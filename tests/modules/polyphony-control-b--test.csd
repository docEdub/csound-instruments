<CsoundSynthesizer>
<CsOptions>
{{CsOptions}}
{{HostOptions}}
--messagelevel=0
 -+msg_color=false
</CsOptions>
<CsInstruments>

sr = {{sr}}
ksmps = {{ksmps}}
nchnls = 1

{{CsInstruments}}

massign 0, 2
pgmassign 0, 0

gi_noteId init 0


gS_tests[] = fillarray( \
    "" \
    , "Note1ShouldEnterSoftOffStateWhenSoftMaxIs1AndNote2Starts" \
)

gk_testInstrumentNumbers[] init lenarray(gS_tests)
gk_testResults[] init lenarray(gS_tests)


instr Note1ShouldEnterSoftOffStateWhenSoftMaxIs1AndNote2Starts
    {{LogTrace_i '("%s ...", nstrstr(p1))'}}

    i_testIndex = p4
    {{hostValueSet}}("PolyphonyControl_Test::SoftMax", 1)

    ki init 0
    ki += 1

    if (ki == 1) then
        {{LogTrace_k '("Calling midiTesting_noteOn(1, 1, 127)")'}}
        midiTesting_noteOn(1, 1, 127)
        midiTesting_noteOn(1, 2, 127)
    endif

    if (ki == 3) then
        // TODO: Make a csound-test package in the CsoundTemplating repo that adds Handlebar helpers for common test functions, like ASSERT_EQUAL.
        k_actual = {{hostValueGet}}:k("Note.1.state")
        i_expected = {{eval "(Constants.PolyphonyControl_B.State.SoftOff)"}} $NEWLINE if (k_actual != i_expected) then $NEWLINE {{LogError_k '("%s - ASSERT_EQUAL failed: Expected = %f, Actual = %f", gS_tests[i_testIndex], i_expected, k_actual)'}}
            gk_testResults[i_testIndex] = {{false}}
        else
            gk_testResults[i_testIndex] = {{true}}
        endif

        {{LogTrace_k '("Calling midiTesting_noteOff(1, 1)")'}}
        midiTesting_noteOff(1, 1)
        midiTesting_noteOff(1, 2)
        turnoff()
    endif
endin


instr 2
    {{LogTrace_i '("%s.%d ...", nstrstr(p1), frac(p1) * 10)'}}

    gi_noteId += 1
    i_noteId = gi_noteId

    k_state = AF_Module_PolyphonyControl_B("PolyphonyControl_Test")
    ; k_state = {{eval "(Constants.PolyphonyControl_B.State.SoftOff)"}}

    S_channel init " "
    S_channel = sprintfk("Note.%d.state", i_noteId)
    {{LogDebug_k '("S_channel = %s", S_channel)'}}
    {{hostValueSet}}(S_channel, k_state)
endin


{{InitializeModule "AF_Module_PolyphonyControl_B" "PolyphonyControl_Test"}}


instr InitializeInstrumentNumbers
    S_instrument = gS_tests[p4]
    if (strcmp("x", strsub(S_instrument, 0, 1)) == 0) then
        S_instrument = strsub(S_instrument, 1, strlen(S_instrument))
    endif

    i_instrumentNumber = nstrnum(S_instrument)
    gk_testInstrumentNumbers[p4] = i_instrumentNumber

    ki = 0
    while (ki <= p4) do
        {{LogDebug_k '("gk_testInstrumentNumbers[%d] = %d", ki, gk_testInstrumentNumbers[ki])'}}
        ki += 1
    od
    turnoff()
endin


instr Initialize
    {{LogTrace_i '("Reset ...")'}}

    ki = 0
    while (ki < lenarray(gk_testResults)) do
        gk_testResults[ki] = -2
        ki += 1
    od

    {{LogTrace_k '("Reset - done")'}}
    turnoff()
endin


instr Reset
    {{LogTrace_i '("Reset ...")'}}

    {{LogTrace_k '("Reset - done")'}}
    turnoff()
endin


instr RunTest
    k_instrumentNumber = gk_testInstrumentNumbers[p4]

    k_initialized init {{false}}
    if (k_initialized == {{false}}) then
        k_initialized = {{true}}

        {{LogTrace_i '("RunTest starting %s", nstrstr(p4))'}}
        scoreline(sprintfk("i%d 0 -1 %d", k_instrumentNumber, p4), k(1))
    else
        if (active:k(k_instrumentNumber) == 0) then
            turnoff()
        endif
    endif
    {{LogTrace_k '("RunTest k-pass - done")'}}
endin


instr RunTests
    prints("\n");
    {{LogTrace_k '("RunTests k-pass ...")'}}

    scoreline_i("i\"Initialize\" 0 -1")

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
            scoreline(sprintfk("i\"RunTest\" 0 -1 %d", k_testIndex), k(1))
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
                gk_testResults[k_testIndex] = -1
                kgoto end
            endif

            k_resetDone = {{false}}
            scoreline("i\"Reset\" 0 -1", k(1))
        endif
    else
        printsk("Test results:\n")
        printsk("--------------------------------------------------------------------------------------------------\n")
        ki = 1
        k_exitCode = 0
        while (ki < lenarray(gk_testResults)) do
            if (gk_testResults[ki] == -2) then
                printsk("MISSING")
                k_exitCode += 1
            elseif (gk_testResults[ki] == -1) then
                printsk("skipped")
                k_exitCode += 1
            elseif (gk_testResults[ki] == {{false}}) then
                printsk("FAILED ")
                k_exitCode += 1
            else
                printsk("PASSED ")
            endif
            S_testName = sprintfk("%s", gS_tests[ki])
            if (gk_testResults[ki] == -1) then
                // Remove the "x" prefix.
                S_testName = sprintfk("%s", strsubk(S_testName, 1, strlenk(S_testName)))
            endif
            printsk(" #%d  %s\n", ki, S_testName)
            ki += 1
        od
        printsk("--------------------------------------------------------------------------------------------------\n")

        scoreline(sprintfk("i\"Exit\" 0 -1 %d", k_exitCode), k(1))
    endif
end:
    {{LogTrace_k '("RunTests k-pass - done, k_testIndex = %d", k_testIndex)'}}
endin


instr Exit
    prints("\n");
    {{LogInfo_i '("Exit code = %d", p4)'}}
    prints("\n");
    exitnow(p4)
endin


</CsInstruments>
<CsScore>

{{CsScore}}

i"RunTests" 0 z

</CsScore>
<CsoundSynthesizer>
