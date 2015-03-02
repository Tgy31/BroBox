//
//  BBPaypalManager.h
//  BroBox
//
//  Created by Tanguy Hélesbeux on 02/03/2015.
//  Copyright (c) 2015 Brobox. All rights reserved.
//

#import "BBObject.h"

// Frameworks
#import <UIKit/UIKit.h>

@interface BBPaypalManager : BBObject

+ (BOOL)hasConsentForFuturePayement;
+ (void)obtainConsentFromViewController:(UIViewController *)viewController;

@end
