//
//  BBMissionRequestEditionVC.m
//  BroBox
//
//  Created by Tanguy Hélesbeux on 04/02/2015.
//  Copyright (c) 2015 Brobox. All rights reserved.
//

#import "BBMissionRequestEditionVC.h"

@interface BBMissionRequestEditionVC ()

@end

@implementation BBMissionRequestEditionVC

#pragma mark - View life cycle

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    
    [self startLoading];
}

#pragma mark - Initialization

#pragma mark - Navigation methods

- (void)setAsRootViewController {
    [self.navigationController setViewControllers:@[self] animated:NO];
}

@end
