//
//  BBFacebookManager.m
//  BroBox
//
//  Created by Tanguy Hélesbeux on 06/02/2015.
//  Copyright (c) 2015 Brobox. All rights reserved.
//

#import "BBFacebookManager.h"

// Frameworks
#import <FacebookSDK/FacebookSDK.h>

@implementation BBFacebookManager

#pragma mark - Services

+ (void)fetchUserInformationsWithBlock:(BBFacebookRequestHandler)block{
    FBRequest *meRequest = [FBRequest requestForMe];
    [meRequest startWithCompletionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
        block(result, error);
    }];
}

#pragma mark - API CALLS

#pragma mark - Session state

+ (BOOL)isSessionAvailable
{
    return (FBSession.activeSession.state == FBSessionStateCreatedTokenLoaded || FBSession.activeSession.state == FBSessionStateCreatedOpening || [self isSessionOpen]);
}

+ (BOOL)isSessionOpen
{
    return (FBSession.activeSession.state == FBSessionStateOpen || FBSession.activeSession.state == FBSessionStateOpenTokenExtended);
}

@end
