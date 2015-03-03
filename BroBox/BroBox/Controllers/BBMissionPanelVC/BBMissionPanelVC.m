//
//  BBMissionPanelVC.m
//  BroBox
//
//  Created by Tanguy Hélesbeux on 15/02/2015.
//  Copyright (c) 2015 Brobox. All rights reserved.
//

#import "BBMissionPanelVC.h"

// Controllers
#import "BBCarrierPickerVC.h"
#import "BBMissionOverviewVC.h"

// Managers
#import "AppDelegate.h"
#import "BBParseManager.h"
#import "BBInstallationManager.h"


typedef NS_ENUM(NSInteger, BBMissionPanelSection) {
    BBMissionPanelSectionMission,
    BBMissionPanelSectionCarriers,
    BBMissionPanelSectionDelete
};

@interface BBMissionPanelVC () <UITableViewDataSource, UITableViewDelegate, BBCarrierPickerDelegate, UIAlertViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (strong, nonatomic) UIBarButtonItem *testButton;

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
    
    if (self.mission.carrier) {
        self.navigationItem.rightBarButtonItem = self.testButton;
    }
}

#pragma mark - Getters & Setters

- (UIBarButtonItem *)testButton {
    if (!_testButton) {
        _testButton = [[UIBarButtonItem alloc] initWithTitle:@"[DEBUG]"
                                                       style:UIBarButtonItemStyleDone
                                                      target:self
                                                      action:@selector(testButtonHandler)];
        _testButton.tintColor = [UIColor orangeColor];
    }
    return _testButton;
}

#pragma mark - Handlers

- (void)testButtonHandler {
    [BBInstallationManager setCarriedMission:self.mission];
    [AppDelegate presentCarrierScreenForMission:self.mission];
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return BBMissionPanelSectionDelete + 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.section) {
        case BBMissionPanelSectionMission: {
            static NSString *identifier = @"BBMissionPanelSectionMission";
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier
                                                                    forIndexPath:indexPath];
            if (!cell) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                              reuseIdentifier:identifier];
            }
            cell.textLabel.text = NSLocalizedString(@"Edit mission", @"");
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            return cell;
        }
            
        case BBMissionPanelSectionCarriers: {
            static NSString *identifier = @"BBMissionPanelSectionCarriers";
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier
                                                                    forIndexPath:indexPath];
            if (!cell) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                              reuseIdentifier:identifier];
            }
            cell.textLabel.text = NSLocalizedString(@"Carriers", @"");
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            return cell;
        }
            
        case BBMissionPanelSectionDelete: {
            static NSString *identifier = @"BBMissionPanelSectionDelete";
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier
                                                                    forIndexPath:indexPath];
            if (!cell) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                              reuseIdentifier:identifier];
            }
            cell.textLabel.text = NSLocalizedString(@"Delete", @"");
            cell.textLabel.textColor = [UIColor redColor];
            cell.accessoryType = UITableViewCellAccessoryNone;
            return cell;
        }
            default:
            return nil;
    }
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
        case BBMissionPanelSectionCarriers: {
            BBCarrierPickerVC *destination = [BBCarrierPickerVC new];
            destination.mission = self.mission;
            destination.delegate = self;
            [self.navigationController pushViewController:destination animated:YES];
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
