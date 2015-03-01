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
        sharedManager.userActiveMissionIsLoading = NO;
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

+ (BBParseMission *)userActiveMission {
    return [BBInstallationManager sharedManager].userActiveMission;
}

+ (BOOL)userActiveMissionIsLoading {
    return [BBInstallationManager sharedManager].userActiveMissionIsLoading;
}

+ (void)setUserActiveMission:(BBParseMission *)userActiveMission {
    [[BBInstallationManager sharedManager] setUserActiveMission:userActiveMission];
}

- (void)setUserActiveMission:(BBParseMission *)userActiveMission {
    BOOL shouldNotify = ![_userActiveMission isEqual:userActiveMission];
    _userActiveMission = userActiveMission;
    
    if (shouldNotify) {
        [self notifiUserActiveMissionDidChange];
    }
}

- (void)setUserActiveMissionIsLoading:(BOOL)userActiveMissionIsLoading {
    _userActiveMissionIsLoading = userActiveMissionIsLoading;
    
    if (userActiveMissionIsLoading) {
        [self notifyUserActiveMisssionIsLoading];
    }
}

#pragma mark - Braodcast

- (void)registerToUserSessionStateChanges {
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(handleLogInNotification)
                                                 name:BBSessionLoginNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(handleSignUpNotification)
                                                 name:BBSessionSignupNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(handleLogOutNotification)
                                                 name:BBSessionLogoutNotification object:nil];
}

- (void)handleLogInNotification {
    [self setInstallationUser];
    [self fetchUserActiveMission];
}

- (void)handleSignUpNotification {
    [self fetchUserActiveMission];
}

- (void)handleLogOutNotification {
    [self clearUserProperties];
}

- (void)notifyUserActiveMisssionIsLoading {
    [[NSNotificationCenter defaultCenter] postNotificationName:BBNotificationUserActiveMissionIsLoading
                                                        object:nil];
}

- (void)notifiUserActiveMissionDidChange {
    [[NSNotificationCenter defaultCenter] postNotificationName:BBNotificationUserActiveMissionDidChange
                                                        object:nil];
}

#pragma mark - API

- (void)setInstallationUser {
    PFInstallation *installation = [PFInstallation currentInstallation];
    [installation setObject:[BBParseUser currentUser] forKey:@"user"];
    [installation saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (succeeded && !error) {
            
        } else {
            NSString *title = NSLocalizedString(@"Notification disabled", @"");
            [[[UIAlertView alloc] initWithTitle:title message:[error localizedDescription] delegate:nil cancelButtonTitle:@"Close" otherButtonTitles:nil] show];
        }
    }];
}

- (void)fetchUserActiveMission {
    self.userActiveMissionIsLoading = YES;
    [BBParseManager fetchUserActiveMission:[BBParseUser currentUser]
                                 withBlock:^(PFObject *object, NSError *error) {
                                     if (!error) {
                                         self.userActiveMission = (BBParseMission *)object;
                                     } else {
                                         self.userActiveMission = nil;
                                     }
                                     self.userActiveMissionIsLoading = NO;
    }];
}

#pragma mark - User properties

- (void)clearUserProperties {
    self.userActiveMission = nil;
}

@end
