/*
 *  delay-mono-a.orc
 *
 *  Single channel delay with feedback implemented using the `vdelay3` opcode.
 */

{{DeclareModule 'DelayMono_A'}}

/// Single channel delay with feedback implemented using the `vdelay3` opcode.
/// @param 1 Channel prefix used for host automation parameters.
/// @param 2 A-rate input signal.
/// @out A-rate output signal.
///
opcode {{Module_public}}, a, Sa
    S_channelPrefix, a_in xin
    i_instanceIndex = {{hostValueGet}}:i(S_channelPrefix)

    i_maxDelayTimeMs = 5000

    if ({{moduleGet:k 'Enabled'}} == $false) then
        a_out = a_in
        kgoto end
    endif

    k_delayTime = {{moduleGet:k 'Time'}}
    k_feedback  = {{moduleGet:k 'Feedback'}}
    k_mix       = {{moduleGet:k 'Mix'}}

    a_delaySignal init 0
    a_delaySignal = vdelay3(a_in, a(k_delayTime * 1000), i_maxDelayTimeMs)

    a_feedbackSignal init 0
    a_feedbackSignal = vdelay3((a_delaySignal + a_feedbackSignal) * k_feedback, a(k_delayTime * 1000), i_maxDelayTimeMs)

    a_out = a_in * (1 - k_mix) + (a_delaySignal + a_feedbackSignal) * k_mix

end:
    xout(a_out)
endop
