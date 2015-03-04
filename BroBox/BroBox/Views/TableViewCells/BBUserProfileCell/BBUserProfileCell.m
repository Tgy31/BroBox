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

#define NIB_NAME @"BBUserProfileCell"
#define PREFERED_HEIGHT 70.0

@interface BBUserProfileCell()

@property (weak, nonatomic) IBOutlet FBProfilePictureView *profilePictureView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *roleLabel;


@end

@implementation BBUserProfileCell


- (void)awakeFromNib {
    
    self.profilePictureView.layer.cornerRadius = self.profilePictureView.frame.size.width/2.0;
    self.profilePictureView.backgroundColor = [UIColor lightGrayColor];
    
    self.roleLabel.textColor = [UIColor colorWithRed:0.89f green:0.40f blue:0.00f alpha:1.00f];
    
    if (self.user) {
        [self updateViews];
    }
}

- (void)updateViews {
    self.roleLabel.text = self.title;
    self.nameLabel.text = [self.user fullName];
    
    self.profilePictureView.profileID = self.user.facebookID;
}

- (void)setUser:(BBParseUser *)user {
    _user = user;
    
    [self updateViews];
}

- (void)setTitle:(NSString *)title {
    _title = title;
    
    [self updateViews];
}

#pragma mark - Helpers

+ (NSString *)reusableIdentifier {
    return NIB_NAME;
}

+ (void)registerToTableView:(UITableView *)tableView {
    UINib *nib = [UINib nibWithNibName:NIB_NAME bundle:nil];
    [tableView registerNib:nib forCellReuseIdentifier:[BBUserProfileCell reusableIdentifier]];
}

+ (CGFloat)preferedHeight {
    return PREFERED_HEIGHT;
}

@end
