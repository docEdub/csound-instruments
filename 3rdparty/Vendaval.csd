<Cabbage> bounds(0, 0, 0, 0)
form caption("Vendaval"), size(1000,800), colour(1, 1, 1), pluginId("cja1")
//Signature
label bounds(350, 4, 300, 41) text("V E N D A V A L") fontColour(188, 151, 49, 255)
label bounds(410, 48, 180, 19) text("by Caio M. Jiacomini") fontColour(255, 255, 255, 255)
label bounds(10, 8, 118, 20) text("PRESETS") fontColour(255, 255, 255, 255)
combobox bounds(9, 36, 264, 32) channelType("string") populate("../../../../3rdparty/Vendaval.snaps") fontColour(188, 151, 49, 255)  fontColour(188, 151, 49, 255) channel("combo6") text("Reset", "Soft Howling", "Stormy Gusts", "Bone Chilling", "Spooky Howling", "Through The Window") value("1")
filebutton bounds(140, 4, 64, 33) text("Save", "Save") mode("named preset")
filebutton bounds(208, 4, 64, 33) text("Delete", "Delete") mode("remove preset")

//Global
label bounds(24, 100, 150, 26) text("Global") fontColour(255, 255, 255, 255)
hslider bounds(24, 136, 150, 50) range(0, 1, 1, 1, 0.01) channel("GlobalVolume")  text("Volume") trackerColour(188, 151, 49, 255) textColour(255, 255, 255, 255)
hslider bounds(24, 186, 150, 50) range(0, 10000, 10000, 0.5, 1) channel("GlobalCutoff")  text("Cutoff") trackerColour(188, 151, 49, 255) textColour(255, 255, 255, 255)
hslider bounds(24, 236, 150, 50) range(0.1, 10, 2, 1, 0.2) channel("GlobalAttack")  text("Attack") trackerColour(188, 151, 49, 255) textColour(255, 255, 255, 255)
hslider bounds(24, 286, 150, 50) range(0.1, 10, 1, 1, 0.2) channel("GlobalDecay")  text("Decay") trackerColour(188, 151, 49, 255) textColour(255, 255, 255, 255)
hslider bounds(24, 336, 150, 50) range(0, 1, 1, 1, 0.01) channel("GlobalSustain")  text("Sustain") trackerColour(188, 151, 49, 255) textColour(255, 255, 255, 255)
hslider bounds(24, 386, 150, 50) range(0.1, 10, 2, 1, 0.2) channel("GlobalRelease")  text("Release") trackerColour(188, 151, 49, 255) textColour(255, 255, 255, 255)
//REVERB
label bounds(804, 298, 151, 28) text("Reverb") fontColour(255, 255, 255, 255)
hslider bounds(804, 336, 149, 50) range(0, 1, 0.2, 1, 0.01) channel("ReverbMix")  text("Mix") trackerColour(188, 151, 49, 255) fontColour(188, 151, 49, 255) textColour(255, 255, 255, 255)
hslider bounds(804, 386, 149, 52) range(0, 1, 0.7, 1, 0.01) channel("ReverbSize")  text("Size") trackerColour(188, 151, 49, 255) textColour(255, 255, 255, 255) fontColour(188, 151, 49, 255) colour(255, 255, 255, 255)
//Wooing
label bounds(218, 100, 151, 28) text("Wooing") fontColour(255, 255, 255, 255)
hslider bounds(218, 138, 150, 50) range(0, 1, 1, 1, 0.01) channel("WooingVolume")  text("Volume") trackerColour(188, 151, 49, 255) textColour(255, 255, 255, 255)
hslider bounds(218, 186, 150, 50) range(200, 1500, 700, 1, 1) text("Frequency") channel("WooingFrequency") trackerColour(188, 151, 49, 255) textColour(255, 255, 255, 255)
hslider bounds(218, 236, 150, 50) range(1, 5, 1, 1, 0.05) text("Range") channel("WooingRange") trackerColour(188, 151, 49, 251) textColour(255, 255, 255, 255)
hslider bounds(218, 286, 150, 50) range(0.5, 3, 1, 1, 0.05) text("Rate") channel("WooingRate") trackerColour(188, 151, 49, 255) textColour(255, 255, 255, 255)
hslider bounds(218, 336, 150, 50) range(1, 100, 25, 1, 1) text("Bandwidth") channel("WooingBandwidth") trackerColour(188, 151, 49, 255) textColour(255, 255, 255, 255)
hslider bounds(218, 386, 150, 50) range(0, 1, 0, 0.5, 0.01) channel("WooingResonance") text("Resonance") trackerColour(188, 151, 49, 255) textColour(255, 255, 255, 255)
hslider bounds(218, 436, 150, 50) range(1, 3, 0, 1, 0.01) channel("WooingHarmonizerFreq") text("Harmony Freq") trackerColour(188, 151, 49, 255) textColour(255, 255, 255, 255)
hslider bounds(218, 486, 150, 50) range(0, 1, 0, 1, 0.01) channel("WooingHarmonizerVol") text("Harmony Vol") trackerColour(188, 151, 49, 255) textColour(255, 255, 255, 255)

//Rumble
label bounds(804, 100, 151, 28) text("Rumble") fontColour(255, 255, 255, 255)
hslider bounds(804, 136, 150, 50) range(0, 1, 0, 1, 0.01) channel("RumbleVolume")  text("Volume") trackerColour(188, 151, 49, 255) textColour(255, 255, 255, 255)
hslider bounds(804, 188, 150, 50) range(60, 200, 200, 1, 1) channel("RumbleCutoff")  text("Cutoff") trackerColour(188, 151, 49, 251) textColour(255, 255, 255, 255)
hslider bounds(804, 238, 150, 50) range(0, 1, 0, 1, 0.01) channel("RumbleDistortion")  text("Distortion")trackerColour(188, 151, 49, 255) textColour(255, 255, 255, 255)
//Background
label bounds(414, 100, 162, 28) text("Background") fontColour(255, 255, 255, 255)
hslider bounds(414, 136, 150, 50) range(0, 1, 1, 1, 0.01) channel("BackgroundVolume") text("Volume") trackerColour(188, 151, 49, 255) textColour(255, 255, 255, 255)
hslider bounds(414, 186, 150, 50) range(250, 800, 400, 1, 1) channel("BackgroundFrequency") text("Frequency") trackerColour(188, 151, 49, 255) textColour(255, 255, 255, 255)
hslider bounds(414, 236, 150, 50) range(1, 3, 0.05, 1, 0.05) channel("BackgroundRange") text("Range") trackerColour(188, 151, 49, 255) textColour(255, 255, 255, 255)
hslider bounds(414, 286, 150, 50) range(0.5, 3, 1, 1, 0.05) channel("BackgroundRate") text("Rate") trackerColour(188, 151, 49, 255) textColour(255, 255, 255, 255)
hslider bounds(414, 336, 150, 50) range(100, 250, 100, 1, 1) channel("BackgroundBandwidth") text("Bandwidth") trackerColour(188, 151, 49, 255) textColour(255, 255, 255, 255)
hslider bounds(414, 386, 150, 50) range(0, 1, 0, 1, 0.01) channel("BackgroundResonance") text("Resonance") trackerColour(188, 151, 49, 255) textColour(255, 255, 255, 255)
hslider bounds(414, 436, 150, 50) range(1, 3, 0, 1, 0.01) channel("BackgroundHarmonizerFreq") text("Harmony Freq") trackerColour(188, 151, 49, 255) textColour(255, 255, 255, 255)
hslider bounds(414, 486, 150, 50) range(0, 1, 0, 1, 0.01) channel("BackgroundHarmonizerVol") text("Harmony Vol") trackerColour(188, 151, 49, 255) textColour(255, 255, 255, 255)

//Gusts
label bounds(608, 100, 162, 28) text("Gusts") fontColour(255, 255, 255, 255)
hslider bounds(608, 136, 150, 50) range(0, 1, 1, 1, 0.01) channel("GustsVolume") text("Volume") trackerColour(188, 151, 49, 255) textColour(255, 255, 255, 255)
hslider bounds(608, 186, 150, 50) range(300, 700, 400, 1, 1) channel("GustsFrequency") text("Frequency") trackerColour(188, 151, 49, 255) textColour(255, 255, 255, 255)
hslider bounds(608, 236, 150, 50) range(1, 4, 1.5, 1, 0.05) channel("GustsRange") text("Range") trackerColour(188, 151, 49, 255) textColour(255, 255, 255, 255)
hslider bounds(608, 286, 150, 50) range(0.5, 3, 1, 1, 0.05) channel("GustsRate") text("Rate") trackerColour(188, 151, 49, 255) textColour(255, 255, 255, 255)
hslider bounds(608, 336, 150, 50) range(150, 350, 100, 1, 1) channel("GustsBandwidth") text("Bandwidth") trackerColour(188, 151, 49, 255) textColour(255, 255, 255, 255)
hslider bounds(608, 386, 150, 50) channel("GustsResonance") range(0, 1, 0, 1, 0.01) text("Resonance") textColour(255, 255, 255, 255) trackerColour(188, 151, 49, 255)

// Console
csoundoutput bounds(1, 551, 998, 248) colour("black") corners(0) fontColour("grey") outlineColour(0, 63, 127) outlineThickness(1) presetIgnore(1)

</Cabbage>
<CsoundSynthesizer>
<CsOptions>
-n -+rtmidi=NULL -M0 -dm0
</CsOptions>
<CsInstruments>

ksmps = 32
nchnls = 2
0dbfs	= 1

seed 0
massign 0, "Master"


instr Wooing
    //CHNGET CHANNELS
    kWooingVolume chnget"WooingVolume_withOffset"
    kCenterFrequency chnget "WooingFrequency_withOffset"
    kWooingRangeMultiplier chnget "WooingRange"
    kRateIntensity chnget "WooingRate"
    kBandwidth chnget "WooingBandwidth"
    kResonance chnget "WooingResonance"
    kHarmonizerMultiplier chnget "WooingHarmonizerFreq"
    kHarmonizerVol chnget "WooingHarmonizerVol"

    ; printsk("wooing frequency = %f\n", kCenterFrequency)

    //PORTK
    kWooingVolume portk kWooingVolume, 0.02
    kCenterFrequency portk kCenterFrequency, 0.02
    kHarmonizerMultiplier portk kHarmonizerMultiplier, 0.02
    kBandwidth portk kBandwidth, 0.02
    kHarmonizerVol portk kHarmonizerVol, 0.02

    //RANDOMIZATION
    kWooing jspline 75 * kWooingRangeMultiplier, .4 * kRateIntensity , 1.5 * kRateIntensity
    kVolume = (kWooing/13)
    kVolume = ampdb(kVolume)
    kVolume limit kVolume, 1, 3

    //BODY
    aNoise pinker
    aNoiseBp butterbp aNoise, kCenterFrequency + kWooing, kBandwidth
    aNoiseLp moogladder aNoiseBp, kCenterFrequency + kWooing + kBandwidth, kResonance

    aNoiseBpHarm butterbp aNoise * kHarmonizerVol, (kCenterFrequency + kWooing) * kHarmonizerMultiplier, kBandwidth
    aNoiseLpHarm moogladder aNoiseBpHarm, (kCenterFrequency + kWooing + kBandwidth) * kHarmonizerMultiplier, kResonance
    aNoiseBalanced balance aNoiseLp + aNoiseLpHarm, aNoiseBp

    aWooing = (aNoiseBalanced * kVolume) * kWooingVolume
    chnset aWooing, "GlobalMix"
endin


instr Background
    //CHNGET CHANNELS
    kBackgroundVolume chnget "BackgroundVolume_withOffset"
    kBandwidth chnget "BackgroundBandwidth"
    kCenterFrequency chnget "BackgroundFrequency_withOffset"
    kJitterRangeMultiplier chnget "BackgroundRange"
    kRateMultiplier chnget "BackgroundRate"
    kResonance chnget "BackgroundResonance"
    kHarmonizerFreq chnget "BackgroundHarmonizerFreq"
    kHarmonizerVol chnget "BackgroundHarmonizerVol"

    //PORTK
    kBackgroundVolume portk kBackgroundVolume, 0.02
    kBandwidth portk kBandwidth, 0.02
    kCenterFrequency portk kCenterFrequency, 0.02
    kResonance portk kResonance, 0.02
    kHarmonizerFreq portk kHarmonizerFreq, 0.02
    kHarmonizerVol portk kHarmonizerVol, 0.02

    //RANDOMIZATION
    kJitter jspline 100 * kJitterRangeMultiplier, .2 * kRateMultiplier, 2 * kRateMultiplier
    kVolume = (kJitter/13.1)
    kVolume = ampdb(kVolume)
    kVolume limit kVolume, 0.8, 1.4

    //BODY
    aNoise noise 1, 0
    aNoiseBp butterbp aNoise, kCenterFrequency + kJitter, kBandwidth
    aNoiseLp moogladder aNoiseBp, kCenterFrequency + kBandwidth + kJitter, kResonance

    aNoiseBpHarm butterbp aNoise * kHarmonizerVol, (kCenterFrequency + kJitter) * kHarmonizerFreq, kBandwidth
    aNoiseLpHarm moogladder aNoiseBpHarm, (kCenterFrequency + kBandwidth + kJitter) * kHarmonizerFreq, kResonance
    aNoiseBalanced balance aNoiseLp + aNoiseLpHarm, aNoiseBp

    aBackground = (aNoiseBalanced * kVolume) * kBackgroundVolume
    chnmix aBackground, "GlobalMix"
endin


instr Gusts
    //CHNGET CHANNELS
    kGustsVolume chnget "GustsVolume"
    kFrequency chnget "GustsFrequency"
    kRange chnget "GustsRange"
    kRate chnget "GustsRate"
    kBandwidth chnget "GustsBandwidth"
    kResonance chnget "GustsResonance"

    //PORTK SMOOTHING
    kGustsVolume portk kGustsVolume, 0.02
    kFrequency portk kFrequency, 0.02
    kBandwidth portk kBandwidth, 0.02

    //RANDOMIZATION
    kJitter1 jspline 100 * kRange, 1 * kRate, 3 * kRate
    kVolume = (kJitter1/30)
    kVolume = ampdb(kVolume)
    kVolume limit kVolume, 0.8, 1.3

    kJitter2 jspline .3, .4 * kRate, 1 * kRate
    kLfo lfo .3, kJitter2 + .4, 4 //kcps is a random value between .1 to .4

    //BODY
    aNoise pinkish 1, 0, 4
    aNoiseBp butterbp aNoise, (kFrequency + kJitter1) * kLfo, kBandwidth
    aNoiseLp moogladder aNoiseBp, kFrequency + kBandwidth + kJitter1, kResonance
    aNoiseBalance balance aNoiseLp, aNoiseBp

    aGusts = (aNoiseBalance * kVolume) * kGustsVolume
    chnmix aGusts, "GlobalMix"
endin


instr Rumble
    //CHNGET CHANNELS
    kRumbleVolume chnget "RumbleVolume_withOffset"
    kRumbleDistortion chnget "RumbleDistortion"
    kRumbleCutoff chnget "RumbleCutoff_withOffset"

    //PORTK SMOOTHING
    kRumbleVolume portk kRumbleVolume, 0.02
    kRumbleDistortion portk kRumbleDistortion, 0.02
    kRumbleCutoff portk kRumbleCutoff, 0.02

    //BODY
    aNoise pinker
    aLp lpf18 aNoise, kRumbleCutoff, 0, kRumbleDistortion

    aRumble = aLp * kRumbleVolume
    chnmix aRumble, "GlobalMix"
endin


instr Mixer
    //CHNGET CHANNELS
    kGlobalVolume chnget "GlobalVolume"
    kGlobalCutoff chnget "GlobalCutoff"
    aGlobalMix chnget "GlobalMix"

    //PORTK SMOOTHING
    kGlobalVolume portk kGlobalVolume, 0.02
    kGlobalCutoff portk kGlobalCutoff, 0.1

    //BODY
    aGlobalLp butterlp aGlobalMix, kGlobalCutoff

    aMixerSum = aGlobalLp * kGlobalVolume
    aMixerLimiter compress aMixerSum, aMixerSum, -1, 87, 87, 100, 0.01, 0.01, .5

    chnset aMixerLimiter, "MixerOut"
endin


instr Reverb
    //CHNGET CHANNELS
    kReverbMix chnget "ReverbMix"
    kReverbSize chnget "ReverbSize"
    aMixerOut chnget "MixerOut"

    //PORTK SMOOTHING
    kReverbMix portk kReverbMix, 0.02
    kReverbSize portk kReverbSize, 0.02

    //BODY
    aDryHp butterhp aMixerOut, 150
    aVerbL, aVerbR reverbsc aDryHp, aDryHp, kReverbSize, 4000, 44100, 5

    aOutL ntrpol aDryHp, aVerbL, kReverbMix
    aOutR ntrpol aDryHp, aVerbR, kReverbMix

    chnset aOutL, "OutL"
    chnset aOutR, "OutR"
endin


instr Master
    //CHNGET CHANNELS
    iAttackTime chnget "GlobalAttack"
    iDecayTime chnget "GlobalDecay"
    iSustainLevel chnget "GlobalSustain"
    iReleaseTime chnget "GlobalRelease"

    aOutL chnget "OutL"
    aOutR chnget "OutR"

    event_i "i", 1, 0, -1
    event_i "i", 2, 0, -1
    event_i "i", 3, 0, -1
    event_i "i", 4, 0, -1
    event_i "i", 5, 0, -1
    event_i "i", 6, 0, -1

    //BODY
    aEnv madsr iAttackTime, iDecayTime, iSustainLevel, iReleaseTime
    outs aOutL * aEnv, aOutR * aEnv

    //CHANNEL CLEARING
    chnclear "aGlobalMix"
    chnclear "MixerOut"
    chnclear "OutL"
    chnclear "OutR"

    //TURNOFF
    kMidiRls release
    schedwhen kMidiRls, "TurnOff", iReleaseTime, 0.1
endin

scoreline_i("i\"Master\" 1 -1")


instr TurnOff
    turnoff2 1, 0, 0
    turnoff2 2, 0, 0
    turnoff2 3, 0, 0
    turnoff2 4, 0, 0
    turnoff2 5, 0, 0
    turnoff2 6, 0, 0
    turnoff2 7, 0, 0
    turnoff2 8, 0, 0
endin

instr Vendaval_alwayson

    // XR hands and head tracking ...

    a_bodyTrackingData = inch(1)
    k_bodyTrackingId init -1
    k_bodyTrackingData[] init 42
    ki = 0
    while (ki < ksmps) do
        k_bodyTrackingValue = vaget(ki, a_bodyTrackingData)
        if (k_bodyTrackingValue > 0.999999) then
            k_bodyTrackingId = 0
        elseif (k_bodyTrackingValue < -0.999999) then
            k_bodyTrackingId = -1
        elseif (k_bodyTrackingId >= 0 && k_bodyTrackingId < 42) then
            k_bodyTrackingData[k_bodyTrackingId] = k_bodyTrackingValue
            k_bodyTrackingId += 1
        endif
        ki += 1
    od

    k_leftWristX = k_bodyTrackingData[0]
    k_leftWristY = k_bodyTrackingData[1]
    k_leftWristZ = k_bodyTrackingData[2]

    k_leftFingerTip1X = k_bodyTrackingData[3]
    k_leftFingerTip1Y = k_bodyTrackingData[4]

    k_leftFingerTip3X = k_bodyTrackingData[9]
    k_leftFingerTip3Y = k_bodyTrackingData[10]
    k_leftFingerTip3Z = k_bodyTrackingData[11]

    k_leftFingerTip5X = k_bodyTrackingData[15]
    k_leftFingerTip5Y = k_bodyTrackingData[16]

    k_rightWristX = k_bodyTrackingData[18]
    k_rightWristY = k_bodyTrackingData[19]
    k_rightWristZ = k_bodyTrackingData[20]

    k_rightFingerTip1X = k_bodyTrackingData[21]
    k_rightFingerTip1Y = k_bodyTrackingData[22]

    k_rightFingerTip2X = k_bodyTrackingData[24]

    k_rightFingerTip3X = k_bodyTrackingData[27]
    k_rightFingerTip3Y = k_bodyTrackingData[28]
    k_rightFingerTip3Z = k_bodyTrackingData[29]

    k_rightFingerTip4X = k_bodyTrackingData[30]

    k_rightFingerTip5X = k_bodyTrackingData[33]
    k_rightFingerTip5Y = k_bodyTrackingData[34]

    k_headPositionX = k_bodyTrackingData[36]
    k_headPositionY = k_bodyTrackingData[37]
    k_headPositionZ = k_bodyTrackingData[38]

    i_volumeLag_up = 1
    i_volumeLag_down = 30

    // Wooing volume
    i_wooingVolume_scale = 2
    k_wooingVolume_offset = expcurve(lagud(max(0, k_rightFingerTip3Y * i_wooingVolume_scale), i_volumeLag_up, i_volumeLag_down), 3)
    k_wooingVolume = chnget:k("WooingVolume")
    chnset(k_wooingVolume + k_wooingVolume_offset, "WooingVolume_withOffset")
    ; printsk("wooing volume offset = %f\n", k_wooingVolume_offset)

    // Wooing frequency
    i_wooingFrequency_scale = 400
    k_wooingFrequency_offset = k_rightFingerTip3X * i_wooingFrequency_scale
    k_wooingFrequency = chnget:k("WooingFrequency")
    chnset(k_wooingFrequency + k_wooingFrequency_offset, "WooingFrequency_withOffset")

    // Rumble volume
    i_rumbleVolume_scale = 2
    k_rumbleVolume_offset = expcurve(lagud(max(0, k_leftFingerTip3Y * i_rumbleVolume_scale), i_volumeLag_up, i_volumeLag_down), 3)
    k_rumbleVolume = chnget:k("RumbleVolume")
    chnset(k_rumbleVolume + k_rumbleVolume_offset, "RumbleVolume_withOffset")

    // Background volume
    i_backgroundVolume_scale = 2
    k_backgroundVolume_offset = expcurve(lagud(max(0, k_leftFingerTip3Y * i_backgroundVolume_scale), i_volumeLag_up, i_volumeLag_down), 3)
    k_backgroundVolume = chnget:k("BackgroundVolume")
    chnset(k_backgroundVolume + k_backgroundVolume_offset, "BackgroundVolume_withOffset")

    // Background frequency
    i_backgroundFrequency_scale = 500
    k_backgroundFrequency_offset = k_leftFingerTip3X * i_backgroundFrequency_scale
    k_backgroundFrequency = chnget:k("BackgroundFrequency")
    chnset(k_backgroundFrequency + k_backgroundFrequency_offset, "BackgroundFrequency_withOffset")

    // Rumble cutoff frequency
    i_rumbleCutoff_scale = 150
    k_rumbleCutoff_offset = k_leftFingerTip3X * i_rumbleCutoff_scale
    k_rumbleCutoff = chnget:k("RumbleCutoff")
    chnset(k_rumbleCutoff + k_rumbleCutoff_offset, "RumbleCutoff_withOffset")
    ; printsk("rumble cutoff offset = %f\n", k_rumbleCutoff_offset)

endin

// Start at 1 second to give the host time to set it's values.
scoreline_i("i\"Vendaval_alwayson\" 1 -1")


</CsInstruments>
<CsScore>
f0 36000
;i "Master" 0 -1
</CsScore>
</CsoundSynthesizer>
<bsbPanel>
 <label>Widgets</label>
 <objectName/>
 <x>100</x>
 <y>100</y>
 <width>320</width>
 <height>240</height>
 <visible>true</visible>
 <uuid/>
 <bgcolor mode="nobackground">
  <r>255</r>
  <g>255</g>
  <b>255</b>
 </bgcolor>
</bsbPanel>
<bsbPresets>
</bsbPresets>
