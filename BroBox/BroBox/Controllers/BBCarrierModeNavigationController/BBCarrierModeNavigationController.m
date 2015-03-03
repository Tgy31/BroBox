//
//  BBCarrierModeNavigationController.m
//  BroBox
//
//  Created by Tanguy Hélesbeux on 03/03/2015.
//  Copyright (c) 2015 Brobox. All rights reserved.
//

#import "BBCarrierModeNavigationController.h"

// Controllers
#import "BBCarrierPanelVC.h"

@interface BBCarrierModeNavigationController ()

@end

@implementation BBCarrierModeNavigationController

#pragma mark - Initialization

+ (instancetype)newWithMission:(BBParseMission *)mission
{
    BBCarrierPanelVC *rootVC = [BBCarrierPanelVC new];
    BBCarrierModeNavigationController *navigationController = [[BBCarrierModeNavigationController alloc] initWithRootViewController:rootVC];
    
    rootVC.mission = mission;
    navigationController.mission = mission;
    
    rootVC.title = NSLocalizedString(@"Mission in progress", @"");
    
    return navigationController;
}

@end
