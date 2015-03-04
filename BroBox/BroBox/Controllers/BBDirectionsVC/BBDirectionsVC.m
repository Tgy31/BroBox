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
#define SECTION_NAME_KEY @"name"

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
             SECTION_ITEMS_KEY: @[
                     itemFrom,
                     itemTo
                     ]
             };
}

- (NSDictionary *)streetNetworkSectionFromJson:(NSDictionary *)json {
    
    NSString *mode = [json objectForKey:@"mode"];
    
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
             SECTION_ITEMS_KEY: items
             };
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 0;
    return self.directions.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSDictionary *direction = [self.directions objectAtIndex:section];
    NSArray *items = [direction objectForKey:SECTION_ITEMS_KEY];
    
    return items.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    return nil;
}

#pragma mark - UITableViewDelegate

@end
