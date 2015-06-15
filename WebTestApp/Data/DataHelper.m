
#import <Foundation/Foundation.h>
#import "DataHelper.h"
#import "AFNetworking.h"

@interface DataHelper ()

@end

@implementation DataHelper
@synthesize onSuccess, onFailed;

- (jboolean)saveWithJavaUtilArrayList:(JavaUtilArrayList *)companies{
    //TODO implement caching
    return false;
}

- (void)getObject{
    NSLog(@"Method getObject not implemented in DataHelper.m !!!!!");
}

- (void)getString{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    [manager GET:WLDataInterface_get_URL_() parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        //TODO implement caching
        JavaUtilArrayList *list = [self parseWithNSString:operation.responseString];
        [self onSuccessWithJavaUtilArrayList:list withBoolean:NO];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self onErrorWithNSString:error.localizedDescription];
    }];
}

- (void)onSuccessWithJavaUtilArrayList:(JavaUtilArrayList *)companies withBoolean:(jboolean)cached{
    if(onSuccess){
        onSuccess(companies);
    }
}

- (void)onErrorWithNSString:(NSString *)message{
    if(onFailed){
        onFailed(message);
    }
}


@end