//
//  AppDelegate.h
//  BroBox
//
//  Created by Tanguy Hélesbeux on 22/01/2015.
//  Copyright (c) 2015 Brobox. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

+ (void)presentRootScreen;
+ (void)presentLoginScreen;
+ (void)presentSignUpScreen;
+ (void)presentClientScreen;
+ (void)presentCarrierScreen;

@end

