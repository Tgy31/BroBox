//
//  BBMissionOverviewVC.m
//  BroBox
//
//  Created by Tanguy Hélesbeux on 06/02/2015.
//  Copyright (c) 2015 Brobox. All rights reserved.
//

#import "BBMissionOverviewVC.h"

// Managers
#import "BBParseManager.h"
#import "BBLocationManager.h"

// Model
#import "BBParseUser.h"

// Views
#import "BBUserProfileCell.h"

typedef NS_ENUM(NSInteger, BBMissionOverviewSection) {
    BBMissionOverviewSectionPackage,
    BBMissionOverviewSectionTrip,
    BBMissionOverviewSectionCreator
};

typedef NS_ENUM(NSInteger, BBMissionOverviewPackageCell) {
    BBMissionOverviewPackageCellCategory,
    BBMissionOverviewPackageCellBreakable
};

typedef NS_ENUM(NSInteger, BBMissionOverviewTripCell) {
    BBMissionOverviewTripCellPickUp,
    BBMissionOverviewTripCellDropOff,
    BBMissionOverviewTripCellReward
};

@interface BBMissionOverviewVC () <UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableview;

// Scroll properties
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIView *contentView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contentViewWidthConstraint;

// Other views
@property (weak, nonatomic) IBOutlet UILabel *labelFrom;
@property (weak, nonatomic) IBOutlet UILabel *labelTo;
@property (weak, nonatomic) IBOutlet UIButton *actionButton;

@end

@implementation BBMissionOverviewVC

#pragma mark - View life cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initializeTableView];
    [self initialiazeView];
    [self setViewForMission:self.mission];
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    
    self.contentViewWidthConstraint.constant = self.view.frame.size.width;
    
    [self.scrollView layoutIfNeeded];
    self.scrollView.contentSize = self.contentView.frame.size;
}

#pragma mark - Initialization

#define CELL_IDENTIFIER @"BBCellIdentifier"

- (void)initializeTableView {
    
    self.tableview.delegate = self;
    self.tableview.dataSource = self;
    
    [BBUserProfileCell registerToTableView:self.tableview];
    
    self.tableview.tableFooterView.backgroundColor = [UIColor clearColor];
}

- (void)initialiazeView {
    
    self.title = NSLocalizedString(@"Mission", @"");
    
//    Texts
    NSString *actionTitle = NSLocalizedString(@"Accept mission", @"Action button title in mission overview screen");
    [self.actionButton setTitle:actionTitle forState:UIControlStateNormal];
    [self.actionButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.actionButton.backgroundColor = [UIColor colorWithRed:0.24f green:0.65f blue:0.31f alpha:1.00f];
    self.actionButton.layer.cornerRadius = 5.0;
    
//    Controls
    [self.actionButton addTarget:self
                          action:@selector(actionButtonHandler)
                forControlEvents:UIControlEventTouchUpInside];
    
    [self updateFooterView];
}

- (void)setViewForMission:(BBParseMission *)mission {
    if (mission) {
        self.labelFrom.text = mission.from.title;
        self.labelTo.text = mission.to.title;
    }
}

#pragma mark - Getters & Setters

- (void)setMission:(BBParseMission *)mission {
    _mission = mission;
    [self setViewForMission:mission];
}

- (void)setActionType:(BBMissionOverviewActionType)actionType {
    _actionType = actionType;
    [self updateFooterView];
}

#pragma marl - View Methods

- (void)showAcceptMissionSuccess {
    NSString *title = NSLocalizedString(@"Success", @"");
    NSString *subtitle = NSLocalizedString(@"You succesfully accepted to carry this mission. Please wait for the creator to select a carrier", @"");
    [self showPlaceHolderWithtitle:title subtitle:subtitle];
}

- (void)showAcceptMissionFailedWithError:(NSError *)error {
    NSString *title = NSLocalizedString(@"Error", @"");
    NSString *subtitle = [error localizedFailureReason];
    [self showPlaceHolderWithtitle:title subtitle:subtitle];
}

- (void)updateFooterView {
    switch (self.actionType) {
        case BBMissionOverviewActionTypeNone:
            self.tableview.tableFooterView.hidden = YES;
            self.actionButton.hidden = YES;
            break;
            
        case BBMissionOverviewActionTypeAccept:
            self.tableview.tableFooterView.hidden = NO;
            self.actionButton.hidden = NO;
            break;
    }
}

#pragma mark - Handlers

- (void)actionButtonHandler {
    [self acceptMission];
}

#pragma mark - API

- (void)acceptMission {
    [self startLoading];
    
//    Update user location is possible
    BBParseUser *user = [BBParseUser currentUser];
    user.location = [BBGeoPoint geoPointWithLocation:[BBLocationManager userLocation]];
    [user saveInBackground];
    
    [BBParseManager mission:self.mission
                 addCarrier:user
                  withBlock:^(BOOL succeeded, NSError *error) {
                      if (!error ) {
                          [self showAcceptMissionSuccess];
                      } else {
                          NSLog(@"%@", error);
                          [self showAcceptMissionFailedWithError:error];
                      }
    }];
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return BBMissionOverviewSectionCreator + 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    switch (section) {
        case BBMissionOverviewSectionPackage:
            return 2;
        case BBMissionOverviewSectionTrip:
            return 3;
        case BBMissionOverviewSectionCreator:
            return 1;
            
        default:
            return 0;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.section) {
        case BBMissionOverviewSectionPackage:
            return [self tableView:tableView packageCellForRowAtIndexPath:indexPath];
        case BBMissionOverviewSectionTrip:
            return [self tableView:tableView tripCellForRowAtIndexPath:indexPath];
        case BBMissionOverviewSectionCreator:
            return [self tableView:tableView creatorCellForRowAtIndexPath:indexPath];
            
        default:
            return nil;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView
  packageCellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CELL_IDENTIFIER];
    
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue2
                                      reuseIdentifier:CELL_IDENTIFIER];
    }
    
    cell.accessoryType = UITableViewCellAccessoryNone;
    
    switch (indexPath.row) {
        case BBMissionOverviewPackageCellCategory:
            cell.textLabel.text = NSLocalizedString(@"Type", @"");
            cell.detailTextLabel.text = [self.mission localizedCategory];
            break;
            
        case BBMissionOverviewPackageCellBreakable:
            cell.textLabel.text = NSLocalizedString(@"Breakable", @"");
            cell.detailTextLabel.text = self.mission.breakable ? NSLocalizedString(@"Yes", @"") : NSLocalizedString(@"No", @"");
            break;
            
        default:
            break;
    }
    
    return cell;
}

- (UITableViewCell *)tableView:(UITableView *)tableView
     tripCellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CELL_IDENTIFIER];
    
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue2
                                      reuseIdentifier:CELL_IDENTIFIER];
    }
    
    cell.accessoryType = UITableViewCellAccessoryNone;
    
    switch (indexPath.row) {
        case BBMissionOverviewTripCellPickUp:
            cell.textLabel.text = NSLocalizedString(@"Pick up", @"");
            cell.detailTextLabel.text = self.mission.from.title;
            break;
            
        case BBMissionOverviewTripCellDropOff:
            cell.textLabel.text = NSLocalizedString(@"Drop off", @"");
            cell.detailTextLabel.text = self.mission.to.title;
            break;
            
        case BBMissionOverviewTripCellReward:
            cell.textLabel.text = NSLocalizedString(@"Reward", @"");
            cell.detailTextLabel.text = [NSString stringWithFormat:@"%.2f€", [self.mission.reward floatValue]];
            break;
            
        default:
            break;
    }
    
    return cell;
}

- (UITableViewCell *)tableView:(UITableView *)tableView
  creatorCellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *identifier = [BBUserProfileCell reusableIdentifier];
    BBUserProfileCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier forIndexPath:indexPath];
    
    cell.user = self.mission.creator;
    
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == BBMissionOverviewSectionCreator) {
        return [BBUserProfileCell preferedHeight];
    } else {
        return 44.0;
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    switch (section) {
        case BBMissionOverviewSectionPackage:
            return NSLocalizedString(@"Package", @"");
        case BBMissionOverviewSectionTrip:
            return NSLocalizedString(@"Journey", @"");
        case BBMissionOverviewSectionCreator:
            return NSLocalizedString(@"Creator", @"");
            
        default:
            return nil;
    }
}


@end
