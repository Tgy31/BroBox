//
//  BBInstallationManager.h
//  BroBox
//
//  Created by Tanguy Hélesbeux on 06/02/2015.
//  Copyright (c) 2015 Brobox. All rights reserved.
//

#import "BBObject.h"

// Model
#import "BBParseMission.h"

static NSString *BBNotificationUserMissionIsLoading = @"BBNotificationUserActiveMissionIsLoading";
static NSString *BBNotificationUserMissionDidChange = @"BBNotificationUserActiveMissionDidChange";

@interface BBInstallationManager : BBObject

@property (strong, nonatomic) BBParseMission *userMission;
@property (strong, nonatomic) BBParseMission *activeMission;
@property (nonatomic) BOOL userMissionIsLoading;

@property (nonatomic) BOOL debugMode;

+ (void)initialize;

+ (void)setUserMission:(BBParseMission *)userMission;
+ (BBParseMission *)userMission;
+ (BOOL)userMissionIsLoading;

+ (void)setActiveMission:(BBParseMission *)activeMission;
+ (BBParseMission *)activeMission;

+ (BOOL)debugMode;
+ (void)setDebugMode:(BOOL)debugMode;

@end
