//
//  BBCarrierAnnotationView.h
//  BroBox
//
//  Created by Tanguy Hélesbeux on 28/02/2015.
//  Copyright (c) 2015 Brobox. All rights reserved.
//

#import <MapKit/MapKit.h>

// Model
#import "BBCarrierAnnotation.h"

@interface BBCarrierAnnotationView : MKAnnotationView

@property (strong, nonatomic) BBCarrierAnnotation *carrierAnnotation;

@end
