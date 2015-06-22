
#import "DBHelper.h"
#import "Company.h"
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

- (BOOL) setCompanies:(JavaUtilArrayList*)companies{
    [mDbQueue inDatabase:^(FMDatabase *db) {
        WLCompany *_c = [[WLCompany alloc] init];
        BOOL b = [db executeUpdate:[_c getSqlDeleteEntries]];
        NSLog(@"Delete all entries: %u error message: %@", b, [db lastErrorMessage]);
        for(int i=0; i<[companies size]; i++){
            WLCompany *company = [companies getWithInt:i];
            NSString *insert = [company getSqlInsert];
            if(insert && insert.length>0){
                b = [db executeUpdate:insert];
            }
            NSLog(@"Insert entry: %u error message: %@", b, [db lastErrorMessage]);
        }
    }];
    return NO;
}

- (JavaUtilArrayList*) getCompanies{
    [mDbQueue inDatabase:^(FMDatabase *db) {
        JavaUtilArrayList *companies = [[JavaUtilArrayList alloc] init];
        WLCompany *_c = [[WLCompany alloc] init];
        FMResultSet *results = [db executeQuery:[_c getSqlSelectAll]];
        if(results){
            while (results.next) {
                WLCompany *company = [[WLCompany alloc] init];
                [company setTaxNumberWithInt: [results intForColumn:WLCompany_SQL_COLUMN_NAME_TAXNUMBER_]];
                [company setFullNameWithNSString: [results stringForColumn:WLCompany_SQL_COLUMN_NAME_FULLNAME_]];
                [company setShortNameWithNSString: [results stringForColumn:WLCompany_SQL_COLUMN_NAME_SHORTNAME_]];
                [company setIdNumberWithNSString: [results stringForColumn:WLCompany_SQL_COLUMN_NAME_IDNUMBER_]];
                [company setAddressPostNumberWithNSString: [results stringForColumn:WLCompany_SQL_COLUMN_NAME_ADDRESSPOSTNUMBER_]];
                [company setAddressHouseNumberWithNSString: [results stringForColumn:WLCompany_SQL_COLUMN_NAME_ADDRESSHOUSENUMBER_]];
                [company setAddressMunicipalityWithNSString: [results stringForColumn:WLCompany_SQL_COLUMN_NAME_ADDRESSMUNICIPALITY_]];
                [company setAddressPostWithNSString: [results stringForColumn:WLCompany_SQL_COLUMN_NAME_ADDRESSPOST_]];
                [company setAddressStreetWithNSString: [results stringForColumn:WLCompany_SQL_COLUMN_NAME_ADDRESSSTREET_]];
                [company setSearchColumnWithNSString: [results stringForColumn:WLCompany_SQL_COLUMN_NAME_SEARCHCOLUMN_]];
                [companies addWithId:company];
                NSLog(@"READ from db: %@", [company getFullName]);
            }
            NSLog(@"READED %u entries", [companies size]);
        }
    }];
    return nil;
}


@end
