
#import <Foundation/Foundation.h>
#import "LoginHelper.h"
#import "AFNetworking.h"

@interface LoginHelper ()

@end

@implementation LoginHelper
@synthesize loginSuccess, loginFailed;


- (void)loginWithNSString:(NSString *)username
             withNSString:(NSString *)password{
    NSString *authHead = [self getAuthHeaderWithNSString:username withNSString:password];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    [manager.requestSerializer setValue:authHead forHTTPHeaderField:@"Authorization"];
    

    [manager GET:WLLoginInterface_get_URL_() parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"JSON: %@", responseObject);
        [self onLoginSuccess];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self onLoginFailedWithInt:0 withNSString:[error localizedDescription]];
        NSLog(@"Error: %@", error);
    }];
}

- (void)onLoginSuccess{
    if(loginSuccess){
        loginSuccess();
    }
    NSLog(@"Login Success!!!");
}

- (void)onLoginFailedWithInt:(jint)code withNSString:(NSString *)message{
    if(loginFailed){
        loginFailed(code, message);
    }
    NSLog(@"Login Failed!!!");
}


@end