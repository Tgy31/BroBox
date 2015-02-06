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
#import "BBParseManager.h"


static BBInstallationManager *sharedManager;

@interface BBInstallationManager()

@property (nonatomic) BOOL isInitialized;


@end

@implementation BBInstallationManager

#pragma mark - Singleton

+ (void)initialize {
    [[BBInstallationManager sharedManager] initialize];
}

- (void)initialize {
    if (!self.isInitialized) {
        sharedManager.userActiveMissionRequestIsLoading = NO;
        [sharedManager registerToUserSessionStateChanges];
        self.isInitialized = YES;
    }
}

+ (BBInstallationManager *)sharedManager {
    if (!sharedManager) {
        sharedManager = [BBInstallationManager new];
    }
    return sharedManager;
}

#pragma mark - Getters & Setters

- (void)setUserActiveMissionRequestIsLoading:(BOOL)userActiveMissionRequestIsLoading {
    _userActiveMissionRequestIsLoading = userActiveMissionRequestIsLoading;
    
    if (userActiveMissionRequestIsLoading) {
        [self notifyUserActiveMisssionRequestIsLoading];
    } else {
        [self notifiUserActiveMissionRequestDidChange];
    }
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

- (void)notifyUserActiveMisssionRequestIsLoading {
    [[NSNotificationCenter defaultCenter] postNotificationName:BBNotificationUserActiveMissionRequestIsLoading
                                                        object:nil];
}

- (void)notifiUserActiveMissionRequestDidChange {
    [[NSNotificationCenter defaultCenter] postNotificationName:BBNotificationUserActiveMissionRequestDidChange
                                                        object:nil];
}

#pragma mark - API

- (void)fetchUserActiveMissionRequest {
    self.userActiveMissionRequestIsLoading = YES;
    [BBParseManager fetchUserActiveMissionRequest:[BBParseUser currentUser]
                                        withBlock:^(PFObject *object, NSError *error) {
                                            if (!error) {
                                                self.userActiveMissionRequest = (BBParseMissionRequest *)object;
                                            } else {
                                                self.userActiveMissionRequest = nil;
                                            }
                                            self.userActiveMissionRequestIsLoading = NO;
    }];
}

#pragma mark - User properties

- (void)clearUserProperties {
    self.userActiveMissionRequest = nil;
}

@end
