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

// Managers
#import "BBInstallationManager.h"
#import "BBParseManager.h"


#define APP_NAME @"BroBox"
#define APP_ICON @"pin.png"

#define NOTIFICATION_KEY_TITLE @"title"
#define NOTIFICATION_KEY_SUBTITLE @"subtitle"
#define NOTIFICATION_KEY_TYPE @"type"
#define NOTIFICATION_KEY_MESSAGE @"alert"

static NSString *BBNotificationKeyNewCarrier = @"BBNotificationKeyNewCarrier";
static NSString *BBNotificationKeySelectedCarrier = @"BBNotificationKeySelectedCarrier";
static NSString *BBNotificationKeyNewMessage = @"BBNotificationKeyNewMessage";

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
    NSDictionary *aps = [userInfo objectForKey:@"aps"];
    NSString *message = [aps objectForKey:@"alert"];
    
    //    Optional data
    NSString *title = [userInfo objectForKey:@"title"];
    
    LNNotification *notification = [[LNNotification alloc] initWithTitle:title
                                                                 message:message];
    
    [[LNNotificationCenter defaultCenter] presentNotification:notification
                                     forApplicationIdentifier:APP_IDENTIFIER
                                                     userInfo:userInfo];
    
    BBNotificationType type = [BBNotificationManager typeFromNotificationData:userInfo];
    
    switch (type) {
        case BBNotificationTypeNewCarrier: {
            BBParseMission *mission = [BBInstallationManager userActiveMission];
            [self refreshMissionMessages:mission];
            break;
        }
        case BBNotificationTypeSelectedCarrier:
            break;
        case BBNotificationTypeNewMessage:
            break;
            
        default:
            break;
    }
}

- (void)notificationWasTapped:(NSNotification*)notification {
//    LNNotification* tappedNotification = notification.object;
    
    BBNotificationType type = [BBNotificationManager typeFromNotificationData:notification.userInfo];
    
    switch (type) {
        case BBNotificationTypeNewCarrier:
            [self handleNotificationForNewCarrierTapped:notification];
            break;
        case BBNotificationTypeSelectedCarrier:
            [self handleNotificationForSelectedCarrierTapped:notification];
            break;
        case BBNotificationTypeNewMessage:
            [self handleNotificationForNewMessageTapped:notification];
            break;
            
        default:
            break;
    }
}

- (void)handleNotificationForNewCarrierTapped:(NSNotification *)notification {
    
}

- (void)handleNotificationForSelectedCarrierTapped:(NSNotification *)notification {
    
}

- (void)handleNotificationForNewMessageTapped:(NSNotification *)notification {
}

- (void)refreshMissionMessages:(BBParseMission *)mission {
    if (mission) {
        [BBParseManager fetchMessagesForMission:mission withBlock:nil];
    }
}

#pragma mark - Send Notifications

+ (void)pushNotificationWithMessage:(NSString *)message
                              title:(NSString *)title
                           subtitle:(NSString *)subtitle
                               type:(BBNotificationType)type
                               info:(NSDictionary *)info
                            toQuery:(PFQuery *)query {
    
    NSMutableDictionary *data = [info mutableCopy];
    [data setObject:message forKey:NOTIFICATION_KEY_MESSAGE];
    [data setObject:title forKey:NOTIFICATION_KEY_TITLE];
    [data setObject:subtitle forKey:NOTIFICATION_KEY_SUBTITLE];
    [data setObject:[self keyForNotificationType:type] forKey:NOTIFICATION_KEY_TYPE];
    
    // Send push notification to query
    PFPush *push = [[PFPush alloc] init];
    [push setQuery:query];
    [push setData:data];
    [push sendPushInBackground];
}

+ (void)pushNotificationWithMessage:(NSString *)message
                              title:(NSString *)title
                           subtitle:(NSString *)subtitle
                               type:(BBNotificationType)type
                               info:(NSDictionary *)info
                             toUser:(BBParseUser *)user {
    
    PFQuery *query = [PFInstallation query];
    [query whereKey:@"user" equalTo:user];
    
    [self pushNotificationWithMessage:message
                                title:title
                             subtitle:subtitle
                                 type:type
                                 info:info
                              toQuery:query];
}

#pragma mark - Helpers

+ (NSString *)keyForNotificationType:(BBNotificationType)type {
    switch (type) {
        case BBNotificationTypeNewCarrier:
            return BBNotificationKeyNewCarrier;
        case BBNotificationTypeSelectedCarrier:
            return BBNotificationKeySelectedCarrier;
        case BBNotificationTypeNewMessage:
            return BBNotificationKeyNewMessage;
            
        default:
            return nil;
    }
}

+ (BBNotificationType)typeFromNotificationData:(NSDictionary *)data {
    NSString *typeKey = [data objectForKey:NOTIFICATION_KEY_TYPE];
    
    if ([typeKey isEqualToString:BBNotificationKeyNewCarrier]) {
        return BBNotificationTypeNewCarrier;
    } else if ([typeKey isEqualToString:BBNotificationKeySelectedCarrier]) {
        return BBNotificationTypeSelectedCarrier;
    } else if ([typeKey isEqualToString:BBNotificationKeyNewMessage]) {
        return BBNotificationTypeNewMessage;
    }
    return -1;
}

@end
