//
//  BBMission.m
//  BroBox
//
//  Created by Tanguy Hélesbeux on 25/01/2015.
//  Copyright (c) 2015 Brobox. All rights reserved.
//

#import "BBParseMission.h"

@implementation BBParseMission

@dynamic from;
@dynamic to;

#pragma mark - Parse subclassing

+ (void)load {
    [self registerSubclass];
}

+ (NSString *)parseClassName {
    return @"BBParseMission";
}

@end
