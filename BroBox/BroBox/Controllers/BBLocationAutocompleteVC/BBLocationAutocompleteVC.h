//
//  BBLocationAutocompleteVC.h
//  BroBox
//
//  Created by Tanguy Hélesbeux on 04/02/2015.
//  Copyright (c) 2015 Brobox. All rights reserved.
//

#import "BBViewController.h"

// Model
#import "BBGeoPoint.h"

///--------------------------------------
/// @name Blocks
///--------------------------------------

typedef void (^BBLocationAutocompleteBlock)(BBGeoPoint *place);

@protocol BBLocationAutocompleteDelegate;

@interface BBLocationAutocompleteVC : BBViewController

@property (weak, nonatomic) id<BBLocationAutocompleteDelegate> delegate;
@property (copy, nonatomic) BBLocationAutocompleteBlock completionBlock;

@end

@protocol BBLocationAutocompleteDelegate <NSObject>

- (void)locationAutocompleteReturnedPlace:(BBGeoPoint *)place;

@end
