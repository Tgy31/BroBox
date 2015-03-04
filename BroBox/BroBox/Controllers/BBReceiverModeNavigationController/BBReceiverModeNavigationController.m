//
//  BBReceiverModeNavigationController.m
//  BroBox
//
//  Created by Tanguy Hélesbeux on 04/03/2015.
//  Copyright (c) 2015 Brobox. All rights reserved.
//

#import "BBReceiverModeNavigationController.h"


// Controllers
#import "BBreceiverPanelVC.h"

@interface BBReceiverModeNavigationController ()

@end

@implementation BBReceiverModeNavigationController

#pragma mark - Initialization

+ (instancetype)newWithMission:(BBParseMission *)mission
{
    BBReceiverPanelVC *rootVC = [BBReceiverPanelVC new];
    BBReceiverModeNavigationController *navigationController = [[BBReceiverModeNavigationController alloc] initWithRootViewController:rootVC];
    
    rootVC.mission = mission;
    navigationController.mission = mission;
    
    rootVC.title = NSLocalizedString(@"Mission in progress", @"");
    
    return navigationController;
}

@end
