//
//  BBLoginManager.h
//  BroBox
//
//  Created by Tanguy Hélesbeux on 23/01/2015.
//  Copyright (c) 2015 Brobox. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Parse/Parse.h>

static NSString * BBSessionSignupNotification = @"BBSessionSignupNotification";
static NSString * BBSessionLoginNotification = @"BBSessionLoginNotification";
static NSString * BBSessionLogoutNotification = @"BBSessionLogoutNotification";

@interface BBLoginManager : NSObject

+ (void)loginWithFacebookWithBlock:(PFUserResultBlock)block;
+ (void)logout;

@end
