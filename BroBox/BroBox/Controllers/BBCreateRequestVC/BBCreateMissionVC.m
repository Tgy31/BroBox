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
#import "BBPaypalManager.h"

// Controllers
#import "BBLocationAutocompleteVC.h"
#import "BBCreateMissionNavigationController.h"
#import "BBPaypalPayementVC.h"

// Model
#import "BBGeoPoint.h"
#import "BBParseMission.h"

@interface BBCreateMissionVC () <BBPayPalManagerDelegate>

@property (nonatomic, strong, readwrite) PayPalConfiguration *payPalConfiguration;

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

// Rewards view
@property (weak, nonatomic) IBOutlet UIView *viewReward;
@property (weak, nonatomic) IBOutlet UILabel *valueLabelReward;
@property (weak, nonatomic) IBOutlet UILabel *titleLabelReward;


// Other views
@property (weak, nonatomic) IBOutlet UISegmentedControl *categorySegmentedControl;
@property (strong, nonatomic) UIBarButtonItem *doneBarButton;
@property (weak, nonatomic) IBOutlet UIButton *doneButton;

// Objects
@property (strong, nonatomic) BBGeoPoint *placeFrom;
@property (strong, nonatomic) BBGeoPoint *placeTo;
@property (nonatomic) BBMissionCategory category;
@property (nonatomic) BOOL breakable;
@property (nonatomic) CGFloat price;
@property (nonatomic) CGFloat tripPrice;
@property (strong, nonatomic) BBParseMission *mission;


@end

@implementation BBCreateMissionVC

- (CGFloat)computePrice {
    CGFloat fPrice = 2.30;
    fPrice += self.tripPrice;
    switch (self.category) {
        case BBMissionCategoryLight: {
            fPrice += 0;
            break;
        }
        case BBMissionCategoryStandard: {
            fPrice += 0.80;
            break;
        }
        case BBMissionCategoryHeavy: {
            fPrice += 2.0;
            break;
        }
    }
    
    if (self.breakable) {
        fPrice += 2.0;
    }
    return fPrice;
}

- (CGFloat)generateTripPrice {
    if (self.placeFrom && self.placeTo) {
        int random = arc4random_uniform(200);
        return random/100.0;
    }
    return 0;
}

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
    [self.switchBreakable setOn:NO animated:NO];
    
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
    
    self.category = BBMissionCategoryStandard;
    self.categorySegmentedControl.selectedSegmentIndex = self.category;
    
//    Reward
    self.titleLabelReward.text = NSLocalizedString(@"Price", @"");
    
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
    
    [self.categorySegmentedControl addTarget:self
                                      action:@selector(categorySegmentedControlHandler)
                            forControlEvents:UIControlEventValueChanged];
    
    [self.switchBreakable addTarget:self
                             action:@selector(breakableSwitchHandler)
                   forControlEvents:UIControlEventValueChanged];
    
    [self.doneButton addTarget:self
                        action:@selector(doneButtonHandler)
              forControlEvents:UIControlEventTouchUpInside];
}

#pragma mark - View methods

- (void)updateViewFrom {
    self.valueLabelFrom.text = self.placeFrom.title;
}

- (void)updateViewTo {
    self.valueLabelTo.text = self.placeTo.title;
}

- (void)updateViewReward {
    self.price = [self computePrice];
    self.valueLabelReward.text = [NSString stringWithFormat:@"%.2f€", self.price];
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
    self.tripPrice = [self generateTripPrice];
    [self updateViewFrom];
    [self updateDoneButtonEnabled];
    [self updateViewReward];
}

- (void)setPlaceTo:(BBGeoPoint *)placeTo {
    _placeTo = placeTo;
    self.tripPrice = [self generateTripPrice];
    [self updateViewTo];
    [self updateDoneButtonEnabled];
    [self updateViewReward];
}

- (void)setCategory:(BBMissionCategory)category {
    _category = category;
    [self updateViewReward];
}

- (void)setBreakable:(BOOL)breakable {
    _breakable = breakable;
    [self updateViewReward];
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
    self.mission = [BBParseMission missionFrom:self.placeFrom
                                            to:self.placeTo];
    self.mission.breakable = self.breakable;
    self.mission.category = self.category;
    self.mission.reward = [NSNumber numberWithFloat:self.price - 0.2];
    
    [self pay:self.price];
}

- (void)categorySegmentedControlHandler {
    self.category = self.categorySegmentedControl.selectedSegmentIndex;
}

- (void)breakableSwitchHandler {
    self.breakable = self.switchBreakable.isOn;
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

#pragma mark - Paypal -

- (void)pay:(CGFloat)price {
    [BBPaypalManager payWithPaypal:self.price fromViewController:self];
}

#pragma mark - BBPayPalManagerDelegate

- (void)singlePaymentDidCancel {
    self.mission = nil;
}

- (void)singlePaymentDidSucceed:(PayPalPayment *)payment {
    [self saveMission:self.mission];
}

- (void)futurePaymentAuthorizationDidCancel {
    self.mission = nil;
}

- (void)futurePaymentAuthorizationDidSucced:(NSDictionary *)futurePaymentAuthorization {
    [self singlePaymentDidSucceed:nil];
}




@end
