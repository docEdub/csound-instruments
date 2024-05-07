/*
 *  lfo-a.orc
 *
 *  Low frequency oscillator generator module.
 */

{{DeclareModule 'FnX_A'}}

{{#with FnX_A}}

{{Enable-LogDebug true}}

opcode {{Module_public}}, k, Sk
    S_channelPrefix, k_x xin
    i_instanceIndex = {{hostValueGet}}:i(S_channelPrefix)


    if ({{moduleGet:k 'Enabled'}} == $false) then
        k_y = k_x
        kgoto end
    endif

    S_algorithm_previous init ""
    S_algorithm = {{moduleGet:S 'Algorithm'}}

    if (strcmpk(S_algorithm, S_algorithm_previous) != 0) then
        {{LogDebug_k '("Algorithm = \"%s\"", S_algorithm)'}}
        S_algorithm_previous = sprintfk("%s", S_algorithm)
    endif

    k_y = k_x

end:
    xout(k_y)
endop


{{/with}}
