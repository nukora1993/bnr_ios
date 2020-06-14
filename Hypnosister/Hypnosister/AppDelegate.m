//
//  AppDelegate.m
//  Hypnosister
//
//  Created by nuko on 2020/6/8.
//  Copyright © 2020 nuko. All rights reserved.
//

#import "AppDelegate.h"
#import "HypnosisView.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
//    CGRect firstFrame = CGRectMake(160, 240, 100, 150);
//    CGRect firstFrame = self.window.bounds;
//
//    HypnosisView *firstView =[[HypnosisView alloc] initWithFrame:firstFrame];
    
    CGRect screenRect = self.window.bounds;
    CGRect bigRect = screenRect;
    bigRect.size.width *= 2.0;
//    bigRect.size.height *= 2.0;
    
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:screenRect];
    scrollView.pagingEnabled = YES;
    
//    firstView.backgroundColor = [UIColor redColor];
    
//    [self.window addSubview:firstView];
    
//    CGRect secondFrame = CGRectMake(20, 30, 50, 50);
//
//    HypnosisView *secondView = [[HypnosisView alloc] initWithFrame:secondFrame];
//    secondView.backgroundColor = [UIColor blueColor];
    
//    [self.window addSubview:secondView];
//    [firstView addSubview:secondView];
    self.window.rootViewController = [[UIViewController alloc] init];
    
    // we need add sub view to content view, or our custom view will be masked
//    [self.window.rootViewController.view addSubview:firstView];
    [self.window.rootViewController.view addSubview:scrollView];
//    HypnosisView *hypnosisView =[[HypnosisView alloc] initWithFrame:bigRect];
    HypnosisView *hypnosisView = [[HypnosisView alloc] initWithFrame:screenRect];
    
    [scrollView addSubview:hypnosisView];
    
    screenRect.origin.x += screenRect.size.width;
    HypnosisView *anotherView = [[HypnosisView alloc] initWithFrame:screenRect];
    [scrollView addSubview:anotherView];
    
    scrollView.contentSize = bigRect.size;
    
    self.window.backgroundColor = [UIColor whiteColor];
    
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
