//
//  ReminderViewController.m
//  HypnoNerd
//
//  Created by nuko on 2020/6/8.
//  Copyright © 2020 nuko. All rights reserved.
//

#import "ReminderViewController.h"

@interface ReminderViewController ()

@property (nonatomic, weak) IBOutlet UIDatePicker *datePicker;

@end

@implementation ReminderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    NSLog(@"ReminderViewController loaded its view.");
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    self.datePicker.minimumDate = [NSDate dateWithTimeIntervalSinceNow:60];
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)addReminder:(id)sender{
    NSDate *date = self.datePicker.date;
    NSLog(@"Setting a reminder for %@", date);
    
    // before ios 10
    UILocalNotification *note = [[UILocalNotification alloc] init];
    note.alertBody = @"Hypnotize me!";
    note.fireDate = date;
    
    UIUserNotificationSettings *local = [UIUserNotificationSettings settingsForTypes:1<<2 categories:nil];
    
    [[UIApplication sharedApplication] registerUserNotificationSettings:local];
    
    [[UIApplication sharedApplication] scheduleLocalNotification:note];
}

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    
    if (self) {
        UITabBarItem *tbi = self.tabBarItem;
        
        tbi.title = @"Reminder";
        
        UIImage *i= [UIImage imageNamed:@"Time.png"];
        tbi.image = i;
    }
    return self;
}



@end
