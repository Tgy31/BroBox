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
#import <LNNotificationsUI/LNNotificationsUI.h>


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
        
        [self test];
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

- (void)test {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        LNNotification *notification = [LNNotification notificationWithTitle:@"Title" message:@"Message"];
        [[LNNotificationCenter defaultCenter] presentNotification:notification forApplicationIdentifier:APP_IDENTIFIER];
    });
}

#pragma mark - Handler

- (void)notificationWasTapped:(NSNotification*)notification {
//    LNNotification* tappedNotification = notification.object;
    NSLog(@"Tap");
}

@end
