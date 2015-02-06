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
#import "BBParseMissionRequest.h"
#import "BBParseUser.h"

///--------------------------------------
/// @name Blocks
///--------------------------------------

typedef void (^BBArrayResultBlock)(NSArray *objects, NSError *error);
typedef void (^BBObjectResultBlock)(PFObject *object, NSError *error);
typedef void (^BBBooleanResultBlock)(BOOL succeeded, NSError *error);


@interface BBParseManager : NSObject

+ (void)fetchGeoPointsWithBlock:(BBArrayResultBlock)block;
+ (void)fetchMissionRequestsWithBlock:(BBArrayResultBlock)block;
+ (void)missionRequest:(BBParseMissionRequest *)missionRequest addCarrier:(BBParseUser *)carrier withBlock:(BBBooleanResultBlock)block;
+ (void)user:(BBParseUser *)user confirmSignUpWithBlock:(BBBooleanResultBlock)block;
+ (void)fetchUserActiveMissionRequest:(BBParseUser *)user
                            withBlock:(BBObjectResultBlock)block;

@end
