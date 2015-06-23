
#import <Foundation/Foundation.h>
#import "sqlite3.h"
#import "FMDatabase.h"
#import "FMDatabaseQueue.h"
#import "Company.h"

@interface DBHelper : NSObject {
    FMDatabaseQueue *mDbQueue;
}

+ (DBHelper*)sharedInstance;

- (FMDatabaseQueue *)getQueue;

@end
