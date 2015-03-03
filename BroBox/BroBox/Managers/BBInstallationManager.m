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

+ (BBParseMission *)userMission {
    return [BBInstallationManager sharedManager].userMission;
}

+ (BOOL)userMissionIsLoading {
    return [BBInstallationManager sharedManager].userMissionIsLoading;
}

+ (void)setUserMission:(BBParseMission *)userMission {
    [[BBInstallationManager sharedManager] setUserMission:userMission];
}

- (void)setUserMission:(BBParseMission *)userMission {
    BOOL shouldNotify = ![_userMission isEqual:userMission];
    _userMission = userMission;
    
    if (shouldNotify) {
        [self notifiUserMissionDidChange];
    }
}

- (void)setUserActiveMissionIsLoading:(BOOL)userMissionIsLoading {
    _userMissionIsLoading = userMissionIsLoading;
    
    if (userMissionIsLoading) {
        [self notifyUserMisssionIsLoading];
    }
}

+ (void)setCarriedMission:(BBParseMission *)carriedMission {
    [[BBInstallationManager sharedManager] setCarriedMission:carriedMission];
}

+ (BBParseMission *)carriedMission {
    return [BBInstallationManager sharedManager].carriedMission;
}

+ (BBParseMission *)activeMission {
    return [[BBInstallationManager sharedManager] activeMision];
}

- (BBParseMission *)activeMision {
    return self.carriedMission ? self.carriedMission : self.userMission;
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
    [self fetchUserMission];
}

- (void)handleSignUpNotification {
    [self fetchUserMission];
}

- (void)handleLogOutNotification {
    [self clearUserProperties];
}

- (void)notifyUserMisssionIsLoading {
    [[NSNotificationCenter defaultCenter] postNotificationName:BBNotificationUserMissionIsLoading
                                                        object:nil];
}

- (void)notifiUserMissionDidChange {
    [[NSNotificationCenter defaultCenter] postNotificationName:BBNotificationUserMissionDidChange
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

- (void)fetchUserMission {
    self.userActiveMissionIsLoading = YES;
    [BBParseManager fetchUserActiveMission:[BBParseUser currentUser]
                                 withBlock:^(PFObject *object, NSError *error) {
                                     if (!error) {
                                         self.userMission = (BBParseMission *)object;
                                     } else {
                                         self.userMission = nil;
                                     }
                                     self.userActiveMissionIsLoading = NO;
    }];
}

#pragma mark - User properties

- (void)clearUserProperties {
    self.userMission = nil;
}

@end
