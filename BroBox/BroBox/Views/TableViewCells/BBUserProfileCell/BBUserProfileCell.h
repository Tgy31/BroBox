//
//  BBUserProfileCell.h
//  BroBox
//
//  Created by Tanguy Hélesbeux on 15/02/2015.
//  Copyright (c) 2015 Brobox. All rights reserved.
//

#import "BBTableViewCell.h"

// Model
#import "BBParseUser.h"

@interface BBUserProfileCell : BBTableViewCell

@property (strong, nonatomic) BBParseUser *user;


@end
