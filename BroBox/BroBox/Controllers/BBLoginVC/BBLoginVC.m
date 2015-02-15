//
//  BBLoginVC.m
//  BroBox
//
//  Created by Tanguy Hélesbeux on 23/01/2015.
//  Copyright (c) 2015 Brobox. All rights reserved.
//

#import "BBLoginVC.h"
#import "AppDelegate.h"

#import <FacebookSDK/FacebookSDK.h>

// Managers
#import "BBLoginManager.h"
#import "BBFacebookManager.h"

@interface BBLoginVC ()

@property (weak, nonatomic) IBOutlet UIButton * facebookLoginButton;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *loadingIndicator;
@property (weak, nonatomic) IBOutlet UILabel *errorLabel;

@end

@implementation BBLoginVC

#pragma mark - View life cycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self tryLoginFromCache];
    
    self.facebookLoginButton.backgroundColor = [UIColor colorWithRed:0.28f green:0.38f blue:0.64f alpha:1.00f];
    self.facebookLoginButton.layer.cornerRadius = 5.0;
    [self.facebookLoginButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    self.loadingIndicator.hidesWhenStopped = YES;
    
    self.errorLabel.text = nil;
}

#pragma mark - Handlers

- (IBAction)loginButtonHandler {
    [self manualLogin];
}

#pragma mark - Logins

- (void)tryLoginFromCache {
    // Whenever a person opens the app, check for a cached session
    if ([BBFacebookManager isSessionAvailable]) {
        [self automaticLogin];
    }
}

- (void)automaticLogin {
    [self startLoading];
    [BBLoginManager loginWithFacebookWithBlock:^(BBParseUser *user, NSError *error) {
        if (error) {
            self.errorLabel.text = [error localizedDescription];
        } else if (!user) {
        } else if (user.isNew || !user.facebookID) {
            [self mustSignUp];
        } else {
            [self openApplication];
        }
        [self stopLoading];
    }];
}

- (void)manualLogin {
    [self startLoading];
    [BBLoginManager loginWithFacebookWithBlock:^(BBParseUser *user, NSError *error) {
        if (error) {
            self.errorLabel.text = [error localizedDescription];
        } else if (!user) {
        } else if (user.isNew || !user.facebookID) {
            [self mustSignUp];
        } else {
            [self openApplication];
        }
        [self stopLoading];
    }];
}

#pragma mark - Action

- (void)openApplication {
    [AppDelegate presentRootScreen];
}

- (void)mustSignUp {
    [AppDelegate presentSignUpScreen];
}

#pragma mark - View

- (void)startLoading {
    self.errorLabel.text = nil;
    [self.loadingIndicator startAnimating];
    self.facebookLoginButton.hidden = YES;
}

- (void)stopLoading {
    [self.loadingIndicator stopAnimating];
    self.facebookLoginButton.hidden = NO;
}


@end
