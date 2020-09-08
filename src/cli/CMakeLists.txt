project(ddcctl C CXX OBJC)



list(
  APPEND
  DDCCLI_SRC_FILES
  ${CMAKE_CURRENT_SOURCE_DIR}/../apple/DDC+Apple.cpp
  ${CMAKE_CURRENT_SOURCE_DIR}/../apple/ddc.h
  ${CMAKE_CURRENT_SOURCE_DIR}/../apple/DDCFramework.h
  ${CMAKE_CURRENT_SOURCE_DIR}/../apple/DDCFramework.mm
)


add_executable(
  ${PROJECT_NAME}
  ${CMAKE_CURRENT_SOURCE_DIR}/ddccli.cpp
  ${DDCCLI_SRC_FILES}
)


#get_target_property(ddc_LIB ddc LIBRARY_OUTPUT_DIRECTORY)
message(info "DDC Lib: ${ddc_LIB}")

add_dependencies(${PROJECT_NAME} ddc)


#target_link_directories(${PROJECT_NAME} PRIVATE ${ddc_LIB})
find_library(ddc_LIB ddc)
#link_directories(
#  /usr/local/lib
#)
if (APPLE)
target_link_libraries(${PROJECT_NAME} PUBLIC  ${CONAN_LIBS} "-framework IOKit" "-framework AppKit" "-framework Foundation" "-framework CoreFoundation")
target_link_options(${PROJECT_NAME} PRIVATE "-lobjc")
endif()

install(TARGETS ${PROJECT_NAME}
  RUNTIME DESTINATION ${INSTALL_DIR})
