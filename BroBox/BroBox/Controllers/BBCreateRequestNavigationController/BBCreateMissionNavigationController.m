//
//  BBCreateMissionNavigationController.m
//  BroBox
//
//  Created by Tanguy Hélesbeux on 04/02/2015.
//  Copyright (c) 2015 Brobox. All rights reserved.
//

#import "BBCreateMissionNavigationController.h"

// Managers
#import "BBInstallationManager.h"

// Controllers
#import "BBCreateMissionVC.h"
#import "BBMissionPanelVC.h"

@interface BBCreateMissionNavigationController ()

@end

@implementation BBCreateMissionNavigationController

#pragma mark - Initialization

+ (instancetype)new
{
    BBViewController *rootVC = nil;
    if ([BBInstallationManager userActiveMissionIsLoading]) {
        rootVC = [BBViewController new];
        [rootVC startLoading];
    } else {
        BBParseMission *mission = [BBInstallationManager userActiveMission];
        rootVC = [BBCreateMissionNavigationController rootViewControllerForUserActiveMission:mission];
    }
    BBCreateMissionNavigationController *navigationController = [[BBCreateMissionNavigationController alloc] initWithRootViewController:rootVC];
    
    navigationController.title = NSLocalizedString(@"My mission", @"");
    
    return navigationController;
}

- (void)setViewControllersForUserActiveMission:(BBParseMission *)mission
                                      animated:(BOOL)animated {
    BBViewController *rootVC = [BBCreateMissionNavigationController rootViewControllerForUserActiveMission:mission];
    [self setViewControllers:@[rootVC] animated:animated];
}

+ (BBViewController *)rootViewControllerForUserActiveMission:(BBParseMission *)mission {
    if (mission) {
        BBMissionPanelVC *rootVC = [BBMissionPanelVC new];
        rootVC.title = NSLocalizedString(@"My mission", @"");
        return rootVC;
    } else {
        BBCreateMissionVC *rootVC = [BBCreateMissionVC new];
        rootVC.title = NSLocalizedString(@"Create mission", @"");
        return rootVC;
    }
}

#pragma mark - View life cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    if (![BBInstallationManager userActiveMissionIsLoading]) {
//        [self setViewControllersForUserActiveMission:[BBInstallationManager userActiveMission]
//                                            animated:NO];
//    }
    
    [self registerToUserActiveMissionNotifications];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - Broadcast

- (void)registerToUserActiveMissionNotifications {
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(handleUserActiveMissionStateDidChange)
                                                 name:BBNotificationUserActiveMissionDidChange
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(handleUserActiveMissionStateDidChange)
                                                 name:BBNotificationUserActiveMissionIsLoading
                                               object:nil];
}

- (void)handleUserActiveMissionStateDidChange {
    [self setViewControllersForUserActiveMission:[BBInstallationManager userActiveMission]
                                        animated:YES];
}

@end
