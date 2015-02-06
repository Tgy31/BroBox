//
//  BBInstallationManager.m
//  BroBox
//
//  Created by Tanguy Hélesbeux on 06/02/2015.
//  Copyright (c) 2015 Brobox. All rights reserved.
//

#import "BBInstallationManager.h"

// Managers
#import "BBLoginManager.h"

static BBInstallationManager *sharedManager;

@interface BBInstallationManager()


@end

@implementation BBInstallationManager

#pragma mark - Singleton

+ (BBInstallationManager *)sharedManager {
    if (!sharedManager) {
        sharedManager = [BBInstallationManager new];
    }
    return sharedManager;
}

#pragma mark - Braodcast

- (void)registerToUserSessionStateChanges {
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(handleLogInNotification)
                                                 name:BBSessionLoginNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(handleLogOutNotification)
                                                 name:BBSessionLogoutNotification object:nil];
}

- (void)handleLogInNotification {
    [self fetchUserActiveMissionRequest];
}

- (void)handleLogOutNotification {
    [self clearUserProperties];
}

#pragma mark - API

- (void)fetchUserActiveMissionRequest {
    
}

#pragma mark - User properties

- (void)clearUserProperties {
    self.userActiveMissionRequest = nil;
}

@end
