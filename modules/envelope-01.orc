/*
 *  envelope-01.orc
 *
 *  Envelope generator module with exponential attack, decay, and release segments using the `mxadsr` opcode.
 */

gS_envelope_01_module_channels[][] init 1, {{eval '(Object.keys(constants.envelope_01.channel).length)'}}
gi_envelope_01_module_instance_count init 0

/// @internal
opcode _envelope_01_module_get, i, ii
    iInstanceIndex, iChannelIndex xin
    xout({{getHostValue}}:i(gS_envelope_01_module_channels[iInstanceIndex][iChannelIndex - 1]))
endop

/// @internal
opcode _envelope_01_module_get, k, ii
    iInstanceIndex, iChannelIndex xin
    xout({{getHostValue}}:k(gS_envelope_01_module_channels[iInstanceIndex][iChannelIndex - 1]))
endop

/// @internal
opcode _envelope_01_module_set, 0, iik
    iInstanceIndex, iChannelIndex, kValue xin
    {{setHostValue}}(gS_envelope_01_module_channels[iInstanceIndex][iChannelIndex - 1], kValue)
endop

/// Generates an exponential ADSR envelope using the `mxadsr` opcode.
/// @param 1 Channel prefix used for host automation parameters.
/// @out A-rate envelope.
///
opcode AF_envelope_01_module, a, S
    SChannelPrefix xin

    ii = {{getHostValue}}:i(SChannelPrefix)

    if (_envelope_01_module_get:k(ii, {{envelope_01.channel.Enabled}}) == {{false}}) then
        aOut = 1
        kgoto end
    endif

    iA = _envelope_01_module_get:i(ii, {{envelope_01.channel.Attack}})
    iD = _envelope_01_module_get:i(ii, {{envelope_01.channel.Decay}})
    iS = _envelope_01_module_get:i(ii, {{envelope_01.channel.Sustain}})
    iR = _envelope_01_module_get:i(ii, {{envelope_01.channel.Release}})

    aOut = mxadsr:a(iA, iD, iS, iR) - 0.001;

end:
    xout(aOut)
endop

/// Initialization instrument for the `envelope_01` module.
/// @param 4 Channel prefix used for host automation parameters. Should match the channel prefix used for the `AF_envelope_01_module` opcode.
///
instr AF_envelope_01_module
    SChannelPrefix = p4

    iModuleInstanceIndex = gi_envelope_01_module_instance_count
    gi_envelope_01_module_instance_count += 1

    // Initialize the channel array using the channel object keys declared in envelope-01.ui.json.
    SChannelSuffixes[] = fillarray({{eval '(asStrings(Object.keys(constants.envelope_01.channel)))'}})

    // Grow the global channels array if needed.
    if (lenarray:i(gS_envelope_01_module_channels) < gi_envelope_01_module_instance_count) then
        S_envelope_01_module_channels[][] init gi_envelope_01_module_instance_count, lenarray(SChannelSuffixes)
        ii = 0
        until (ii == iModuleInstanceIndex) do
            ij = 0
            until (ij == lenarray(SChannelSuffixes)) do
                S_envelope_01_module_channels[ii][ij] = gS_envelope_01_module_channels[ii][ij]
                ij += 1
            od
            ii += 1
        od

        SChannel = strcat(SChannelPrefix, "_")
        ii = 0
        until (ii == lenarray(SChannelSuffixes)) do
            S_envelope_01_module_channels[iModuleInstanceIndex][ii] = strcat(SChannel, SChannelSuffixes[ii])
            ii += 1
        od

        gS_envelope_01_module_channels = S_envelope_01_module_channels
    else
        SChannel = strcat(SChannelPrefix, "_")
        ii = 0
        until (ii == lenarray(SChannelSuffixes)) do
            gS_envelope_01_module_channels[iModuleInstanceIndex][ii] = strcat(SChannel, SChannelSuffixes[ii])
            ii += 1
        od
    endif

    // Set the instance index channel value for the module's UDO.
    {{setHostValue}}(SChannelPrefix, iModuleInstanceIndex)
end:
endin
