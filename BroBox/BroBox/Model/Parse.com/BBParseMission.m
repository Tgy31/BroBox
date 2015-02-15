//
//  BBMission.m
//  BroBox
//
//  Created by Tanguy Hélesbeux on 25/01/2015.
//  Copyright (c) 2015 Brobox. All rights reserved.
//

#import "BBParseMission.h"

@interface BBParseMission()

@property (strong, nonatomic) NSString *categoryName;

@end

@implementation BBParseMission

@dynamic creator;
@dynamic from;
@dynamic to;
@dynamic categoryName;
@dynamic breakable;
@dynamic reward;
@dynamic carrier;

#pragma mark - Category

+ (NSString *)categoryNameForCategory:(BBMissionCategory)category {
    switch (category) {
        case BBMissionCategoryLight:
            return @"Light";
        case BBMissionCategoryStandard:
            return @"Standard";
        case BBMissionCategoryHeavy:
            return @"Heavy";
    }
}

+ (NSString *)localizedCategoryNameForCategory:(BBMissionCategory)category {
    return  NSLocalizedString([BBParseMission categoryNameForCategory:category], @"");
}

- (NSString *)localizedCategory {
    return [BBParseMission localizedCategoryNameForCategory:self.category];
}

@synthesize category = _category;

- (void)setCategory:(BBMissionCategory)category {
    _category = category;
    self.categoryName = [BBParseMission categoryNameForCategory:category];
}

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

#pragma mark - Parse relations

- (PFRelation *)carriersAwaitingRelation {
    return [self relationForKey:@"carriersAwaiting"];
}

@end
