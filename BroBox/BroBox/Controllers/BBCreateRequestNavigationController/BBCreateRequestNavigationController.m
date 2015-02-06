//
//  BBCreateRequestNavigationController.m
//  BroBox
//
//  Created by Tanguy Hélesbeux on 04/02/2015.
//  Copyright (c) 2015 Brobox. All rights reserved.
//

#import "BBCreateRequestNavigationController.h"

// Managers
#import "BBInstallationManager.h"

// Controllers
#import "BBCreateRequestVC.h"

@interface BBCreateRequestNavigationController ()

@end

@implementation BBCreateRequestNavigationController

#pragma mark - Initialization

+ (instancetype)new
{
    BBViewController *rootVC = nil;
    if ([BBInstallationManager userActiveMissionIsLoading]) {
        rootVC = [BBViewController new];
        [rootVC startLoading];
    } else {
        BBParseMission *mission = [BBInstallationManager userActiveMission];
        rootVC = [BBCreateRequestNavigationController rootViewControllerForUserActiveMission:mission];
    }
    BBCreateRequestNavigationController *navigationController = [[BBCreateRequestNavigationController alloc] initWithRootViewController:rootVC];
    
    navigationController.title = NSLocalizedString(@"My mission", @"");
    
    return navigationController;
}

- (void)setViewControllersForUserActiveMission:(BBParseMission *)mission
                                      animated:(BOOL)animated {
    BBViewController *rootVC = [BBCreateRequestNavigationController rootViewControllerForUserActiveMission:mission];
    [self setViewControllers:@[rootVC] animated:animated];
}

+ (BBViewController *)rootViewControllerForUserActiveMission:(BBParseMission *)mission {
    if (mission) {
        BBViewController *rootVC = [BBViewController new];
        [rootVC showPlaceHolderWithtitle:@"existing mission" subtitle:@""];
        rootVC.title = NSLocalizedString(@"My mission", @"");
        return rootVC;
    } else {
        BBCreateRequestVC *rootVC = [BBCreateRequestVC new];
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
