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
    [BBParseManager fetchGeoPointsWithBlock:^(NSArray *objects, NSError *error) {
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
#define SUBTITLE_PATERN @"x: %f - y: %f"

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *identifier = CELL_IDENTIFIER;
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CELL_IDENTIFIER];
    }
    
    BBGeoPoint *geoPoint = [self.data objectAtIndex:indexPath.row];
    
    cell.textLabel.text = @"GeoPoint";
    
    cell.detailTextLabel.text = [NSString stringWithFormat:SUBTITLE_PATERN, geoPoint.coordinate.latitude, geoPoint.coordinate.longitude];
    
    return cell;
}



@end
