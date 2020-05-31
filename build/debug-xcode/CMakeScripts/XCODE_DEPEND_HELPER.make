# DO NOT EDIT
# This makefile makes sure all linkable targets are
# up-to-date with anything they link to
default:
	echo "Do not invoke directly"

# Rules to remove targets that are older than anything to which they
# link.  This forces Xcode to relink the targets from scratch.  It
# does not seem to check these dependencies itself.
PostBuild.DDCFramework.Debug:
/projects/macos/ddcctl/build/debug-xcode/lib/DDCFramework.framework/DDCFramework:
	/bin/rm -f /projects/macos/ddcctl/build/debug-xcode/lib/DDCFramework.framework/DDCFramework


PostBuild.ddc.Debug:
/projects/macos/ddcctl/build/debug-xcode/lib/libddc.dylib:
	/bin/rm -f /projects/macos/ddcctl/build/debug-xcode/lib/libddc.dylib


PostBuild.ddcctl.Debug:
PostBuild.ddc.Debug: /projects/macos/ddcctl/build/debug-xcode/bin/ddcctl
/projects/macos/ddcctl/build/debug-xcode/bin/ddcctl:\
	/projects/macos/ddcctl/build/debug-xcode/lib/libddc.dylib
	/bin/rm -f /projects/macos/ddcctl/build/debug-xcode/bin/ddcctl


PostBuild.DDCFramework.Release:
/projects/macos/ddcctl/build/debug-xcode/lib/DDCFramework.framework/DDCFramework:
	/bin/rm -f /projects/macos/ddcctl/build/debug-xcode/lib/DDCFramework.framework/DDCFramework


PostBuild.ddc.Release:
/projects/macos/ddcctl/build/debug-xcode/lib/libddc.dylib:
	/bin/rm -f /projects/macos/ddcctl/build/debug-xcode/lib/libddc.dylib


PostBuild.ddcctl.Release:
PostBuild.ddc.Release: /projects/macos/ddcctl/build/debug-xcode/bin/ddcctl
/projects/macos/ddcctl/build/debug-xcode/bin/ddcctl:\
	/projects/macos/ddcctl/build/debug-xcode/lib/libddc.dylib
	/bin/rm -f /projects/macos/ddcctl/build/debug-xcode/bin/ddcctl


PostBuild.DDCFramework.MinSizeRel:
/projects/macos/ddcctl/build/debug-xcode/lib/DDCFramework.framework/DDCFramework:
	/bin/rm -f /projects/macos/ddcctl/build/debug-xcode/lib/DDCFramework.framework/DDCFramework


PostBuild.ddc.MinSizeRel:
/projects/macos/ddcctl/build/debug-xcode/lib/libddc.dylib:
	/bin/rm -f /projects/macos/ddcctl/build/debug-xcode/lib/libddc.dylib


PostBuild.ddcctl.MinSizeRel:
PostBuild.ddc.MinSizeRel: /projects/macos/ddcctl/build/debug-xcode/bin/ddcctl
/projects/macos/ddcctl/build/debug-xcode/bin/ddcctl:\
	/projects/macos/ddcctl/build/debug-xcode/lib/libddc.dylib
	/bin/rm -f /projects/macos/ddcctl/build/debug-xcode/bin/ddcctl


PostBuild.DDCFramework.RelWithDebInfo:
/projects/macos/ddcctl/build/debug-xcode/lib/DDCFramework.framework/DDCFramework:
	/bin/rm -f /projects/macos/ddcctl/build/debug-xcode/lib/DDCFramework.framework/DDCFramework


PostBuild.ddc.RelWithDebInfo:
/projects/macos/ddcctl/build/debug-xcode/lib/libddc.dylib:
	/bin/rm -f /projects/macos/ddcctl/build/debug-xcode/lib/libddc.dylib


PostBuild.ddcctl.RelWithDebInfo:
PostBuild.ddc.RelWithDebInfo: /projects/macos/ddcctl/build/debug-xcode/bin/ddcctl
/projects/macos/ddcctl/build/debug-xcode/bin/ddcctl:\
	/projects/macos/ddcctl/build/debug-xcode/lib/libddc.dylib
	/bin/rm -f /projects/macos/ddcctl/build/debug-xcode/bin/ddcctl




# For each target create a dummy ruleso the target does not have to exist
/projects/macos/ddcctl/build/debug-xcode/lib/libddc.dylib:
