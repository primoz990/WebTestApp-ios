
#import <Foundation/Foundation.h>
#import "Data.h"
#include "java/util/ArrayList.h"

@interface DataHelper : WLData

@property (readwrite, copy) void (^onSuccess)(JavaUtilArrayList*, BOOL);
@property (readwrite, copy) void (^onFailed)(NSString*);

@end
