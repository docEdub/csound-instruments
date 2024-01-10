cmake_minimum_required(VERSION 3.26)

project("csound-instruments")

include(FetchContent)
FetchContent_Declare(
    CsoundTemplating
    GIT_REPOSITORY git@github.com:docEdub/CsoundTemplating.git
    GIT_TAG 1be362a1ed1097bb5121cf56ff198151ea7eaaab
)
FetchContent_MakeAvailable(CsoundTemplating)

macro(add_plugin NAME TYPE)
    add_csound_templates(
        PACKAGES
            cabbage-core
            cabbage-extended-option-button
            cabbage-tab-group
            csound-core
            csound-module
        OPCODES
            "modules/shared/filter.orc"
            "modules/body-tracking-a.orc"
            "modules/delay-mono-a.orc"
            "modules/delay-stereo-a.orc"
            "modules/envelope-a.orc"
            "modules/filter-a.orc"
            "modules/filter-b.orc"
            "modules/lfo-a.orc"
            "modules/reverb-a.orc"
            "modules/source-a.orc"
            "modules/volume-a.orc"
        JSON
            "modules/body-tracking-a.json"
            "modules/delay-mono-a.json"
            "modules/delay-stereo-a.json"
            "modules/envelope-a.json"
            "modules/filter-a.json"
            "modules/filter-b.json"
            "modules/lfo-a.json"
            "modules/reverb-a.json"
            "modules/source-a.json"
            "modules/volume-a.json"
            "shared/common-ui-types.json"
            "shared/module-constants.json"
            "shared/module-ui-types.json"
            "styles/default.json"
            "${NAME}.json"
        ${TYPE}_SOURCES
            "${NAME}.csd"
    )
endmacro()

macro(add_combo NAME)
    add_plugin("combos/${NAME}" "EFFECT")
endmacro()

macro(add_instrument NAME)
    add_plugin("instruments/${NAME}" "SYNTH")
endmacro()


add_combo("combo-a1")
# add_combo("combo-a2")

# add_instrument("synth-a1")
# add_instrument("synth-a2")


generate_csound_templates()
