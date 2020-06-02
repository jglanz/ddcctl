#pragma once
#import <Foundation/Foundation.h>
#import "DDCControlIds.h"


/**
 * Display holder
 */


@interface DDCWriteCommand : NSObject
@property(assign) UInt controlId, newValue;

- (instancetype)initWithControl:(DDCControl)control andValue:(UInt)value;
- (instancetype)initWithControlId:(UInt8)controlId andValue:(UInt)value;

@end

@interface DDCReadCommand : NSObject
@property(assign) Boolean success;
@property(assign) UInt32 controlId, value, maxValue;
- (instancetype)initWithControlId:(UInt8)controlId;
@end

@interface DDCDisplay : NSObject
@property(copy) NSString *name;
@property(assign) UInt32 productId, vendorId, serial, index;

//- (void) stepBrightness: (Boolean) isUp isSmall: (Boolean) isSmall;
- (Boolean)write:(DDCWriteCommand *)cmd;
- (Boolean)read:(DDCReadCommand *)cmd;
@end

@interface DDCManager : NSObject {
@private
    NSMutableArray *_displays;


}

+ (DDCManager *) shared;




- (NSMutableArray *)getDisplays;

- (Boolean)write:(DDCWriteCommand *)cmd for:(DDCDisplay *)display;

- (Boolean)read:(DDCReadCommand *)cmd for:(DDCDisplay *)display;
@end
