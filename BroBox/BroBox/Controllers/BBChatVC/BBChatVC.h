//
//  BBChatVC.h
//  BroBox
//
//  Created by Tanguy Hélesbeux on 01/03/2015.
//  Copyright (c) 2015 Brobox. All rights reserved.
//

#import "SLKTextViewController.h"

// Managers
#import "BBParseManager.h"

@interface BBChatVC : SLKTextViewController

@property (strong, nonatomic) BBParseMission *mission;

@end
