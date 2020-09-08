project(ddc C CXX OBJC)

include_directories(
  BEFORE
  ${CMAKE_CURRENT_SOURCE_DIR}
)

set(DDC_SRC_FILES ./DDC.hpp ./DDCControlIds.h)

# APPLE FRAMEWORK BUILD
if (APPLE)
  set(CMAKE_OSX_DEPLOYMENT_TARGET "10.15" CACHE STRING "Minimum OS X deployment version")
  set(CMAKE_FIND_FRAMEWORK FIRST)

  find_library(CoreGraphics_LIB CoreGraphics)
  find_library(CoreFoundation_LIB CoreFoundation)
  find_library(Foundation_LIB Foundation)
  find_library(IOKit_LIB IOKit)
  find_library(AppKit_LIB AppKit)
  message(STATUS "FW path: ${IOKit_LIB}")


  add_compile_definitions(
    APPLE=1
    kDDCMinReplyDelay=30000000
  )

  list(
    APPEND
    DDC_SRC_FILES
    ${CMAKE_CURRENT_SOURCE_DIR}/apple/DDC+Apple.cpp
    ${CMAKE_CURRENT_SOURCE_DIR}/apple/ddc.h
    ${CMAKE_CURRENT_SOURCE_DIR}/apple/DDCFramework.h
    ${CMAKE_CURRENT_SOURCE_DIR}/apple/DDCFramework.mm
  )

endif ()
add_library(
  ${PROJECT_NAME} SHARED
  ${DDC_SRC_FILES}
)

if (APPLE)
  target_link_libraries(${PROJECT_NAME} PUBLIC "-framework CoreGraphics" "-framework IOKit" "-framework AppKit" "-framework Foundation")


  target_link_options(${PROJECT_NAME} PUBLIC "-lobjc")

  set_target_properties(${PROJECT_NAME} PROPERTIES
    FRAMEWORK TRUE
    FRAMEWORK_VERSION 1.0.0
    MACOSX_FRAMEWORK_IDENTIFIER "com.densebrain.ddc"
    MACOSX_FRAMEWORK_INFO_PLIST ${CMAKE_CURRENT_SOURCE_DIR}/apple/Info.plist
    PUBLIC_HEADER ${CMAKE_CURRENT_SOURCE_DIR}/apple/DDC+Apple.h
#    XCODE_ATTRIBUTE_CODE_SIGN_IDENTITY "Apple Developer"
    XCODE_ATTRIBUTE_CODE_SIGN_IDENTITY "iPhone Developer"
    #INSTALL_NAME_DIR "@rpath"
    )


endif ()

install(TARGETS ${PROJECT_NAME} DESTINATION lib)

add_subdirectory(cli)