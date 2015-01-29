//
//  BBMissionRequestAnnotationView.m
//  BroBox
//
//  Created by Tanguy Hélesbeux on 29/01/2015.
//  Copyright (c) 2015 Brobox. All rights reserved.
//

#import "BBMissionRequestAnnotationView.h"

// Others
#import "UIImage+Resize.h"

#define IMAGE_NAME @"pin.png"
#define IMAGE_SIZE 25

@implementation BBMissionRequestAnnotationView

- (instancetype)initWithAnnotation:(id<MKAnnotation>)annotation
                   reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithAnnotation:annotation
                     reuseIdentifier:reuseIdentifier];
    if (self) {
        self.image = [[UIImage imageNamed:IMAGE_NAME] imageScaledToSize:CGSizeMake(IMAGE_SIZE, IMAGE_SIZE)];
        self.enabled = YES;
        self.canShowCallout = YES;
        self.centerOffset = CGPointMake(0, -IMAGE_SIZE / 2);
    }
    return self;
}

@end
