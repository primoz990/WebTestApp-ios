
#import "DBHelper.h"
#import "DbContract.h"

@implementation DBHelper

- (instancetype)init
{
    self = [super init];
    if (self) {
        //Set database path
        NSString *docsPath = [[[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject] path];
        NSString *dbPath = [docsPath stringByAppendingPathComponent:WLDbContract_DATABASE_NAME_];
        //TODO in background?
        mDbQueue = [FMDatabaseQueue databaseQueueWithPath:dbPath];
        [mDbQueue inDatabase:^(FMDatabase *db) {
            WLCompany *_c = [[WLCompany alloc] init];
            [db executeUpdate:[_c getSqlCreateTable]];
        }];
    }
    return self;
}

+ (DBHelper*)sharedInstance{
    static dispatch_once_t predicate = 0;
    __strong static id sharedObject = nil;
    dispatch_once(&predicate, ^{
        sharedObject = [[self alloc] init];
    });
    return sharedObject;
}

- (FMDatabaseQueue *)getQueue{
    return mDbQueue;
}

@end
