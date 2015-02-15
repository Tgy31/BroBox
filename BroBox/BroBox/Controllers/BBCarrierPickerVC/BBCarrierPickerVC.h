//
//  BBCarrierPickerVC.h
//  BroBox
//
//  Created by Tanguy Hélesbeux on 15/02/2015.
//  Copyright (c) 2015 Brobox. All rights reserved.
//

#import <UIKit/UIKit.h>

// Model
#import "BBParseMission.h"

@protocol BBCarrierPickerDelegate;

@interface BBCarrierPickerVC : UITableViewController

@property (weak, nonatomic) id<BBCarrierPickerDelegate> delegate;

@property (strong, nonatomic) BBParseMission *mission;

@end


@protocol BBCarrierPickerDelegate <NSObject>

- (void)carrierPickerDidSelectCarrier:(BBParseUser *)carrier;

@end