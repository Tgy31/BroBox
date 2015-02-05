//
//  BBMissionRequestAnnotationView.h
//  BroBox
//
//  Created by Tanguy Hélesbeux on 29/01/2015.
//  Copyright (c) 2015 Brobox. All rights reserved.
//

#import <MapKit/MapKit.h>

// Model
#import "BBMissionAnnotation.h"

@interface BBMissionAnnotationView : MKAnnotationView

@property (weak, nonatomic) BBMissionAnnotation *missionAnnotation;

@end
