//
//  BBCanalTpManager.h
//  BroBox
//
//  Created by Tanguy Hélesbeux on 30/01/2015.
//  Copyright (c) 2015 Brobox. All rights reserved.
//

#import "BBObject.h"

// Frameworks
#import <AFNetworking/AFNetworking.h>
#import <MapKit/MapKit.h>

///--------------------------------------
/// @name Blocks
///--------------------------------------

typedef void (^BBJourneyResultBlock)(NSDictionary *json, NSError *error);

@interface BBCanalTpManager : AFHTTPSessionManager

+ (void)getJourneyFrom:(CLLocationCoordinate2D)from
                    to:(CLLocationCoordinate2D)to
             withBlock:(BBJourneyResultBlock)block;

@end
