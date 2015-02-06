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
#import "BBFacebookManager.h"

@interface BBSignUpVC ()

// Views
@property (weak, nonatomic) IBOutlet FBProfilePictureView *profilePictureView;
@property (weak, nonatomic) IBOutlet UILabel *firstNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *lastNameLabel;

@end

@implementation BBSignUpVC

#pragma mark - View life cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self fetchUserInfo];
}

#pragma mark - API

- (void)fetchUserInfo {
    [self stopLoading];
    [BBFacebookManager fetchUserInformationsWithBlock:^(id result, NSError *error) {
        
    }];
}


@end
