//
//  BBLocationAutocompleteVC.m
//  BroBox
//
//  Created by Tanguy Hélesbeux on 04/02/2015.
//  Copyright (c) 2015 Brobox. All rights reserved.
//

#import "BBLocationAutocompleteVC.h"

// Managers
#import "BBGoogleManager.h"
#import "BBLocationManager.h"

// Libraries
#import "UIViewController+DBPrivacyHelper.h"

@interface BBLocationAutocompleteVC () <UITableViewDataSource, UITableViewDelegate>

// Views
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

// Objects
@property (strong, nonatomic) NSArray *places;

@end

@implementation BBLocationAutocompleteVC

#pragma mark - View life Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self registerToLocationManagerNotifications];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    self.title = NSLocalizedString(@"Search location", @"Default location autocomplete screen title");
    
    [BBLocationManager startUpdatingLocation];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - Broadcasts

- (void)registerToLocationManagerNotifications {
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(locationAuthorizationDeniedHandler)
                                                 name:BBNotificationLocationAuthorizationDenied
                                               object:nil];
}

- (void)locationAuthorizationDeniedHandler {
    
    [self showPrivacyHelperForType:DBPrivacyTypeLocation controller:^(DBPrivateHelperController *vc) {
        //customize the view controller to present
    } didPresent:^{
    } didDismiss:^{
        [self showPrivacyHelperForType:DBPrivacyTypeLocation];
    } useDefaultSettingPane:NO]; //If NO force to use DBPrivateHelperController instead of the default settings pane on iOS 8. Only for iOS 8. Default value is YES.
}

#pragma mark - API 

- (void)fetchPlacesForString:(NSString *)string {
//    [BBGoogleManager fetchCompletionWithString:string location: block:^(NSDictionary *json, NSError *error) {
//        
//    }];
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.places.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifier = @"placeCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle
                                      reuseIdentifier:identifier];
    }
    
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}

@end
