cmake_minimum_required(VERSION 3.26)

project("csound-instruments")

include(FetchContent)
FetchContent_Declare(
    CsoundTemplating
    GIT_REPOSITORY https://github.com/docEdub/CsoundTemplating.git
    GIT_TAG b976b448a0dfcf663bd7b0bac18a8ff616648bca
)
FetchContent_MakeAvailable(CsoundTemplating)

set(synth_sources
    "csd/subtractive-synth-01"
)

foreach(synth_source ${synth_sources})
    add_csound_templates(
        PACKAGES
            cabbage-core
            cabbage-tab-group
            csound-core
        SYNTH_SOURCES
            "${synth_source}.csd"
        JSON
            "${synth_source}.ui.json"
            "styles/default.json"
    )
endforeach()

generate_csound_templates()
