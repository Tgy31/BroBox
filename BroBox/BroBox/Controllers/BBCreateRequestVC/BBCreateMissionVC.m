//
//  BBCreateMissionVC.m
//  BroBox
//
//  Created by Tanguy Hélesbeux on 04/02/2015.
//  Copyright (c) 2015 Brobox. All rights reserved.
//

#import "BBCreateMissionVC.h"

// Managers
#import "BBInstallationManager.h"

// Controllers
#import "BBLocationAutocompleteVC.h"
#import "BBCreateMissionNavigationController.h"

// Model
#import "BBGeoPoint.h"
#import "BBParseMission.h"

@interface BBCreateMissionVC ()

// From views
@property (weak, nonatomic) IBOutlet UIView *viewFrom;
@property (weak, nonatomic) IBOutlet UILabel *titleLabelFrom;
@property (weak, nonatomic) IBOutlet UILabel *valueLabelFrom;

// To views
@property (weak, nonatomic) IBOutlet UIView *viewTo;
@property (weak, nonatomic) IBOutlet UILabel *titleLabelTo;
@property (weak, nonatomic) IBOutlet UILabel *valueLabelTo;

// Breakbale view
@property (weak, nonatomic) IBOutlet UIView *viewBreakable;
@property (weak, nonatomic) IBOutlet UILabel *titleLabelBreakable;
@property (weak, nonatomic) IBOutlet UISwitch *switchBreakable;

// Other views
@property (weak, nonatomic) IBOutlet UISegmentedControl *categorySegmentedControl;
@property (strong, nonatomic) UIBarButtonItem *doneBarButton;
@property (weak, nonatomic) IBOutlet UIButton *doneButton;

// Objects
@property (strong, nonatomic) BBGeoPoint *placeFrom;
@property (strong, nonatomic) BBGeoPoint *placeTo;
@property (nonatomic) BBMissionCategory category;
@property (nonatomic) BOOL breakable;


@end

@implementation BBCreateMissionVC

#pragma mark - View life cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self viewInitialization];
    [self gestureInitialization];
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
}

#pragma mark - Initialization

- (void)viewInitialization {
    
//    From views
    self.titleLabelFrom.text = NSLocalizedString(@"Pick up", @"Create mission title");
    self.valueLabelFrom.text = @"";
    
//    To views
    self.titleLabelTo.text = NSLocalizedString(@"Drop off", @"Create mission title");
    self.valueLabelTo.text = @"";
    
//    Breakable
    self.titleLabelBreakable.text = NSLocalizedString(@"Breakable", @"");
    
//    DoneButton
    [self.doneButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.doneButton.layer.cornerRadius = 5.0;
    NSString *doneTitle = NSLocalizedString(@"Create mission", @"");
    [self.doneButton setTitle:doneTitle forState:UIControlStateNormal];
    
    //    Category
    NSString *lightTitle = [BBParseMission localizedCategoryNameForCategory:BBMissionCategoryLight];
    [self.categorySegmentedControl setTitle:lightTitle forSegmentAtIndex:BBMissionCategoryLight];
    
    NSString *standardTitle = [BBParseMission localizedCategoryNameForCategory:BBMissionCategoryStandard];
    [self.categorySegmentedControl setTitle:standardTitle forSegmentAtIndex:BBMissionCategoryStandard];
    
    NSString *heavyTitle = [BBParseMission localizedCategoryNameForCategory:BBMissionCategoryHeavy];
    [self.categorySegmentedControl setTitle:heavyTitle forSegmentAtIndex:BBMissionCategoryHeavy];
    
    self.categorySegmentedControl.selectedSegmentIndex = BBMissionCategoryStandard;
    
    [self updateDoneButtonEnabled];
    
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
        self.doneBarButton.enabled = NO;
        self.doneButton.enabled = NO;
        UIColor *gray = [UIColor lightGrayColor];
        self.doneButton.backgroundColor = gray;
    } else {
        self.doneBarButton.enabled = YES;
        self.doneButton.enabled = YES;
        UIColor *green = [UIColor colorWithRed:0.24f green:0.65f blue:0.31f alpha:1.00f];
        self.doneButton.backgroundColor = green;
    }
}

#pragma mark - Getters & Setters

- (UIBarButtonItem *)doneBarButton {
    if (!_doneBarButton) {
        _doneBarButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone
                                                                    target:self
                                                                    action:@selector(doneButtonHandler)];
        self.navigationItem.rightBarButtonItem = _doneBarButton;
    }
    return _doneBarButton;
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
    BBParseMission *mission = [BBParseMission missionFrom:self.placeFrom
                                                       to:self.placeTo];
    
    [self saveMission:mission];
}

#pragma mark - API

- (void)saveMission:(BBParseMission *)mission {
    [self startLoading];
    self.doneBarButton.enabled = NO;
    [mission saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (!error) {
            [BBInstallationManager setUserActiveMission:mission];
        } else {
            NSString *title = NSLocalizedString(@"Mission save failed", @"");
            NSString *subtitle = [error localizedDescription];
            BBViewController *destination = [BBViewController new];
            [destination showPlaceHolderWithtitle:title subtitle:subtitle];
            [self.navigationController pushViewController:destination animated:YES];
        }
        [self stopLoading];
        self.doneBarButton.enabled = YES;
    }];
}


@end
