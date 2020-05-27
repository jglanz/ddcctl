cmake_minimum_required(VERSION 3.16)
project(ddcctl C)

set(CMAKE_C_STANDARD 11)
set(CMAKE_OSX_DEPLOYMENT_TARGET "10.15" CACHE STRING "Minimum OS X deployment version")
set(CMAKE_FIND_FRAMEWORK FIRST)

include_directories(.)

include(CMakeFindFrameworks)
#find_package(IOKit REQUIRED)
#find_package(AppKit REQUIRED)
CMAKE_FIND_FRAMEWORKS(Foundation)
CMAKE_FIND_FRAMEWORKS(IOKit)
CMAKE_FIND_FRAMEWORKS(AppKit)

add_compile_definitions(
  kDDCMinReplyDelay=30000000
)


add_executable(
  ${PROJECT_NAME}
  DDC.c
  DDC.h
  ddcctl.m
)


target_link_libraries(${PROJECT_NAME}  ${IOKit_FRAMEWORKS} ${AppKit_FRAMEWORKS} ${Foundation_FRAMEWORKS})
