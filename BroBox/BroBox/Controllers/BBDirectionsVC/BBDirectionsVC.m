//
//  BBDirectionsVC.m
//  BroBox
//
//  Created by Tanguy Hélesbeux on 04/03/2015.
//  Copyright (c) 2015 Brobox. All rights reserved.
//

#import "BBDirectionsVC.h"

#define SECTION_MODE_KEY @"mode"
#define SECTION_ITEMS_KEY @"items"
#define SECTION_DURATION_KEY @"duration"

#define ITEM_TITLE_KEY @"title"
#define ITEM_SUBTITLE_KEY @"subtitle"
#define ITEM_TYPE_KEY @"type"

#define ITEM_TYPE_FROM @"from"
#define ITEM_TYPE_TO @"to"
#define ITEM_TYPE_PATH @"path"

@interface BBDirectionsVC () <UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (strong, nonatomic) NSArray *directions;

@end

@implementation BBDirectionsVC

#pragma mark - View life cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initializeTableView];
}

#pragma mark - Initialization

- (void)initializeTableView {
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
}

#pragma mark - Getters && Setters

- (void)setJson:(NSDictionary *)json {
    _json = json;
    
    self.directions = [self directionsFromJson:json];
    
    NSNumber *duration = [json objectForKey:@"duration"];
    self.title = [self hydratedDurationWithNumber:duration];
}

#pragma mark - Data manipulation

- (NSArray *)directionsFromJson:(NSDictionary *)json {
    
    NSMutableArray *directions = [[NSMutableArray alloc] init];
    
    NSArray *sections = [json objectForKey:@"sections"];
    for (NSDictionary *section in sections) {
        [directions addObject:[self sectionFromJson:section]];
    }
    
    return directions;
}

- (NSDictionary *)sectionFromJson:(NSDictionary *)json {
    
    NSString *type = [json objectForKey:@"type"];
    if ([type isEqualToString:@"public_transport"]) {
        
        return [self publicTransportSectionFromJson:json];
        
    } else if ([type isEqualToString:@"street_network"]) {
        
        return  [self streetNetworkSectionFromJson:json];
        
    }
    return nil;
}

- (NSDictionary *)publicTransportSectionFromJson:(NSDictionary *)json {
    
    NSDictionary *displayInfo = [json objectForKey:@"display_informations"];
    NSString *mode = [displayInfo objectForKey:@"commercial_mode"];
    NSNumber *duration = [json objectForKey:@"duration"];
    
    NSDictionary *from = [json objectForKey:@"from"];
    NSDictionary *to = [json objectForKey:@"to"];
    
    NSDictionary *itemFrom = @{
                               ITEM_TYPE_KEY: ITEM_TYPE_FROM,
                               ITEM_TITLE_KEY: [from objectForKey:@"name"],
                               ITEM_SUBTITLE_KEY: [NSString stringWithFormat:@"Direction %@", [displayInfo objectForKey:@"direction"]]
                               };
    
    NSDictionary *itemTo = @{
                             ITEM_TYPE_KEY: ITEM_TYPE_TO,
                             ITEM_TITLE_KEY: [to objectForKey:@"name"]
                             };
    
    return @{
             SECTION_MODE_KEY: mode,
             SECTION_DURATION_KEY: duration,
             SECTION_ITEMS_KEY: @[
                     itemFrom,
                     itemTo
                     ]
             };
}

- (NSDictionary *)streetNetworkSectionFromJson:(NSDictionary *)json {
    
    NSString *mode = [json objectForKey:@"mode"];
    NSNumber *duration = [json objectForKey:@"duration"];
    
    NSDictionary *from = [json objectForKey:@"from"];
    NSDictionary *to = [json objectForKey:@"to"];
    
    NSDictionary *itemFrom = @{
                               ITEM_TYPE_KEY: ITEM_TYPE_FROM,
                               ITEM_TITLE_KEY: [from objectForKey:@"name"],
                               };
    
    NSDictionary *itemTo = @{
                             ITEM_TYPE_KEY: ITEM_TYPE_TO,
                             ITEM_TITLE_KEY: [to objectForKey:@"name"]
                             };
    
    NSArray *pathInfo = [json objectForKey:@"path"];
    NSMutableArray *items = [[NSMutableArray alloc] initWithCapacity:pathInfo.count];
    [items addObject:itemFrom];
    
    for (NSDictionary *info in pathInfo) {
        NSDictionary *path = @{
                               ITEM_TYPE_KEY: ITEM_TYPE_PATH,
                               ITEM_SUBTITLE_KEY: [info objectForKey:@"name"]
                               };
        [items addObject:path];
    }
    
    [items addObject:itemTo];
    
    return @{
             SECTION_MODE_KEY: mode,
             SECTION_DURATION_KEY: duration,
             SECTION_ITEMS_KEY: items
             };
}

- (NSString *)hydratedDurationWithNumber:(NSNumber *)duration {
    
    int d = [duration intValue];
    
    int seconds = d % 60;
    
    d = (d - seconds) / 60;
    
    int minutes = d % 60;
    
    d = (d - minutes) / 60;
    
    int hours = d;
    
    if (hours > 0) {
        return [NSString stringWithFormat:@"%d hours %d minutes %d seconds", hours, minutes, seconds];
    } else {
        return [NSString stringWithFormat:@"%d minutes %d seconds", minutes, seconds];
    }
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.directions.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSDictionary *direction = [self.directions objectAtIndex:section];
    NSArray *items = [direction objectForKey:SECTION_ITEMS_KEY];
    
    return items.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSDictionary *direction = [self.directions objectAtIndex:indexPath.section];
    NSDictionary *item = [[direction objectForKey:SECTION_ITEMS_KEY] objectAtIndex:indexPath.row];
    
    NSString *itemType = [item objectForKey:ITEM_TYPE_KEY];
    
    if ([itemType isEqualToString:ITEM_TYPE_PATH]) {
        return [self tableView:tableView cellForPathForRowAtIndexPath:indexPath withItem:item];
    } else if ([itemType isEqualToString:ITEM_TYPE_FROM]) {
        return [self tableView:tableView cellForFromForRowAtIndexPath:indexPath withItem:item];
    } else if ([itemType isEqualToString:ITEM_TYPE_TO]) {
        return [self tableView:tableView cellForToForRowAtIndexPath:indexPath withItem:item];
    }
    
    return [[UITableViewCell alloc] init];
}

#define CELL_PATH_IDENTIFIER @"cellPath"

- (UITableViewCell *)tableView:(UITableView *)tableView cellForPathForRowAtIndexPath:(NSIndexPath *)indexPath withItem:(NSDictionary *)item {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CELL_PATH_IDENTIFIER];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle
                                      reuseIdentifier:CELL_PATH_IDENTIFIER];
    }
    
    cell.detailTextLabel.text = [item objectForKey:ITEM_SUBTITLE_KEY];
    
    return cell;
}

#define CELL_FROM_IDENTIFIER @"cellFrom"

- (UITableViewCell *)tableView:(UITableView *)tableView cellForFromForRowAtIndexPath:(NSIndexPath *)indexPath withItem:(NSDictionary *)item {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CELL_FROM_IDENTIFIER];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle
                                      reuseIdentifier:CELL_FROM_IDENTIFIER];
    }
    
    cell.textLabel.text = [item objectForKey:ITEM_TITLE_KEY];
    cell.textLabel.textColor = [UIColor blueColor];
    cell.detailTextLabel.text = [item objectForKey:ITEM_SUBTITLE_KEY];
    
    return cell;
}

#define CELL_TO_IDENTIFIER @"cellTo"

- (UITableViewCell *)tableView:(UITableView *)tableView cellForToForRowAtIndexPath:(NSIndexPath *)indexPath withItem:(NSDictionary *)item {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CELL_PATH_IDENTIFIER];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle
                                      reuseIdentifier:CELL_PATH_IDENTIFIER];
    }
    
    cell.textLabel.text = [item objectForKey:ITEM_TITLE_KEY];
    cell.textLabel.textColor = [UIColor orangeColor];
    cell.detailTextLabel.text = [item objectForKey:ITEM_SUBTITLE_KEY];
    
    return cell;
}

#pragma mark - UITableViewDelegate

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    NSDictionary *direction = [self.directions objectAtIndex:section];
    return [direction objectForKey:SECTION_MODE_KEY];
}

- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section {
    NSDictionary *direction = [self.directions objectAtIndex:section];
    NSNumber *duration = [direction objectForKey:SECTION_DURATION_KEY];
    
    return [self hydratedDurationWithNumber:duration];
}


@end
