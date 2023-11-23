cmake_minimum_required(VERSION 3.26)

project("csound-instruments")

include(FetchContent)
FetchContent_Declare(
    CsoundTemplating
    GIT_REPOSITORY https://github.com/docEdub/CsoundTemplating.git
    GIT_TAG b986979cc8e0e61b3e3c2bb13dd42256f5c057b0
)
FetchContent_MakeAvailable(CsoundTemplating)
find_package(CsoundTemplating REQUIRED PATHS "${csoundtemplating_SOURCE_DIR}")

message("-- Running CsoundTemplating npm install ...\n")
execute_process(COMMAND npm --prefix "${csoundtemplating_SOURCE_DIR}" install)
message("\n-- Running CsoundTemplating npm install - done")

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
