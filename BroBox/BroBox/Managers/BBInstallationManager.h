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
@property (strong, nonatomic) BBParseMission *carriedMission;
@property (nonatomic) BOOL userMissionIsLoading;

+ (void)initialize;

+ (void)setUserMission:(BBParseMission *)userMission;
+ (BBParseMission *)userMission;
+ (BOOL)userMissionIsLoading;

+ (void)setCarriedMission:(BBParseMission *)carriedMission;
+ (BBParseMission *)carriedMission;

+ (BBParseMission *)activeMission;

@end
