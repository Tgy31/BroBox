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

@interface BBParseMission : PFObject

@property (strong, nonatomic) BBGeoPoint *from;
@property (strong, nonatomic) BBGeoPoint *to;

@end
