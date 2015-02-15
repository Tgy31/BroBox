//
//  BBMissionPanelVC.m
//  BroBox
//
//  Created by Tanguy Hélesbeux on 15/02/2015.
//  Copyright (c) 2015 Brobox. All rights reserved.
//

#import "BBMissionPanelVC.h"


typedef NS_ENUM(NSInteger, BBMissionPanelSection) {
    BBMissionPanelSectionMission,
    BBMissionPanelSectionCarriers,
    BBMissionPanelSectionDelete
};

@interface BBMissionPanelVC () <UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation BBMissionPanelVC

#pragma mark - View life cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
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
            cell.accessoryType = UITableViewCellAccessoryDetailDisclosureButton;
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
            cell.textLabel.text = NSLocalizedString(@"3 carriers available", @"");
            cell.accessoryType = UITableViewCellAccessoryDetailDisclosureButton;
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
            cell.accessoryType = UITableViewCellAccessoryDetailDisclosureButton;
            return cell;
        }
            default:
            return nil;
    }
}

#pragma mark - UITableViewDelegate



@end
