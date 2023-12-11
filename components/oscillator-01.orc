
opcode _oscillator_component_, a, S
    SChannelPrefix xin

    iHost_shape_1       = {{getHostValue}}:i(strcat(SChannelPrefix, "_shape_1"))
    iHost_shape_2       = {{getHostValue}}:i(strcat(SChannelPrefix, "_shape_2"))
    kHost_pulseWidth_1  = {{getHostValue}}:k(strcat(SChannelPrefix, "_pulsewidth_1"))
    kHost_pulseWidth_2  = {{getHostValue}}:k(strcat(SChannelPrefix, "_pulsewidth_2"))
    kHost_semi_1        = {{getHostValue}}:k(strcat(SChannelPrefix, "_semi_1"))
    kHost_semi_2        = {{getHostValue}}:k(strcat(SChannelPrefix, "_semi_2"))
    kHost_fine_1        = {{getHostValue}}:k(strcat(SChannelPrefix, "_fine_1"))
    kHost_fine_2        = {{getHostValue}}:k(strcat(SChannelPrefix, "_fine_2"))
    kHost_mix           = {{getHostValue}}:k(strcat(SChannelPrefix, "_mix"))

    kNoteNumber_1 = 60 + 100 * kHost_semi_1 + kHost_fine_1
    iMode_1 = {{vco2.mode.Sawtooth}}
    if (iHost_shape_1 == {{oscillator.shape.Square}}) then
        iMode_1 = {{vco2.mode.Square}}
    elseif (iHost_shape_1 == {{oscillator.shape.Sawtooth}}) then
        kHost_pulseWidth_1 = max(0.01, min(kHost_pulseWidth_1, 0.99))
    endif

    {{LogDebug_k '("%s = %f", kHost_mix, kHost_mix)'}}
    {{LogDebug_k '("%s = %f", "kNoteNumber_1", kNoteNumber_1)'}}
    {{LogDebug_i '("%s = %f", iHost_shape_1, iHost_shape_1)'}}
    {{LogDebug_k '("%s = %f", kHost_pulseWidth_1, kHost_pulseWidth_1)'}}

    aOut = vco2(k(1) - kHost_mix, cpsmidinn(kNoteNumber_1), iMode_1, kHost_pulseWidth_1)

    kOscillator2Enabled = ( \
        kHost_mix > 0 \
        && iHost_shape_1 != iHost_shape_2 \
        && (iHost_shape_1 != {{oscillator.shape.Sawtooth}} && kHost_pulseWidth_1 != kHost_pulseWidth_2) \
        && kHost_semi_1 != kHost_semi_2 \
        && kHost_fine_1 != kHost_fine_2 \
    ) ? {{true}} : {{false}} \

    {{LogDebug_k '("%s = %f", "kOscillator2Enabled", kOscillator2Enabled)'}}

    if (kOscillator2Enabled == {{true}}) then
        kNoteNumber_2 = 60 + 100 * kHost_semi_2 + kHost_fine_2
        iMode_2 = {{vco2.mode.Sawtooth}}
        if (iHost_shape_2 == {{oscillator.shape.Square}}) then
            iMode_2 = {{vco2.mode.Square}}
        elseif (iHost_shape_2 == {{oscillator.shape.Sawtooth}}) then
            kHost_pulseWidth_2 = max(0.01, min(kHost_pulseWidth_2, 0.99))
        endif

        {{LogDebug_k '("%s = %f", kHost_mix, kHost_mix)'}}
        {{LogDebug_k '("%s = %f", "kNoteNumber_2", kNoteNumber_2)'}}
        {{LogDebug_i '("%s = %f", iHost_shape_2, iHost_shape_2)'}}
        {{LogDebug_k '("%s = %f", kHost_pulseWidth_2, kHost_pulseWidth_2)'}}

        aOut += vco2(kHost_mix, cpsmidinn(kNoteNumber_2), iMode_2, kHost_pulseWidth_2)
    endif

    xout(aOut)
endop

opcode _oscillator_component_, a, 0
    xout(_oscillator_component_("oscillator"))
endop
