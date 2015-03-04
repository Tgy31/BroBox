//
//  BBMissionPanelVC.m
//  BroBox
//
//  Created by Tanguy Hélesbeux on 15/02/2015.
//  Copyright (c) 2015 Brobox. All rights reserved.
//

#import "BBMissionPanelVC.h"

// Controllers
#import "BBUserPickerVC.h"
#import "BBMissionOverviewVC.h"

// Managers
#import "AppDelegate.h"
#import "BBParseManager.h"
#import "BBInstallationManager.h"


typedef NS_ENUM(NSInteger, BBMissionPanelSection) {
    BBMissionPanelSectionMission,
    BBMissionPanelSectionUsers,
    BBMissionPanelSectionDelete,
    BBMissionPanelSectionStartMission
};


typedef NS_ENUM(NSInteger, BBMissionPanelUserRow) {
    BBMissionPanelUserRowReceiver,
    BBMissionPanelUserRowCarrier
};

@interface BBMissionPanelVC () <UITableViewDataSource, UITableViewDelegate, BBUserPickerDelegate, UIAlertViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSIndexPath *selectedRowIndexPath;

@end

@implementation BBMissionPanelVC

#pragma mark - View life cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    
    self.tableView.estimatedRowHeight = 44;
}

#pragma mark - DEBUG

- (BOOL)shouldShowDebugBarbutton {
    return (self.mission.carrier != nil);
}

#pragma mark - Getters & Setters

#pragma mark - Handlers

- (void)debugButtonHandler {
    [BBInstallationManager setCarriedMission:self.mission];
    [AppDelegate presentClientScreenForMission:self.mission];
}

- (void)missionDetailsCellHandler {
    BBMissionOverviewVC *destination = [BBMissionOverviewVC new];
    destination.mission = self.mission;
    destination.actionType = BBMissionOverviewActionTypeNone;
    [self.navigationController pushViewController:destination animated:YES];
}

- (void)receiverCellHandler {
    BBUserPickerVC *destination = [BBUserPickerVC new];
    destination.mission = nil;
    destination.delegate = self;
    destination.selectedUser = self.mission.receiver;
    destination.title = NSLocalizedString(@"Receiver", @"");
    destination.subtitle = NSLocalizedString(@"Available receivers", @"");
    [self.navigationController pushViewController:destination animated:YES];
}

- (void)carrierCellHandler {
    BBUserPickerVC *destination = [BBUserPickerVC new];
    destination.mission = self.mission;
    destination.delegate = self;
    destination.selectedUser = self.mission.carrier;
    destination.title = NSLocalizedString(@"Carrier", @"");
    destination.subtitle = NSLocalizedString(@"Available carriers", @"");
    [self.navigationController pushViewController:destination animated:YES];
}

- (void)startMissionCellHandler {
    NSString *title = NSLocalizedString(@"Start mission", @"");
    NSString *message = NSLocalizedString(@"Do you confirm %@ as your carrier for this mission ?", @"");
    NSString *cancelButtonTitle = NSLocalizedString(@"No", @"");
    NSString *confirmButtonTitle = NSLocalizedString(@"Yes", @"");
    NSString *formattedMessage = [NSString stringWithFormat:message, self.mission.carrier.firstName];
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:title
                                                        message:formattedMessage
                                                       delegate:self
                                              cancelButtonTitle:cancelButtonTitle
                                              otherButtonTitles:confirmButtonTitle, nil];
    
    [alertView show];
}

- (void)deleteMissionCellHandler {
    NSString *title = NSLocalizedString(@"Delete mission", @"");
    NSString *message = NSLocalizedString(@"You are about to delete your mission. This won't cost you anything. Do you confirm ?", @"");
    NSString *cancel = NSLocalizedString(@"No", @"");
    NSString *confirm = NSLocalizedString(@"Yes", @"");
    UIAlertView *deleteAlert = [[UIAlertView alloc] initWithTitle:title
                                                          message:message
                                                         delegate:self
                                                cancelButtonTitle:cancel
                                                otherButtonTitles:confirm, nil];
    [deleteAlert show];
}

- (void)startMissionHandler {
    
    [self startLoading];
    [self.navigationController popViewControllerAnimated:YES];
    [BBParseManager mission:self.mission setSelectedCarrier:self.mission.carrier withBlock:^(BOOL succeeded, NSError *error) {
        if (!error) {
            [AppDelegate presentClientScreenForMission:self.mission];
            [self stopLoading];
        } else {
            
        }
    }];
}

- (void)deleteMissionHandler {
    [self startLoading];
    [BBParseManager deleteMission:self.mission
                        withBlock:^(BOOL succeeded, NSError *error) {
                            if (succeeded) {
                                [BBInstallationManager setUserMission:nil];
                            } else {
                                
                            }
                        }];
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (self.mission.carrier && self.mission.receiver) {
        return BBMissionPanelSectionStartMission + 1;
    } else {
        return BBMissionPanelSectionStartMission;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    switch (section) {
        case BBMissionPanelSectionUsers:
            return 2;
            
        default:
            return 1;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.section) {
        case BBMissionPanelSectionMission: {
            static NSString *identifier = @"BBMissionPanelSectionMission";
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
            if (!cell) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                              reuseIdentifier:identifier];
            }
            cell.textLabel.text = NSLocalizedString(@"Mission details", @"");
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            return cell;
        }
            
        case BBMissionPanelSectionUsers: {
            switch (indexPath.row) {
                case BBMissionPanelUserRowReceiver:
                    return [self tableView:tableView cellForReceiverForRowAtIndexPath:indexPath];
                    
                case BBMissionPanelUserRowCarrier:
                    return [self tableView:tableView cellForCarrierForRowAtIndexPath:indexPath];
            }
        }
            
        case BBMissionPanelSectionStartMission: {
            static NSString *identifier = @"BBMissionPanelSectionStartMission";
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
            if (!cell) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                              reuseIdentifier:identifier];
            }
            cell.textLabel.text = NSLocalizedString(@"Start mission", @"");
            cell.textLabel.textColor = [UIColor colorWithRed:0.53f green:0.72f blue:0.00f alpha:1.00f];
            cell.accessoryType = UITableViewCellAccessoryNone;
            return cell;
        }
            
        case BBMissionPanelSectionDelete: {
            static NSString *identifier = @"BBMissionPanelSectionDelete";
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
            if (!cell) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                              reuseIdentifier:identifier];
            }
            cell.textLabel.text = NSLocalizedString(@"Delete", @"");
            cell.textLabel.textColor = [UIColor redColor];
            cell.accessoryType = UITableViewCellAccessoryNone;
            return cell;
        }
    }
    return nil;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForCarrierForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *identifier = @"BBMissionPanelSectionCarriers";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1
                                      reuseIdentifier:identifier];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    cell.textLabel.text = NSLocalizedString(@"Carrier", @"");
    
    if (self.mission.carrier) {
        cell.detailTextLabel.text = [self.mission.carrier fullName];
    } else {
        cell.detailTextLabel.text = NSLocalizedString(@"Select", @"");
    }
    return cell;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForReceiverForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *identifier = @"BBMissionPanelSectionReceivers";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1
                                      reuseIdentifier:identifier];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    cell.textLabel.text = NSLocalizedString(@"Receiver", @"");
    
    if (self.mission.receiver) {
        cell.detailTextLabel.text = [self.mission.receiver fullName];
    } else {
        cell.detailTextLabel.text = NSLocalizedString(@"Select", @"");
    }
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    self.selectedRowIndexPath = indexPath;
    
    switch (indexPath.section) {
        case BBMissionPanelSectionMission: {
            [self missionDetailsCellHandler];
            break;
        }
            
        case BBMissionPanelSectionUsers: {
            switch (indexPath.row) {
                case BBMissionPanelUserRowReceiver:
                    [self receiverCellHandler];
                    break;
                case BBMissionPanelUserRowCarrier:
                    [self carrierCellHandler];
                    break;
            }
            break;
        }
        
        case BBMissionPanelSectionStartMission: {
            [self startMissionCellHandler];
            break;
        }
            
        case BBMissionPanelSectionDelete: {
            [self deleteMissionCellHandler];
            break;
        }
    }
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - BBCarrierPickerDelegate

- (void)userPickerDidSelectUser:(BBParseUser *)user {
    if (self.selectedRowIndexPath.row == BBMissionPanelUserRowReceiver) {
        [self didSelectReceiverHandler:user];
    } else {
        [self didSelectCarrierHandler:user];
    }
    
    self.selectedRowIndexPath = nil;
}

- (void)didSelectReceiverHandler:(BBParseUser *)receiver {
    self.mission.receiver = receiver;
    [self.mission saveEventually];
    [self.tableView reloadData];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didSelectCarrierHandler:(BBParseUser *)carrier {
    self.mission.carrier = carrier;
    [self.mission saveEventually];
    [self.tableView reloadData];
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {
    if (self.selectedRowIndexPath.section == BBMissionPanelSectionDelete) {
        if (buttonIndex == 1) {
            [self deleteMissionHandler];
        }
    } else if (self.selectedRowIndexPath.section == BBMissionPanelSectionStartMission) {
        if (buttonIndex == 1) {
            [self startMissionHandler];
        }
    }
}

@end
