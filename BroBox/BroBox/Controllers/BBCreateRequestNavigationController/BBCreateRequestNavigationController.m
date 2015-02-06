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
    BBViewController *rootVC = [BBViewController new];
    [rootVC startLoading];
    BBCreateRequestNavigationController *navigationController = [[BBCreateRequestNavigationController alloc] initWithRootViewController:rootVC];
    
    navigationController.title = NSLocalizedString(@"My mission", @"");
    
    return navigationController;
}

- (void)setViewControllersForUserActiveMission:(BBParseMissionRequest *)missionRequest
                                      animated:(BOOL)animated {
    if (missionRequest) {
        BBViewController *rootVC = [BBViewController new];
        [rootVC showPlaceHolderWithtitle:@"existing mission" subtitle:@""];
        rootVC.title = NSLocalizedString(@"My mission", @"");
        [self setViewControllers:@[rootVC] animated:animated];
    } else {
        BBCreateRequestVC *rootVC = [BBCreateRequestVC new];
        rootVC.title = NSLocalizedString(@"Create mission", @"");
        [self setViewControllers:@[rootVC] animated:animated];
    }
}

#pragma mark - View life cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setViewControllersForUserActiveMission:[BBInstallationManager userActiveMissionRequest]
                                        animated:NO];
    
    [self registerToUserActiveMissionNotifications];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - Broadcast

- (void)registerToUserActiveMissionNotifications {
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(handleUserActiveMissionStateDidChange)
                                                 name:BBNotificationUserActiveMissionRequestDidChange
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(handleUserActiveMissionStateDidChange)
                                                 name:BBNotificationUserActiveMissionRequestIsLoading
                                               object:nil];
}

- (void)handleUserActiveMissionStateDidChange {
    [self setViewControllersForUserActiveMission:[BBInstallationManager userActiveMissionRequest]
                                        animated:YES];
}

@end
