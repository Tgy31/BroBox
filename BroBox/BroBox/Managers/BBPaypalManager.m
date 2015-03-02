//
//  BBPaypalManager.m
//  BroBox
//
//  Created by Tanguy Hélesbeux on 02/03/2015.
//  Copyright (c) 2015 Brobox. All rights reserved.
//

#import "BBPaypalManager.h"

// Frameworks

static BBPaypalManager *sharedManager;

@interface BBPaypalManager() <PayPalPaymentDelegate, PayPalFuturePaymentDelegate>

@property (nonatomic, strong, readwrite) PayPalConfiguration *payPalConfiguration;
@property (nonatomic) BOOL hasConsentForFuturePayement;

@property (weak, nonatomic) UIViewController<BBPayPalManagerDelegate> *delegate;

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
        
        // See PayPalConfiguration.h for details and default values.
        // Should you wish to change any of the values, you can do so here.
        // For example, if you wish to accept PayPal but not payment card payments, then add:
        _payPalConfiguration.acceptCreditCards = YES;
        // Or if you wish to have the user choose a Shipping Address from those already
        // associated with the user's PayPal account, then add:
        _payPalConfiguration.payPalShippingAddressOption = PayPalShippingAddressOptionPayPal;
        
        _payPalConfiguration.forceDefaultsInSandbox = YES;
    }
    return _payPalConfiguration;
}

#pragma mark - Endpoints

+ (void)payWithPaypal:(CGFloat)price fromViewController:(UIViewController<BBPayPalManagerDelegate> *)viewController {
    [[BBPaypalManager sharedManager] payWithPaypal:price fromViewController:viewController];
}

- (void)payWithPaypal:(CGFloat)price fromViewController:(UIViewController<BBPayPalManagerDelegate> *)viewController {
    
    self.delegate = viewController;
    
    if (self.hasConsentForFuturePayement) {
        if ([viewController respondsToSelector:@selector(singlePaymentDidSucceed:)]) {
            [viewController singlePaymentDidSucceed:nil];
        }
    } else {
        [self presentActionSheetWithPrice:price
                        andViewController:viewController];
    }
}

+ (void)obtainConsentFromViewController:(UIViewController<BBPayPalManagerDelegate> *)viewController {
    [[BBPaypalManager sharedManager] obtainConsentFromViewController:viewController];
}

- (void)obtainConsentFromViewController:(UIViewController<BBPayPalManagerDelegate> *)viewController {
    
    self.delegate = viewController;
    
    PayPalFuturePaymentViewController *fpViewController;
    fpViewController = [[PayPalFuturePaymentViewController alloc] initWithConfiguration:self.payPalConfiguration
                                                                               delegate:self];
    
    // Present the PayPalFuturePaymentViewController
    [viewController presentViewController:fpViewController animated:YES completion:nil];
}

- (void)presentActionSheetWithPrice:(CGFloat)price andViewController:(UIViewController<BBPayPalManagerDelegate> *)viewController {
    
    NSString *titleFormat = NSLocalizedString(@"Pay %.2f€ with PayPal", @"");
    NSString *title = [NSString stringWithFormat:titleFormat, price];
    NSString *message = NSLocalizedString(@"You are not logged in with PayPal. You can make a single payment or connect your PayPal account to BroBox", @"");
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title
                                                                             message:message preferredStyle:UIAlertControllerStyleActionSheet];
    
    UIAlertAction *singlePaymentAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"Single payment", @"")
                                                                  style:UIAlertActionStyleDefault
                                                                handler:^(UIAlertAction *action) {
                                                                    [self singlePayment:price fromViewController:viewController];
                                                                }];
    [alertController addAction:singlePaymentAction];
    
    UIAlertAction *loginPaymentAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"Connect PayPal account", @"")
                                                                 style:UIAlertActionStyleDefault
                                                               handler:^(UIAlertAction *action) {
                                                                   [self obtainConsentFromViewController:viewController];
                                                               }];
    [alertController addAction:loginPaymentAction];
    
    UIAlertAction *cancelPaymentAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"Cancel", @"")
                                                                  style:UIAlertActionStyleCancel
                                                                handler:^(UIAlertAction *action) {
                                                                }];
    [alertController addAction:cancelPaymentAction];
    
    [viewController presentViewController:alertController animated:YES completion:^{
        
    }];
}

- (void)singlePayment:(CGFloat)price fromViewController:(UIViewController<BBPayPalManagerDelegate> *)viewController {
    // Create a PayPalPayment
    PayPalPayment *payment = [[PayPalPayment alloc] init];
    
    // Amount, currency, and description
    payment.amount = [[NSDecimalNumber alloc] initWithString:[NSString stringWithFormat:@"%.2f", price]];
    payment.currencyCode = @"EUR";
    payment.shortDescription = @"BroBox delivery request";
    
    // Use the intent property to indicate that this is a "sale" payment,
    // meaning combined Authorization + Capture.
    // To perform Authorization only, and defer Capture to your server,
    // use PayPalPaymentIntentAuthorize.
    // To place an Order, and defer both Authorization and Capture to
    // your server, use PayPalPaymentIntentOrder.
    // (PayPalPaymentIntentOrder is valid only for PayPal payments, not credit card payments.)
    payment.intent = PayPalPaymentIntentSale;
    
    // Several other optional fields that you can set here are documented in PayPalPayment.h,
    // including paymentDetails, items, invoiceNumber, custom, softDescriptor, etc.
    
    // Check whether payment is processable.
    if (!payment.processable) {
        // If, for example, the amount was negative or the shortDescription was empty, then
        // this payment would not be processable. You would want to handle that here.
    }
    
    // Create a PayPalPaymentViewController.
    PayPalPaymentViewController *paymentViewController;
    paymentViewController = [[PayPalPaymentViewController alloc] initWithPayment:payment
                                                                   configuration:self.payPalConfiguration
                                                                        delegate:self];
    
    // Present the PayPalPaymentViewController.
    [viewController presentViewController:paymentViewController animated:YES completion:nil];
}

#pragma mark - PayPalFuturePaymentDelegate methods

- (void)payPalFuturePaymentDidCancel:(PayPalFuturePaymentViewController *)futurePaymentViewController {
    
    if ([self.delegate respondsToSelector:@selector(futurePaymentAuthorizationDidCancel)]) {
        [self.delegate futurePaymentAuthorizationDidCancel];
    }
    
    // User cancelled login. Dismiss the PayPalLoginViewController, breathe deeply.
    [self.delegate dismissViewControllerAnimated:YES
                                      completion:nil];
    self.delegate = nil;
}

- (void)payPalFuturePaymentViewController:(PayPalFuturePaymentViewController *)futurePaymentViewController
                didAuthorizeFuturePayment:(NSDictionary *)futurePaymentAuthorization {
    
    // The user has successfully logged into PayPal, and has consented to future payments.
    
    // Your code must now send the authorization response to your server.
//    [self sendAuthorizationToServer:futurePaymentAuthorization];
    self.hasConsentForFuturePayement = YES;
    
    
    // Be sure to dismiss the PayPalLoginViewController.
    [self.delegate dismissViewControllerAnimated:YES
                                      completion:nil];
    
    if ([self.delegate respondsToSelector:@selector(futurePaymentAuthorizationDidSucced:)]) {
        [self.delegate futurePaymentAuthorizationDidSucced:futurePaymentAuthorization];
    }
    self.delegate = nil;
}

#pragma mark - PayPalPaymentDelegate methods

- (void)payPalPaymentViewController:(PayPalPaymentViewController *)paymentViewController
                 didCompletePayment:(PayPalPayment *)completedPayment {
    
    // Payment was processed successfully; send to server for verification and fulfillment.
    [self verifyCompletedPayment:completedPayment];
    
    
    if ([self.delegate respondsToSelector:@selector(singlePaymentDidSucceed:)]) {
        [self.delegate singlePaymentDidSucceed:completedPayment];
    }
    
    // Dismiss the PayPalPaymentViewController.
    [self.delegate dismissViewControllerAnimated:YES completion:nil];
    self.delegate = nil;
}

- (void)payPalPaymentDidCancel:(PayPalPaymentViewController *)paymentViewController {
    
    
    if ([self.delegate respondsToSelector:@selector(singlePaymentDidCancel)]) {
        [self.delegate singlePaymentDidCancel];
    }
    
    // The payment was canceled; dismiss the PayPalPaymentViewController.
    [self.delegate dismissViewControllerAnimated:YES completion:nil];
    self.delegate = nil;
}

- (void)verifyCompletedPayment:(PayPalPayment *)completedPayment {
    
    // Send confirmation to your server; your server should verify the proof of payment
    // and give the user their goods or services. If the server is not reachable, save
    // the confirmation and try again later.
}

@end
