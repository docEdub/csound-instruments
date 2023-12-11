
opcode _oscillator_component_, a, S
    SChannelPrefix xin
    kNoteNumber init notnum()

    iHost_wave_1       = {{getHostValue}}:i(strcat(SChannelPrefix, "_wave_1"))
    iHost_wave_2       = {{getHostValue}}:i(strcat(SChannelPrefix, "_wave_2"))
    kHost_pulseWidth_1  = {{getHostValue}}:k(strcat(SChannelPrefix, "_pulsewidth_1"))
    kHost_pulseWidth_2  = {{getHostValue}}:k(strcat(SChannelPrefix, "_pulsewidth_2"))
    kHost_semi_1        = {{getHostValue}}:k(strcat(SChannelPrefix, "_semi_1"))
    kHost_semi_2        = {{getHostValue}}:k(strcat(SChannelPrefix, "_semi_2"))
    kHost_fine_1        = {{getHostValue}}:k(strcat(SChannelPrefix, "_fine_1"))
    kHost_fine_2        = {{getHostValue}}:k(strcat(SChannelPrefix, "_fine_2"))
    kHost_mix           = {{getHostValue}}:k(strcat(SChannelPrefix, "_mix"))

    kNoteNumber_1 = kNoteNumber + kHost_semi_1 * 100 + kHost_fine_1

    iMode_1 = {{vco2.mode.Sawtooth}}
    if (iHost_wave_1 == {{oscillator.wave.Square}}) then
        iMode_1 = {{vco2.mode.Square}}
    endif

    kHost_pulseWidth_1 = max(0.01, min(kHost_pulseWidth_1, 0.99))

    aOut = vco2(k(1) - kHost_mix, cpsmidinn(kNoteNumber_1), iMode_1, kHost_pulseWidth_1)
    ; {{LogDebug_k '("kHost_mix = %f", kHost_mix)'}}
    ; {{LogDebug_k '("kNoteNumber_1 = %f", kNoteNumber_1)'}}
    ; {{LogDebug_i '("iHost_wave_1 = %f", iHost_wave_1)'}}
    ; {{LogDebug_k '("kHost_pulseWidth_1 = %f", kHost_pulseWidth_1)'}}

    kOscillator2Enabled = ( \
        kHost_mix > 0 \
        && iHost_wave_1 != iHost_wave_2 \
        && (iHost_wave_1 != {{oscillator.wave.Sawtooth}} && kHost_pulseWidth_1 != kHost_pulseWidth_2) \
        && kHost_semi_1 != kHost_semi_2 \
        && kHost_fine_1 != kHost_fine_2 \
    ) ? {{true}} : {{false}} \

    ; {{LogDebug_k '("kOscillator2Enabled = %f", kOscillator2Enabled)'}}

    if (kOscillator2Enabled == {{true}}) then
        kNoteNumber_2 = kNoteNumber + kHost_semi_2 * 100 + kHost_fine_2

        iMode_2 = {{vco2.mode.Sawtooth}}
        if (iHost_wave_2 == {{oscillator.wave.Square}}) then
            iMode_2 = {{vco2.mode.Square}}
        endif

        kHost_pulseWidth_2 = max(0.01, min(kHost_pulseWidth_2, 0.99))

        aOut += vco2(kHost_mix, cpsmidinn(kNoteNumber_2), iMode_2, kHost_pulseWidth_2)
        ; {{LogDebug_k '("kHost_mix = %f", kHost_mix)'}}
        ; {{LogDebug_k '("kNoteNumber_2 = %f", kNoteNumber_2)'}}
        ; {{LogDebug_i '("iHost_wave_2 = %f", iHost_wave_2)'}}
        ; {{LogDebug_k '("kHost_pulseWidth_2 = %f", kHost_pulseWidth_2)'}}
    endif

    xout(aOut)
endop

opcode _oscillator_component_, a, 0
    xout(_oscillator_component_("oscillator"))
endop
