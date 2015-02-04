//
//  BBLocationManager.h
//  BroBox
//
//  Created by Tanguy Hélesbeux on 04/02/2015.
//  Copyright (c) 2015 Brobox. All rights reserved.
//

#import "BBObject.h"

static NSString *BBNotificationLocationAuthorizationDenied = @"BBNotificationLocationAuthorizationDenied";

@interface BBLocationManager : BBObject

+ (void)startUpdatingLocation;

@end
