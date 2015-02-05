//
//  BBMissionAnnotation.h
//  BroBox
//
//  Created by Tanguy Hélesbeux on 05/02/2015.
//  Copyright (c) 2015 Brobox. All rights reserved.
//

#import "BBObject.h"

// Frameworks
#import <MapKit/MapKit.h>

// Model
#import "BBParseMission.h"

typedef NS_ENUM(NSInteger, BBMissionAnnotationType) {
    BBMissionAnnotationTypeFrom,
    BBMissionAnnotationTypeTo
};

@interface BBMissionAnnotation : BBObject <MKAnnotation>

@property (nonatomic, strong) BBParseMission *mission;
@property (nonatomic) BBMissionAnnotationType type;

+ (instancetype)annotationForMission:(BBParseMission *)mission
                            withType:(BBMissionAnnotationType)type;

@end
