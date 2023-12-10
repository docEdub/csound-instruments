
opcode component_Oscillator, a, S
    SChannelPrefix xin

    SOsc1_shape = strcat(SChannelPrefix, "_oscillator_1_shape")
    SOsc2_shape = strcat(SChannelPrefix, "_oscillator_2_shape")

    SOsc1_pulseWidth = strcat(SChannelPrefix, "_oscillator_1_pulsewidth")
    SOsc2_pulseWidth = strcat(SChannelPrefix, "_oscillator_2_pulsewidth")

    SOsc1_detune = strcat(SChannelPrefix, "_oscillator_1_detune")
    SOsc2_detune = strcat(SChannelPrefix, "_oscillator_2_detune")

    SMix = strcat(SChannelPrefix, "_mix")

    iOsc1_shape = {{getHostValue}}:i(SOsc1_shape)
    iOsc2_shape = {{getHostValue}}:i(SOsc2_shape)

    aOut init 0
    xout aOut
endop
