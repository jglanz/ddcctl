cmake_minimum_required(VERSION 3.16)
project(ddcctl C CXX OBJC)

set(CMAKE_CXX_STANDARD 11)
set(CMAKE_C_STANDARD 11)

set(CMAKE_OSX_DEPLOYMENT_TARGET "10.15" CACHE STRING "Minimum OS X deployment version")
set(CMAKE_FIND_FRAMEWORK FIRST)



#include(CMakeFindFrameworks)
#find_package(IOKit REQUIRED)
#find_package(AppKit REQUIRED)
#find_package(Foundation REQUIRED)

find_library(CoreGraphics_LIB CoreGraphics)
find_library(Foundation_LIB Foundation)
find_library(IOKit_LIB IOKit)
find_library(AppKit_LIB AppKit)
message(STATUS "FW path: ${IOKit_LIB}")

include_directories(
        BEFORE
        ${CMAKE_CURRENT_LIST_DIR}
#        ${IOKit_FRAMEWORKS}/Headers
#        ${AppKit_FRAMEWORKS}/Headers
#        ${Foundation_FRAMEWORKS}/Headers
#        ${CoreGraphics_FRAMEWORKS}/Headers
)
#

add_compile_definitions(
  kDDCMinReplyDelay=30000000
)

add_library(ddc SHARED
        DDC.cpp
        DDC.h
        )

target_link_libraries(ddc "-framework IOKit" "-framework AppKit" "-framework Foundation")

get_target_property(ddc_LIB ddc OUTPUT_NAME)

add_executable(
  ${PROJECT_NAME}
        DDC.h
        ddcctl.m
        DDC.cpp
)

target_link_options(${PROJECT_NAME} PRIVATE "-lobjc")
#target_link_options(${PROJECT_NAME} PUBLIC -framework IOKit -framework AppKit -framework Foundation)
#target_link_libraries(${PROJECT_NAME}  ${IOKit_LIB} ${AppKit_LIB} ${Foundation_LIB})
#add_dependencies(${PROJECT_NAME} ddc)
#target_link_libraries(${PROJECT_NAME} ${ddc_LIB} "-framework IOKit" "-framework AppKit" "-framework Foundation")
#target_link_libraries(${PROJECT_NAME} "IOKit.framework" "AppKit.framework" "Foundation.framework")
target_link_libraries(${PROJECT_NAME}  "-framework IOKit" "-framework AppKit" "-framework Foundation")
