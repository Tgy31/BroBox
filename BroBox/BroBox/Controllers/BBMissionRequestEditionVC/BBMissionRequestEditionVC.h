//
//  BBMissionRequestEditionVC.h
//  BroBox
//
//  Created by Tanguy Hélesbeux on 04/02/2015.
//  Copyright (c) 2015 Brobox. All rights reserved.
//

#import "BBViewController.h"

// Model
#import "BBParseMissionRequest.h"

@interface BBMissionRequestEditionVC : BBViewController

@property (strong, nonatomic) BBParseMissionRequest *missionRequest;

- (void)setAsRootViewController;

@end
