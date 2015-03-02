//
//  BBPaypalManager.m
//  BroBox
//
//  Created by Tanguy Hélesbeux on 02/03/2015.
//  Copyright (c) 2015 Brobox. All rights reserved.
//

#import "BBPaypalManager.h"

// Frameworks
#import <PayPal-iOS-SDK/PayPalMobile.h>

static BBPaypalManager *sharedManager;

@interface BBPaypalManager() <PayPalFuturePaymentDelegate>

@property (nonatomic, strong, readwrite) PayPalConfiguration *payPalConfiguration;
@property (nonatomic) BOOL hasConsentForFuturePayement;

@end

@implementation BBPaypalManager

#pragma mark - Singleton

+ (instancetype)sharedManager {
    if (!sharedManager) {
        sharedManager = [BBPaypalManager new];
        
        sharedManager.hasConsentForFuturePayement = NO;
        
        // Start out working with the mock environment. When you are ready, switch to PayPalEnvironmentProduction.
        [PayPalMobile preconnectWithEnvironment:PayPalEnvironmentNoNetwork];
    }
    return sharedManager;
}

+ (BOOL)hasConsentForFuturePayement {
    return [BBPaypalManager sharedManager].hasConsentForFuturePayement;
}

#pragma mark - Getters and Setters

- (PayPalConfiguration *)payPalConfiguration {
    if (!_payPalConfiguration) {
        _payPalConfiguration = [[PayPalConfiguration alloc] init];
        
        // See PayPalConfiguration.h for details and default values.
        
        // Minimally, you will need to set three merchant information properties.
        // These should be the same values that you provided to PayPal when you registered your app.
        _payPalConfiguration.merchantName = @"BroBox";
        _payPalConfiguration.merchantPrivacyPolicyURL = [NSURL URLWithString:@"https://www.omega.supreme.example/privacy"];
        _payPalConfiguration.merchantUserAgreementURL = [NSURL URLWithString:@"https://www.omega.supreme.example/user_agreement"];
    }
    return _payPalConfiguration;
}

#pragma mark - Endpoints

+ (void)obtainConsentFromViewController:(UIViewController *)viewController {
    [[BBPaypalManager sharedManager] obtainConsentFromViewController:viewController];
}

- (void)obtainConsentFromViewController:(UIViewController *)viewController {
    PayPalFuturePaymentViewController *fpViewController;
    fpViewController = [[PayPalFuturePaymentViewController alloc] initWithConfiguration:self.payPalConfiguration
                                                                               delegate:self];
    
    // Present the PayPalFuturePaymentViewController
    [viewController presentViewController:fpViewController animated:YES completion:nil];
}

#pragma mark - PayPalFuturePaymentDelegate methods

- (void)payPalFuturePaymentDidCancel:(PayPalFuturePaymentViewController *)futurePaymentViewController {
    // User cancelled login. Dismiss the PayPalLoginViewController, breathe deeply.
    [futurePaymentViewController.presentingViewController dismissViewControllerAnimated:YES
                                                                             completion:nil];
}

- (void)payPalFuturePaymentViewController:(PayPalFuturePaymentViewController *)futurePaymentViewController
                didAuthorizeFuturePayment:(NSDictionary *)futurePaymentAuthorization {
    // The user has successfully logged into PayPal, and has consented to future payments.
    
    // Your code must now send the authorization response to your server.
//    [self sendAuthorizationToServer:futurePaymentAuthorization];
    self.hasConsentForFuturePayement = YES;
    
    // Be sure to dismiss the PayPalLoginViewController.
    [futurePaymentViewController.presentingViewController dismissViewControllerAnimated:YES
                                                                             completion:nil];
}

@end
