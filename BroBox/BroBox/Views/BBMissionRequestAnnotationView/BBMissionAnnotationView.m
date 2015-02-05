//
//  BBMissionRequestAnnotationView.m
//  BroBox
//
//  Created by Tanguy Hélesbeux on 29/01/2015.
//  Copyright (c) 2015 Brobox. All rights reserved.
//

#import "BBMissionAnnotationView.h"

// Others
#import "UIImage+Resize.h"

#define IMAGE_NAME @"pin.png"
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
            self.image = [[UIImage imageNamed:IMAGE_NAME] imageScaledToSize:CGSizeMake(IMAGE_SIZE, IMAGE_SIZE)];
            self.centerOffset = CGPointMake(0, -IMAGE_SIZE / 2);
            
            UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
            self.rightCalloutAccessoryView = rightButton;
            break;
        }
            
        case BBMissionAnnotationTypeTo: {
            self.image = [[UIImage imageNamed:IMAGE_NAME] imageScaledToSize:CGSizeMake(IMAGE_SIZE, IMAGE_SIZE)];
            self.centerOffset = CGPointMake(0, -IMAGE_SIZE / 2);
            
            UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
            self.rightCalloutAccessoryView = rightButton;
            break;
        }
    }
}

- (void)setDefaultView {
    
}

#pragma mark - Getters & Setters

- (void)setAnnotation:(id<MKAnnotation>)annotation {
    if ([annotation isKindOfClass:[BBMissionAnnotation class]]) {
        self.missionAnnotation = annotation;
    } else {
        self.missionAnnotation = nil;
    }
    [super setAnnotation:annotation];
}

@end
