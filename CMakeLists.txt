cmake_minimum_required(VERSION 3.26)

project("csound-instruments")

include(FetchContent)
FetchContent_Declare(
    CsoundTemplating
    GIT_REPOSITORY git@github.com:docEdub/CsoundTemplating.git
    GIT_TAG f4d0fd20763dc502c890b119a531bd3483eb1547
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
            "modules/delay-mono-a.orc"
            "modules/envelope-a.orc"
            "modules/filter-a.orc"
            "modules/lfo-a.orc"
            "modules/source-a.orc"
        JSON
            "modules/delay-mono-a.json"
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
