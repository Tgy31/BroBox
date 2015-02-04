//
//  BBGoogleManager.h
//  BroBox
//
//  Created by Tanguy Hélesbeux on 04/02/2015.
//  Copyright (c) 2015 Brobox. All rights reserved.
//

#import "BBObject.h"

// Frameworks
#import <MapKit/MapKit.h>
#import <AFNetworking/AFNetworking.h>

///--------------------------------------
/// @name Blocks
///--------------------------------------

typedef void (^BBGoogleAutoCompleteResult)(NSDictionary *json, NSError *error);

@interface BBGoogleManager : AFHTTPSessionManager

+ (void)fetchCompletionWithString:(NSString *)string
                         location:(CLLocation *)location
                            block:(BBGoogleAutoCompleteResult)block;

@end
