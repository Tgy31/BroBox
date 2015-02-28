//
//  BBCarrierAnnotationView.m
//  BroBox
//
//  Created by Tanguy Hélesbeux on 28/02/2015.
//  Copyright (c) 2015 Brobox. All rights reserved.
//

#import "BBCarrierAnnotationView.h"

// Others
#import "UIImage+Resize.h"

// Managers
#import "BBFacebookManager.h"

#define IMAGE_NAME @"user_pin.png"
#define IMAGE_WIDTH 30
#define IMAGE_HEIGHT 49

@implementation BBCarrierAnnotationView


#pragma mark - Initialization

- (instancetype)initWithAnnotation:(id<MKAnnotation>)annotation
                   reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithAnnotation:annotation
                     reuseIdentifier:reuseIdentifier];
    if (self) {
        self.enabled = YES;
        self.canShowCallout = YES;
        
        [self setDefaultView];
        [self fetchUserProfilePicture:self.carrierAnnotation.carrier];
    }
    
    return self;
}

- (void)setDefaultView {
    self.image = [[UIImage imageNamed:IMAGE_NAME] imageScaledToSize:CGSizeMake(IMAGE_WIDTH, IMAGE_HEIGHT)];
    self.centerOffset = CGPointMake(0, -IMAGE_HEIGHT / 2);
}

- (void)fetchUserProfilePicture:(BBParseUser *)user {
    [BBFacebookManager fetchUserProfilePicture:user.facebookID withBlock:^(UIImage *image, NSError *error) {
        self.image = [self imageWithProfilePictureImage:image];
    }];
}

#define PROFILE_BORDER_WIDTH 2

- (UIImage *)imageWithProfilePictureImage:(UIImage *)profileImage {
    
    CGSize newSize = CGSizeMake(IMAGE_WIDTH, IMAGE_HEIGHT);
    UIGraphicsBeginImageContext( newSize );
    
    // Use existing opacity as is
    [self.image drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
    
    // Apply supplied opacity if applicable
    CGRect profileFrame = CGRectMake(PROFILE_BORDER_WIDTH,PROFILE_BORDER_WIDTH,newSize.width - PROFILE_BORDER_WIDTH*2,newSize.width - PROFILE_BORDER_WIDTH*2);
    [[UIBezierPath bezierPathWithRoundedRect:profileFrame
                                cornerRadius:profileFrame.size.width/2] addClip];
    [profileImage drawInRect:profileFrame];
    
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    return newImage;
}

#pragma mark - Getters & Setters

- (void)setAnnotation:(id<MKAnnotation>)annotation {
    if ([annotation isKindOfClass:[BBCarrierAnnotation class]]) {
        self.carrierAnnotation = annotation;
    } else {
        self.carrierAnnotation = nil;
    }
    [super setAnnotation:annotation];
}

@end
