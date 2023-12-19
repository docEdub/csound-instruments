cmake_minimum_required(VERSION 3.26)

project("csound-instruments")

include(FetchContent)
FetchContent_Declare(
    CsoundTemplating
    GIT_REPOSITORY https://github.com/docEdub/CsoundTemplating.git
    GIT_TAG 35c0072529c5fbf5e8f46776f1f983d42f01c510
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
    JSON
        "modules/envelope-a.json"
        "modules/filter-a.json"
        "modules/lfo-a.json"
        "modules/source-a.json"
        "instruments/synth-a.json"
        "shared/module-constants.json"
        "shared/module-ui-types.json"
        "styles/default.json"
)

generate_csound_templates()
