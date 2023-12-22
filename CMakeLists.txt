cmake_minimum_required(VERSION 3.26)

project("csound-instruments")

include(FetchContent)
FetchContent_Declare(
    CsoundTemplating
    GIT_REPOSITORY https://github.com/docEdub/CsoundTemplating.git
    GIT_TAG 110b40362debf7bfd546a1827d47ca330aa07f70
)
FetchContent_MakeAvailable(CsoundTemplating)

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
    SYNTH_SOURCES
        "instruments/synth-a.csd"
        "instruments/synth-a2.csd"
    JSON
        "modules/envelope-a.json"
        "modules/filter-a.json"
        "modules/lfo-a.json"
        "modules/source-a.json"
        "instruments/synth-a.json"
        "instruments/synth-a2.json"
        "shared/module-constants.json"
        "shared/module-ui-types.json"
        "styles/default.json"
)

generate_csound_templates()
