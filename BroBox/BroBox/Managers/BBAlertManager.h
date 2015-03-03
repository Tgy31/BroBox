//
//  BBAlertManager.h
//  BroBox
//
//  Created by Tanguy Hélesbeux on 02/03/2015.
//  Copyright (c) 2015 Brobox. All rights reserved.
//

#import "BBObject.h"

// Model
#import "BBParseMission.h"

///--------------------------------------
/// @name Blocks
///--------------------------------------

typedef void (^BBAlertButtonHandlerBlock)();
typedef void (^BBAlertButtonHandlerMissionBlock)(BBParseMission *mission);

@interface BBAlertManager : BBObject

+ (void)presentAlertForMissionStart:(BBParseMission *)mission
                          withBlock:(BBAlertButtonHandlerMissionBlock)block;

@end
