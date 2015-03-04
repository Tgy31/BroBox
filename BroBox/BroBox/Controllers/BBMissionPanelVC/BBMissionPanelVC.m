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
    BBMissionPanelSectionDelete
};


typedef NS_ENUM(NSInteger, BBMissionPanelUserRow) {
    BBMissionPanelUserRowReceiver,
    BBMissionPanelUserRowCarrier
};

@interface BBMissionPanelVC () <UITableViewDataSource, UITableViewDelegate, BBUserPickerDelegate, UIAlertViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation BBMissionPanelVC

#pragma mark - View life cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    
    [self.tableView registerClass:[UITableViewCell class]
           forCellReuseIdentifier:@"BBMissionPanelSectionMission"];
    [self.tableView registerClass:[UITableViewCell class]
           forCellReuseIdentifier:@"BBMissionPanelSectionCarriers"];
    [self.tableView registerClass:[UITableViewCell class]
           forCellReuseIdentifier:@"BBMissionPanelSectionDelete"];
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

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return BBMissionPanelSectionDelete + 1;
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
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    cell.textLabel.text = NSLocalizedString(@"Select a carrier", @"");
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
    cell.detailTextLabel.text = NSLocalizedString(@"Select", @"");
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.section) {
        case BBMissionPanelSectionMission: {
            BBMissionOverviewVC *destination = [BBMissionOverviewVC new];
            destination.mission = self.mission;
            destination.actionType = BBMissionOverviewActionTypeNone;
            [self.navigationController pushViewController:destination animated:YES];
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
        case BBMissionPanelSectionDelete: {
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
            break;
        }
    }
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)receiverCellHandler {
    BBUserPickerVC *destination = [BBUserPickerVC new];
    destination.mission = nil;
    destination.delegate = self;
    [self.navigationController pushViewController:destination animated:YES];
}

- (void)carrierCellHandler {
    BBUserPickerVC *destination = [BBUserPickerVC new];
    destination.mission = self.mission;
    destination.delegate = self;
    [self.navigationController pushViewController:destination animated:YES];
}

#pragma mark - BBCarrierPickerDelegate

- (void)carrierPickerDidSelectCarrier:(BBParseUser *)carrier {
    [self startLoading];
    [self.navigationController popViewControllerAnimated:YES];
    [BBParseManager mission:self.mission setSelectedCarrier:carrier withBlock:^(BOOL succeeded, NSError *error) {
        if (!error) {
            [AppDelegate presentClientScreenForMission:self.mission];
            [self stopLoading];
        } else {
            
        }
    }];
}

#pragma mark - UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 1) {
        [self deleteMission];
    }
}

- (void)deleteMission {
    [self startLoading];
    [BBParseManager deleteMission:self.mission
                        withBlock:^(BOOL succeeded, NSError *error) {
                            if (succeeded) {
                                [BBInstallationManager setUserMission:nil];
                            } else {
                                
                            }
    }];
}

@end
