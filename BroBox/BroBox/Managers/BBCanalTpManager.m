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

#pragma mark - Data format

+ (NSArray *)pathForJourney:(NSDictionary *)journey {
    return [[BBCanalTpManager sharedManager] pathForJourney:journey];
}

- (NSArray *)pathForJourney:(NSDictionary *)journey {
    NSMutableArray *locations = [[NSMutableArray alloc] init];
    NSArray *sections = [journey objectForKey:@"sections"];
    for (NSDictionary *section in sections) {
        NSArray *coordinates = [[section objectForKey:@"geojson"] objectForKey:@"coordinates"];
        for (NSArray *coordinate in coordinates) {
            double latitude = [[coordinate lastObject] doubleValue];
            double longitude = [[coordinate firstObject] doubleValue];
            CLLocation *location = [[CLLocation alloc] initWithLatitude:latitude longitude:longitude];
            [locations addObject:location];
        }
    }
    return locations;
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
    
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"yyyyMMdd'T'hhmm"];
    
    NSDictionary *parameters = @{
                                 @"from": [self stringFromCoordinate:from],
                                 @"to": [self stringFromCoordinate:to],
                                 @"datetime": [dateFormat stringFromDate:[NSDate date]]
                                 };
    
    [self GET:@"journeys" parameters:parameters success:^(NSURLSessionDataTask *task, id responseObject) {
        block(responseObject, nil);
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        block(nil, error);
    }];
}


- (void)getAllPersons:(NSArray *)friendList
              success:(void (^)(NSURLSessionDataTask *, NSDictionary *))success
              failure:(void (^)(NSURLSessionDataTask *, NSError *))failure
{
    [self GET:@"persons/" parameters:nil success:success failure:failure];
}


@end
