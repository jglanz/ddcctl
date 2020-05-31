cmake_minimum_required(VERSION 3.16)
project(ddcctl C CXX OBJC)


set(CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)
set(CMAKE_CXX_EXTENSIONS ON)
set(CMAKE_CXX_STANDARD ${CXX_STANDARD})
set(CMAKE_C_STANDARD 11)
set(CMAKE_OSX_DEPLOYMENT_TARGET "10.15" CACHE STRING "Minimum OS X deployment version")
set(CMAKE_FIND_FRAMEWORK FIRST)

option(LIBRARY_TYPE SHARED )

add_definitions("-std=c++${CXX_STANDARD}")

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
find_library(CoreFoundation_LIB CoreFoundation)
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
  src/DDC.hpp
)



target_link_libraries(ddc PRIVATE  "-framework CoreGraphics" "-framework IOKit" "-framework AppKit" "-framework Foundation")


add_library(
  DDCFramework SHARED
  src/DDC.cpp
  src/DDC.hpp
  src/DDCFramework.h
  src/DDCFramework.mm
  )
target_link_options(DDCFramework PRIVATE "-lobjc")

set_target_properties(DDCFramework PROPERTIES
  FRAMEWORK TRUE
  FRAMEWORK_VERSION 1.0.0
  MACOSX_FRAMEWORK_IDENTIFIER "com.3fv.ddc"
  MACOSX_FRAMEWORK_INFO_PLIST ${CMAKE_SOURCE_DIR}/Info.plist
  PUBLIC_HEADER src/DDCFramework.h
  XCODE_ATTRIBUTE_CODE_SIGN_IDENTITY "Apple Development"
  )

target_link_libraries(DDCFramework PRIVATE ${CONAN_LIBS} "-framework IOKit" "-framework AppKit" "-framework Foundation" "-framework CoreFoundation")


get_target_property(ddc_LIB ddc OUTPUT_NAME)


add_executable(
  ${PROJECT_NAME}
  src/DDC.hpp
  src/ddcctl.cpp
  src/DDC.cpp
)

#scapix_bridge_headers(
#  ${PROJECT_NAME}
#  "com.3fv.ddcctl"
#  "src/DDC.h"
#
#)
add_dependencies(${PROJECT_NAME} ddc)
target_link_libraries(${PROJECT_NAME} PRIVATE ddc ${CONAN_LIBS} "-framework IOKit" "-framework AppKit" "-framework Foundation" "-framework CoreFoundation")
#target_link_options(${PROJECT_NAME} PRIVATE "-lobjc")

