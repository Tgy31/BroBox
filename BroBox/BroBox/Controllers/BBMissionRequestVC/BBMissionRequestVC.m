//
//  BBMissionRequestVC.m
//  BroBox
//
//  Created by Tanguy Hélesbeux on 06/02/2015.
//  Copyright (c) 2015 Brobox. All rights reserved.
//

#import "BBMissionRequestVC.h"

// Managers
#import "BBParseManager.h"

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
    [self setViewForMissionRequest:self.missionRequest];
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

- (void)setViewForMissionRequest:(BBParseMissionRequest *)missionRequest {
    if (missionRequest) {
        self.labelFrom.text = missionRequest.mission.from.title;
        self.labelTo.text = missionRequest.mission.to.title;
    }
}

#pragma mark - Getters & Setters

- (void)setMissionRequest:(BBParseMissionRequest *)missionRequest {
    _missionRequest = missionRequest;
    [self setViewForMissionRequest:missionRequest];
}

#pragma marl - View Methods

- (void)showAcceptMissionRequestSuccess {
    NSString *title = NSLocalizedString(@"Success", @"");
    NSString *subtitle = NSLocalizedString(@"You succesfully accepted to carry this mission. Please wait for the creator to select a carrier", @"");
    [self showPlaceHolderWithtitle:title subtitle:subtitle];
}

- (void)showAcceptMissionRequestFailedWithError:(NSError *)error {
    NSString *title = NSLocalizedString(@"Error", @"");
    NSString *subtitle = [error localizedFailureReason];
    [self showPlaceHolderWithtitle:title subtitle:subtitle];
}

#pragma mark - Handlers

- (void)actionButtonHandler {
    [self acceptMissionRequest];
}

#pragma mark - API

- (void)acceptMissionRequest {
    [self startLoading];
    [BBParseManager missionRequest:self.missionRequest
                        addCarrier:[PFUser currentUser]
                         withBlock:^(BOOL succeeded, NSError *error) {
                             if (!error ) {
                                 [self showAcceptMissionRequestSuccess];
                             } else {
                                 NSLog(@"%@", error);
                                 [self showAcceptMissionRequestFailedWithError:error];
                             }
    }];
}

@end
