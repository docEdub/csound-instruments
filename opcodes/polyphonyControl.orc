{{includeGuardStart}}

/*
 *  polyphonyControl.orc
 *
 *  Polyphony control opcodes for soft and hard note limits, and click free note off.
 *  When the soft limit is reached, the oldest note is faded out over {{PolyphonyControl.SoftOffFadeTime}} seconds.
 *  When the hard limit is reached, the oldest note is turned off on or after the first zero crossing of the given audio input.
 *
 * Usage example:
 * ```
 * instr 1
 *     k_polyphonyControlState = AF_PolyphonyControl_state()
 *     if (k_polyphonyControlState == {{PolyphonyControl.State.Off}}) then
 *         kgoto end
 *     endif
 *
 *     // < Instrument code ... >
 *
 *     // NB: Use dc block opcode on the audio output, otherwise zero crossing detection may fail.
 *     a_out = dcblock2(a_out, ksmps)
 *
 *     if (k_polyphonyControlState != {{PolyphonyControl.State.Inactive}}) then
 *         a_out = AF_PolyphonyControl_audioProcessing(a_out, k_polyphonyControlState)
 *     endif
 *
 *     outall(a_out)
 *  end:
 *  endin
 *  ```
 */

// For logging.
gi_noteId init 0

gk_AF_PolyphonyControl_softOffActiveNoteCount init 0
gk_AF_PolyphonyControl_hardOffActiveNoteCount init 0


opcode AF_PolyphonyControl_state, k, 0
    // For logging.
    gi_noteId += 1
    i_id init gi_noteId

    {{LogDebug_i '("[%d] Active soft/hard off note count: %d/%d", i_id, i(gk_AF_PolyphonyControl_softOffActiveNoteCount), i(gk_AF_PolyphonyControl_hardOffActiveNoteCount))'}}

    k_state init {{PolyphonyControl.State.Inactive}}
    k_hardTurnoffActivated init {{false}}
    k_softTurnoffActivated init {{false}}

    // If hard off was activated on the last k-pass, set state to `Off`.
    if (k_hardTurnoffActivated == {{true}}) then
        k_state = {{PolyphonyControl.State.Off}}
    endif

    // Return if state is `Off`.
    if (k_state == {{PolyphonyControl.State.Off}}) then
        kgoto end
    endif

    gk_AF_PolyphonyControl_softOffActiveNoteCount init i(gk_AF_PolyphonyControl_softOffActiveNoteCount) + 1
    gk_AF_PolyphonyControl_hardOffActiveNoteCount init i(gk_AF_PolyphonyControl_hardOffActiveNoteCount) + 1
    i_polyphonyHardMax = {{hostValueGet}}:i("UI::PolyphonyHardMax")
    i_polyphonySoftMax = {{hostValueGet}}:i("UI::PolyphonySoftMax")

    if (gk_AF_PolyphonyControl_hardOffActiveNoteCount > i_polyphonyHardMax) then
        {{LogTrace_k '("[%d] Hard off activated", i_id)'}}
        k_hardTurnoffActivated = {{true}}
        gk_AF_PolyphonyControl_hardOffActiveNoteCount -= 1
        if (k_softTurnoffActivated == {{false}}) then
            gk_AF_PolyphonyControl_softOffActiveNoteCount -= 1
        endif
        k_state = {{PolyphonyControl.State.HardOff}}
    elseif (k_softTurnoffActivated == {{false}} && gk_AF_PolyphonyControl_softOffActiveNoteCount > i_polyphonySoftMax) then
        {{LogTrace_k '("[%d] Soft off activated", i_id)'}}
        k_softTurnoffActivated = {{true}}
        gk_AF_PolyphonyControl_softOffActiveNoteCount -= 1
        k_state = {{PolyphonyControl.State.SoftOff}}
    endif

    if (k_softTurnoffActivated == {{true}}) then
        k_fadeTime init {{PolyphonyControl.SoftOffFadeTime}}
        k_fadeTime -= gi_secondsPerKPass
        if (k_fadeTime <= 0) then
            {{LogTrace_k '("[%d] Soft off fade - done", i_id)'}}
            k_state = {{PolyphonyControl.State.Off}}
        endif
    endif

    if (k_state == {{PolyphonyControl.State.Off}} || lastcycle() == {{true}}) then
        k_state = {{PolyphonyControl.State.Off}}

        if (k_hardTurnoffActivated == {{false}}) then
            gk_AF_PolyphonyControl_hardOffActiveNoteCount -= 1
            {{LogDebug_k '("[%d] Active hard off note count: %d", i_id, gk_AF_PolyphonyControl_hardOffActiveNoteCount)'}}
        endif
        if (k_softTurnoffActivated == {{false}}) then
            gk_AF_PolyphonyControl_softOffActiveNoteCount -= 1
            {{LogDebug_k '("[%d] Active soft off note count: %d", i_id, gk_AF_PolyphonyControl_softOffActiveNoteCount)'}}
        endif
    endif

end:
    xout(k_state)
endop


opcode AF_PolyphonyControl_audioProcessing, a, ak
    a_out, k_state xin

    if (k_state == {{PolyphonyControl.State.HardOff}}) then
        k_off init {{false}}

        // Search the audio output buffer for the first zero crossing.
        ki = 1
        k_prevSample = vaget(0, a_out)
        if (k_prevSample == 0) then
            k_off = {{true}}
        endif
        while (k_off == {{false}} && ki < ksmps) do
            k_sample = vaget(ki, a_out)
            if ((k_sample < 0 && k_prevSample > 0) || (k_sample > 0 && k_prevSample < 0) || k_sample == 0) then
                k_off = {{true}}
            endif
            ki += 1
        od
        if (k_off == {{true}}) then
            // Clear the rest of the audio output buffer.
            while (ki < ksmps) do
                vaset(0, ki, a_out)
                ki += 1
            od
        endif
    else
        // Mute instrument after 0.5 second fade out.
        k_fade init 1
        k_fade -= 1 / ({{PolyphonyControl.SoftOffFadeTime}} * kr)
        k_fade = max(0, k_fade)
        a_fade = a(k_fade)

        a_out *= a_fade
    endif

    xout(a_out)
endop


{{includeGuardEnd}}
