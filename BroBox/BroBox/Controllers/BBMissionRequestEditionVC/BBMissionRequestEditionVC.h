//
//  BBMissionRequestEditionVC.h
//  BroBox
//
//  Created by Tanguy Hélesbeux on 04/02/2015.
//  Copyright (c) 2015 Brobox. All rights reserved.
//

#import "BBViewController.h"

// Model
#import "BBParseMission.h"

@interface BBMissionRequestEditionVC : BBViewController

@property (strong, nonatomic) BBParseMission *mission;

- (void)setAsRootViewController;

@end
