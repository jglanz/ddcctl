#!/bin/sh
make -C /projects/macos/ddcctl/build/debug-xcode -f /projects/macos/ddcctl/build/debug-xcode/CMakeScripts/ddc_postBuildPhase.make$CONFIGURATION OBJDIR=$(basename "$OBJECT_FILE_DIR_normal") all
