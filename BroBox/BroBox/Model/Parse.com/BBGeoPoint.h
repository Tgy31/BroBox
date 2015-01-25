//
//  BBGeoPoint.h
//  BroBox
//
//  Created by Tanguy Hélesbeux on 25/01/2015.
//  Copyright (c) 2015 Brobox. All rights reserved.
//

#import <Parse/Parse.h>

@interface BBGeoPoint : PFObject

@property (strong, nonatomic) PFGeoPoint *coordinate;

+ (instancetype)geoPointWithLatitude:(double)latitude longitude:(double)longitude;

@end
