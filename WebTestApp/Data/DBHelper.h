
#import <Foundation/Foundation.h>
#import "sqlite3.h"
#import "FMDatabase.h"
#import "FMDatabaseQueue.h"
#include "java/util/ArrayList.h"

@interface DBHelper : NSObject {
    FMDatabaseQueue *mDbQueue;
}

+ (DBHelper*)sharedInstance;

- (BOOL) setCompanies:(JavaUtilArrayList*)companies;
- (JavaUtilArrayList*) getCompanies;



@end
