cmake_minimum_required(VERSION 3.26)

project("csound-instruments")

include(FetchContent)
FetchContent_Declare(
    CsoundTemplating
    GIT_REPOSITORY https://github.com/docEdub/CsoundTemplating.git
    GIT_TAG 5feba8b2b462de639c36a0147b59898099465088
)
FetchContent_MakeAvailable(CsoundTemplating)
find_package(CsoundTemplating REQUIRED PATHS "${csoundtemplating_SOURCE_DIR}")

message("-- Running CsoundTemplating npm install ...\n")
execute_process(COMMAND npm --prefix "${csoundtemplating_SOURCE_DIR}" install)
message("\n-- Running CsoundTemplating npm install - done")

add_csound_templates(
    PACKAGES
        csound-core
    SOURCES
    JSON
        "styles/default.json"
)

generate_csound_templates()
