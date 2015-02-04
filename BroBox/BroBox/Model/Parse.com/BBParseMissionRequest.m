//
//  BBParseMissionRequest.m
//  BroBox
//
//  Created by Tanguy Hélesbeux on 04/02/2015.
//  Copyright (c) 2015 Brobox. All rights reserved.
//

#import "BBParseMissionRequest.h"

// Frameworks
#import <Parse/PFObject+Subclass.h>

@implementation BBParseMissionRequest

@dynamic mission;



#pragma mark - Parse subclassing

+ (void)load {
    [self registerSubclass];
}

+ (NSString *)parseClassName {
    return @"BBParseMissionRequest";
}

@end
