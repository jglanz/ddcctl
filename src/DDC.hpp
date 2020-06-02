//
//  DDC.h
//  DDC Panel
//
//  Created by Jonathan Taylor on 7/10/09.
//  See ftp://ftp.cis.nctu.edu.tw/pub/csie/Software/X11/private/VeSaSpEcS/VESA_Document_Center_Monitor_Interface/mccsV3.pdf
//  See http://read.pudn.com/downloads110/ebook/456020/E-EDID%20Standard.pdf
//  See ftp://ftp.cis.nctu.edu.tw/pub/csie/Software/X11/private/VeSaSpEcS/VESA_Document_Center_Monitor_Interface/EEDIDrAr2.pdf
//

#pragma clang diagnostic push
#pragma ide diagnostic ignored "UnusedGlobalDeclarationInspection"
#pragma ide diagnostic ignored "UnusedMacroInspection"
#pragma once


// use the following construct to specify c linkage for c and c++ translations:
#include <string>
#include <map>
#include <vector>
#include <functional>
#include "DDCControlIds.h"

#define DISPLAY_OPT "display"
#define BRIGHTNESS_OPT "brightness"
#define CONTRAST_OPT "contrast"
#define INPUT_SOURCE_OPT "source"


#if defined(APPLE)



#if defined(__cplusplus)
extern "C" {
#endif

#include <IOKit/IOKitLib.h>
#include <IOKit/i2c/IOI2CInterface.h>
#include <IOKit/graphics/IOGraphicsLib.h>
#include <CoreGraphics/CoreGraphics.h>



#if defined(__cplusplus)
}
using DisplayServicePort = io_service_t;
#endif

#else
using UInt64 = uint64_t;
using UInt32 = uint32_t;
using UInt16 = uint16_t;
using UInt8 = uint8_t;
using DisplayServicePort = void *;
#endif

namespace DDC {

  class DisplayInfo {
  public:
    std::string name{""};
    UInt32 serial{0};
    UInt32 vendorId{0};
    UInt32 productId{0};
    UInt32 index{0};

    DisplayInfo() = default;

    DisplayInfo(
      std::string name,
      UInt32 serial,
      UInt32 vendorId,
      UInt32 productId,
      UInt32 index
    );

    virtual ~DisplayInfo() = default;
  };

  using DisplayInfoCallback = std::function<bool(DisplayInfo, DisplayServicePort)>;


  void forEachServicePort(const DisplayInfoCallback &callback);

  std::vector<DisplayInfo> getDisplays();


  struct DDCWriteCommand {
    UInt8 control_id;
    UInt8 new_value;
  };

  struct DDCReadCommand {
    UInt8 controlId;
    bool success;
    UInt8 maxValue;
    UInt8 currentValue;
  };

  struct EDID {
    UInt64 header: 64;
    UInt8 : 1;
    UInt16 eisaid: 15;
    UInt16 productcode: 16;
    UInt32 serial: 32;
    UInt8 week: 8;
    UInt8 year: 8;
    UInt8 versionmajor: 8;
    UInt8 versionminor: 8;
    union videoInput {
      struct digitalInput {
        UInt8 type: 1;
        UInt8 : 6;
        UInt8 dfp: 1;
      } digital;
      struct analogInput {
        UInt8 type: 1;
        UInt8 synclevels: 2;
        UInt8 pedestal: 1;
        UInt8 separate: 1;
        UInt8 composite: 1;
        UInt8 green: 1;
        UInt8 serrated: 1;
      } analog;
    } videoInput;
    UInt8 maxh: 8;
    UInt8 maxv: 8;
    UInt8 gamma: 8;
    UInt8 standby: 1;
    UInt8 suspend: 1;
    UInt8 activeoff: 1;
    UInt8 displaytype: 2;
    UInt8 srgb: 1;
    UInt8 preferredtiming: 1;
    UInt8 gtf: 1;
    UInt8 redxlsb: 2;
    UInt8 redylsb: 2;
    UInt8 greenxlsb: 2;
    UInt8 greenylsb: 2;
    UInt8 bluexlsb: 2;
    UInt8 blueylsb: 2;
    UInt8 whitexlsb: 2;
    UInt8 whiteylsb: 2;
    UInt8 redxmsb: 8;
    UInt8 redymsb: 8;
    UInt8 greenxmsb: 8;
    UInt8 greenymsb: 8;
    UInt8 bluexmsb: 8;
    UInt8 blueymsb: 8;
    UInt8 whitexmsb: 8;
    UInt8 whiteymsb: 8;
    UInt8 t720x400a70: 1;
    UInt8 t720x400a88: 1;
    UInt8 t640x480a60: 1;
    UInt8 t640x480a67: 1;
    UInt8 t640x480a72: 1;
    UInt8 t640x480a75: 1;
    UInt8 t800x600a56: 1;
    UInt8 t800x600a60: 1;
    UInt8 t800x600a72: 1;
    UInt8 t800x600a75: 1;
    UInt8 t832x624a75: 1;
    UInt8 t1024x768a87: 1;
    UInt8 t1024x768a60: 1;
    UInt8 t1024x768a72: 1;
    UInt8 t1024x768a75: 1;
    UInt8 t1280x1024a75: 1;
    UInt8 t1152x870a75: 1;
    UInt8 othermodes: 7;
    struct timing {
      UInt8 xresolution: 8;
      UInt8 ratio: 2;
      UInt8 vertical: 6;
    } timing1;
    struct timing timing2;
    struct timing timing3;
    struct timing timing4;
    struct timing timing5;
    struct timing timing6;
    struct timing timing7;
    struct timing timing8;
    union descriptor {
      struct timingdetail {
        UInt16 clock: 16;
        UInt8 hactivelsb: 8;
        UInt8 hblankinglsb: 8;
        UInt8 hactivemsb: 4;
        UInt8 hblankingmsb: 4;
        UInt8 vactivelsb: 8;
        UInt8 vblankinglsb: 8;
        UInt8 vactivemsb: 4;
        UInt8 vblankingmsb: 4;
        UInt8 hsyncoffsetlsb: 8;
        UInt8 hsyncpulselsb: 8;
        UInt8 vsyncoffsetlsb: 4;
        UInt8 vsyncpulselsb: 4;
        UInt8 hsyncoffsetmsb: 2;
        UInt8 hsyncpulsemsb: 2;
        UInt8 vsyncoffsetmsb: 2;
        UInt8 vsyncpulsemsb: 2;
        UInt8 hsizelsb: 8;
        UInt8 vsizelsb: 8;
        UInt8 hsizemsb: 4;
        UInt8 vsizemsb: 4;
        UInt8 hborder: 8;
        UInt8 vborder: 8;
        UInt8 interlaced: 1;
        UInt8 stereo: 2;
        UInt8 synctype: 2;
        UInt8 vsyncpol_serrated: 1;
        UInt8 hsyncpol_syncall: 1;
        UInt8 twowaystereo: 1;
      } timing;
      struct text {
        UInt32 : 24;
        UInt8 type: 8;
        UInt8 : 8;
        char data[13];
      } text;
      struct __attribute__ ((packed)) rangelimits {
        UInt64 header: 40;
        UInt8 minvfield: 8;
        UInt8 minhfield: 8;
        UInt8 minhline: 8;
        UInt8 minvline: 8;
        UInt8 maxclock: 8;
        UInt8 extended: 8;
        UInt8 : 8;
        UInt8 startfreq: 8;
        UInt8 cvalue: 8;
        UInt16 mvalue: 16;
        UInt8 kvalue: 8;
        UInt8 jvalue: 8;
      } range;
      struct __attribute__ ((packed)) whitepoint {
        UInt64 header: 40;
        UInt8 index: 8;
        UInt8 : 4;
        UInt8 whitexlsb: 2;
        UInt8 whiteylsb: 2;
        UInt8 whitexmsb: 8;
        UInt8 whiteymsb: 8;
        UInt8 gamma: 8;
        UInt8 index2: 8;
        UInt8 : 4;
        UInt8 whitexlsb2: 2;
        UInt8 whiteylsb2: 2;
        UInt8 whitexmsb2: 8;
        UInt8 whiteymsb2: 8;
        UInt8 gamma2: 8;
        UInt32 : 24;
      } whitepoint;
    } descriptors[4];
    UInt8 extensions: 8;
    UInt8 checksum: 8;
  };


  bool DDCWrite(const DisplayInfo &display, struct DDCWriteCommand *write);

  bool DDCRead(const DisplayInfo &display, struct DDCReadCommand *read);

  bool EDIDTest(const DisplayInfo &display, struct EDID *edid);

  UInt32 SupportedTransactionType(const DisplayInfo &it, io_service_t port);

}
//#if defined(__cplusplus)
//}
//#endif

#pragma clang diagnostic pop
