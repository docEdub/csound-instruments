cmake_minimum_required(VERSION 3.26)

project("csound-instruments")

include(FetchContent)
FetchContent_Declare(
    CsoundTemplating
    GIT_REPOSITORY https://github.com/docEdub/CsoundTemplating.git
    GIT_TAG 7a52382dd3bdddefc46dddb7fb669ddd9c142e0d
)
FetchContent_MakeAvailable(CsoundTemplating)

add_csound_templates(
    PACKAGES
        cabbage-core
        cabbage-tab-group
        csound-core
    OPCODES
        "modules/source-01.orc"
    SYNTH_SOURCES
        "instruments/subtract-synth-01.csd"
    JSON
        "modules/source-01.ui.json"
        "instruments/subtract-synth-01.ui.json"
        "shared/module-constants.json"
        "shared/module-ui-types.json"
        "styles/default.json"
)

generate_csound_templates()
