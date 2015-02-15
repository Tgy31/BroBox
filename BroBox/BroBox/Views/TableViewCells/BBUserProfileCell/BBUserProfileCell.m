//
//  BBUserProfileCell.m
//  BroBox
//
//  Created by Tanguy Hélesbeux on 15/02/2015.
//  Copyright (c) 2015 Brobox. All rights reserved.
//

#import "BBUserProfileCell.h"

// Frameworks
#import <FacebookSDK/FacebookSDK.h>

@interface BBUserProfileCell()

@property (weak, nonatomic) IBOutlet FBProfilePictureView *profilePictureView;
@property (weak, nonatomic) IBOutlet UILabel *firstNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *lastNameLabel;


@end

@implementation BBUserProfileCell


- (void)awakeFromNib {
    
    self.profilePictureView.layer.cornerRadius = self.profilePictureView.frame.size.width/2.0;
    
    if (self.user) {
        [self updateViews];
    }
}

- (void)updateViews {
    self.firstNameLabel.text = self.user.firstName;
    self.lastNameLabel.text = self.user.lastName;
    
    self.profilePictureView.profileID = self.user.facebookID;
}

- (void)setUser:(BBParseUser *)user {
    _user = user;
    
    [self updateViews];
}

@end
