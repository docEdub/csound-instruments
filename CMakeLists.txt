cmake_minimum_required(VERSION 3.26)

project("csound-instruments")

include(FetchContent)
FetchContent_Declare(
    CsoundTemplating
    GIT_REPOSITORY git@github.com:docEdub/CsoundTemplating.git
    GIT_TAG 35255f786c6a0fa10413286fbe0cc8f4877d8fbb
)
FetchContent_MakeAvailable(CsoundTemplating)

macro(add_instrument NAME)
    add_csound_templates(
        PACKAGES
            cabbage-core
            cabbage-tab-group
            csound-core
            csound-module
        OPCODES
            "modules/shared/filter.orc"
            "modules/delay-mono-a.orc"
            "modules/envelope-a.orc"
            "modules/filter-a.orc"
            "modules/lfo-a.orc"
            "modules/reverb-a.orc"
            "modules/source-a.orc"
            "modules/volume-a.orc"
        JSON
            "modules/delay-mono-a.json"
            "modules/envelope-a.json"
            "modules/filter-a.json"
            "modules/lfo-a.json"
            "modules/reverb-a.json"
            "modules/source-a.json"
            "modules/volume-a.json"
            "shared/common-ui-types.json"
            "shared/module-constants.json"
            "shared/module-ui-types.json"
            "styles/default.json"
            "instruments/${NAME}.json"
        SYNTH_SOURCES
            "instruments/${NAME}.csd"
    )
endmacro()

add_instrument("synth-a1")
add_instrument("synth-a2")

generate_csound_templates()
