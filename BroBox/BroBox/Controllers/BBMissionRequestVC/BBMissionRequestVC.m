//
//  BBMissionRequestVC.m
//  BroBox
//
//  Created by Tanguy Hélesbeux on 06/02/2015.
//  Copyright (c) 2015 Brobox. All rights reserved.
//

#import "BBMissionRequestVC.h"

@interface BBMissionRequestVC ()

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIView *contentView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contentViewWidthConstraint;

@end

@implementation BBMissionRequestVC

#pragma mark - View life cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationBarShouldCoverViewController = NO;
    
    [self setViewForMission:self.mission];
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    
    self.contentViewWidthConstraint.constant = self.view.frame.size.width;
    
    [self.scrollView layoutIfNeeded];
    self.scrollView.contentSize = self.contentView.frame.size;
}

#pragma mark - Initialization

- (void)setViewForMission:(BBParseMission *)mission {
    
}

#pragma mark - Getters & Setters

- (void)setMission:(BBParseMission *)mission {
    _mission = mission;
    [self setViewForMission:mission];
}

@end
