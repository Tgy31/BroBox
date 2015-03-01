//
//  BBNotificationManager.m
//  BroBox
//
//  Created by Tanguy Hélesbeux on 07/02/2015.
//  Copyright (c) 2015 Brobox. All rights reserved.
//

#import "BBNotificationManager.h"
#import "BBConstants.h"

// Frameworks
#import "LNNotificationsUI.h"


#define APP_NAME @"BroBox"
#define APP_ICON @"pin.png"

static BBNotificationManager *sharedManager;

@interface BBNotificationManager()

@property (nonatomic) BOOL isInitialized;

@end

@implementation BBNotificationManager

#pragma mark - Singleton

+ (void)initialize {
    [[BBNotificationManager sharedManager] initialize];
}

- (void)initialize {
    if (!self.isInitialized) {
        [self registerApp];
        [self registerToNotificationTap];
        self.isInitialized = YES;
    }
}

+ (BBNotificationManager *)sharedManager {
    if (!sharedManager) {
        sharedManager = [BBNotificationManager new];
    }
    return sharedManager;
}

#pragma mark - Initialization

- (void)registerApp {
    [[LNNotificationCenter defaultCenter] registerApplicationWithIdentifier:APP_IDENTIFIER
                                                                       name:APP_NAME
                                                                       icon:[UIImage imageNamed:APP_ICON]
                                                            defaultSettings:LNNotificationDefaultAppSettings];
}

- (void)registerToNotificationTap {
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(notificationWasTapped:)
                                                 name:LNNotificationWasTappedNotification
                                               object:nil];
}

#pragma mark - Notifications

#pragma mark - Handler

+ (void)handleRemoteNotification:(NSDictionary *)userInfo {
    [[BBNotificationManager sharedManager] handleRemoteNotification:userInfo];
}

- (void)handleRemoteNotification:(NSDictionary *)userInfo {
//    Default data
    NSString *title = [userInfo objectForKey:@"title"];
    
//    Optional data
    NSDictionary *aps = [userInfo objectForKey:@"aps"];
    NSString *message = [aps objectForKey:@"alert"];
    LNNotification *notification = [[LNNotification alloc] initWithTitle:title
                                                                 message:message];
    
    [[LNNotificationCenter defaultCenter] presentNotification:notification
                                     forApplicationIdentifier:APP_IDENTIFIER
                                                     userInfo:userInfo];
}

- (void)notificationWasTapped:(NSNotification*)notification {
//    LNNotification* tappedNotification = notification.object;
    NSLog(@"Tap");
}

#pragma mark - Send Notifications

+ (void)pushNotificationWithMessage:(NSString *)message
                               info:(NSDictionary *)info
                            toQuery:(PFQuery *)query {
    
    NSMutableDictionary *data = [info mutableCopy];
    [data setObject:message forKey:@"alert"];
    
    // Send push notification to query
    PFPush *push = [[PFPush alloc] init];
    [push setQuery:query];
    [push setData:data];
    [push sendPushInBackground];
}

+ (void)pushNotificationWithMessage:(NSString *)message
                               info:(NSDictionary *)info
                             toUser:(BBParseUser *)user {
    
    PFQuery *query = [PFInstallation query];
    [query whereKey:@"user" equalTo:user];
    
    [self pushNotificationWithMessage:message info:info toQuery:query];
}

@end
