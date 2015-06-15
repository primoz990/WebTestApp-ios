
#import <Foundation/Foundation.h>
#import "Login.h"

@interface LoginHelper : WLLogin

@property (readwrite, copy) void (^loginSuccess)(void);
@property (readwrite, copy) void (^loginFailed)(NSInteger, NSString*);

@end
