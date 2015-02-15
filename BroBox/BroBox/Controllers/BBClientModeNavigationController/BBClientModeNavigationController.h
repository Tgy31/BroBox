//
//  BBClientModeNavigationController.h
//  BroBox
//
//  Created by Tanguy Hélesbeux on 15/02/2015.
//  Copyright (c) 2015 Brobox. All rights reserved.
//

#import "BBNavigationController.h"

// Model
#import "BBParseMission.h"

@interface BBClientModeNavigationController : BBNavigationController

@property (strong, nonatomic) BBParseMission *mission;

+ (instancetype)newWithMission:(BBParseMission *)mission;

@end
