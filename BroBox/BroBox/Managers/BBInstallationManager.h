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

static NSString *BBNotificationUserActiveMissionIsLoading = @"BBNotificationUserActiveMissionIsLoading";
static NSString *BBNotificationUserActiveMissionDidChange = @"BBNotificationUserActiveMissionDidChange";

@interface BBInstallationManager : BBObject

@property (strong, nonatomic) BBParseMission *userActiveMission;
@property (nonatomic) BOOL userActiveMissionIsLoading;

+ (void)initialize;

+ (void)setUserActiveMission:(BBParseMission *)userActiveMission;
+ (BBParseMission *)userActiveMission;
+ (BOOL)userActiveMissionIsLoading;

@end
