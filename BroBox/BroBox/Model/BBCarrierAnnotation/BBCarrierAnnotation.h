//
//  BBCarrierAnnotation.h
//  BroBox
//
//  Created by Tanguy Hélesbeux on 28/02/2015.
//  Copyright (c) 2015 Brobox. All rights reserved.
//

#import "BBObject.h"

#import "BBParseUser.h"

@interface BBCarrierAnnotation : BBObject

@property (strong, nonatomic) BBParseUser *carrier;

+ (instancetype)annotationForCarrier:(BBParseUser *)carrier;

@end
