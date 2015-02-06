//
//  BBViewController.m
//  BroBox
//
//  Created by Tanguy Hélesbeux on 22/01/2015.
//  Copyright (c) 2015 Brobox. All rights reserved.
//

#import "BBViewController.h"

// Libraries
#import "GFPlaceHolderView.h"

@interface BBViewController ()

@property (strong, nonatomic) GFPlaceholderView *placeHolderView;

@end

@implementation BBViewController

- (void)setNavigationBarShouldCoverViewController:(BOOL)navigationBarShouldCoverViewController {
    _navigationBarShouldCoverViewController = navigationBarShouldCoverViewController;
    self.navigationController.navigationBar.translucent = navigationBarShouldCoverViewController;
}

#pragma mark - View life cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationBarShouldCoverViewController = NO;
}

#pragma marl - View Methods

- (void)startLoading {
    [self.placeHolderView showLoadingView];
}

- (void)stopLoading {
    [self.placeHolderView hide];
}

- (void)showPlaceHolderWithtitle:(NSString *)title
                        subtitle:(NSString *)subtitle {
    
    [self.placeHolderView showViewWithTitle:title andSubtitle:subtitle];
}

- (void)hidePlaceHolder {
    [self.placeHolderView hide];
}

#pragma mark - Getters & Setters

- (GFPlaceholderView *)placeHolderView {
    if (!_placeHolderView) {
        _placeHolderView = [[GFPlaceholderView alloc] initWithFrame:self.view.bounds];
        [self.view addSubview:_placeHolderView];
    }
    return _placeHolderView;
}

@end
