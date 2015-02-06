//
//  BBMission.m
//  BroBox
//
//  Created by Tanguy Hélesbeux on 25/01/2015.
//  Copyright (c) 2015 Brobox. All rights reserved.
//

#import "BBParseMission.h"

@implementation BBParseMission

@dynamic creator;
@dynamic from;
@dynamic to;

#pragma mark - Factory

+ (BBParseMission *)missionFrom:(BBGeoPoint *)from
                             to:(BBGeoPoint *)to {
    BBParseMission *mission = [BBParseMission object];
    mission.from = from;
    mission.to = to;
    mission.creator = [BBParseUser currentUser];
    return mission;
}

#pragma mark - Parse subclassing

+ (void)load {
    [self registerSubclass];
}

+ (NSString *)parseClassName {
    return @"BBParseMission";
}

@end
