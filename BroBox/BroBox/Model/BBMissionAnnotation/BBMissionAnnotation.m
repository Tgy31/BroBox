//
//  BBMissionAnnotation.m
//  BroBox
//
//  Created by Tanguy Hélesbeux on 05/02/2015.
//  Copyright (c) 2015 Brobox. All rights reserved.
//

#import "BBMissionAnnotation.h"

@implementation BBMissionAnnotation

+ (instancetype)annotationForMission:(BBParseMission *)mission
                            withType:(BBMissionAnnotationType)type {
    BBMissionAnnotation *annotation = [BBMissionAnnotation new];
    annotation.mission = mission;
    annotation.type = type;
    return annotation;
}

#pragma mark - MKAnnotation

- (CLLocationCoordinate2D)coordinate {
    switch (self.type) {
        case BBMissionAnnotationTypeFrom:
            return [self locationCoordinateWithGeoPoint:self.mission.from];
            
        case BBMissionAnnotationTypeTo:
            return [self locationCoordinateWithGeoPoint:self.mission.to];
    }
}

- (NSString *)title {
    switch (self.type) {
        case BBMissionAnnotationTypeFrom:
            return self.mission.from.title;
            
        case BBMissionAnnotationTypeTo:
            return self.mission.to.title;
    }
}

- (NSString *)subtitle {
    NSString *category = [self.mission localizedCategory];
    NSString *breakable = (self.mission.breakable) ? NSLocalizedString(@"Breakable", @"") : NSLocalizedString(@"Safe", @"");
    return [NSString stringWithFormat:@"%@ - %@ - %@€", category, breakable, self.mission.reward];
}

#pragma mark - Helpers

- (CLLocationCoordinate2D)locationCoordinateWithGeoPoint:(BBGeoPoint *)geoPoint {
    return CLLocationCoordinate2DMake(geoPoint.coordinate.latitude, geoPoint.coordinate.longitude);
}

@end
