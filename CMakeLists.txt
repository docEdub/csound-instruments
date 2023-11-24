cmake_minimum_required(VERSION 3.26)

project("csound-instruments")

include(FetchContent)
FetchContent_Declare(
    CsoundTemplating
    GIT_REPOSITORY https://github.com/docEdub/CsoundTemplating.git
    GIT_TAG e4f3320fae197a13b591d03723d608eed0cda997
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
