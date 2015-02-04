//
//  BBCreateRequestNavigationController.m
//  BroBox
//
//  Created by Tanguy Hélesbeux on 04/02/2015.
//  Copyright (c) 2015 Brobox. All rights reserved.
//

#import "BBCreateRequestNavigationController.h"

// Controllers
#import "BBCreateRequestVC.h"

@interface BBCreateRequestNavigationController ()

@end

@implementation BBCreateRequestNavigationController

#pragma mark - Initialization

+ (instancetype)new
{
    BBCreateRequestVC *rootVC = [BBCreateRequestVC new];
    BBCreateRequestNavigationController *navigationController = [[BBCreateRequestNavigationController alloc] initWithRootViewController:rootVC];
    
    rootVC.title = @"Create request";
    
    navigationController.title = @"Create";
    
    return navigationController;
}

#pragma mark - View life cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

@end
