
#import <DDCControlIds.h>
#import "DDCFramework.h"
#import "DDC.hpp"
#import "DDCControlIds.h"

//#pragma clang diagnostic push
//#pragma clang diagnostic ignored "-Wshadow-ivar"

class DDCHelper {
public:
  static const DDCHelper & get() {
    static DDCHelper instance;
    return instance;
  };
  std::vector<DDC::DisplayInfo> displays {};



protected:
  DDCHelper() : displays(DDC::getDisplays()) {

  };
  virtual ~DDCHelper() = default;
};


@implementation DDCReadCommand
- (instancetype)initWithControlId:(UInt8)controlId {
    self = [super init];
    if (self) {
    self.controlId = controlId;
  }
  return self;
}

@end

@implementation DDCWriteCommand
- (instancetype)initWithControl:(DDCControl)control andValue:(UInt)value {
  self = [super init];
  if (self) {
    self.controlId = control;
    self.newValue = value;
  }
  return self;
}

- (instancetype)initWithControlId:(UInt8)controlId andValue: (UInt) value {
self = [super init];
if (self) {
  self.controlId = controlId;
  self.newValue = value;
}
  return self;
}
@end

@implementation DDCDisplay
- (Boolean)write:(DDCWriteCommand *)cmd {
  return [DDCManager.shared write:cmd for:self];
}

- (Boolean)read:(DDCReadCommand *)cmd {
  return [DDCManager.shared read:cmd for:self];
}

@end

/**
 * DDC Manager
 */
@implementation DDCManager

/**
 * Singleton reference
 */
static DDCManager * sharedInstance = nil;


+ (DDCManager *)shared {
  @synchronized (self) {
    if (!sharedInstance) {
      sharedInstance = [[DDCManager alloc] init];
    }
  }
  return sharedInstance;
}


- (instancetype)init {
  self = [super init];
  if (self) {
    self->_displays = [NSMutableArray new];
  }
  return self;
}

- (NSMutableArray *)getDisplays {
  auto *displays = self->_displays;
  if (displays.count) {
    return displays;
  }

  for (const auto & info : DDCHelper::get().displays) {
    DDCDisplay *display = [DDCDisplay.alloc init];
    display.name = [NSString
      stringWithCString:info.name.c_str()
               encoding:NSString.defaultCStringEncoding
    ];
    display.index = info.index;
    display.vendorId = info.vendorId;
    display.productId = info.productId;
    display.serial = info.serial;
    [displays addObject: display];
  }

  return displays;
}


- (Boolean)write:(DDCWriteCommand *)cmd for: (DDCDisplay *) display {

//  auto displays = self.getDisplays;
  auto & info = DDCHelper::get().displays[display.index];
  struct DDC::DDCWriteCommand ddcCommand{
    static_cast<UInt8>(cmd.controlId),
    static_cast<UInt8>(cmd.newValue)
  };

  return DDC::DDCWrite(info, &ddcCommand);

}

- (Boolean)read:(DDCReadCommand *)cmd for: (DDCDisplay *) display {

//  auto displays = self.getDisplays;
  auto & info = DDCHelper::get().displays[display.index];
  struct DDC::DDCReadCommand ddcCommand{
    static_cast<UInt8>(cmd.controlId)
  };

  cmd.success = DDC::DDCRead(info, &ddcCommand);
  if (cmd.success) {
    cmd.value = ddcCommand.currentValue;
    cmd.maxValue = ddcCommand.maxValue;
  }

  return cmd.success;
}


@end

//#pragma clang diagnostic pop
