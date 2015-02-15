//
//  BBClientModeVC.m
//  BroBox
//
//  Created by Tanguy Hélesbeux on 15/02/2015.
//  Copyright (c) 2015 Brobox. All rights reserved.
//

#import "BBClientPanelVC.h"

// Controllers
#import "BBQRReaderVC.h"
#import "BBMissionOverviewVC.h"

// Managers
#import "AppDelegate.h"


typedef NS_ENUM(NSInteger, BBClientPanelSection) {
    BBClientPanelSectionInformations,
    BBClientPanelSectionCheckins,
    BBClientPanelSectionOptions,
};


typedef NS_ENUM(NSInteger, BBClientPanelCheckinRow) {
    BBClientPanelCheckinRowPickUp,
    BBClientPanelCheckinRowDropOff,
};

@interface BBClientPanelVC () <UITableViewDataSource, UITableViewDelegate, UIAlertViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation BBClientPanelVC

#pragma mark - View life cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initializeTableView];
}

#pragma mark - TableView

#define CELL_IDENTIFIER @"BBCellIdentifier"

- (void)initializeTableView {
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    [self.tableView registerClass:[UITableViewCell class]
           forCellReuseIdentifier:CELL_IDENTIFIER];
    self.tableView.estimatedRowHeight = 44.0;
}

#pragma mark UITableviewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return BBClientPanelSectionOptions + 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    switch (section) {
        case BBClientPanelSectionInformations:
            return 1;
        case BBClientPanelSectionCheckins:
            return 2;
        case BBClientPanelSectionOptions:
            return 1;
            
        default:
            return 0;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    switch (indexPath.section) {
        case BBClientPanelSectionInformations:
            return [self tableView:tableView informationCellForIndexPath:indexPath];
            
        case BBClientPanelSectionCheckins:
            return [self tableView:tableView checkinCellForIndexPath:indexPath];
            
        case BBClientPanelSectionOptions:
            return [self tableView:tableView optionCellForIndexPath:indexPath];
            
        default:
            return nil;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView
       checkinCellForIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CELL_IDENTIFIER
                                                            forIndexPath:indexPath];
    
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle
                                      reuseIdentifier:CELL_IDENTIFIER];
    }
    
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    switch (indexPath.row) {
        case BBClientPanelCheckinRowPickUp:
            cell.textLabel.text = NSLocalizedString(@"Check Pick up", @"");
            break;
            
        case BBClientPanelCheckinRowDropOff:
            cell.textLabel.text = NSLocalizedString(@"Check Drop off", @"");
            break;
            
        default:
            break;
    }
    
    return cell;
}

- (UITableViewCell *)tableView:(UITableView *)tableView
   informationCellForIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CELL_IDENTIFIER
                                                            forIndexPath:indexPath];
    
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                      reuseIdentifier:CELL_IDENTIFIER];
    }
    
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.textLabel.text = NSLocalizedString(@"Mission details", @"");
    
    return cell;
}

- (UITableViewCell *)tableView:(UITableView *)tableView
        optionCellForIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CELL_IDENTIFIER
                                                            forIndexPath:indexPath];
    
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                      reuseIdentifier:CELL_IDENTIFIER];
    }
    
    cell.accessoryType = UITableViewCellAccessoryNone;
    cell.textLabel.text = NSLocalizedString(@"Abort mission", @"");
    
    return cell;
}

#pragma mark UITableViewDelegate

- (void)tableView:(UITableView *)tableView
didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    switch (indexPath.section) {
        case BBClientPanelSectionInformations: {
            [self missionDetailsHandler];
            break;
        }
            
        case BBClientPanelSectionCheckins: {
            switch (indexPath.row) {
                case BBClientPanelCheckinRowPickUp:
                    [self pickUpCheckinHandler];
                    break;
                case BBClientPanelCheckinRowDropOff:
                    [self dropOffCheckinHandler];
                    break;
                    
                default:
                    break;
            }
            break;
        }
            
        case BBClientPanelSectionOptions: {
            [self abortMissionHandler];
            break;
        }
            
        default:
            break;
    }
    
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - Handlers

- (void)pickUpCheckinHandler {
    BBQRReaderVC *destination = [BBQRReaderVC new];
    [self.navigationController pushViewController:destination animated:YES];
}

- (void)dropOffCheckinHandler {
    BBQRReaderVC *destination = [BBQRReaderVC new];
    [self.navigationController pushViewController:destination animated:YES];
}

- (void)missionDetailsHandler {
    BBMissionOverviewVC *destination = [BBMissionOverviewVC new];
    [self.navigationController pushViewController:destination animated:YES];
}

- (void)abortMissionHandler {
    
    NSString *title = NSLocalizedString(@"Abort mission", @"");
    NSString *message = NSLocalizedString(@"If you abort the mission now, you will not get your money back. Do you wish to abort mission ?", @"");
    NSString *cancelButtonTitle = NSLocalizedString(@"No", @"");
    NSString *confirmButtonTitle = NSLocalizedString(@"Yes and lose money", @"");
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:title
                                                        message:message
                                                       delegate:self
                                              cancelButtonTitle:cancelButtonTitle
                                              otherButtonTitles:confirmButtonTitle, nil];
    
    [alertView show];
}

#pragma mark - UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {
    switch (buttonIndex) {
        case 1: {
            [AppDelegate presentRootScreen];
            break;
        }
            
        default:
            break;
    }
}

@end
