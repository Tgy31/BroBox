//
//  BBMission.h
//  BroBox
//
//  Created by Tanguy Hélesbeux on 25/01/2015.
//  Copyright (c) 2015 Brobox. All rights reserved.
//

#import <Parse/Parse.h>

// Models
#import "BBGeoPoint.h"
#import "BBParseUser.h"

typedef NS_ENUM(NSInteger, BBMissionCategory) {
    BBMissionCategoryLight,
    BBMissionCategoryStandard,
    BBMissionCategoryHeavy
};

@interface BBParseMission : PFObject

@property (strong, nonatomic) BBParseUser *creator;
@property (strong, nonatomic) BBGeoPoint *from;
@property (strong, nonatomic) BBGeoPoint *to;
@property (nonatomic) BBMissionCategory category;
@property (nonatomic) BOOL breakable;
@property (strong, nonatomic) NSNumber *reward;


+ (BBParseMission *)missionFrom:(BBGeoPoint *)from
                             to:(BBGeoPoint *)to;

- (PFRelation *)carriersAwaitingRelation;

- (NSString *)localizedCategory;
+ (NSString *)localizedCategoryNameForCategory:(BBMissionCategory)category;
+ (NSString *)categoryNameForCategory:(BBMissionCategory)category;

@end
