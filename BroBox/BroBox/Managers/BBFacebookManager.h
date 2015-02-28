//
//  BBFacebookManager.h
//  BroBox
//
//  Created by Tanguy Hélesbeux on 06/02/2015.
//  Copyright (c) 2015 Brobox. All rights reserved.
//
#import <UIKit/UIKit.h>
#import "BBObject.h"

typedef void (^BBFacebookRequestHandler)(id result, NSError *error);
typedef void (^BBFacebookImageBlock)(UIImage *image, NSError *error);

@interface BBFacebookManager : BBObject

+ (void)fetchUserInformationsWithBlock:(BBFacebookRequestHandler)block;
+ (void)fetchUserProfilePicture:(NSString *)userID withBlock:(BBFacebookImageBlock)block;

+ (NSString *)facebookIDFromJson:(NSDictionary *)json;
+ (NSString *)firstNameFromJson:(NSDictionary *)json;
+ (NSString *)lastNameFromJson:(NSDictionary *)json;
+ (NSString *)emailFromJson:(NSDictionary *)json;
+ (NSString *)birthdayFromJson:(NSDictionary *)json;

+ (BOOL)isSessionAvailable;
+ (BOOL)isSessionOpen;

@end
