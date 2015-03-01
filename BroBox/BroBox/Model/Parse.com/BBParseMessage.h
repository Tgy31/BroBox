//
//  BBParseMessage.h
//  BroBox
//
//  Created by Tanguy Hélesbeux on 01/03/2015.
//  Copyright (c) 2015 Brobox. All rights reserved.
//
#import <Parse/Parse.h>

// Model
#import "BBParseMission.h"
#import "BBParseUser.h"

@interface BBParseMessage : PFObject

@property (strong, nonatomic) BBParseMission *mission;
@property (strong, nonatomic) BBParseUser *author;
@property (strong, nonatomic) NSString *content;

// not synchronized with Parse
@property (strong, nonatomic) UIImage *attachment;

@end
