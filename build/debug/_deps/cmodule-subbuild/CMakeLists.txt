# Distributed under the OSI-approved BSD 3-Clause License.  See accompanying
# file Copyright.txt or https://cmake.org/licensing for details.

cmake_minimum_required(VERSION 3.17.2)

# We name the project and the target for the ExternalProject_Add() call
# to something that will highlight to the user what we are working on if
# something goes wrong and an error message is produced.

project(cmodule-populate NONE)

include(ExternalProject)
ExternalProject_Add(cmodule-populate
                     "UPDATE_DISCONNECTED" "False" "URL" "https://github.com/scapix-com/cmodule/archive/v1.0.13.tar.gz" "URL_HASH" "SHA256=0dd63350e809f3be736a62f33f89f92ac0780a0f051e5fb90ae5a3bf51070b48"
                    SOURCE_DIR          "/projects/macos/ddcctl/build/debug/_deps/cmodule-src"
                    BINARY_DIR          "/projects/macos/ddcctl/build/debug/_deps/cmodule-build"
                    CONFIGURE_COMMAND   ""
                    BUILD_COMMAND       ""
                    INSTALL_COMMAND     ""
                    TEST_COMMAND        ""
                    USES_TERMINAL_DOWNLOAD  YES
                    USES_TERMINAL_UPDATE    YES
)
