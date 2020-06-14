//
//  AppDelegate.m
//  HypnoNerd
//
//  Created by nuko on 2020/6/8.
//  Copyright © 2020 nuko. All rights reserved.
//

#import "AppDelegate.h"
#import "HypnosisViewController.h"
#import "ReminderViewController.h"
@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor whiteColor];
//    self.window.rootViewController = [[UIViewController alloc] init];
    HypnosisViewController *hvc = [[HypnosisViewController alloc] init];
    // notice that, we do not set the frame for the view of hvc, by default, the frame is the bounds of the window
//    self.window.rootViewController = hvc;
    
//    NSBundle *appBundle = [NSBundle mainBundle];
//    ReminderViewController *rvc = [[ReminderViewController alloc] initWithNibName:@"ReminderViewController" bundle:appBundle];
    
    ReminderViewController *rvc =[[ReminderViewController alloc] init];
    
    UITabBarController *tabBarController = [[UITabBarController alloc] init];
    tabBarController.viewControllers = @[hvc, rvc];
    
//    self.window.rootViewController = rvc;
    self.window.rootViewController = tabBarController;
    
    [self.window makeKeyAndVisible];

    return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


@end
