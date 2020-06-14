//
//  DrawViewController.m
//  TouchTracker
//
//  Created by nuko on 2020/6/9.
//  Copyright © 2020 nuko. All rights reserved.
//

#import "DrawViewController.h"
#import "DrawView.h"
@interface DrawViewController ()

@end

@implementation DrawViewController

- (void)loadView{
    self.view = [[DrawView alloc] initWithFrame:CGRectZero];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
