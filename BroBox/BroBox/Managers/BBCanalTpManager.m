//
//  BBCanalTpManager.m
//  BroBox
//
//  Created by Tanguy Hélesbeux on 30/01/2015.
//  Copyright (c) 2015 Brobox. All rights reserved.
//

#import "BBCanalTpManager.h"
#import "BBConstants.h"


#define BASE_URL @"http://api.navitia.io/v1/"

static BBCanalTpManager *sharedManager;

@implementation BBCanalTpManager

+ (BBCanalTpManager *)sharedManager
{
    if (!sharedManager) {
        sharedManager = [[self alloc] initWithBaseURL:[NSURL URLWithString:BASE_URL]];
        [sharedManager setAuthorizationHeader];
    }
    return sharedManager;
}

- (instancetype)initWithBaseURL:(NSURL *)url
{
    self = [super initWithBaseURL:url];
    
    if (self) {
        self.responseSerializer = [AFJSONResponseSerializer serializer];
        self.requestSerializer = [AFJSONRequestSerializer serializer];
    }
    
    return self;
}

#pragma mark - Helpers


- (void)setAuthorizationHeader
{
    [self.requestSerializer setAuthorizationHeaderFieldWithUsername:NAVITIA_PRIVATEKEY password:nil];
}

- (NSString *)stringFromCoordinate:(CLLocationCoordinate2D)coordinate {
    return [NSString stringWithFormat:@"%f;%f", coordinate.longitude, coordinate.latitude];
}

#pragma mark - Services -

#pragma mark Journeys

+ (void)getJourneyFrom:(CLLocationCoordinate2D)from
                    to:(CLLocationCoordinate2D)to
             withBlock:(BBJourneyResultBlock)block {
    [[BBCanalTpManager sharedManager] getJourneyFrom:from
                                                  to:to
                                           withBlock:block];
}

- (void)getJourneyFrom:(CLLocationCoordinate2D)from
                    to:(CLLocationCoordinate2D)to
             withBlock:(BBJourneyResultBlock)block {
    NSDictionary *parameters = @{
                                 @"from": [self stringFromCoordinate:from],
                                 @"to": [self stringFromCoordinate:to],
                                 @"datetime": @"20150118T0800"
                                 };
    
    [self GET:@"journeys" parameters:parameters success:^(NSURLSessionDataTask *task, id responseObject) {
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
    }];
}


- (void)getAllPersons:(NSArray *)friendList
              success:(void (^)(NSURLSessionDataTask *, NSDictionary *))success
              failure:(void (^)(NSURLSessionDataTask *, NSError *))failure
{
    [self GET:@"persons/" parameters:nil success:success failure:failure];
}


@end
