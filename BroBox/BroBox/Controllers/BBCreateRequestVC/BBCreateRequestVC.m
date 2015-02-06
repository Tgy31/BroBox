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
#import "BBMissionRequestEditionVC.h"

// Model
#import "BBGeoPoint.h"
#import "BBParseMissionRequest.h"

@interface BBCreateRequestVC ()

// From views
@property (weak, nonatomic) IBOutlet UIView *viewFrom;
@property (weak, nonatomic) IBOutlet UILabel *titleLabelFrom;
@property (weak, nonatomic) IBOutlet UILabel *valueLabelFrom;

// To views
@property (weak, nonatomic) IBOutlet UIView *viewTo;
@property (weak, nonatomic) IBOutlet UILabel *titleLabelTo;
@property (weak, nonatomic) IBOutlet UILabel *valueLabelTo;

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
    
    [self viewInitialization];
    [self gestureInitialization];
}

#pragma mark - Initialization

- (void)viewInitialization {
    
//    From views
    self.titleLabelFrom.text = NSLocalizedString(@"Pick up", @"Create mission request title");
    self.valueLabelFrom.text = @"";
    
//    To views
    self.titleLabelTo.text = NSLocalizedString(@"Drop off", @"Create mission request title");
    self.valueLabelTo.text = @"";
    
    self.doneButton.enabled = NO;
}

- (void)gestureInitialization {
    
//    From views
    UITapGestureRecognizer *fromTapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                     action:@selector(fromViewTapHandler)];
    [self.viewFrom addGestureRecognizer:fromTapGesture];
    self.viewFrom.userInteractionEnabled = YES;
    
//    To views
    UITapGestureRecognizer *toTapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                   action:@selector(toViewTapHandler)];
    [self.viewTo addGestureRecognizer:toTapGesture];
    self.viewTo.userInteractionEnabled = YES;
}

#pragma mark - View methods

- (void)updateViewFrom {
    self.valueLabelFrom.text = self.placeFrom.title;
}

- (void)updateViewTo {
    self.valueLabelTo.text = self.placeTo.title;
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
    BBParseMissionRequest *missionRequest = [BBParseMissionRequest missionRequestFrom:self.placeFrom
                                                                            to:self.placeTo];
    
    BBMissionRequestEditionVC *destination = [BBMissionRequestEditionVC new];
    destination.missionRequest = missionRequest;
    [self.navigationController pushViewController:destination animated:YES];
    
    [missionRequest saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (!error) {
            NSString *title = NSLocalizedString(@"Mission saved", @"");
            NSString *subtitle = NSLocalizedString(@"Your mission has been saved. You can have only one mission at a time", @"");
            [destination showPlaceHolderWithtitle:title subtitle:subtitle];
            [destination setAsRootViewController];
        } else {
            NSString *title = NSLocalizedString(@"Mission save failed", @"");
            NSString *subtitle = [error localizedDescription];
            [destination showPlaceHolderWithtitle:title subtitle:subtitle];
        }
    }];
}


@end
