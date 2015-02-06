//
//  BBSignUpNavigationController.m
//  BroBox
//
//  Created by Tanguy Hélesbeux on 06/02/2015.
//  Copyright (c) 2015 Brobox. All rights reserved.
//

#import "BBSignUpNavigationController.h"

// Controllers
#import "BBSignUpVC.h"

@interface BBSignUpNavigationController ()

@end

@implementation BBSignUpNavigationController

#pragma mark - Initialization

+ (instancetype)new
{
    BBSignUpVC *rootVC = [BBSignUpVC new];
    BBSignUpNavigationController *navigationController = [[BBSignUpNavigationController alloc] initWithRootViewController:rootVC];
    
    rootVC.title = NSLocalizedString(@"Sign up", @"");
    
    return navigationController;
}

@end
