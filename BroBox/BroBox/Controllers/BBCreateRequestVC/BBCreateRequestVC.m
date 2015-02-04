//
//  BBCreateRequestVC.m
//  BroBox
//
//  Created by Tanguy Hélesbeux on 04/02/2015.
//  Copyright (c) 2015 Brobox. All rights reserved.
//

#import "BBCreateRequestVC.h"

@interface BBCreateRequestVC ()

// From views
@property (weak, nonatomic) IBOutlet UIView *fromView;
@property (weak, nonatomic) IBOutlet UILabel *fromTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *fromValueLabel;

// To views
@property (weak, nonatomic) IBOutlet UIView *toView;
@property (weak, nonatomic) IBOutlet UILabel *toTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *toValueLabel;


@end

@implementation BBCreateRequestVC

#pragma mark - View life cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationBarShouldCoverViewController = NO;
    
    [self viewInitialization];
    [self gestureInitialization];
}

#pragma mark - Initialization

- (void)viewInitialization {
    
//    From views
    self.fromTitleLabel.text = NSLocalizedString(@"Pick up", @"Create mission request title");
    self.fromValueLabel.text = @"";
    
//    To views
    self.toTitleLabel.text = NSLocalizedString(@"Drop off", @"Create mission request title");
    self.toValueLabel.text = @"";
    
}

- (void)gestureInitialization {
    
//    From views
    UITapGestureRecognizer *fromTapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                     action:@selector(fromViewTapHandler)];
    [self.fromView addGestureRecognizer:fromTapGesture];
    self.fromView.userInteractionEnabled = YES;
    
//    To views
    UITapGestureRecognizer *toTapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                   action:@selector(toViewTapHandler)];
    [self.toView addGestureRecognizer:toTapGesture];
    self.toView.userInteractionEnabled = YES;
}

#pragma mark - Handlers

- (void)fromViewTapHandler {
    
}

- (void)toViewTapHandler {
    
}


@end
