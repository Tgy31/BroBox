//
//  BBCarrierPickerVC.m
//  BroBox
//
//  Created by Tanguy Hélesbeux on 15/02/2015.
//  Copyright (c) 2015 Brobox. All rights reserved.
//

#import "BBCarrierPickerVC.h"

// Libraries
#import "GFPlaceholderView.h"

// Model
#import "BBParseUser.h"

// Managers
#import "BBParseManager.h"

// Views
#import "BBUserProfileCell.h"

@interface BBCarrierPickerVC () <UIAlertViewDelegate>

@property (strong, nonatomic) GFPlaceholderView *placeHolderView;

@property (strong, nonatomic) NSArray *carriers;
@property (strong, nonatomic) BBParseUser *selectedCarrier;

@end

@implementation BBCarrierPickerVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = NSLocalizedString(@"Select carrier", @"");
    
    [BBUserProfileCell registerToTableView:self.tableView];
    
    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.refreshControl addTarget:self
                            action:@selector(fetchCarriers)
                  forControlEvents:UIControlEventValueChanged];
}

#pragma mark - API

- (void)fetchCarriers {
    [BBParseManager fetchCarriersForMission:self.mission withBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            self.carriers = objects;
        } else {
            NSLog(@"%@", error);
        }
        [self.refreshControl endRefreshing];
    }];
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
    
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    self.selectedCarrier = [self.carriers objectAtIndex:indexPath.row];
    
    NSString *title = NSLocalizedString(@"Start mission", @"");
    NSString *message = NSLocalizedString(@"Do you confirm %@ as your carrier for this mission ?", @"");
    NSString *cancelButtonTitle = NSLocalizedString(@"No", @"");
    NSString *confirmButtonTitle = NSLocalizedString(@"Yes", @"");
    NSString *formattedMessage = [NSString stringWithFormat:message, self.selectedCarrier.firstName];
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:title
                                                        message:formattedMessage
                                                       delegate:self
                                              cancelButtonTitle:cancelButtonTitle
                                              otherButtonTitles:confirmButtonTitle, nil];
    
    [alertView show];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [BBUserProfileCell preferedHeight];
}

#pragma mark - UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {
    switch (buttonIndex) {
        case 1: {
            if ([self.delegate respondsToSelector:@selector(carrierPickerDidSelectCarrier:)]) {
                [self.delegate carrierPickerDidSelectCarrier:self.selectedCarrier];
            }
        }
            
        default:
            break;
    }
    self.selectedCarrier = nil;
}

@end
