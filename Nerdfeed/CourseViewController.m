//
//  CourseViewController.m
//  Nerdfeed
//
//  Created by nuko on 2020/6/11.
//  Copyright © 2020 nuko. All rights reserved.
//

#import "CourseViewController.h"
#import "WebViewController.h"

@interface CourseViewController () <NSURLSessionDataDelegate>

@property (nonatomic) NSURLSession *session;
@property (nonatomic, copy) NSArray *courses;

@end

@implementation CourseViewController

- (void)URLSession:(NSURLSession *)session didReceiveChallenge:(NSURLAuthenticationChallenge *)challenge completionHandler:(void (^)(NSURLSessionAuthChallengeDisposition, NSURLCredential * _Nullable))completionHandler{
    NSURLCredential *cred = [NSURLCredential credentialWithUser:@"admin" password:@"admin" persistence:NSURLCredentialPersistenceForSession];
    
    completionHandler(NSURLSessionAuthChallengeUseCredential, cred);
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSDictionary *course = self.courses[indexPath.row];
    NSURL *URL = [NSURL URLWithString:course[@"url"]];
    
    self.webViewController.title = course[@"title"];
    self.webViewController.URL = URL;
//    [self.navigationController pushViewController:self.webViewController animated:YES];
    
    if (!self.splitViewController) {
        [self.navigationController pushViewController:self.webViewController animated:YES];
    }
    
    
}

- (void)fetchFeed{
    NSString *requestString = @"http://bookapi.bignerdranch.com/courses.json";
    NSURL *url = [NSURL URLWithString:requestString];
    NSURLRequest *req = [NSURLRequest requestWithURL:url];
    
    // create task using NSSession factory
    NSURLSessionDataTask *dataTask = [self.session dataTaskWithRequest:req completionHandler:^(NSData *data, NSURLResponse *response, NSError *error){
//        NSString *json = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        
//        NSLog(@"%@", json);
        
        NSDictionary *jsonObject;
        
        if (data) {
            jsonObject = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
        }else{
            jsonObject = @{@"courses":@[@{ @"title": @"baidu", @"url": @"http://baidu.com"}, @{@"title": @"bing", @"url": @"http://bing.com"}]};
        }
        
        
//        NSLog(@"%@", jsonObject);
        self.courses = jsonObject[@"courses"];
        
        NSLog(@"%@", self.courses);
        
        // notify ui thread
        dispatch_async(dispatch_get_main_queue(), ^{
            NSLog(@"async executed");
            [self.tableView reloadData];
        });
        
    }];
    // do task
    [dataTask resume];
}

- (instancetype)initWithStyle:(UITableViewStyle)style{
    self = [super initWithStyle:style];
    if (self) {
        self.navigationItem.title = @"Courses";
        
        NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
        
        // create NSSession
//        _session = [NSURLSession sessionWithConfiguration:config delegate:nil delegateQueue:nil];
        
        _session = [NSURLSession sessionWithConfiguration:config delegate:self delegateQueue:nil];
        // begin task
        [self fetchFeed];
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"UITableViewCell"];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
#warning Incomplete implementation, return the number of sections
    // gosh, we need return at least 1, or the table view cell will not display
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSLog(@"%@ has been executed", NSStringFromSelector(_cmd));
    return [self.courses count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
//    return nil;
    NSLog(@"%@ has been executed", NSStringFromSelector(_cmd));
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell" forIndexPath:indexPath];
    
    NSDictionary *course = self.courses[indexPath.row];
    cell.textLabel.text = course[@"title"];
    
    return cell;
}

/*
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:<#@"reuseIdentifier"#> forIndexPath:indexPath];
    
    // Configure the cell...
    
    return cell;
}
*/

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
