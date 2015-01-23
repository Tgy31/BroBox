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

@interface BBLoginVC ()

@property (weak, nonatomic) IBOutlet UIButton * facebookLoginButton;

@end

@implementation BBLoginVC

#pragma mark - View life cycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self tryLoginFromCache];
}

#pragma mark - Handlers

- (IBAction)loginButtonHandler {
    [self manualLogin];
}

#pragma mark - Logins

- (void)tryLoginFromCache {
    // Whenever a person opens the app, check for a cached session
    if (FBSession.activeSession.state == FBSessionStateCreatedTokenLoaded
        || FBSession.activeSession.state == FBSessionStateOpen) {
        [self automaticLogin];
    }
}

- (void)automaticLogin {
    [self startLoading];
    [BBLoginManager loginWithFacebookWithBlock:^(PFUser *user, NSError *error) {
        if (error) {
        } else if (!user) {
        } else if (user.isNew) {
            [self openApplication];
        } else {
            [self openApplication];
        }
        [self stopLoading];
    }];
}

- (void)manualLogin {
    [self startLoading];
    [BBLoginManager loginWithFacebookWithBlock:^(PFUser *user, NSError *error) {
        if (error) {
        } else if (!user) {
        } else if (user.isNew) {
            [self openApplication];
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

#pragma mark - View

- (void)startLoading {
    self.facebookLoginButton.hidden = YES;
}

- (void)stopLoading {
    self.facebookLoginButton.hidden = NO;
}


@end
