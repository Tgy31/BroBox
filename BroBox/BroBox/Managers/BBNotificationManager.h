//
//  BBNotificationManager.h
//  BroBox
//
//  Created by Tanguy Hélesbeux on 07/02/2015.
//  Copyright (c) 2015 Brobox. All rights reserved.
//

#import "BBObject.h"

// Frameworks
#import <Parse/Parse.h>

// Model
@class BBParseUser;

@interface BBNotificationManager : BBObject

+ (void)initialize;

+ (void)handleRemoteNotification:(NSDictionary *)userInfo;

+ (void)pushNotificationWithMessage:(NSString *)message
                               info:(NSDictionary *)info
                            toQuery:(PFQuery *)query;

+ (void)pushNotificationWithMessage:(NSString *)message
                               info:(NSDictionary *)info
                             toUser:(BBParseUser *)user;

@end
