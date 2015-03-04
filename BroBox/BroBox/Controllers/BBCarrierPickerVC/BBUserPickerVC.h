//
//  BBUserPickerVC.h
//  BroBox
//
//  Created by Tanguy Hélesbeux on 15/02/2015.
//  Copyright (c) 2015 Brobox. All rights reserved.
//

#import <UIKit/UIKit.h>

// Model
#import "BBParseMission.h"

@protocol BBUserPickerDelegate;

@interface BBUserPickerVC : UITableViewController

@property (weak, nonatomic) id<BBUserPickerDelegate> delegate;

@property (strong, nonatomic) NSString *subtitle;

@property (strong, nonatomic) BBParseMission *mission;
@property (strong, nonatomic) BBParseUser *selectedUser;

@end


@protocol BBUserPickerDelegate <NSObject>

- (void)userPickerDidSelectUser:(BBParseUser *)user;

@end