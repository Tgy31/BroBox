//
//  BBMissionRequestEditionVC.m
//  BroBox
//
//  Created by Tanguy Hélesbeux on 04/02/2015.
//  Copyright (c) 2015 Brobox. All rights reserved.
//

#import "BBMissionRequestEditionVC.h"

// Libraries
#import "GFPlaceHolderView.h"

@interface BBMissionRequestEditionVC ()

@property (strong, nonatomic) GFPlaceholderView *placeHolderView;

@end

@implementation BBMissionRequestEditionVC

#pragma mark - View life cycle

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    
    [self startLoading];
}

#pragma mark - Initialisation

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
        _placeHolderView = [[GFPlaceholderView alloc] initWithFrame:self.view.frame];
        [self.view addSubview:_placeHolderView];
    }
    return _placeHolderView;
}

#pragma mark - Navigation methods

- (void)setAsRootViewController {
    [self.navigationController setViewControllers:@[self] animated:NO];
}

@end
