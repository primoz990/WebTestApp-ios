
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
            [db executeUpdate:WLDbContract_SQL_CREATE_COMPANIES_];
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
        BOOL b = [db executeUpdate:WLDbContract_SQL_DELETE_ALL_COMPANY_ENTRIES_];
        NSLog(@"Delete all entries: %u error message: %@", b, [db lastErrorMessage]);
        for(int i=0; i<[companies size]; i++){
            WLCompany *company = [companies getWithInt:i];
            NSString *insert = [NSString stringWithFormat:
                    @"INSERT INTO %@ (%@, %@, %@, %@, %@, %@, %@, %@, %@, %@, %@) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)",
                    WLDbContract_CompanyEntry_TABLE_NAME_,
                    WLDbContract_CommonColumns_COLUMN_NAME_ID_,
                    WLDbContract_CompanyEntry_COLUMN_NAME_TAXNUMBER_,
                    WLDbContract_CompanyEntry_COLUMN_NAME_FULLNAME_,
                    WLDbContract_CompanyEntry_COLUMN_NAME_SHORTNAME_,
                    WLDbContract_CompanyEntry_COLUMN_NAME_IDNUMBER_,
                    WLDbContract_CompanyEntry_COLUMN_NAME_ADDRESSPOSTNUMBER_,
                    WLDbContract_CompanyEntry_COLUMN_NAME_ADDRESSHOUSENUMBER_,
                    WLDbContract_CompanyEntry_COLUMN_NAME_ADDRESSMUNICIPALITY_,
                    WLDbContract_CompanyEntry_COLUMN_NAME_ADDRESSPOST_,
                    WLDbContract_CompanyEntry_COLUMN_NAME_ADDRESSSTREET_,
                    WLDbContract_CompanyEntry_COLUMN_NAME_SEARCHCOLUMN_];
            
            b = [db executeUpdate:
                    insert,
                    [NSNumber numberWithInt: i],
                    [NSNumber numberWithInt: company.getTaxNumber],
                    company.getFullName,
                    company.getShortName,
                    company.getIdNumber,
                    company.getAddressPostNumber,
                    company.getAddressHouseNumber,
                    company.getAddressMunicipality,
                    company.getAddressPost,
                    company.getAddressStreet,
                    company.getSearchColumn];
            NSLog(@"Insert entry: %u error message: %@", b, [db lastErrorMessage]);
        }
    }];
    return NO;
}

- (JavaUtilArrayList*) getCompanies{
    [mDbQueue inDatabase:^(FMDatabase *db) {
        JavaUtilArrayList *companies = [[JavaUtilArrayList alloc] init];
        NSString *select = [NSString stringWithFormat:@"SELECT * FROM %@", WLDbContract_CompanyEntry_TABLE_NAME_];
        FMResultSet *results = [db executeQuery:select];
        if(results){
            while (results.next) {
                WLCompany *company = [[WLCompany alloc] init];
                [company setTaxNumberWithInt: [results intForColumn:WLDbContract_CompanyEntry_COLUMN_NAME_TAXNUMBER_]];
                [company setFullNameWithNSString: [results stringForColumn:WLDbContract_CompanyEntry_COLUMN_NAME_FULLNAME_]];
                [company setShortNameWithNSString: [results stringForColumn:WLDbContract_CompanyEntry_COLUMN_NAME_SHORTNAME_]];
                [company setIdNumberWithNSString: [results stringForColumn:WLDbContract_CompanyEntry_COLUMN_NAME_IDNUMBER_]];
                [company setAddressPostNumberWithNSString: [results stringForColumn:WLDbContract_CompanyEntry_COLUMN_NAME_ADDRESSPOSTNUMBER_]];
                [company setAddressHouseNumberWithNSString: [results stringForColumn:WLDbContract_CompanyEntry_COLUMN_NAME_ADDRESSHOUSENUMBER_]];
                [company setAddressMunicipalityWithNSString: [results stringForColumn:WLDbContract_CompanyEntry_COLUMN_NAME_ADDRESSMUNICIPALITY_]];
                [company setAddressPostWithNSString: [results stringForColumn:WLDbContract_CompanyEntry_COLUMN_NAME_ADDRESSPOST_]];
                [company setAddressStreetWithNSString: [results stringForColumn:WLDbContract_CompanyEntry_COLUMN_NAME_ADDRESSSTREET_]];
                [company setSearchColumnWithNSString: [results stringForColumn:WLDbContract_CompanyEntry_COLUMN_NAME_SEARCHCOLUMN_]];
                [companies addWithId:company];
                NSLog(@"READ from db: %@", [company getFullName]);
            }
            NSLog(@"READED %u entries", [companies size]);
        }
    }];
    return nil;
}


@end
