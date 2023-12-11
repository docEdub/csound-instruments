cmake_minimum_required(VERSION 3.26)

project("csound-instruments")

include(FetchContent)
FetchContent_Declare(
    CsoundTemplating
    GIT_REPOSITORY https://github.com/docEdub/CsoundTemplating.git
    GIT_TAG af4f9ab3bfc2d1ac8a936696eca9c4701fc196ea
)
FetchContent_MakeAvailable(CsoundTemplating)

add_csound_templates(
    PACKAGES
        cabbage-core
        cabbage-tab-group
        csound-core
    OPCODES
        "components/oscillator-01.orc"
    SYNTH_SOURCES
        "instruments/subtractive-synth-01.csd"
    JSON
        "components/oscillator-01.ui.json"
        "instruments/subtractive-synth-01.ui.json"
        "styles/default.json"
)

generate_csound_templates()
