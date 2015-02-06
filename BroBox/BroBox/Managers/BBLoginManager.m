//
//  BBLoginManager.m
//  BroBox
//
//  Created by Tanguy Hélesbeux on 23/01/2015.
//  Copyright (c) 2015 Brobox. All rights reserved.
//

#import "BBLoginManager.h"
#import <ParseFacebookUtils/PFFacebookUtils.h>

#define FACEBOOK_PERMISSIONS @[]

@implementation BBLoginManager



#pragma mark - Login
#pragma mark Facebook

+ (void)loginWithFacebookWithBlock:(BBUserResultBlock)block {
    [PFFacebookUtils logInWithPermissions:FACEBOOK_PERMISSIONS block:^(PFUser *u, NSError *error) {
        BBParseUser *user = (BBParseUser *)u;
        if (error) {
            NSLog(@"%@", error);
        } else if (!user) {
            // No cached user or user canceled login
        } else if (user.isNew) {
            NSLog(@"User signed up and logged in through Facebook!");
            [self postSignupNotification];
            
        } else {
            NSLog(@"User logged in through Facebook!");
            [self postLoginNotification];
        }
        
        if (block) {
            block(user, error);
        }
    }];
}

#pragma mark - Logout

+ (void)logout {
    [PFUser logOut];
    [FBSession.activeSession closeAndClearTokenInformation];
    [self postLogoutNotification];
}

#pragma mark - Broadcast

+ (void)postLogoutNotification {
    [[NSNotificationCenter defaultCenter] postNotificationName:BBSessionLogoutNotification
                                                        object:nil];
}

+ (void)postLoginNotification {
    [[NSNotificationCenter defaultCenter] postNotificationName:BBSessionLoginNotification
                                                        object:nil];
}

+ (void)postSignupNotification {
    [[NSNotificationCenter defaultCenter] postNotificationName:BBSessionSignupNotification
                                                        object:nil];
}

@end
