//
//  BBParseUser.h
//  BroBox
//
//  Created by Tanguy Hélesbeux on 06/02/2015.
//  Copyright (c) 2015 Brobox. All rights reserved.
//

#import <Parse/Parse.h>

@interface BBParseUser : PFUser

@property (strong, nonatomic) NSString *facebookID;
@property (strong, nonatomic) NSString *birthday;
@property (strong, nonatomic) NSString *firstName;
@property (strong, nonatomic) NSString *lastName;
@property (strong, nonatomic) PFGeoPoint *location;

+ (BBParseUser *)currentUser;

- (NSString *)fullName;

@end
