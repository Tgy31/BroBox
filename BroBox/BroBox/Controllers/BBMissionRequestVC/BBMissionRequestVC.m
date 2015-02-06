//
//  BBMissionRequestVC.m
//  BroBox
//
//  Created by Tanguy Hélesbeux on 06/02/2015.
//  Copyright (c) 2015 Brobox. All rights reserved.
//

#import "BBMissionRequestVC.h"

@interface BBMissionRequestVC ()


// Scroll properties
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIView *contentView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contentViewWidthConstraint;

// Other views
@property (weak, nonatomic) IBOutlet UILabel *labelFrom;
@property (weak, nonatomic) IBOutlet UILabel *labelTo;
@property (weak, nonatomic) IBOutlet UIButton *actionButton;


@end

@implementation BBMissionRequestVC

#pragma mark - View life cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationBarShouldCoverViewController = NO;
    
    [self initialiazeView];
    [self setViewForMission:self.mission];
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    
    self.contentViewWidthConstraint.constant = self.view.frame.size.width;
    
    [self.scrollView layoutIfNeeded];
    self.scrollView.contentSize = self.contentView.frame.size;
}

#pragma mark - Initialization

- (void)initialiazeView {
    
//    Texts
    NSString *actionTitle = NSLocalizedString(@"Accept mission", @"Action button title in mission request screen");
    [self.actionButton setTitle:actionTitle forState:UIControlStateNormal];
    
//    Controls
    [self.actionButton addTarget:self
                          action:@selector(actionButtonHandler)
                forControlEvents:UIControlEventTouchUpInside];
}

- (void)setViewForMission:(BBParseMission *)mission {
    if (mission) {
        self.labelFrom.text = self.mission.from.title;
        self.labelTo.text = self.mission.to.title;
    }
}

#pragma mark - Getters & Setters

- (void)setMission:(BBParseMission *)mission {
    _mission = mission;
    [self setViewForMission:mission];
}

#pragma mark - Handlers

- (void)actionButtonHandler {
    
}

@end
