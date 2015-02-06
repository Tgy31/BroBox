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

#pragma mark - Helpers

#define FACEBOOK_KEY_ID @"id"
#define FACEBOOK_KEY_FIRSTNAME @"first_name"
#define FACEBOOK_KEY_LASTNAME @"last_name"
#define FACEBOOK_KEY_EMAIL @"email"
#define FACEBOOK_KEY_BIRTHDATE @"birthday"

+ (NSString *)facebookIDFromJson:(NSDictionary *)json {
    return [json objectForKey:FACEBOOK_KEY_ID];
}

+ (NSString *)firstNameFromJson:(NSDictionary *)json {
    return [json objectForKey:FACEBOOK_KEY_FIRSTNAME];
}

+ (NSString *)lastNameFromJson:(NSDictionary *)json {
    return [json objectForKey:FACEBOOK_KEY_LASTNAME];
}

+ (NSString *)emailFromJson:(NSDictionary *)json {
    return [json objectForKey:FACEBOOK_KEY_EMAIL];
}

+ (NSString *)birthdateFromJson:(NSDictionary *)json {
    return [json objectForKey:FACEBOOK_KEY_BIRTHDATE];
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
