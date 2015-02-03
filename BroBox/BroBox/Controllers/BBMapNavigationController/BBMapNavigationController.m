//
//  BBMapNavigationController.m
//  BroBox
//
//  Created by Tanguy Hélesbeux on 23/01/2015.
//  Copyright (c) 2015 Brobox. All rights reserved.
//

#import "BBMapNavigationController.h"

// Controllers
#import "BBMapVC.h"

@interface BBMapNavigationController ()

@end

@implementation BBMapNavigationController

#pragma mark - Initialization

+ (instancetype)new
{
    BBMapVC *mapVC = [BBMapVC new];
    BBMapNavigationController *navigationController = [[BBMapNavigationController alloc] initWithRootViewController:mapVC];
    
    mapVC.title = @"Map";
    
    navigationController.title = @"Map";
    
    return navigationController;
}

#pragma mark - View life cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

@end
