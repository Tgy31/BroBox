//
//  BBAlertManager.m
//  BroBox
//
//  Created by Tanguy Hélesbeux on 02/03/2015.
//  Copyright (c) 2015 Brobox. All rights reserved.
//

#import "BBAlertManager.h"

// Frameworks
#import <SIAlertView/SIAlertView.h>

static BBAlertManager *sharedManager;

@implementation BBAlertManager

+ (instancetype)sharedManager {
    if (!sharedManager) {
        sharedManager = [BBAlertManager new];
    }
    return sharedManager;
}

#pragma mark - Alert views

+ (void)presentAlertForMissionStart:(BBParseMission *)mission
                          withBlock:(BBAlertButtonHandlerBlock)block {
    
    [[BBAlertManager sharedManager] presentAlertForMissionStart:mission
                                                      withBlock:block];
}


- (void)presentAlertForMissionStart:(BBParseMission *)mission
                          withBlock:(BBAlertButtonHandlerBlock)block {
    
    NSString *title = NSLocalizedString(@"Mission accepted", @"");
    NSString *messageFormat = NSLocalizedString(@"You have been selected to carry %@'s mission", @"");
    NSString *message = [NSString stringWithFormat:messageFormat, mission.creator.firstName];
    
    SIAlertView *alertView = [[SIAlertView alloc] initWithTitle:title andMessage:message];
    
    NSString *buttonTitle = NSLocalizedString(@"Start mission", @"");
    
    [alertView addButtonWithTitle:buttonTitle
                             type:SIAlertViewButtonTypeDestructive
                          handler:^(SIAlertView *alert) {
                              block();
                          }];
    
    alertView.transitionStyle = SIAlertViewTransitionStyleBounce;
    
    [alertView show];
}

@end
