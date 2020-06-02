cmake_minimum_required(VERSION 3.16)
project(ddc-project C CXX OBJC)

# OPTIONS
option(LIBRARY_TYPE SHARED)

# INIT
include(${CMAKE_CURRENT_SOURCE_DIR}/cmake/Init.cmake)

# INCLUDE DIRS

add_subdirectory(src)