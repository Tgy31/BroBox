//
//  BBMissionListVC.m
//  BroBox
//
//  Created by Tanguy Hélesbeux on 25/01/2015.
//  Copyright (c) 2015 Brobox. All rights reserved.
//

#import "BBMissionListVC.h"

// Managers
#import "BBParseManager.h"

// Controllers
#import "BBMissionOverviewVC.h"

@interface BBMissionListVC ()

// Views

// Properties
@property (strong, nonatomic) NSArray *data;

@end

@implementation BBMissionListVC

#pragma mark - Life cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initializeTableview];
    [self fetchData];
}

#pragma mark - API

- (void)fetchData {
    [BBParseManager fetchMissionsAwaitingWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            self.data = objects;
        } else {
            NSLog(@"%@", error);
        }
        [self.refreshControl endRefreshing];
    }];
}

#pragma mark - Getters & Setters

- (void)setData:(NSArray *)data {
    _data = data;
    
    [self.tableView reloadData];
}

#pragma mark - TableView

- (void)initializeTableview {
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    // Initialize the refresh control.
    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.refreshControl addTarget:self
                            action:@selector(fetchData)
                  forControlEvents:UIControlEventValueChanged];

}

#pragma mark UITableviewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.data count];
}

#define CELL_IDENTIFIER @"geoPointCell"

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *identifier = CELL_IDENTIFIER;
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CELL_IDENTIFIER];
    }
    
    BBParseMission *mission = [self.data objectAtIndex:indexPath.row];
    
    cell.textLabel.text = mission.from.title;
    
    NSString *category = [mission localizedCategory];
    NSString *breakable = (mission.breakable) ? NSLocalizedString(@"Breakable", @"") : NSLocalizedString(@"Safe", @"");
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%@ - %@ - %@€", category, breakable, mission.reward];
    
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    BBParseMission *mission = [self.data objectAtIndex:indexPath.row];
    
    BBMissionOverviewVC *destination = [BBMissionOverviewVC new];
    destination.mission = mission;
    destination.actionType = BBMissionOverviewActionTypeAccept;
    [self.navigationController pushViewController:destination animated:YES];
    
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
}


@end
