//
//  BBFacebookManager.h
//  BroBox
//
//  Created by Tanguy Hélesbeux on 06/02/2015.
//  Copyright (c) 2015 Brobox. All rights reserved.
//

#import "BBObject.h"

typedef void (^BBFacebookRequestHandler)(id result, NSError *error);

@interface BBFacebookManager : BBObject

+ (void)fetchUserInformationsWithBlock:(BBFacebookRequestHandler)block;

+ (BOOL)isSessionAvailable;
+ (BOOL)isSessionOpen;

@end
