//
//  BBCarrierAnnotation.m
//  BroBox
//
//  Created by Tanguy Hélesbeux on 28/02/2015.
//  Copyright (c) 2015 Brobox. All rights reserved.
//

#import "BBCarrierAnnotation.h"

@implementation BBCarrierAnnotation

+ (instancetype)annotationForCarrier:(BBParseUser *)carrier {
    BBCarrierAnnotation *annotation = [BBCarrierAnnotation new];
    annotation.carrier = carrier;
    return annotation;
}

#pragma mark - MKAnnotation

- (CLLocationCoordinate2D)coordinate {
    return CLLocationCoordinate2DMake(self.carrier.location.latitude, self.carrier.location.longitude);
}

- (NSString *)title {
    return [self.carrier fullName];
}

- (NSString *)subtitle {
    return NSLocalizedString(@"Carrier", @"");
}

@end
