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

+ (void)missionRequest:(BBParseMissionRequest *)missionRequest
            addCarrier:(BBParseUser *)carrier
             withBlock:(BBBooleanResultBlock)block {
    
    PFRelation *carrierRelation = [missionRequest carriersAwaitingRelation];
    [carrierRelation addObject:carrier];
    [missionRequest saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        block(succeeded, error);
    }];
}

+ (void)user:(BBParseUser *)user
confirmSignUpWithBlock:(BBBooleanResultBlock)block {
    
    [user saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        block(succeeded, error);
    }];
}

@end
