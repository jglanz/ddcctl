cmake_minimum_required(VERSION 3.16)
project(ddcctl C CXX OBJC)

set(CXX_STANDARD_REQUIRED ON)
set(CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD ${CXX_STANDARD})
set(CMAKE_C_STANDARD 11)
set(CMAKE_OSX_DEPLOYMENT_TARGET "10.15" CACHE STRING "Minimum OS X deployment version")
set(CMAKE_FIND_FRAMEWORK FIRST)

add_definitions("-std=stdc++${CXX_STANDARD}")

if(NOT EXISTS ${CMAKE_BINARY_DIR}/conanbuildinfo.cmake)
  execute_process(
    COMMAND
    conan install ${CMAKE_CURRENT_LIST_DIR}
    WORKING_DIRECTORY
    ${CMAKE_BINARY_DIR}
  )
endif()

include(${CMAKE_BINARY_DIR}/conanbuildinfo.cmake)
conan_basic_setup()

find_library(CoreGraphics_LIB CoreGraphics)
find_library(Foundation_LIB Foundation)
find_library(IOKit_LIB IOKit)
find_library(AppKit_LIB AppKit)
message(STATUS "FW path: ${IOKit_LIB}")

include_directories(
  BEFORE
  ${CMAKE_CURRENT_LIST_DIR}
)

add_compile_definitions(
  kDDCMinReplyDelay=30000000
)

add_library(
  ddc SHARED
  src/DDC.cpp
  src/DDC.h
)

target_link_libraries(ddc "-framework CoreGraphics" "-framework IOKit" "-framework AppKit" "-framework Foundation")

get_target_property(ddc_LIB ddc OUTPUT_NAME)

add_executable(
  ${PROJECT_NAME}
  src/DDC.h
  src/ddcctl.cpp
  src/DDC.cpp
)

target_link_libraries(${PROJECT_NAME} ${CONAN_LIBS} "-framework IOKit" "-framework AppKit" "-framework Foundation")
#target_link_options(${PROJECT_NAME} PRIVATE "-lobjc")

