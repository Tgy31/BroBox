//
//  BBParseManager.m
//  BroBox
//
//  Created by Tanguy Hélesbeux on 25/01/2015.
//  Copyright (c) 2015 Brobox. All rights reserved.
//

#import "BBParseManager.h"

// Model
#import "BBParseMessage.h"

// Managers
#import "BBNotificationManager.h"

@implementation BBParseManager

+ (void)fetchGeoPointsWithBlock:(BBArrayResultBlock)block {
    PFQuery *query = [BBGeoPoint query];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        block(objects, error);
    }];
}

+ (void)fetchMissionsAwaitingWithBlock:(BBArrayResultBlock)block {
    PFQuery *query = [BBParseMission query];
    [query includeKey:@"from"];
    [query includeKey:@"to"];
    [query includeKey:@"creator"];
    [query includeKey:@"carrier"];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        block(objects, error);
    }];
}

+ (void)mission:(BBParseMission *)mission
     addCarrier:(BBParseUser *)carrier
      withBlock:(BBBooleanResultBlock)block {
    
    PFRelation *carriersAwaitingRelation = [mission carriersAwaitingRelation];
    [carriersAwaitingRelation addObject:carrier];
    [mission saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        block(succeeded, error);
        if (!error) {
            NSString *title = NSLocalizedString(@"New carrier available", @"");
            NSString *messageFormat = NSLocalizedString(@"%@ accepted to carry your mission", @"");
            NSString *message = [NSString stringWithFormat:messageFormat, [carrier fullName]];
            NSDictionary *info = @{
                                   @"title": title
                                   };
            [BBNotificationManager pushNotificationWithMessage:message
                                                          info:info
                                                          type:BBNotificationTypeNewCarrier
                                                        toUser:mission.creator];
        }
    }];
}

+ (void)mission:(BBParseMission *)mission
setSelectedCarrier:(BBParseUser *)carrier
      withBlock:(BBBooleanResultBlock)block {
    
    BBParseUser *tempCarrier = mission.carrier;
    mission.carrier = carrier;
    mission.pebbleAuthToken = carrier.objectId;
    [mission saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (error) {
            mission.carrier = tempCarrier;
        }
        block(succeeded, error);
        if (!error) {
            NSString *title = NSLocalizedString(@"Mission starts now", @"");
            NSString *messageFormat = NSLocalizedString(@"%@ chosed you as his carrier", @"");
            NSString *message = [NSString stringWithFormat:messageFormat, [mission.creator fullName]];
            NSDictionary *info = @{
                                   @"title": title
                                   };
            [BBNotificationManager pushNotificationWithMessage:message
                                                          info:info
                                                          type:BBNotificationTypeSelectedCarrier
                                                        toUser:carrier];
        }
    }];
}

+ (void)user:(BBParseUser *)user
confirmSignUpWithBlock:(BBBooleanResultBlock)block {
    
    [user saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        block(succeeded, error);
    }];
}

+ (void)fetchUserActiveMission:(BBParseUser *)user
                     withBlock:(BBObjectResultBlock)block{
    PFQuery *query = [BBParseMission query];
    [query includeKey:@"from"];
    [query includeKey:@"to"];
    [query includeKey:@"creator"];
    [query includeKey:@"carrier"];
    [query whereKey:@"creator" equalTo:user];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            if (objects.count > 1) {
                error = [NSError errorWithDomain:@"More than one active mission for this user" code:404 userInfo:nil];
            }
            block([objects firstObject], error);
        } else {
            NSLog(@"%@", error);
            block(nil, error);
        }
    }];
}

+ (void)fetchCarriersForMission:(BBParseMission *)mission
                      withBlock:(BBArrayResultBlock)block {
    PFQuery *query = [[mission carriersAwaitingRelation] query];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        block(objects, error);
    }];
    
}

+ (void)fetchActiveCarrierAndLocationForMission:(BBParseMission *)mission
                                      withBlock:(BBObjectResultBlock)block {
    
    PFQuery *query = [BBParseUser query];
    [query whereKey:@"objectId" equalTo:mission.carrier.objectId];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (objects.count == 1) {
            block([objects firstObject], error);
        } else {
            block(nil, error);
        }
    }];
}

+ (void)fetchMessagesForMission:(BBParseMission *)mission
                      withBlock:(BBArrayResultBlock)block {
    
    PFQuery *query = [BBParseMessage query];
    [query whereKey:@"mission" equalTo:mission];
    [query includeKey:@"author"];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            mission.messages = [objects mutableCopy];
        }
        block(objects, error);
    }];
}

+ (void)addMessage:(BBParseMessage *)message
         toMission:(BBParseMission *)mission
         withBLock:(BBBooleanResultBlock)block {
    
    message.mission = mission;
    [message saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        [[mission messagesRelation] addObject:message];
        [mission saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            block(succeeded, error);
            if (!error) {
                NSString *title = NSLocalizedString(@"BroBox", @"");
                NSString *messageFormat = NSLocalizedString(@"%@: %@", @"");
                NSString *notifMessage = [NSString stringWithFormat:messageFormat, message.author.firstName, message.content];
                NSDictionary *info = @{
                                       @"title": title
                                       };
                
                BBParseUser *receiver = ([message.author.objectId isEqualToString:mission.creator.objectId]) ? mission.carrier : mission.creator;
                
                [BBNotificationManager pushNotificationWithMessage:notifMessage
                                                              info:info
                                                              type:BBNotificationTypeNewMessage
                                                            toUser:receiver];
            }
        }];
    }];
}

+ (void)deleteMission:(BBParseMission *)mission
            withBlock:(BBBooleanResultBlock)block {
    
    [mission deleteInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        block(succeeded, error);
    }];
}



@end
