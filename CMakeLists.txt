cmake_minimum_required(VERSION 3.26)

project("csound-instruments")

include(FetchContent)
FetchContent_Declare(
    CsoundTemplating
    GIT_REPOSITORY git@github.com:docEdub/CsoundTemplating.git
    GIT_TAG d25e5091f3c4bfa7d74050b17e9ee346e0dd22d6
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
            "modules/polyphony-control-a.orc"
            "modules/polyphony-control-b.orc"
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
            "modules/polyphony-control-a.json"
            "modules/polyphony-control-b.json"
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

macro(add_module_test NAME)
    add_csound_templates(
        PACKAGES
            cabbage-core
            csound-core
            csound-module
            csound-test
        OPCODES
            "modules/${NAME}.orc"
        JSON
            "modules/${NAME}.json"
            "test-config.json"
        EFFECT_SOURCES
            "tests/modules/${NAME}--test.csd"
        NO_CABBAGE_PLUGIN
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

add_module_test("polyphony-control-b")

generate_csound_templates()
