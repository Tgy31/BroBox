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

// Managers
#import "AppDelegate.h"
#import "BBInstallationManager.h"

@interface BBViewController ()

@property (strong, nonatomic) GFPlaceholderView *placeHolderView;
@property (strong, nonatomic) UIBarButtonItem *debugButton;

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
    
    [self setUpAppearance];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    if ([BBInstallationManager debugMode] && [self shouldShowDebugBarbutton]) {
        self.navigationItem.rightBarButtonItem = self.debugButton;
    } else {
        self.navigationItem.rightBarButtonItem = nil;
    }
}

- (void)viewDidLayoutSubviews {
    [super viewWillLayoutSubviews];
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

- (BOOL)shouldShowDebugBarbutton {
    return NO;
}

- (GFPlaceholderView *)placeHolderView {
    if (!_placeHolderView) {
        _placeHolderView = [[GFPlaceholderView alloc] initWithFrame:self.view.bounds];
        [self.view addSubview:_placeHolderView];
    }
    return _placeHolderView;
}

- (UIBarButtonItem *)debugButton {
    if (!_debugButton) {
        _debugButton = [[UIBarButtonItem alloc] initWithTitle:@"[DEBUG]"
                                                       style:UIBarButtonItemStylePlain
                                                      target:self
                                                      action:@selector(debugButtonHandler)];
        _debugButton.tintColor = [UIColor orangeColor];
    }
    return _debugButton;
}

#pragma mark - Appearance 

- (void)setUpAppearance {
}

#pragma mark - Handlers

- (void)debugButtonHandler {
    NSLog(@"Debug button not handle");
}

@end
