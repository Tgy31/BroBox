//
//  BBLoginManager.h
//  BroBox
//
//  Created by Tanguy Hélesbeux on 23/01/2015.
//  Copyright (c) 2015 Brobox. All rights reserved.
//

//Frameworks
#import <Foundation/Foundation.h>
#import <Parse/Parse.h>

// Model
#import "BBParseUser.h"

typedef void (^BBUserResultBlock)(BBParseUser *user, NSError *error);

static NSString * BBSessionSignupNotification = @"BBSessionSignupNotification";
static NSString * BBSessionLoginNotification = @"BBSessionLoginNotification";
static NSString * BBSessionLogoutNotification = @"BBSessionLogoutNotification";

@interface BBLoginManager : NSObject

+ (void)loginWithFacebookWithBlock:(BBUserResultBlock)block;
+ (void)logout;

@end
