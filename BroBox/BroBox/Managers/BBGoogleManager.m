//
//  BBGoogleManager.m
//  BroBox
//
//  Created by Tanguy Hélesbeux on 04/02/2015.
//  Copyright (c) 2015 Brobox. All rights reserved.
//

#import "BBGoogleManager.h"

#define GOOGLE_PLACE_API_KEY @"AIzaSyD0tUcYWxjL0iw56FHIK-TqY9e5NkhT63s"
#define PLACE_TYPE @"address"
#define PLACE_RADIUS 500000

#define GOOGLE_KEY_PREDICTIONS @"predictions"
#define GOOGLE_KEY_PREDICTION_DESCRIPTION @"description"

static BBGoogleManager *sharedManager;

@implementation BBGoogleManager

+ (instancetype)sharedManager {
    if (!sharedManager) {
        sharedManager = [BBGoogleManager new];
    }
    return sharedManager;
}

#pragma mark - API Services

+ (void)fetchCompletionWithString:(NSString *)string
                         location:(CLLocation *)location
                            block:(BBGoogleAutoCompleteResult)block {
    [[BBGoogleManager sharedManager] fetchCompletionWithString:string
                                                      location:location
                                                         block:block];
}


- (void)fetchCompletionWithString:(NSString *)string
                         location:(CLLocation *)location
                            block:(BBGoogleAutoCompleteResult)block {
    static NSString *sURL = @"https://maps.googleapis.com/maps/api/place/autocomplete/json";
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionaryWithDictionary:@{
                                                                                      @"key": GOOGLE_PLACE_API_KEY,
                                                                                      @"input": string,
                                                                                      @"types": PLACE_TYPE
                                                                                      }];
    
    if (location) {
        NSString *locationParameter = [NSString stringWithFormat:@"%f,%f", location.coordinate.latitude, location.coordinate.longitude];
        [parameters setObject:locationParameter forKey:@"location"];
    }
    
    [self GET:sURL parameters:parameters success:^(NSURLSessionDataTask *task, id responseObject) {
        block(responseObject, nil);
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        block(nil, error);
    }];
}

@end
