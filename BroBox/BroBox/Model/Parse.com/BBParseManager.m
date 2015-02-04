//
//  BBParseManager.m
//  BroBox
//
//  Created by Tanguy Hélesbeux on 25/01/2015.
//  Copyright (c) 2015 Brobox. All rights reserved.
//

#import "BBParseManager.h"

@implementation BBParseManager

+ (void)fetchGeoPointsWithBlock:(BBArrayResultBlock)block {
    PFQuery *query = [BBGeoPoint query];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        block(objects, error);
    }];
}

+ (void)fetchMissionRequestsWithBlock:(BBArrayResultBlock)block {
    PFQuery *query = [BBParseMissionRequest query];
    [query includeKey:@"mission"];
    [query includeKey:@"mission.from"];
    [query includeKey:@"mission.to"];
    [query includeKey:@"mission.creator"];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        block(objects, error);
    }];
}

@end
