//
//  BBMissionAnnotationView.m
//  BroBox
//
//  Created by Tanguy Hélesbeux on 29/01/2015.
//  Copyright (c) 2015 Brobox. All rights reserved.
//

#import "BBMissionAnnotationView.h"

// Others
#import "UIImage+Resize.h"

// Frameworks
#import <FacebookSDK/FacebookSDK.h>

#define IMAGE_NAME_STANDARD @"pin.png"
#define IMAGE_NAME_ARRIVAL @"pin_black.png"
#define IMAGE_SIZE 25

@implementation BBMissionAnnotationView

#pragma mark - Initialization

- (instancetype)initWithAnnotation:(id<MKAnnotation>)annotation
                   reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithAnnotation:annotation
                     reuseIdentifier:reuseIdentifier];
    if (self) {
        self.enabled = YES;
        self.canShowCallout = YES;
        
        if (self.missionAnnotation) {
            [self setViewForType:self.missionAnnotation.type];
        } else {
            [self setDefaultView];
        }
    }
    return self;
}

- (void)setViewForType:(BBMissionAnnotationType)type {
    switch (type) {
        case BBMissionAnnotationTypeFrom: {
            self.image = [[UIImage imageNamed:IMAGE_NAME_STANDARD] imageScaledToSize:CGSizeMake(IMAGE_SIZE, IMAGE_SIZE)];
            self.centerOffset = CGPointMake(0, -IMAGE_SIZE / 2);
            break;
        }
            
        case BBMissionAnnotationTypeTo: {
            self.image = [[UIImage imageNamed:IMAGE_NAME_ARRIVAL] imageScaledToSize:CGSizeMake(IMAGE_SIZE, IMAGE_SIZE)];
            self.centerOffset = CGPointMake(0, -IMAGE_SIZE / 2);
            break;
        }
    }
    
    FBProfilePictureView *profileView = [[FBProfilePictureView alloc] initWithProfileID:self.missionAnnotation.mission.creator.facebookID
                                                                        pictureCropping:FBProfilePictureCroppingSquare];
    profileView.frame = CGRectMake(0, 0, 52, 52);
    self.leftCalloutAccessoryView = profileView;
    
    UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeInfoLight];
    self.rightCalloutAccessoryView = rightButton;
}

- (void)setDefaultView {
    
}

#pragma mark - Getters & Setters

- (void)setAnnotation:(id<MKAnnotation>)annotation {
    if ([annotation isKindOfClass:[BBMissionAnnotation class]]) {
        self.missionAnnotation = annotation;
        [self setViewForType:self.missionAnnotation.type];
    } else {
        self.missionAnnotation = nil;
        [self setDefaultView];
    }
    [super setAnnotation:annotation];
}

@end
