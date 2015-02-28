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
#import "BBParseMission.h"
#import "BBParseUser.h"

///--------------------------------------
/// @name Blocks
///--------------------------------------

typedef void (^BBArrayResultBlock)(NSArray *objects, NSError *error);
typedef void (^BBObjectResultBlock)(PFObject *object, NSError *error);
typedef void (^BBBooleanResultBlock)(BOOL succeeded, NSError *error);


@interface BBParseManager : NSObject

+ (void)fetchGeoPointsWithBlock:(BBArrayResultBlock)block;
+ (void)fetchMissionsAwaitingWithBlock:(BBArrayResultBlock)block;
+ (void)mission:(BBParseMission *)mission addCarrier:(BBParseUser *)carrier withBlock:(BBBooleanResultBlock)block;
+ (void)user:(BBParseUser *)user confirmSignUpWithBlock:(BBBooleanResultBlock)block;
+ (void)fetchUserActiveMission:(BBParseUser *)user
                     withBlock:(BBObjectResultBlock)block;
+ (void)fetchCarriersForMission:(BBParseMission *)mission
                      withBlock:(BBArrayResultBlock)block;
+ (void)deleteMission:(BBParseMission *)mission
            withBlock:(BBBooleanResultBlock)block;

@end
