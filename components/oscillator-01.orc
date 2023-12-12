
opcode _oscillator_component_, a, S
    SChannelPrefix xin

    iHost_wave_1        = {{getHostValue}}:i(strcat(SChannelPrefix, "_wave_1")) - 1
    iHost_wave_2        = {{getHostValue}}:i(strcat(SChannelPrefix, "_wave_2")) - 1
    kHost_pulseWidth_1  = {{getHostValue}}:k(strcat(SChannelPrefix, "_pulseWidth_1"))
    kHost_pulseWidth_2  = {{getHostValue}}:k(strcat(SChannelPrefix, "_pulseWidth_2"))
    kHost_semi_1        = {{getHostValue}}:k(strcat(SChannelPrefix, "_semi_1"))
    kHost_semi_2        = {{getHostValue}}:k(strcat(SChannelPrefix, "_semi_2"))
    kHost_fine_1        = {{getHostValue}}:k(strcat(SChannelPrefix, "_fine_1"))
    kHost_fine_2        = {{getHostValue}}:k(strcat(SChannelPrefix, "_fine_2"))
    kHost_mix           = {{getHostValue}}:k(strcat(SChannelPrefix, "_mix"))

    iHost_link          = {{getHostValue}}:i(strcat(SChannelPrefix, "_link"))
    kHost_link          = {{getHostValue}}:k(strcat(SChannelPrefix, "_link"))

    if (iHost_link == {{true}}) then
        iHost_wave_2 = iHost_wave_1 + 1
        {{setHostValue}}(strcat(SChannelPrefix, "_wave_2"), iHost_wave_2)
    endif

    kLast_pulseWidth_1  init 0
    kLast_pulseWidth_2  init 0
    kLast_fine_1        init 0
    kLast_fine_2        init 0

    if (kHost_link == {{true}}) then
        if (kHost_pulseWidth_1 != kLast_pulseWidth_1) then
            kHost_pulseWidth_2 = kHost_pulseWidth_1
            {{setHostValue}}(strcat(SChannelPrefix, "_pulseWidth_2"), kHost_pulseWidth_2)
        elseif (kHost_pulseWidth_2 != kLast_pulseWidth_2) then
            kHost_pulseWidth_1 = kHost_pulseWidth_2
            {{setHostValue}}(strcat(SChannelPrefix, "_pulseWidth_1"), kHost_pulseWidth_1)
        endif

        if (kHost_fine_1 != kLast_fine_1) then
            kHost_fine_2 = -kHost_fine_1
            {{setHostValue}}(strcat(SChannelPrefix, "_fine_2"), kHost_fine_2)
        elseif (kHost_fine_2 != kLast_fine_2) then
            kHost_fine_1 = -kHost_fine_2
            {{setHostValue}}(strcat(SChannelPrefix, "_fine_1"), kHost_fine_1)
        endif

        kLast_pulseWidth_1 = kHost_pulseWidth_1
        kLast_pulseWidth_2 = kHost_pulseWidth_2
        kLast_fine_1 = kHost_fine_1
        kLast_fine_2 = kHost_fine_2
    endif

    kNoteNumber init notnum()

    kNoteNumber_1 = kNoteNumber + kHost_semi_1 + kHost_fine_1 / 100
    iMode_1 = iHost_wave_1 == {{oscillator.wave.Saw}} ? {{vco2.mode.Sawtooth}} : {{vco2.mode.Square}}
    aOut = vco2(kHost_mix, cpsmidinn(kNoteNumber_1), iMode_1, kHost_pulseWidth_1)
    ; {{LogDebug_k '("kHost_mix = %f", kHost_mix)'}}
    ; {{LogDebug_k '("kNoteNumber_1 = %f", kNoteNumber_1)'}}
    ; {{LogDebug_i '("iMode_1 = %f", iMode_1)'}}
    ; {{LogDebug_k '("kHost_pulseWidth_1 = %f", kHost_pulseWidth_1)'}}

    kNoteNumber_2 = kNoteNumber + kHost_semi_2 + kHost_fine_2 / 100
    iMode_2 = iHost_wave_2 == {{oscillator.wave.Saw}} ? {{vco2.mode.Sawtooth}} : {{vco2.mode.Square}}
    aOut += vco2(k(1) - kHost_mix, cpsmidinn(kNoteNumber_2), iMode_2, kHost_pulseWidth_2)
    ; {{LogDebug_k '("kHost_mix = %f", kHost_mix)'}}
    ; {{LogDebug_k '("kNoteNumber_2 = %f", kNoteNumber_2)'}}
    ; {{LogDebug_i '("iMode_2 = %f", iMode_2)'}}
    ; {{LogDebug_k '("kHost_pulseWidth_2 = %f", kHost_pulseWidth_2)'}}

    xout(aOut)
endop

opcode _oscillator_component_, a, 0
    xout(_oscillator_component_("oscillator"))
endop
