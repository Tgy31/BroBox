//
//  BBGeoPoint.m
//  BroBox
//
//  Created by Tanguy Hélesbeux on 25/01/2015.
//  Copyright (c) 2015 Brobox. All rights reserved.
//

#import "BBGeoPoint.h"
#import <Parse/PFObject+Subclass.h>

@implementation BBGeoPoint

@dynamic coordinate;
@dynamic googleReference;
@dynamic title;
@dynamic subtitle;

+ (instancetype)geoPointWithLatitude:(double)latitude longitude:(double)longitude {
    BBGeoPoint *geoPoint = [BBGeoPoint object];
    geoPoint.coordinate = [PFGeoPoint geoPointWithLatitude:latitude longitude:longitude];
    return geoPoint;
}

#pragma mark - Parse subclassing

+ (void)load {
    [self registerSubclass];
}

+ (NSString *)parseClassName {
    return @"BBGeoPoint";
}

@end
