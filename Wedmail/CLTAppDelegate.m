//
//  CLTAppDelegate.m
//  Wedmail
//
//  Created by Christopher Truman on 11/2/13.
//  Copyright (c) 2013 truman. All rights reserved.
//

#import "CLTAppDelegate.h"
#import "CLTLaunchViewController.h"
#import "UIApplication+Test.h"
#import <UIColor-Utilities/UIColor+Expanded.h>
#import <Pinterest/Pinterest.h>
#import <DCIntrospect/DCIntrospect.h>

@implementation CLTAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    Pinterest * pinterest = [[Pinterest alloc] initWithClientId:@"1433851"];
    [pinterest createPinWithImageURL:[NSURL URLWithString:@"http://t1.gstatic.com/images?q=tbn:ANd9GcSgQ514WJgn8Rf6kI-hWoHsob2u2dhauj5AQNKyiFRa9F4RLYLokw"] sourceURL:[NSURL URLWithString:@"http://sitmeanssit.com/dog-training-mu/houston-dog-training/puppy-classes/"] description:@"Cool pin bro"];
    CLTLaunchViewController * launchViewController = [[CLTLaunchViewController alloc] init];
    UINavigationController * navigationController = [[UINavigationController alloc] initWithRootViewController:launchViewController];
    [navigationController setNavigationBarHidden:YES];
    [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
    [[UINavigationBar appearance] setBarTintColor:[UIColor colorWithHexString:@"bcd756"]];
    [[UINavigationBar appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName: [UIColor whiteColor], NSFontAttributeName: [UIFont fontWithName:@"Gotham" size:18]}];

    self.window.rootViewController = navigationController;

    [self.window makeKeyAndVisible];

#if TARGET_IPHONE_SIMULATOR
    [[DCIntrospect sharedIntrospector] start];
#endif 
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
