//
//  BBViewController.m
//  BroBox
//
//  Created by Tanguy Hélesbeux on 22/01/2015.
//  Copyright (c) 2015 Brobox. All rights reserved.
//

#import "BBViewController.h"

@interface BBViewController ()

@end

@implementation BBViewController

- (void)setNavigationBarShouldCoverViewController:(BOOL)navigationBarShouldCoverViewController {
    _navigationBarShouldCoverViewController = navigationBarShouldCoverViewController;
    self.navigationController.navigationBar.translucent = navigationBarShouldCoverViewController;
}

@end
