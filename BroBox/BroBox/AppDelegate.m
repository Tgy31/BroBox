//
//  AppDelegate.m
//  BroBox
//
//  Created by Tanguy Hélesbeux on 22/01/2015.
//  Copyright (c) 2015 Brobox. All rights reserved.
//

#import "AppDelegate.h"

#import <Parse/Parse.h>
#import <ParseFacebookUtils/PFFacebookUtils.h>
#import <FacebookSDK/FacebookSDK.h>

// Controllers
#import "BBLoginVC.h"
#import "BBRootVC.h"
#import "BBSignUpNavigationController.h"
#import "BBClientModeNavigationController.h"

// Managers
#import "BBLoginManager.h"
#import "BBInstallationManager.h"
#import "BBNotificationManager.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    // Parse.com
    [Parse setApplicationId:@"fI62p2aPbqyKFQIL61QpVP3jPCu9PwMmrYCGPAMz"
                  clientKey:@"KAKyr3cG0gkx2bHHkLNgG8yRbz07dYTQCGA5MnO1"];
    [PFFacebookUtils initializeFacebook];
    // [Optional] Track statistics around application opens.
    [PFAnalytics trackAppOpenedWithLaunchOptions:launchOptions];
    
    [self applicationRegisterToParsePushNotifications:application];
    
    [BBInstallationManager initialize];
    [BBNotificationManager initialize];
    
    [self initializeWindow];
    [self presentLoginScreen];
    
    return YES;
}

- (void)applicationRegisterToParsePushNotifications:(UIApplication *)application {
    UIUserNotificationType userNotificationTypes = (UIUserNotificationTypeAlert |
                                                    UIUserNotificationTypeBadge |
                                                    UIUserNotificationTypeSound);
    UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:userNotificationTypes
                                                                             categories:nil];
    [application registerUserNotificationSettings:settings];
    [application registerForRemoteNotifications];
}

- (void)application:(UIApplication *)application
didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    // Store the deviceToken in the current Installation and save it to Parse.
    PFInstallation *currentInstallation = [PFInstallation currentInstallation];
    [currentInstallation setDeviceTokenFromData:deviceToken];
    [currentInstallation saveInBackground];
}

- (void)application:(UIApplication *)application
didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    NSLog(@"%@", error);
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    
    [FBAppCall handleDidBecomeActiveWithSession:[PFFacebookUtils session]];
    
    // Logs 'install' and 'app activate' App Events.
    [FBAppEvents activateApp];
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation {
    // attempt to extract a token from the url
    return [FBAppCall handleOpenURL:url sourceApplication:sourceApplication];
}

#pragma mark - App screens

- (void)initializeWindow {
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
}

- (void)presentLoginScreen {
    self.window.rootViewController = [BBLoginVC new];
}

- (void)presentRootScreen {
    self.window.rootViewController = [BBRootVC new];
}

- (void)presentSignUpScreen {
    self.window.rootViewController = [BBSignUpNavigationController new];
}

- (void)presentClientScreenForMission:(BBParseMission *)mission {
    self.window.rootViewController = [BBClientModeNavigationController newWithMission:mission];
}

- (void)presentCarrierScreenForMission:(BBParseMission *)mission
{
    
}

+ (void)presentLoginScreen
{
    [[self sharedDelegate] presentLoginScreen];
}

+ (void)presentRootScreen
{
    [[self sharedDelegate] presentRootScreen];
}

+ (void)presentSignUpScreen {
    [[self sharedDelegate] presentSignUpScreen];
}

+ (void)presentClientScreenForMission:(BBParseMission *)mission {
    [[self sharedDelegate] presentClientScreenForMission:mission];
}

+ (void)presentCarrierScreenForMission:(BBParseMission *)mission {
    [[self sharedDelegate] presentCarrierScreenForMission:mission];
}

#pragma mark - Helpers

+ (AppDelegate *)sharedDelegate {
    return (AppDelegate *)[[UIApplication sharedApplication] delegate];
}

@end
