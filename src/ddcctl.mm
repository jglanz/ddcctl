//
//  ddcctl.m
//  query and control monitors through their on-wire data channels and OSD microcontrollers
//  http://en.wikipedia.org/wiki/Display_Data_Channel#DDC.2FCI
//  http://en.wikipedia.org/wiki/Monitor_Control_Command_Set
//
//  Copyright Joey Korkames 2016 http://github.com/kfix
//  Licensed under GPLv3, full text at http://www.gnu.org/licenses/gpl-3.0.txt

//  Now using argv[] instead of user-defaults to handle commandline arguments.
//  Added optional use of an external app 'OSDisplay' to have a BezelUI like OSD.
//  Have fun! Marc (Saman-VDR) 2016

//#import <Foundation/Foundation.h>
//#import <AppKit/NSScreen.h>
//#import <stdio.h>
//#import "DDC.h"

#ifdef DEBUG
#define MyLog NSLog
#else
#define MyLog(...) (void)printf("%s\n",[[NSString stringWithFormat:__VA_ARGS__] UTF8String])
#endif



#ifdef BLACKLIST
NSUserDefaults *defaults;
int blacklistedDeviceWithNumber;
#endif
#ifdef OSD
bool useOsd;
#endif

//
//NSString *EDIDString(char *string) {
//    NSString *temp = [[[NSString alloc] initWithBytes:string length:13 encoding:NSASCIIStringEncoding] autorelease];
//    return ([temp rangeOfString:@"\n"].location != NSNotFound)
//           ? [temp componentsSeparatedByString:@"\n"][0] : temp;
//}
//
///* Get current value for control from display */
//uint getControl(CGDirectDisplayID displayId, uint controlId) {
//    struct DDCReadCommand command;
//    command.controlId = static_cast<UInt8>(controlId);
//    command.maxValue = 0;
//    command.currentValue = 0;
//    MyLog(@"D: querying VCP control: #%u =?", command.controlId);
//
//    if (!DDCRead(displayId, &command)) {
//        MyLog(@"E: DDC send command failed!");
//        MyLog(@"E: VCP control #%u (0x%02hhx) = current: %u, max: %u", command.controlId, command.controlId,
//              command.currentValue, command.maxValue);
//    } else {
//        MyLog(@"I: VCP control #%u (0x%02hhx) = current: %u, max: %u", command.controlId, command.controlId,
//              command.currentValue, command.maxValue);
//    }
//    return command.currentValue;
//}
//
///* Set new value for control from display */
//void setControl(CGDirectDisplayID cdisplay, uint control_id, uint new_value) {
//    struct DDCWriteCommand command;
//    command.control_id = static_cast<UInt8>(control_id);
//    command.new_value = static_cast<UInt8>(new_value);
//
//    MyLog(@"D: setting VCP control #%u => %u", command.control_id, command.new_value);
//    if (!DDCWrite(cdisplay, &command)) {
//        MyLog(@"E: Failed to send DDC command!");
//    }
//#ifdef OSD
//    if (useOsd) {
//        NSString *OSDisplay = @"/Applications/OSDisplay.app/Contents/MacOS/OSDisplay";
//        switch (control_id) {
//            case 16:
//                [NSTask launchedTaskWithLaunchPath:OSDisplay
//                                         arguments:[NSArray arrayWithObjects:
//                                                    @"-l", [NSString stringWithFormat:@"%u", new_value],
//                                                    @"-i", @"brightness", nil]];
//                break;
//
//            case 18:
//                [NSTask launchedTaskWithLaunchPath:OSDisplay
//                                         arguments:[NSArray arrayWithObjects:
//                                                    @"-l", [NSString stringWithFormat:@"%u", new_value],
//                                                    @"-i", @"contrast", nil]];
//                break;
//
//            default:
//                break;
//        }
//    }
//#endif
//}
//
///* Get current value to Set relative value for control from display */
//void getSetControl(CGDirectDisplayID displayId, uint controlId, NSString *newValue, NSString *op) {
//    struct DDCReadCommand command;
//    command.controlId = static_cast<UInt8>(controlId);
//    command.maxValue = 0;
//    command.currentValue = 0;
//
//    // read
//    MyLog(@"D: querying VCP control: #%u =?", command.controlId);
//
//    if (!DDCRead(displayId, &command)) {
//        MyLog(@"E: DDC send command failed!");
//        MyLog(@"E: VCP control #%u (0x%02hhx) = current: %u, max: %u", command.controlId, command.controlId,
//              command.currentValue, command.maxValue);
//    } else {
//        MyLog(@"I: VCP control #%u (0x%02hhx) = current: %u, max: %u", command.controlId, command.controlId,
//              command.currentValue, command.maxValue);
//    }
//
//    // calculate
//    NSString *formula = [NSString stringWithFormat:@"%u %@ %@", command.currentValue, op, newValue];
//    NSExpression *exp = [NSExpression expressionWithFormat:formula];
//    NSNumber *set_value = [exp expressionValueWithObject:nil context:nil];
//
//    // validate and write
//    if (set_value.intValue >= 0 && set_value.intValue <= command.maxValue) {
//        MyLog(@"D: relative setting: %@ = %d", formula, set_value.intValue);
//        setControl(displayId, controlId, set_value.unsignedIntValue);
//    } else {
//        MyLog(@"D: relative setting: %@ = %d is out of range!", formula, set_value.intValue);
//    }
//}

/* Main function */
int main(int argc, const char *argv[]) {

    @autoreleasepool {

//      auto allDisplays = allDisplays();
//      for (auto info in allDisplays) {
//        MyLog(@"Screen #%u: %@", info.index, info.name);
//      }
//
//        NSPointerArray *_displayIDs = [NSPointerArray pointerArrayWithOptions:NSPointerFunctionsOpaqueMemory |
//                                                                              NSPointerFunctionsIntegerPersonality];
//
//        for (NSScreen *screen in NSScreen.screens) {
//            NSDictionary *description = [screen deviceDescription];
//            if (description[@"NSDeviceIsScreen"]) {
//                CGDirectDisplayID screenNumber = [description[@"NSScreenNumber"] unsignedIntValue];
//                if (CGDisplayIsBuiltin(screenNumber))
//                    continue; // ignore MacBook screens because the lid can be closed and they don't use DDC.
//                [_displayIDs addPointer:(void *) (UInt64) screenNumber];
//                NSSize displayPixelSize = [description[NSDeviceSize] sizeValue];
//                CGSize displayPhysicalSize = CGDisplayScreenSize(screenNumber); // dspPhySz only valid if EDID present!
//                float displayScale = [screen backingScaleFactor];
//                double rotation = CGDisplayRotation(screenNumber);
//                if (displayScale > 1) {
//                    MyLog(@"D: NSScreen #%u (%.0fx%.0f %g°) HiDPI",
//                          screenNumber,
//                          displayPixelSize.width,
//                          displayPixelSize.height,
//                          rotation);
//                } else {
//                    MyLog(@"D: NSScreen #%u (%.0fx%.0f %g°) %0.2f DPI",
//                          screenNumber,
//                          displayPixelSize.width,
//                          displayPixelSize.height,
//                          rotation,
//                          (displayPixelSize.width / displayPhysicalSize.width) *
//                          25.4f); // there being 25.4 mm in an inch
//                }
//            }
//        }
//        MyLog(@"I: found %lu external display%@", [_displayIDs count], [_displayIDs count] > 1 ? @"s" : @"");
//
//
//        // Defaults
//        NSString *screenName = @"";
//        NSInteger displayId = -1;
//        NSUInteger commandInterval = 100000;
//        BOOL dumpValues = NO;
//
//        NSString *HelpString = @"Usage:\n"
//                               @"ddcctl \t-d <1-..>  [display#]\n"
//                               @"\t-w 100000  [delay usecs between settings]\n"
//                               @"\n"
//                               @"----- Basic settings -----\n"
//                               @"\t-b <1-..>  [brightness]\n"
//                               @"\t-c <1-..>  [contrast]\n"
//                               @"\t-rbc       [reset brightness and contrast]\n"
//                               #ifdef OSD
//                               @"\t-O         [osd: needs external app 'OSDisplay']\n"
//                               #endif
//                               @"\n"
//                               @"----- Settings that don\'t always work -----\n"
//                               @"\t-m <1|2>   [mute speaker OFF/ON]\n"
//                               @"\t-v <1-254> [speaker volume]\n"
//                               @"\t-i <1-18>  [select input source]\n"
//                               @"\t-p <1|2-5> [power on | standby/off]\n"
//                               @"\t-o         [read-only orientation]\n"
//                               @"\n"
//                               @"----- Settings (testing) -----\n"
//                               @"\t-rg <1-..>  [red gain]\n"
//                               @"\t-gg <1-..>  [green gain]\n"
//                               @"\t-bg <1-..>  [blue gain]\n"
//                               @"\t-rrgb       [reset color]\n"
//                               @"\n"
//                               @"----- Setting grammar -----\n"
//                               @"\t-X ?       (query value of setting X)\n"
//                               @"\t-X NN      (put setting X to NN)\n"
//                               @"\t-X <NN>-   (decrease setting X by NN)\n"
//                               @"\t-X <NN>+   (increase setting X by NN)";
//
//
//        // Commandline Arguments
//        NSMutableDictionary *actions = [[[NSMutableDictionary alloc] init] autorelease];
//
//        for (int i = 1; i < argc; i++) {
//            if (!strcmp(argv[i], "-d")) {
//                i++;
//                if (i >= argc) break;
//                displayId = atoi(argv[i]);
//            } else if (!strcmp(argv[i], "-b")) {
//                i++;
//                if (i >= argc) break;
//                actions[@"b"] = @[@BRIGHTNESS, [[[NSString alloc] initWithUTF8String:argv[i]] autorelease]];
//            } else if (!strcmp(argv[i], "-c")) {
//                i++;
//                if (i >= argc) break;
//                actions[@"c"] = @[@CONTRAST, [[[NSString alloc] initWithUTF8String:argv[i]] autorelease]];
//            } else if (!strcmp(argv[i], "-rbc")) {
//                actions[@"rbc"] = @[@RESET_BRIGHTNESS_AND_CONTRAST, @"1"];
//            } else if (!strcmp(argv[i], "-rg")) {
//                i++;
//                if (i >= argc) break;
//                actions[@"rg"] = @[@RED_GAIN, [[[NSString alloc] initWithUTF8String:argv[i]] autorelease]];
//            } else if (!strcmp(argv[i], "-gg")) {
//                i++;
//                if (i >= argc) break;
//                actions[@"gg"] = @[@GREEN_GAIN, [[[NSString alloc] initWithUTF8String:argv[i]] autorelease]];
//            } else if (!strcmp(argv[i], "-bg")) {
//                i++;
//                if (i >= argc) break;
//                actions[@"bg"] = @[@BLUE_GAIN, [[[NSString alloc] initWithUTF8String:argv[i]] autorelease]];
//            } else if (!strcmp(argv[i], "-rrgb")) {
//                actions[@"rrgb"] = @[@RESET_COLOR, @"1"];
//            } else if (!strcmp(argv[i], "-D")) {
//                dumpValues = YES;
//            } else if (!strcmp(argv[i], "-p")) {
//                i++;
//                if (i >= argc) break;
//                actions[@"p"] = @[@DPMS, [[[NSString alloc] initWithUTF8String:argv[i]] autorelease]];
//            } else if (!strcmp(argv[i], "-o")) { // read only
//                actions[@"o"] = @[@ORIENTATION, @"?"];
//            } else if (!strcmp(argv[i], "-osd")) { // read only - returns '1' (OSD closed) or '2' (OSD active)
//                actions[@"osd"] = @[@ON_SCREEN_DISPLAY, @"?"];
//            } else if (!strcmp(argv[i], "-lang")) { // read only
//                actions[@"lang"] = @[@OSD_LANGUAGE, @"?"];
//            } else if (!strcmp(argv[i], "-reset")) {
//                actions[@"reset"] = @[@RESET, @"1"];
//            } else if (!strcmp(argv[i], "-preset_a")) {
//                i++;
//                if (i >= argc) break;
//                actions[@"preset_a"] = @[@COLOR_PRESET_A,
//                                         [[[NSString alloc] initWithUTF8String:argv[i]] autorelease]];
//            } else if (!strcmp(argv[i], "-preset_b")) {
//                i++;
//                if (i >= argc) break;
//                actions[@"preset_b"] = @[@COLOR_PRESET_B,
//                                         [[[NSString alloc] initWithUTF8String:argv[i]] autorelease]];
//            } else if (!strcmp(argv[i], "-preset_c")) {
//                i++;
//                if (i >= argc) break;
//                actions[@"preset_c"] = @[@COLOR_PRESET_C,
//                                         [[[NSString alloc] initWithUTF8String:argv[i]] autorelease]];
//            } else if (!strcmp(argv[i], "-i")) {
//                i++;
//                if (i >= argc) break;
//                actions[@"i"] = @[@INPUT_SOURCE, [NSString.alloc initWithUTF8String:argv[i]]];
//            } else if (!strcmp(argv[i], "-m")) {
//                i++;
//                if (i >= argc) break;
//                actions[@"m"] = @[@AUDIO_MUTE, [[[NSString alloc] initWithUTF8String:argv[i]] autorelease]];
//            } else if (!strcmp(argv[i], "-v")) {
//                i++;
//                if (i >= argc) break;
//                actions[@"v"] = @[@AUDIO_SPEAKER_VOLUME, [[[NSString alloc] initWithUTF8String:argv[i]] autorelease]];
//            } else if (!strcmp(argv[i], "-w")) {
//                i++;
//                if (i >= argc) break;
//                commandInterval = static_cast<NSUInteger>(atoi(argv[i]));
//            }
//#ifdef OSD
//                else if (!strcmp(argv[i], "-O")) {
//                    useOsd = YES;
//                }
//#endif
//#ifdef TEST
//                else if (!strcmp(argv[i], "-test")) {
//                    i++;
//                    if (i >= argc) break;
//                    NSString *test = [[NSString alloc] initWithUTF8String:argv[i]];
//                    i++;
//                    if (i >= argc) break;
//                    [actions setObject:@[test, [[NSString alloc] initWithUTF8String:argv[i]]] forKey:@"test"];
//                    NSLog(@"TEST: %@  %@", test, [[NSString alloc] initWithUTF8String:argv[i]]);
//                }
//#endif
//            else if (!strcmp(argv[i], "-h")) {
//                NSLog(@"ddcctl 0.1x - %@", HelpString);
//                return 0;
//            } else {
//                NSLog(@"Unknown argument: %@", [[[NSString alloc] initWithUTF8String:argv[i]] autorelease]);
//                return -1;
//            }
//        }
//
//        uint32_t displayCount;
//        CGGetActiveDisplayList(0, nil, &displayCount);
//        CGDirectDisplayID displayIds[displayCount];
//        CGGetActiveDisplayList(displayCount, displayIds, &displayCount);
//        for (uint32_t i = 0; i < displayCount; i++) {
//            CGDirectDisplayID did = displayIds[i];
//            MyLog(@"I: polling display %lu's EDID", did);
////
////        // Let's go...
////        //if (0 < displayId && displayId <= [_displayIDs count]) {
////            MyLog(@"I: polling display %lu's EDID", displayId);
////            CGDirectDisplayID cdisplay = (CGDirectDisplayID) [_displayIDs pointerAtIndex:displayId - 1];
////            struct EDID edid = {};
////            if (EDIDTest(cdisplay, &edid)) {
////                for (union descriptor *des = edid.descriptors;
////                     des < edid.descriptors + sizeof(edid.descriptors); des++) {
////                    switch (des->text.type) {
////                        case 0xFF:
////                            MyLog(@"I: got edid.serial: %@", EDIDString(des->text.data));
////                            break;
////                        case 0xFC:
////                            screenName = EDIDString(des->text.data);
////                            MyLog(@"I: got edid.name: %@", screenName);
////                            break;
////                    }
////                }
////
////                // Debugging
////                if (dump_values) {
////                    for (uint i = 0x00; i <= 255; i++) {
////                        getControl(cdisplay, i);
////                        usleep(command_interval);
////                    }
////                }
//
//            // Actions
//            [actions enumerateKeysAndObjectsUsingBlock:^(id argname, NSArray *valueArray, BOOL *stop) {
//                uint controlId = static_cast<uint>([valueArray[0] intValue]);
//                NSString *argVal = valueArray[1];
//                MyLog(@"D: action: %@: %@", argname, argVal);
//
//                if (controlId > -1) {
//                    // this is a valid monitor control
//                    NSString *argValNum = [argVal stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"-+"]]; // look for relative setting ops
//                    if ([argVal hasPrefix:@"+"] || [argVal hasPrefix:@"-"]) { // +/-NN relative
//                        getSetControl(did, controlId, argValNum, [argVal substringToIndex:1]);
//                    } else if ([argVal hasSuffix:@"+"] || [argVal hasSuffix:@"-"]) { // NN+/- relative
//                        // read, calculate, then write
//                        getSetControl(did, controlId, argValNum,
//                                      [argVal substringFromIndex:argVal.length - 1]);
//                    } else if ([argVal hasPrefix:@"?"]) {
//                        // read current setting
//                        getControl(did, controlId);
//                    } else if (argValNum == argVal) {
//                        // write fixed setting
//                        setControl(did, controlId, static_cast<uint>([argVal intValue]));
//                    }
//                }
//                usleep(static_cast<useconds_t>(commandInterval)); // stagger comms to these wimpy I2C mcu's
//            }];
//
//        }
////        else {
////            MyLog(@"E: Failed to poll display!");
////            return -1;
////        }
////    }
////        } else { // no display id given
////            NSLog(@"%@", HelpString);
////        }
    }
    return 0;
}
