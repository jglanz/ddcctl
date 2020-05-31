
#import <Foundation/Foundation.h>

@interface DDCDisplay : NSObject
@property (copy) NSString * name;
@property (assign) NSInteger productId, vendorId, serial, index;
@end

@interface DDCWriteCommand : NSObject
@property (assign) NSInteger controlId, newValue;
@end

@interface DDCReadCommand : NSObject
@property (assign) Boolean success;
@property (assign) NSInteger controlId, value,maxValue;
@end


@interface DDCManager : NSObject {
  @private
  NSMutableArray * _displays;



}

- (NSMutableArray *) getDisplays;

- (Boolean) write: (DDCWriteCommand *) cmd for: (DDCDisplay *) display;
- (Boolean) read: (DDCReadCommand *) cmd for: (DDCDisplay *) display;
@end
