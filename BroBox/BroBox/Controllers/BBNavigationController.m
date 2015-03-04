//
//  BBNavigationController.m
//  BroBox
//
//  Created by Tanguy Hélesbeux on 23/01/2015.
//  Copyright (c) 2015 Brobox. All rights reserved.
//

#import "BBNavigationController.h"

@interface BBNavigationController ()

@end

@implementation BBNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setUpAppearance];
}

#pragma mark - Appearance

- (void)setUpAppearance {
    self.navigationBar.tintColor = [UIColor colorWithRed:0.89f green:0.40f blue:0.00f alpha:1.00f];
    [self.navigationBar setTitleTextAttributes:@{
                                                 NSForegroundColorAttributeName : [UIColor colorWithRed:0.89f green:0.40f blue:0.00f alpha:1.00f]
                                                 }];
}

@end
