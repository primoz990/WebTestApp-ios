
#import "DataTableViewController.h"
#import "Company.h"

@interface DataTableViewController ()

@end

@implementation DataTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    companiesList = [[JavaUtilArrayList alloc] init];
    
    DataHelper *dh = [[DataHelper alloc] init];
    dh.onSuccess = ^(JavaUtilArrayList* companies, BOOL cached){
        [companiesList clear];
        companiesList = companies;
        [self.tableView reloadData];
        NSLog(@"Cache: %u", cached);
    };
    dh.onFailed = ^(NSString *message){
        NSLog(@"Getting data ERROR: %@", message);
    };
    [dh execute];
}

- (IBAction)onBackClick:(id)sender {
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [companiesList size];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    

    WLCompany *company = [companiesList getWithInt:(int)indexPath.row];
    [cell.textLabel setText:[company getFullName]];
    [cell.detailTextLabel setText:[company getAddressStreet]];
    
    return cell;
}

@end
