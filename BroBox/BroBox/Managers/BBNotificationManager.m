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
#import "AppDelegate.h"
#import "BBInstallationManager.h"
#import "BBParseManager.h"
#import "BBAlertManager.h"


#define APP_NAME @"BroBox"
#define APP_ICON @"pin.png"

#define NOTIFICATION_KEY_TITLE @"title"
#define NOTIFICATION_KEY_SUBTITLE @"subtitle"
#define NOTIFICATION_KEY_TYPE @"type"
#define NOTIFICATION_KEY_MESSAGE @"alert"
#define NOTIFICATION_KEY_MISSION @"mission"

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

+ (void)openApplicationWithRemoteNotification:(NSDictionary *)userInfo {
    [[BBNotificationManager sharedManager] openApplicationWithRemoteNotification:userInfo];
}

- (void)openApplicationWithRemoteNotification:(NSDictionary *)userInfo {
    
    BBNotificationType type = [BBNotificationManager typeFromNotificationData:userInfo];
    
    switch (type) {
        case BBNotificationTypeNewCarrier: {
            [self presentNotification:userInfo];
            break;
        }
            
        case BBNotificationTypeSelectedCarrier: {
            [self handleSelectedCarrierNotification:userInfo];
            break;
        }
            
        case BBNotificationTypeNewMessage: {
            [self presentNotification:userInfo];
            break;
        }
            
        default:
            break;
    }
}

+ (void)handleRemoteNotification:(NSDictionary *)userInfo {
    [[BBNotificationManager sharedManager] handleRemoteNotification:userInfo];
}

- (void)handleRemoteNotification:(NSDictionary *)userInfo {
    
    BBNotificationType type = [BBNotificationManager typeFromNotificationData:userInfo];
    
    switch (type) {
        case BBNotificationTypeNewCarrier: {
            [self presentNotification:userInfo];
            break;
        }
            
        case BBNotificationTypeSelectedCarrier: {
            [self handleSelectedCarrierNotification:userInfo];
            break;
        }
            
        case BBNotificationTypeNewMessage: {
            BBParseMission *mission = [BBInstallationManager activeMission];
            [self refreshMissionMessages:mission];
            [self presentNotification:userInfo];
            break;
        }
            
        default:
            break;
    }
}

- (void)handleSelectedCarrierNotification:(NSDictionary *)userInfo {
    
    NSString *missionID = [userInfo objectForKey:NOTIFICATION_KEY_MISSION];
    [BBParseManager fetchMissionWithID:missionID withBlock:^(PFObject *object, NSError *error) {
        
        BBParseMission *mission = (BBParseMission *)object;
        [BBAlertManager presentAlertForMissionStart:mission withBlock:^(BBParseMission *mission) {
            NSNotification *notification = [NSNotification notificationWithName:@"notification" object:mission];
            [self notificationForSelectedCarrierTapHandler:notification];
        }];
        
    }];
}

- (void)presentNotification:(NSDictionary *)userInfo {
    
    //    Default data
    NSDictionary *aps = [userInfo objectForKey:@"aps"];
    NSString *message = [aps objectForKey:NOTIFICATION_KEY_MESSAGE];
    
    //    Optional data
    NSString *title = [userInfo objectForKey:NOTIFICATION_KEY_TITLE];
    NSString *subtitle = [userInfo objectForKey:NOTIFICATION_KEY_SUBTITLE];
    
    LNNotification *notification = [[LNNotification alloc] initWithTitle:title ? title : @"BroBox"
                                                                 message:subtitle ? subtitle : message];
    
    [[LNNotificationCenter defaultCenter] presentNotification:notification
                                     forApplicationIdentifier:APP_IDENTIFIER
                                                     userInfo:userInfo];
}

- (void)notificationWasTapped:(NSNotification*)notification {
//    LNNotification* tappedNotification = notification.object;
    
    BBNotificationType type = [BBNotificationManager typeFromNotificationData:notification.userInfo];
    
    switch (type) {
        case BBNotificationTypeNewCarrier:
            [self notificationForNewCarrierTapHandler:notification];
            break;
        case BBNotificationTypeSelectedCarrier:
            [self notificationForSelectedCarrierTapHandler:notification];
            break;
        case BBNotificationTypeNewMessage:
            [self notificationForNewMessageTapHandler:notification];
            break;
            
        default:
            break;
    }
}

- (void)notificationForNewCarrierTapHandler:(NSNotification *)notification {
    
}

- (void)notificationForSelectedCarrierTapHandler:(NSNotification *)notification {
    
    BBParseMission *mission = (BBParseMission *)notification.object;
    [BBInstallationManager setActiveMission:mission];
    [AppDelegate presentCarrierScreenForMission:mission];
}

- (void)notificationForNewMessageTapHandler:(NSNotification *)notification {
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
