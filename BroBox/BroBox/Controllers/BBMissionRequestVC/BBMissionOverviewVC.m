//
//  BBMissionOverviewVC.m
//  BroBox
//
//  Created by Tanguy Hélesbeux on 06/02/2015.
//  Copyright (c) 2015 Brobox. All rights reserved.
//

#import "BBMissionOverviewVC.h"

// Managers
#import "BBParseManager.h"

// Model
#import "BBParseUser.h"

@interface BBMissionOverviewVC ()


// Scroll properties
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIView *contentView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contentViewWidthConstraint;

// Other views
@property (weak, nonatomic) IBOutlet UILabel *labelFrom;
@property (weak, nonatomic) IBOutlet UILabel *labelTo;
@property (weak, nonatomic) IBOutlet UIButton *actionButton;

@end

@implementation BBMissionOverviewVC

#pragma mark - View life cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
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
    NSString *actionTitle = NSLocalizedString(@"Accept mission", @"Action button title in mission overview screen");
    [self.actionButton setTitle:actionTitle forState:UIControlStateNormal];
    
//    Controls
    [self.actionButton addTarget:self
                          action:@selector(actionButtonHandler)
                forControlEvents:UIControlEventTouchUpInside];
}

- (void)setViewForMission:(BBParseMission *)mission {
    if (mission) {
        self.labelFrom.text = mission.from.title;
        self.labelTo.text = mission.to.title;
    }
}

#pragma mark - Getters & Setters

- (void)setMission:(BBParseMission *)mission {
    _mission = mission;
    [self setViewForMission:mission];
}

#pragma marl - View Methods

- (void)showAcceptMissionSuccess {
    NSString *title = NSLocalizedString(@"Success", @"");
    NSString *subtitle = NSLocalizedString(@"You succesfully accepted to carry this mission. Please wait for the creator to select a carrier", @"");
    [self showPlaceHolderWithtitle:title subtitle:subtitle];
}

- (void)showAcceptMissionFailedWithError:(NSError *)error {
    NSString *title = NSLocalizedString(@"Error", @"");
    NSString *subtitle = [error localizedFailureReason];
    [self showPlaceHolderWithtitle:title subtitle:subtitle];
}

#pragma mark - Handlers

- (void)actionButtonHandler {
    [self acceptMission];
}

#pragma mark - API

- (void)acceptMission {
    [self startLoading];
    [BBParseManager mission:self.mission
                 addCarrier:[BBParseUser currentUser]
                  withBlock:^(BOOL succeeded, NSError *error) {
                      if (!error ) {
                          [self showAcceptMissionSuccess];
                      } else {
                          NSLog(@"%@", error);
                          [self showAcceptMissionFailedWithError:error];
                      }
    }];
}

@end
