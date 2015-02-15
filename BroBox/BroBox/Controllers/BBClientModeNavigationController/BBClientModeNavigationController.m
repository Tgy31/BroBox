//
//  BBClientModeNavigationController.m
//  BroBox
//
//  Created by Tanguy Hélesbeux on 15/02/2015.
//  Copyright (c) 2015 Brobox. All rights reserved.
//

#import "BBClientModeNavigationController.h"


// Controllers
#import "BBClientPanelVC.h"

@interface BBClientModeNavigationController ()

@end

@implementation BBClientModeNavigationController

#pragma mark - Initialization

+ (instancetype)new
{
    BBClientPanelVC *rootVC = [BBClientPanelVC new];
    BBClientModeNavigationController *navigationController = [[BBClientModeNavigationController alloc] initWithRootViewController:rootVC];
    
    rootVC.title = NSLocalizedString(@"Carrier on his way", @"");
    
    return navigationController;
}

@end
