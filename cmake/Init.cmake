set(CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)
set(CMAKE_CXX_EXTENSIONS ON)
set(CMAKE_CXX_STANDARD ${CXX_STANDARD})
set(CMAKE_C_STANDARD 11)
add_definitions("-std=c++${CXX_STANDARD}")

if (NOT EXISTS ${CMAKE_BINARY_DIR}/conanbuildinfo.cmake)
  execute_process(
    COMMAND
    conan install ${CMAKE_CURRENT_LIST_DIR}/../
    WORKING_DIRECTORY
    ${CMAKE_BINARY_DIR}
  )
endif ()

include(${CMAKE_BINARY_DIR}/conanbuildinfo.cmake)
conan_basic_setup()

if (APPLE)
  # use, i.e. don't skip the full RPATH for the build tree
  set(CMAKE_SKIP_BUILD_RPATH FALSE)

  # when building, don't use the install RPATH already
  # (but later on when installing)
  set(CMAKE_BUILD_WITH_INSTALL_RPATH FALSE)

  set(CMAKE_INSTALL_RPATH "${CMAKE_INSTALL_PREFIX}/lib")

  # add the automatically determined parts of the RPATH
  # which point to directories outside the build tree to the install RPATH
  set(CMAKE_INSTALL_RPATH_USE_LINK_PATH TRUE)

  # the RPATH to be used when installing, but only if it's not a system directory
#  list(FIND CMAKE_PLATFORM_IMPLICIT_LINK_DIRECTORIES "${CMAKE_INSTALL_PREFIX}/lib" isSystemDir)
#  if("${isSystemDir}" STREQUAL "-1")
#    set(CMAKE_INSTALL_RPATH "${CMAKE_INSTALL_PREFIX}/lib")
#  endif("${isSystemDir}" STREQUAL "-1")

  endif()