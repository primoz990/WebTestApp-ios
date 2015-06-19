
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

- (JavaUtilArrayList *)getFromDB{
    //TODO in backdroud thread
    return [[DBHelper sharedInstance] getCompanies];
}

- (jboolean)setToDBWithJavaUtilArrayList:(JavaUtilArrayList *)companies{
    //TODO in backdroud thread
    return [[DBHelper sharedInstance] setCompanies:companies];
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