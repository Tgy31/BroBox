//
//  BBParseManager.h
//  BroBox
//
//  Created by Tanguy Hélesbeux on 25/01/2015.
//  Copyright (c) 2015 Brobox. All rights reserved.
//

#import <Foundation/Foundation.h>

// PFObjects
#import "BBGeoPoint.h"

///--------------------------------------
/// @name Blocks
///--------------------------------------

typedef void (^BBArrayResultBlock)(NSArray *objects, NSError *error);


@interface BBParseManager : NSObject

+ (void)fetchGeoPointsWithBlock:(BBArrayResultBlock)block;

@end
