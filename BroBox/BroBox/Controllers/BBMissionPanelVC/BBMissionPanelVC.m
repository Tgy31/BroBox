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

// Managers
#import "AppDelegate.h"


typedef NS_ENUM(NSInteger, BBMissionPanelSection) {
    BBMissionPanelSectionMission,
    BBMissionPanelSectionCarriers,
    BBMissionPanelSectionDelete
};

@interface BBMissionPanelVC () <UITableViewDataSource, UITableViewDelegate, BBCarrierPickerDelegate>

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
            
            break;
        }
    }
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - BBCarrierPickerDelegate

- (void)carrierPickerDidSelectCarrier:(BBParseUser *)carrier {
    [self.navigationController popViewControllerAnimated:YES];
    
    [AppDelegate presentClientScreen];
}

@end
