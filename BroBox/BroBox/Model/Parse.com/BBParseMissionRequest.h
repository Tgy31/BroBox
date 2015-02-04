//
//  BBParseMissionRequest.h
//  BroBox
//
//  Created by Tanguy Hélesbeux on 04/02/2015.
//  Copyright (c) 2015 Brobox. All rights reserved.
//

#import <Parse/Parse.h>

// Models
#import "BBParseMission.h"

@interface BBParseMissionRequest : PFObject

@property (strong, nonatomic) BBParseMission *mission;

+ (BBParseMissionRequest *)missionRequestFrom:(BBGeoPoint *)from
                                           to:(BBGeoPoint *)to;

@end
