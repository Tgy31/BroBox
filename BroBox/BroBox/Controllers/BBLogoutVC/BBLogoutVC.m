//
//  BBLogoutVC.m
//  BroBox
//
//  Created by Tanguy Hélesbeux on 23/01/2015.
//  Copyright (c) 2015 Brobox. All rights reserved.
//

#import "BBLogoutVC.h"
#import "AppDelegate.h"

// Managers
#import "BBLoginManager.h"

@interface BBLogoutVC ()

@end

@implementation BBLogoutVC

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (IBAction)disconnectButtonHandler {
    [BBLoginManager logout];
    [AppDelegate presentLoginScreen];
}


@end
