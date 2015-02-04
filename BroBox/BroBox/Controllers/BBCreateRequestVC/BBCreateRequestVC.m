//
//  BBCreateRequestVC.m
//  BroBox
//
//  Created by Tanguy Hélesbeux on 04/02/2015.
//  Copyright (c) 2015 Brobox. All rights reserved.
//

#import "BBCreateRequestVC.h"

// Controllers
#import "BBLocationAutocompleteVC.h"

// Model
#import "BBGeoPoint.h"

@interface BBCreateRequestVC () <BBLocationAutocompleteDelegate>

// From views
@property (weak, nonatomic) IBOutlet UIView *fromView;
@property (weak, nonatomic) IBOutlet UILabel *fromTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *fromValueLabel;

// To views
@property (weak, nonatomic) IBOutlet UIView *toView;
@property (weak, nonatomic) IBOutlet UILabel *toTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *toValueLabel;

// Other views
@property (strong, nonatomic) UIBarButtonItem *doneButton;

// Objects
@property (strong, nonatomic) BBGeoPoint *placeFrom;
@property (strong, nonatomic) BBGeoPoint *placeTo;


@end

@implementation BBCreateRequestVC

#pragma mark - View life cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationBarShouldCoverViewController = NO;
    
    [self viewInitialization];
    [self gestureInitialization];
}

#pragma mark - Initialization

- (void)viewInitialization {
    
//    From views
    self.fromTitleLabel.text = NSLocalizedString(@"Pick up", @"Create mission request title");
    self.fromValueLabel.text = @"";
    
//    To views
    self.toTitleLabel.text = NSLocalizedString(@"Drop off", @"Create mission request title");
    self.toValueLabel.text = @"";
    
    self.doneButton.enabled = NO;
}

- (void)gestureInitialization {
    
//    From views
    UITapGestureRecognizer *fromTapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                     action:@selector(fromViewTapHandler)];
    [self.fromView addGestureRecognizer:fromTapGesture];
    self.fromView.userInteractionEnabled = YES;
    
//    To views
    UITapGestureRecognizer *toTapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                   action:@selector(toViewTapHandler)];
    [self.toView addGestureRecognizer:toTapGesture];
    self.toView.userInteractionEnabled = YES;
}

#pragma mark - View methods

- (void)updateViewFrom {
    self.fromValueLabel.text = self.placeFrom.title;
}

- (void)updateViewTo {
    self.toValueLabel.text = self.placeTo.title;
}

- (void)updateDoneButtonEnabled {
    if (!self.placeFrom
        || ! self.placeTo) {
        self.doneButton.enabled = NO;
    } else {
        self.doneButton.enabled = YES;
    }
}

#pragma mark - Getters & Setters

- (UIBarButtonItem *)doneButton {
    if (!_doneButton) {
        _doneButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone
                                                                    target:self
                                                                    action:@selector(doneButtonHandler)];
        self.navigationItem.rightBarButtonItem = _doneButton;
    }
    return _doneButton;
}

- (void)setPlaceFrom:(BBGeoPoint *)placeFrom {
    _placeFrom = placeFrom;
    [self updateViewFrom];
    [self updateDoneButtonEnabled];
}

- (void)setPlaceTo:(BBGeoPoint *)placeTo {
    _placeTo = placeTo;
    [self updateViewTo];
    [self updateDoneButtonEnabled];
}

#pragma mark - Handlers

- (void)fromViewTapHandler {
    BBLocationAutocompleteVC *destination = [BBLocationAutocompleteVC new];
    destination.title = NSLocalizedString(@"Pick up", @"Autocompletion screen when setting up pick up location");
    [destination setCompletionBlock:^(BBGeoPoint *place) {
        self.placeFrom = place;
        [self.navigationController popViewControllerAnimated:YES];
    }];
    [self.navigationController pushViewController:destination animated:YES];
}

- (void)toViewTapHandler {
    BBLocationAutocompleteVC *destination = [BBLocationAutocompleteVC new];
    destination.title = NSLocalizedString(@"Drop off", @"Autocompletion screen when setting up drop off location");
    [destination setCompletionBlock:^(BBGeoPoint *place) {
        self.placeTo = place;
        [self.navigationController popViewControllerAnimated:YES];
    }];
    [self.navigationController pushViewController:destination animated:YES];
}

- (void)doneButtonHandler {
    
}

#pragma mark - BBLocationAutocompleteDelegate

- (void)locationAutocompleteReturnedPlace:(BBGeoPoint *)place {
    
}


@end
