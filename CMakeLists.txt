cmake_minimum_required(VERSION 3.26)

project("csound-instruments")

include(FetchContent)
FetchContent_Declare(
    CsoundTemplating
    GIT_REPOSITORY https://github.com/docEdub/CsoundTemplating.git
    GIT_TAG 121c2ba88596d2f087fed52c4def044d97b62912
)
FetchContent_MakeAvailable(CsoundTemplating)

add_csound_templates(
    PACKAGES
        cabbage-core
        cabbage-tab-group
        csound-core
    SOURCES
        "csd/subtractive-synth-01.csd"
    JSON
        "csd/subtractive-synth-01.ui.json"
        "styles/default.json"
)

generate_csound_templates()
