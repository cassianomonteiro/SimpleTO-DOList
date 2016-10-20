//
//  AppDelegate.m
//  SimpleTO-DOList
//
//  Created by Cassiano Monteiro on 19/10/16.
//  Copyright © 2016 Cassiano Monteiro. All rights reserved.
//

#import "AppDelegate.h"
#import <Firebase.h>
#import <MagicalRecord/MagicalRecord.h>
#import <FirebaseAuthUI/FirebaseAuthUI.h>

@implementation AppDelegate

#pragma mark - Test-specific setup to improve unit tests processing

static BOOL isRunningTests(void) __attribute__((const));

/**
 * Method to check if unit tests are being run
 * @link https://www.objc.io/issues/1-view-controllers/testing-view-controllers/
 */
static BOOL isRunningTests(void) {
    NSDictionary* environment = [[NSProcessInfo processInfo] environment];
    NSString* injectBundle = environment[@"XCInjectBundleInto"];
    return (injectBundle != nil);
}

- (BOOL)setUpTestEnvironment
{
    [MagicalRecord setLoggingLevel:MagicalRecordLoggingLevelAll];
    [MagicalRecord setupCoreDataStackWithInMemoryStore];
    return YES;
}

#pragma mark - <UIApplicationDelegate>

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
#ifdef DEBUG
    // Avoid doing unnecessary stuff on unit tests
    if (isRunningTests()) return [self setUpTestEnvironment];
#endif
    
    [MagicalRecord setupAutoMigratingCoreDataStack];
    [FIRApp configure];
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    
    // Saves changes in the application's managed object context before the application terminates.
    [MagicalRecord cleanUp];
}

- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<UIApplicationOpenURLOptionsKey,id> *)options
{
    NSString *sourceApplication = options[UIApplicationOpenURLOptionsSourceApplicationKey];
    return [[FIRAuthUI defaultAuthUI] handleOpenURL:url sourceApplication:sourceApplication];
}

@end
