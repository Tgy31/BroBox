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
#import <PayPal-iOS-SDK/PayPalMobile.h>

@protocol BBPayPalManagerDelegate;

@interface BBPaypalManager : BBObject

+ (BOOL)hasConsentForFuturePayement;

+ (void)payWithPaypal:(CGFloat)price
   fromViewController:(UIViewController<BBPayPalManagerDelegate> *)viewController;

@end

@protocol BBPayPalManagerDelegate <NSObject>

@optional

- (void)singlePaymentDidSucceed:(PayPalPayment *)payment;
- (void)singlePaymentDidCancel;
- (void)futurePaymentAuthorizationDidSucced:(NSDictionary *)futurePaymentAuthorization;
- (void)futurePaymentAuthorizationDidCancel;

@end
