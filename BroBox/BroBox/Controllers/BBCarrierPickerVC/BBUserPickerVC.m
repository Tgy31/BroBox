//
//  BBUserPickerVC.m
//  BroBox
//
//  Created by Tanguy Hélesbeux on 15/02/2015.
//  Copyright (c) 2015 Brobox. All rights reserved.
//

#import "BBUserPickerVC.h"

// Libraries
#import "GFPlaceholderView.h"

// Model
#import "BBParseUser.h"

// Managers
#import "BBParseManager.h"
#import "BBInstallationManager.h"

// Views
#import "BBUserProfileCell.h"

@interface BBUserPickerVC () <UIAlertViewDelegate>

@property (strong, nonatomic) GFPlaceholderView *placeHolderView;

@property (strong, nonatomic) NSArray *carriers;

@end

@implementation BBUserPickerVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [BBUserProfileCell registerToTableView:self.tableView];
    
    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.refreshControl addTarget:self
                            action:@selector(fetchCarriers)
                  forControlEvents:UIControlEventValueChanged];
}

#pragma mark - API

- (void)fetchCarriers {
    
    if ([BBInstallationManager debugMode]) {
        [BBParseManager fetchCarriersForMission:nil withBlock:^(NSArray *objects, NSError *error) {
            [self carrierFetched:objects error:error];
        }];
    } else {
        [BBParseManager fetchCarriersForMission:self.mission withBlock:^(NSArray *objects, NSError *error) {
            [self carrierFetched:objects error:error];
        }];
    }
}

- (void)carrierFetched:(NSArray *)objects error:(NSError *)error {
    if (!error) {
        self.carriers = objects;
    } else {
        NSLog(@"%@", error);
    }
    [self.refreshControl endRefreshing];
}

#pragma mark - Getters & Setters

- (void)setCarriers:(NSArray *)carriers {
    _carriers = carriers;
    [self reloadTableView];
}

- (void)setMission:(BBParseMission *)mission {
    _mission = mission;
    [self fetchCarriers];
}

- (GFPlaceholderView *)placeHolderView {
    if (!_placeHolderView) {
        _placeHolderView = [[GFPlaceholderView alloc] initWithFrame:self.tableView.bounds];
        [self.tableView addSubview:_placeHolderView];
    }
    return _placeHolderView;
}

#pragma marl - View Methods

- (void)startLoading {
    [self.placeHolderView showLoadingView];
}

- (void)stopLoading {
    [self.placeHolderView hide];
}

- (void)showPlaceHolderWithtitle:(NSString *)title
                        subtitle:(NSString *)subtitle {
    
    [self.placeHolderView showViewWithTitle:title andSubtitle:subtitle];
}

- (void)hidePlaceHolder {
    [self.placeHolderView hide];
}

#pragma mark - Table view data source

- (void)reloadTableView {
    
    if (self.carriers.count > 0) {
        [self hidePlaceHolder];
    } else {
        NSString *title = NSLocalizedString(@"No carriers available", @"");
        NSString *subtitle = NSLocalizedString(@"You must wait for some carriers to accept your mission", @"");
        [self showPlaceHolderWithtitle:title subtitle:subtitle];
    }
    
    NSIndexSet *indexSet = [NSIndexSet indexSetWithIndex:0];
    [self.tableView reloadSections:indexSet withRowAnimation:UITableViewRowAnimationAutomatic];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.carriers count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *identifier = [BBUserProfileCell reusableIdentifier];
    BBUserProfileCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier forIndexPath:indexPath];
    
    cell.user = [self.carriers objectAtIndex:indexPath.row];
    
    if ([cell.user.objectId isEqualToString:self.selectedUser.objectId]) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    } else {
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    BBParseUser *user = [self.carriers objectAtIndex:indexPath.row];
    
    if ([self.delegate respondsToSelector:@selector(userPickerDidSelectUser:)]) {
        [self.delegate userPickerDidSelectUser:user];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [BBUserProfileCell preferedHeight];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return self.subtitle;
}

- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section {
    if ([BBInstallationManager debugMode]) {
        return NSLocalizedString(@"Debug mode is active. All users are shown as available", @"");
    } else {
        return nil;
    }
}

@end
