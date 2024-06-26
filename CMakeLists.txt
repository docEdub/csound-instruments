cmake_minimum_required(VERSION 3.26)

project("csound-instruments")

include(FetchContent)
FetchContent_Declare(
    CsoundTemplating
    GIT_REPOSITORY git@github.com:docEdub/CsoundTemplating.git
    GIT_TAG 0635a3ea4ca7268470468962168f746e1df753dc
)
FetchContent_MakeAvailable(CsoundTemplating)

macro(add_plugin NAME TYPE)
    add_csound_templates(
        PACKAGES
            cabbage-core
            cabbage-tab-group
            csound-core
            csound-module
        OPCODES
            "modules/shared/filter.orc"
            "modules/clamp-a.orc"
            "modules/delay-mono-a.orc"
            "modules/delay-stereo-a.orc"
            "modules/envelope-a.orc"
            "modules/filter-a.orc"
            "modules/filter-b.orc"
            "modules/lfo-a.orc"
            "modules/midi-key-range-a.orc"
            "modules/midi-key-transpose-a.orc"
            "modules/offset-a.orc"
            "modules/polyphony-control-b.orc"
            "modules/reverb-a.orc"
            "modules/snap-trigger-a.orc"
            "modules/source-a.orc"
            "modules/source-b.orc"
            "modules/volume-a.orc"
            "shared/csound/macros/common-body-tracking-macros.orc"
            "shared/csound/macros/common-math-defines.orc"
        JSON
            "modules/clamp-a.json"
            "modules/delay-mono-a.json"
            "modules/delay-stereo-a.json"
            "modules/envelope-a.json"
            "modules/filter-a.json"
            "modules/filter-b.json"
            "modules/lfo-a.json"
            "modules/midi-key-range-a.json"
            "modules/midi-key-transpose-a.json"
            "modules/offset-a.json"
            "modules/polyphony-control-b.json"
            "modules/reverb-a.json"
            "modules/snap-trigger-a.json"
            "modules/source-a.json"
            "modules/source-b.json"
            "modules/volume-a.json"
            "shared/json/common-ui-types.json"
            "shared/json/module-constants.json"
            "shared/json/module-ui-types.json"
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
        EFFECT_SOURCES
            "tests/modules/${NAME}--test.csd"
        NO_CABBAGE_PLUGIN
    )

    add_test(NAME "${NAME}" COMMAND csound "${CMAKE_CURRENT_BINARY_DIR}/.output/tests/modules/${NAME}--test.csd")
endmacro()

macro(add_combo NAME)
    add_plugin("combos/${NAME}" "EFFECT")
endmacro()

macro(add_effect NAME)
    add_plugin("effects/${NAME}" "EFFECT")
endmacro()

macro(add_instrument NAME)
    add_plugin("instruments/${NAME}" "SYNTH")
endmacro()

#######################################################################################################################

# add_csound_templates(
#     PACKAGES
#         cabbage-core
#     JSON
#         "3rdparty/Vendaval.json"
#     EFFECT_SOURCES
#         "3rdparty/Vendaval.csd"
# )

add_csound_templates(
    PACKAGES
        cabbage-core
        csound-core
    OPCODES
        "shared/csound/macros/common-body-tracking-macros.orc"
        "shared/csound/macros/common-math-defines.orc"
    JSON
        "combos/body-tracking-b1.json"
        "shared/json/common-ui-types.json"
        "styles/default.json"
    EFFECT_SOURCES
        "combos/body-tracking-b1.csd"
)

add_csound_templates(
    PACKAGES
        cabbage-core
        csound-core
        csound-module
    OPCODES
        "modules/snap-trigger-a.orc"
        "shared/csound/macros/common-body-tracking-macros.orc"
        "shared/csound/macros/common-math-defines.orc"
    JSON
        "combos/snap-drums-a1.json"
        "modules/snap-trigger-a.json"
        "shared/json/common-ui-types.json"
        "shared/json/module-constants.json"
        "shared/json/module-ui-types.json"
        "styles/default.json"
    EFFECT_SOURCES
        "combos/snap-drums-a1.csd"
)

# add_csound_templates(
#     PACKAGES
#         cabbage-core
#         cabbage-tab-group
#         csound-core
#         csound-module
#     EFFECT_SOURCES
#         "effects/reverb-a1.csd"
#     JSON
#         "effects/reverb-a1.json"

#         "modules/reverb-a.json"
#         "shared/json/common-ui-types.json"
#         "shared/json/module-constants.json"
#         "shared/json/module-ui-types.json"
#         "styles/default.json"
#     OPCODES
#         "modules/reverb-a.orc"
# )

# add_csound_templates(
#     PACKAGES
#         cabbage-core
#         cabbage-tab-group
#         csound-core
#         csound-module
#     EFFECT_SOURCES
#         "instruments/hand-grains-a4.csd"
#     JSON
#         "instruments/hand-grains-a4.json"

#         "modules/diskgrain-a.json"
#         "shared/json/common-ui-types.json"
#         "shared/json/module-constants.json"
#         "shared/json/module-ui-types.json"
#         "styles/default.json"
#     OPCODES
#         "modules/diskgrain-a.orc"
# )

# add_csound_templates(
#     PACKAGES
#         cabbage-core
#         csound-core
#     JSON
#         "shared/json/common-ui-types.json"
#         "styles/default.json"
#         "instruments/hand-sines-a3.json"
#     EFFECT_SOURCES
#         "instruments/hand-sines-a3.csd"
# )

# add_combo("combo-a1")
# add_combo("combo-a2")
# add_combo("combo-b1")

# add_instrument("synth-a1")
# add_instrument("synth-a2")

# enable_testing()
# add_module_test("polyphony-control-b")

#######################################################################################################################

generate_csound_templates()
