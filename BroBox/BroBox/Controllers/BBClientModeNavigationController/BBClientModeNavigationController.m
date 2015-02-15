//
//  BBClientModeNavigationController.m
//  BroBox
//
//  Created by Tanguy Hélesbeux on 15/02/2015.
//  Copyright (c) 2015 Brobox. All rights reserved.
//

#import "BBClientModeNavigationController.h"


// Controllers
#import "BBQRReaderVC.h"

@interface BBClientModeNavigationController ()

@end

@implementation BBClientModeNavigationController

#pragma mark - Initialization

+ (instancetype)new
{
    BBQRReaderVC *rootVC = [BBQRReaderVC new];
    BBClientModeNavigationController *navigationController = [[BBClientModeNavigationController alloc] initWithRootViewController:rootVC];
    
    rootVC.title = NSLocalizedString(@"Client", @"");
    
    return navigationController;
}

@end
