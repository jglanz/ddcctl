
#pragma once


#if defined(APPLE) && !defined(__cplusplus)
#import <Foundation/Foundation.h>
typedef NS_OPTIONS(UInt8, DDCControl) {
#else
  enum DDCControl {
#endif
  RESET = 0x04,
  RESET_BRIGHTNESS_AND_CONTRAST = 0x05,
  RESET_GEOMETRY = 0x06,
  RESET_COLOR = 0x08,
  BRIGHTNESS = 0x10,  //OK
  CONTRAST = 0x12, //OK
  COLOR_PRESET_A = 0x14,     // dell u2515h -> Presets: 4 = 5000K, 5 = 6500K, 6 = 7500K, 8 = 9300K, 9 = 10000K, 11 = 5700K, 12 = Custom Color
  RED_GAIN = 0x16,
  GREEN_GAIN = 0x18,
  BLUE_GAIN = 0x1A,
  AUTO_SIZE_CENTER = 0x1E,
  WIDTH = 0x22,
  HEIGHT = 0x32,
  VERTICAL_POS = 0x30,
  HORIZONTAL_POS = 0x20,
  PINCUSHION_AMP = 0x24,
  PINCUSHION_PHASE = 0x42,
  KEYSTONE_BALANCE = 0x40,
  PINCUSHION_BALANCE = 0x26,
  TOP_PINCUSHION_AMP = 0x46,
  TOP_PINCUSHION_BALANCE = 0x48,
  BOTTOM_PINCUSHION_AMP = 0x4A,
  BOTTOM_PINCUSHION_BALANCE = 0x4C,
  VERTICAL_LINEARITY = 0x3A,
  VERTICAL_LINEARITY_BALANCE = 0x3C,
  HORIZONTAL_STATIC_CONVERGENCE = 0x28,
  VERTICAL_STATIC_CONVERGENCE = 0x28,
  MOIRE_CANCEL = 0x56,
  INPUT_SOURCE = 0x60,
  AUDIO_SPEAKER_VOLUME = 0x62,
  RED_BLACK_LEVEL = 0x6C,
  GREEN_BLACK_LEVEL = 0x6E,
  BLUE_BLACK_LEVEL = 0x70,
  ORIENTATION = 0xAA,
  AUDIO_MUTE = 0x8D,
  SETTINGS = 0xB0,                  //unsure on this one
  ON_SCREEN_DISPLAY = 0xCA,     // read only   -> returns '1' (OSD closed) or '2' (OSD active)
  OSD_LANGUAGE = 0xCC,
  DPMS = 0xD6,
  COLOR_PRESET_B = 0xDC,     // dell u2515h -> Presets: 0 = Standard, 2 = Multimedia, 3 = Movie, 5 = Game
  VCP_VERSION = 0xDF,
  COLOR_PRESET_C = 0xE0,     // dell u2515h -> Brightness on/off (0 or 1)
  POWER_CONTROL = 0xE1,
  TOP_LEFT_SCREEN_PURITY = 0xE8,
  TOP_RIGHT_SCREEN_PURITY = 0xE9,
  BOTTOM_LEFT_SCREEN_PURITY = 0xE8,
  BOTTOM_RIGHT_SCREEN_PURITY = 0xEB
};
//
//#if defined(__cplusplus)
//}
//#endif
