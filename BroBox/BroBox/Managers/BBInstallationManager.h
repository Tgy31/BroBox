//
//  BBInstallationManager.h
//  BroBox
//
//  Created by Tanguy Hélesbeux on 06/02/2015.
//  Copyright (c) 2015 Brobox. All rights reserved.
//

#import "BBObject.h"

// Model
#import "BBParseMissionRequest.h"

static NSString *BBNotificationUserActiveMissionRequestIsLoading = @"BBNotificationUserActiveMissionRequestIsLoading";
static NSString *BBNotificationUserActiveMissionRequestDidChange = @"BBNotificationUserActiveMissionRequestDidChange";

@interface BBInstallationManager : BBObject

@property (strong, nonatomic) BBParseMissionRequest *userActiveMissionRequest;
@property (nonatomic) BOOL userActiveMissionRequestIsLoading;

+ (void)initialize;

@end
