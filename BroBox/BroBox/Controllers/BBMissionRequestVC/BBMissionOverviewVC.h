//
//  BBMissionOverviewVC.h
//  BroBox
//
//  Created by Tanguy Hélesbeux on 06/02/2015.
//  Copyright (c) 2015 Brobox. All rights reserved.
//

#import "BBViewController.h"

// Model
#import "BBParseMission.h"

typedef NS_ENUM(NSInteger, BBMissionOverviewActionType) {
    BBMissionOverviewActionTypeNone,
    BBMissionOverviewActionTypeAccept
};

@interface BBMissionOverviewVC : BBViewController

@property (strong, nonatomic) BBParseMission *mission;
@property (nonatomic) BBMissionOverviewActionType actionType;

@end
