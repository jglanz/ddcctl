project(ddcctl C CXX OBJC)




add_executable(
  ${PROJECT_NAME}
  ${CMAKE_CURRENT_SOURCE_DIR}/ddccli.cpp
)


#get_target_property(ddc_LIB ddc LIBRARY_OUTPUT_DIRECTORY)
message(info "DDC Lib: ${ddc_LIB}")

add_dependencies(${PROJECT_NAME} ddc)


#target_link_directories(${PROJECT_NAME} PRIVATE ${ddc_LIB})
find_library(ddc_LIB ddc)
if (APPLE)
target_link_libraries(${PROJECT_NAME} PUBLIC  ${CONAN_LIBS} "-framework ${ddc_LIB}" "-framework IOKit" "-framework AppKit" "-framework Foundation" "-framework CoreFoundation")
target_link_options(${PROJECT_NAME} PRIVATE "-lobjc")
endif()

install(TARGETS ${PROJECT_NAME}
  RUNTIME DESTINATION ${INSTALL_DIR})
