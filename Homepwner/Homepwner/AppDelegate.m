//
//  AppDelegate.m
//  Homepwner
//
//  Created by nuko on 2020/6/8.
//  Copyright © 2020 nuko. All rights reserved.
//

#import "AppDelegate.h"
#import "ItemsViewController.h"
#import "ItemStore.h"

NSString * const NextItemValuePrefsKey = @"NextItemValue";
NSString * const NextItemNamePrefsKey = @"NextItemName";

@interface AppDelegate ()

@end

@implementation AppDelegate

// called before the creation of the first class instance
+ (void)initialize{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSDictionary *factorySettings = @{NextItemValuePrefsKey : @75,
                                      NextItemNamePrefsKey : @"Coffee Cup"};
    
    [defaults registerDefaults:factorySettings];
    
    
}

- (BOOL)application:(UIApplication *)application shouldSaveApplicationState:(NSCoder *)coder{
    return YES;
}


- (BOOL)application:(UIApplication *)application shouldRestoreApplicationState:(NSCoder *)coder{
    return YES;
}

- (BOOL)application:(UIApplication *)application willFinishLaunchingWithOptions:(NSDictionary<UIApplicationLaunchOptionsKey,id> *)launchOptions{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor whiteColor];
    
    return YES;
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    NSLog(@"%@", NSStringFromSelector(_cmd));
    // Override point for customization after application launch.
//    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    // if state restoration did not occur, if occur, the root view controller must not be nil
    if (!self.window.rootViewController) {
        ItemsViewController *itemsViewController = [[ItemsViewController alloc] init];
            
        //    self.window.backgroundColor = [UIColor whiteColor];
        //    self.window.rootViewController = [[UIViewController alloc] init];
        //    self.window.rootViewController = itemsViewController;
        UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:itemsViewController];
        
        // restoration identifier
        navController.restorationIdentifier = NSStringFromClass([navController class]);
        
        self.window.rootViewController = navController;
        
        
    }
    
    
    [self.window makeKeyAndVisible];
    

    return YES;
}

- (UIViewController *)application:(UIApplication *)application viewControllerWithRestorationIdentifierPath:(NSArray<NSString *> *)identifierComponents coder:(NSCoder *)coder{
    UIViewController *vc = [[UINavigationController alloc] init];
    
    vc.restorationIdentifier = [identifierComponents lastObject];
    
    if ([identifierComponents count] == 1) {
        self.window.rootViewController = vc;
    }
    
    return vc;
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    NSLog(@"%@", NSStringFromSelector(_cmd));
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    NSLog(@"%@", NSStringFromSelector(_cmd));
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // when app enter in background, we need store the data
    BOOL success = [[ItemStore sharedStore] saveChanges];
    if (success) {
        NSLog(@"Saved all of the Items");
    }else{
        NSLog(@"Could not save any of the items");
    }
    
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    NSLog(@"%@", NSStringFromSelector(_cmd));
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    NSLog(@"%@", NSStringFromSelector(_cmd));
}

- (void)applicationWillTerminate:(UIApplication *)application{
    NSLog(@"%@", NSStringFromSelector(_cmd));
}


@end
