//
//  BBParseUser.m
//  BroBox
//
//  Created by Tanguy Hélesbeux on 06/02/2015.
//  Copyright (c) 2015 Brobox. All rights reserved.
//

#import "BBParseUser.h"

// Frameworks
#import <Parse/PFObject+Subclass.h>

@implementation BBParseUser

@dynamic facebookID;
@dynamic birthday;
@dynamic firstName;
@dynamic lastName;
@dynamic location;

- (NSString *)fullName {
    return [NSString stringWithFormat:@"%@ %@", self.firstName, self.lastName];
}

#pragma mark - Parse subclassing

+ (BBParseUser *)currentUser {
    PFUser *user = [PFUser currentUser];
    if ([user isKindOfClass:[BBParseUser class]]) {
        return (BBParseUser *)user;
    }
    return nil;
}

+ (void)load {
    [self registerSubclass];
}

@end
