
opcode _oscillator_component_audio_generator_, a, kkiV
    kAmp, kCps, iMode, kPulseWidth xin

    if (iMode == {{oscillator.wave.Sine}}) then
        aOut = poscil3(kAmp, kCps)
    else
        iVco2Mode = \
            iMode == {{oscillator.wave.Saw}} ? {{vco2.mode.Sawtooth}} : \
            iMode == {{oscillator.wave.Pulse}} ? {{vco2.mode.Square}} : \
            iMode == {{oscillator.wave.Triangle}} ? {{vco2.mode.SawtoothTriangleRamp}} : \
            -1
        aOut = vco2(kAmp, kCps, iVco2Mode, kPulseWidth)
        ; {{LogDebug_k '("kAmp = %f", kAmp)'}}
        ; {{LogDebug_k '("kNoteNumber_1 = %f", kNoteNumber_1)'}}
        ; {{LogDebug_i '("iVco2Mode = %f", iVco2Mode)'}}
        ; {{LogDebug_k '("kPulseWidth = %f", kPulseWidth)'}}
    endif

    xout(aOut)
endop

opcode _oscillator_component_on_channel_, a, S
    SChannelPrefix xin

    kHost_enabled_1     = {{getHostValue}}:k(strcat(SChannelPrefix, "_enabled_1"))
    iHost_wave_1        = {{getHostValue}}:i(strcat(SChannelPrefix, "_wave_1"))
    kHost_pulseWidth_1  = {{getHostValue}}:k(strcat(SChannelPrefix, "_pulseWidth_1"))
    kHost_fine_1        = {{getHostValue}}:k(strcat(SChannelPrefix, "_fine_1"))

    kHost_mix           = {{getHostValue}}:k(strcat(SChannelPrefix, "_mix"))

    kHost_enabled_2     = {{getHostValue}}:k(strcat(SChannelPrefix, "_enabled_2"))
    iHost_wave_2        = {{getHostValue}}:i(strcat(SChannelPrefix, "_wave_2"))
    kHost_pulseWidth_2  = {{getHostValue}}:k(strcat(SChannelPrefix, "_pulseWidth_2"))
    kHost_semi_2        = {{getHostValue}}:k(strcat(SChannelPrefix, "_semi_2"))
    kHost_fine_2        = {{getHostValue}}:k(strcat(SChannelPrefix, "_fine_2"))

    kHost_sub_enabled   = {{getHostValue}}:k(strcat(SChannelPrefix, "_sub_enabled"))
    iHost_sub_wave      = {{getHostValue}}:i(strcat(SChannelPrefix, "_sub_wave"))
    kHost_sub_amp       = {{getHostValue}}:k(strcat(SChannelPrefix, "_sub_amp"))

    kNoteNumber init notnum()
    aOut = 0

    if (kHost_enabled_1 == {{true}}) then
        kNoteNumber_1 = kNoteNumber + kHost_fine_1 / 100
        aOut += _oscillator_component_audio_generator_(kHost_mix, cpsmidinn(kNoteNumber_1), iHost_wave_1, kHost_pulseWidth_1)
        ; {{LogDebug_k '("kHost_mix = %f", kHost_mix)'}}
        ; {{LogDebug_k '("kNoteNumber_1 = %f", kNoteNumber_1)'}}
        ; {{LogDebug_i '("iHost_wave_1 = %f", iHost_wave_1)'}}
        ; {{LogDebug_k '("kHost_pulseWidth_1 = %f", kHost_pulseWidth_1)'}}
    endif

    if (kHost_enabled_2 == {{true}}) then
        kNoteNumber_2 = kNoteNumber + kHost_semi_2 + kHost_fine_2 / 100
        aOut += _oscillator_component_audio_generator_(k(1) - kHost_mix, cpsmidinn(kNoteNumber_2), iHost_wave_2, kHost_pulseWidth_2)
        ; {{LogDebug_k '("kHost_mix = %f", kHost_mix)'}}
        ; {{LogDebug_k '("kNoteNumber_2 = %f", kNoteNumber_2)'}}
        ; {{LogDebug_i '("iHost_wave_2 = %f", iHost_wave_2)'}}
        ; {{LogDebug_k '("kHost_pulseWidth_2 = %f", kHost_pulseWidth_2)'}}
    endif

    if (kHost_sub_enabled == {{true}}) then
        if (iHost_sub_wave == {{oscillator.sub.wave.Pulse}}) then
            iMode_sub = {{vco2.mode.SquareWaveNoPWM}}
        elseif (iHost_sub_wave == {{oscillator.sub.wave.Triangle}}) then
            iMode_sub = {{vco2.mode.TriangleNoRamp}}
        endif
        aOut += vco2(kHost_sub_amp, cpsmidinn(kNoteNumber - 12), iMode_sub)
        ; {{LogDebug_i '("iMode_sub = %f", iMode_sub)'}}
    endif

    xout(aOut * 0.1)
end:
endop

opcode _oscillator_component_, a, 0
    xout(_oscillator_component_on_channel_("oscillator"))
endop

instr _oscillator_component_on_channel_
    SChannelPrefix = p4

    if (frac(p1) == 0) then
        // Retrigger this instrument with a fractional instrument number so it doesn't get turned off if another
        // instance of this instrument is started with a non-fractional instrument number.
        scoreline_i(sprintf("i%d.%d 0 -1 \"%s\"", p1, active(p1), SChannelPrefix))
        turnoff()
    endif

    kLast_wave_1        init 0
    kLast_wave_2        init 0
    kLast_pulseWidth_1  init 0
    kLast_pulseWidth_2  init 0
    kLast_fine_1        init 0
    kLast_fine_2        init 0

    if ({{getHostValue}}:k(strcat(SChannelPrefix, "_link")) == {{true}}) then
        kHost_wave_1        = {{getHostValue}}:k(strcat(SChannelPrefix, "_wave_1"))
        kHost_wave_2        = {{getHostValue}}:k(strcat(SChannelPrefix, "_wave_2"))
        kHost_pulseWidth_1  = {{getHostValue}}:k(strcat(SChannelPrefix, "_pulseWidth_1"))
        kHost_pulseWidth_2  = {{getHostValue}}:k(strcat(SChannelPrefix, "_pulseWidth_2"))
        kHost_fine_1        = {{getHostValue}}:k(strcat(SChannelPrefix, "_fine_1"))
        kHost_fine_2        = {{getHostValue}}:k(strcat(SChannelPrefix, "_fine_2"))

        if (kHost_wave_1 != kLast_wave_1) then
            kHost_wave_2 = kHost_wave_1
            {{setHostValue}}(strcat(SChannelPrefix, "_wave_2"), kHost_wave_2)
        elseif (kHost_wave_2 != kLast_wave_2) then
            kHost_wave_1 = kHost_wave_2
            {{setHostValue}}(strcat(SChannelPrefix, "_wave_1"), kHost_wave_1)
        endif

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

        kLast_wave_1 = kHost_wave_1
        kLast_wave_2 = kHost_wave_2
        kLast_pulseWidth_1 = kHost_pulseWidth_1
        kLast_pulseWidth_2 = kHost_pulseWidth_2
        kLast_fine_1 = kHost_fine_1
        kLast_fine_2 = kHost_fine_2
    endif
endin

instr _oscillator_component_
    scoreline_i("i\"_oscillator_component_on_channel_\" 0 -1 \"oscillator\"")
    turnoff()
endin
