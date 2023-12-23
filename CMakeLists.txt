cmake_minimum_required(VERSION 3.26)

project("csound-instruments")

include(FetchContent)
FetchContent_Declare(
    CsoundTemplating
    GIT_REPOSITORY git@github.com:docEdub/CsoundTemplating.git
    GIT_TAG 75d22f0c3963b573c4d6f71d1b8a717889c37b35
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
            "modules/envelope-a.orc"
            "modules/filter-a.orc"
            "modules/lfo-a.orc"
            "modules/source-a.orc"
        JSON
            "modules/envelope-a.json"
            "modules/filter-a.json"
            "modules/lfo-a.json"
            "modules/source-a.json"
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
