//
//  BBCreateRequestNavigationController.h
//  BroBox
//
//  Created by Tanguy Hélesbeux on 04/02/2015.
//  Copyright (c) 2015 Brobox. All rights reserved.
//

#import "BBNavigationController.h"

// Model
#import "BBParseMission.h"

@interface BBCreateRequestNavigationController : BBNavigationController


- (void)setViewControllersForUserActiveMission:(BBParseMission *)mission
                                      animated:(BOOL)animated;

@end
