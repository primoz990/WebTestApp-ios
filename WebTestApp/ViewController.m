
#import "ViewController.h"
#import "LoginHelper.h"

@interface ViewController ()

@end

@implementation ViewController
@synthesize tfPassword, tfUsername, btnLogin, lblStatus;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)onLoginClick:(id)sender {
    
    NSString *user = [tfUsername text];
    NSString *pass = [tfPassword text];
    
    LoginHelper *lh = [[LoginHelper alloc] init];
    lh.loginSuccess = ^{
        [lblStatus setText:@"Login success"];
    };
    lh.loginFailed = ^(NSInteger code, NSString *message){
        NSString *errorMessage = [NSString stringWithFormat:@"Login failed\n%@", message];
        [lblStatus setText:errorMessage];
    };
    [lh executeWithNSString:user withNSString:pass];
}

@end
