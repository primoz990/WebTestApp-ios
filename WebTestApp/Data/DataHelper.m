
#import <Foundation/Foundation.h>
#import "DataHelper.h"
#import "AFNetworking.h"
#import "DataCache.h"
#import "DBHelper.h"

@interface DataHelper ()

@end

@implementation DataHelper
@synthesize onSuccess, onFailed;

- (void)getFromWeb{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    [manager GET:WLDataInterface_get_URL_() parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        JavaUtilArrayList *list = [self parseWithNSString:operation.responseString];
        [self saveWithJavaUtilArrayList:list];
        [self onSuccessWithJavaUtilArrayList:list withBoolean:NO];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self onErrorWithNSString:error.localizedDescription];
    }];
}

- (void)getFromDB{
    //TODO in backdroud thread
    [[[DBHelper sharedInstance] getQueue] inDatabase:^(FMDatabase *db) {
        JavaUtilArrayList *companies = nil;
        WLCompany *_c = [[WLCompany alloc] init];
        FMResultSet *results = [db executeQuery:[_c getSqlSelectAll]];
        if(results){
            companies = [[JavaUtilArrayList alloc] init];
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
        }
        if(companies && companies.size>0){
            NSLog(@"READED %u entries", [companies size]);
            [self onSuccessWithJavaUtilArrayList:companies withBoolean:YES];
        }else{
            NSLog(@"READED NULL");
            [self onErrorWithNSString:@"No data read from DB"];
        }
    }];
}

- (void)setToDBWithJavaUtilArrayList:(JavaUtilArrayList *)companies{
    //TODO in backdroud thread
    [[[DBHelper sharedInstance] getQueue] inDatabase:^(FMDatabase *db) {
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
}

- (void)onSuccessWithJavaUtilArrayList:(JavaUtilArrayList *)companies withBoolean:(jboolean)cached{
    if(onSuccess){
        onSuccess(companies, cached);
    }
}

- (void)onErrorWithNSString:(NSString *)message{
    if(onFailed){
        onFailed(message);
    }
}


@end