//
//  BBRootVC.m
//  BroBox
//
//  Created by Tanguy Hélesbeux on 23/01/2015.
//  Copyright (c) 2015 Brobox. All rights reserved.
//

#import "BBRootVC.h"

// Controllers
#import "BBLogoutVC.h"

@interface BBRootVC ()

@property (strong, nonatomic) UIViewController * mapVC;
@property (strong, nonatomic) UIViewController * missionsVC;
@property (strong, nonatomic) UIViewController * createVC;
@property (strong, nonatomic) UIViewController * notificationVC;
@property (strong, nonatomic) UIViewController * settingsVC;

@end

@implementation BBRootVC

#pragma mark - Initialization

- (instancetype)init {
    self = [super init];
    if (self) {
        self.mapVC = [UIViewController new];
        self.mapVC.view.backgroundColor = [UIColor blueColor];
        self.mapVC.title = @"Map";
        
        self.missionsVC = [UIViewController new];
        self.missionsVC.view.backgroundColor = [UIColor greenColor];
        self.missionsVC.title = @"Missions";
        
        self.createVC = [UIViewController new];
        self.createVC.view.backgroundColor = [UIColor yellowColor];
        self.createVC.title = @"Create";
        
        self.notificationVC = [UIViewController new];
        self.notificationVC.view.backgroundColor = [UIColor redColor];
        self.notificationVC.title = @"Notifs";
        
        self.settingsVC = [BBLogoutVC new];
        self.settingsVC.title = @"Settings";
        
        [self setViewControllers:@[
                                   self.mapVC,
                                   self.missionsVC,
                                   self.createVC,
                                   self.notificationVC,
                                   self.settingsVC
                                   ]];
    }
    return self;
}

@end
