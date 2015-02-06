//
//  BBSignUpVC.m
//  BroBox
//
//  Created by Tanguy Hélesbeux on 06/02/2015.
//  Copyright (c) 2015 Brobox. All rights reserved.
//

#import "BBSignUpVC.h"

// Frameworks
#import <FacebookSDK/FacebookSDK.h>

// Managers
#import "AppDelegate.h"
#import "BBFacebookManager.h"
#import "BBParseManager.h"

// Model
#import "BBParseUser.h"

@interface BBSignUpVC ()

// Views
@property (weak, nonatomic) IBOutlet FBProfilePictureView *profilePictureView;
@property (weak, nonatomic) IBOutlet UITextField *firstNameTextField;
@property (weak, nonatomic) IBOutlet UITextField *lastNameTextField;
@property (weak, nonatomic) IBOutlet UITextField *birthdayTextField;
@property (weak, nonatomic) IBOutlet UITextField *emailTextField;

@property (strong, nonatomic) UIBarButtonItem *actionButton;

// Objects
@property (strong, nonatomic) BBParseUser *user;

@end

@implementation BBSignUpVC

#pragma mark - View life cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self fetchUserInfo];
    [self initializeViews];
}

#pragma mark - Initialization

- (void)initializeViews {
    self.firstNameTextField.placeholder = NSLocalizedString(@"First name", @"");
    self.lastNameTextField.placeholder = NSLocalizedString(@"Last name", @"");
    self.birthdayTextField.placeholder = NSLocalizedString(@"Birthday dd/mm/yyyy", @"");
    self.emailTextField.placeholder = NSLocalizedString(@"Email", @"");
    
    self.actionButton.enabled = YES;
}

#pragma mark - API

- (void)fetchUserInfo {
    [self startLoading];
    [BBFacebookManager fetchUserInformationsWithBlock:^(id result, NSError *error) {
        if (!error) {
            [self updateUser:self.user withJson:result];
            [self updateProfileViews];
            [self stopLoading];
        } else {
            NSLog(@"%@", error);
            [self showFailedToRetrieveFacebookProfileWithError:error];
        }
    }];
}

- (void)saveUser {
    [self startLoading];
    self.actionButton.enabled = NO;
    [BBParseManager user:self.user confirmSignUpWithBlock:^(BOOL succeeded, NSError *error) {
        if (!error) {
            [AppDelegate presentRootScreen];
        } else {
            NSLog(@"%@", error);
        }
        [self stopLoading];
    }];
}

#pragma mark - Getters & Setters

- (BBParseUser *)user {
    if (!_user) {
        return [BBParseUser currentUser];
    }
    return _user;
}

- (UIBarButtonItem *)actionButton {
    if (!_actionButton) {
        NSString *title = NSLocalizedString(@"Next", @"");
        _actionButton = [[UIBarButtonItem alloc] initWithTitle:title
                                                         style:UIBarButtonItemStyleDone
                                                        target:self
                                                        action:@selector(actionButtonHandler)];
        self.navigationItem.rightBarButtonItem = _actionButton;
    }
    return _actionButton;
}

#pragma mark - Handlers

- (void)actionButtonHandler {
    [self saveUser];
}

#pragma mark - View methods

- (void)updateProfileViews {
    self.profilePictureView.profileID = self.user.facebookID;
    self.firstNameTextField.text = self.user.firstName;
    self.lastNameTextField.text = self.user.lastName;
    self.birthdayTextField.text = self.user.birthday;
    self.emailTextField.text = self.user.email;
}

#pragma marl - Placeholder Methods

- (void)showFailedToRetrieveFacebookProfileWithError:(NSError *)error {
    NSString *title = NSLocalizedString(@"Error", @"");
    NSString *subtitle = [error localizedFailureReason];
    [self showPlaceHolderWithtitle:title subtitle:subtitle];
}

#pragma mark - Profile methods

- (void)updateUser:(BBParseUser *)user withJson:(NSDictionary *)json {
    user.facebookID = [BBFacebookManager facebookIDFromJson:json];
    user.firstName = [BBFacebookManager firstNameFromJson:json];
    user.lastName = [BBFacebookManager lastNameFromJson:json];
    user.email = [BBFacebookManager emailFromJson:json];
    user.birthday = [BBFacebookManager birthdayFromJson:json];
}


@end
