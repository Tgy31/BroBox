//
//  BBMissionListNavigationController.m
//  BroBox
//
//  Created by Tanguy Hélesbeux on 25/01/2015.
//  Copyright (c) 2015 Brobox. All rights reserved.
//

#import "BBMissionListNavigationController.h"

// Controllers
#import "BBMissionListVC.h"

@interface BBMissionListNavigationController ()

@end

@implementation BBMissionListNavigationController

+ (instancetype)new
{
    BBMissionListVC *missionListVC = [BBMissionListVC new];
    BBMissionListNavigationController *navigationController = [[BBMissionListNavigationController alloc] initWithRootViewController:missionListVC];
    
    missionListVC.title = @"Missions";
    
    navigationController.title = @"Missions";
    
    return navigationController;
}

#pragma mark - View life cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

@end
