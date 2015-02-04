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
#import <UIViewController+KeyboardAnimation.h>

@interface BBLocationAutocompleteVC () <UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate>

// Views
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *loadingIndicator;

// Constraints
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tableViewBottomConstraint;

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
    self.searchBar.delegate = self;
    
    [self viewInitialisation];
    
    [BBLocationManager startUpdatingLocation];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [self an_unsubscribeKeyboard];
}

#pragma mark - Initializtion

- (void)viewInitialisation {
    
    self.title = NSLocalizedString(@"Search location", @"Default location autocomplete screen title");
    
    self.loadingIndicator.hidesWhenStopped = YES;
    [self.loadingIndicator stopAnimating];
    
    [self.searchBar becomeFirstResponder];
    
    [self an_subscribeKeyboardWithAnimations:^(CGRect keyboardRect, NSTimeInterval duration, BOOL isShowing) {
        self.tableViewBottomConstraint.constant = isShowing ?  CGRectGetHeight(keyboardRect) : 0;
    } completion:^(BOOL finished) {
        
    }];
}

#pragma mark - Getters & Setters

- (void)setPlaces:(NSArray *)places {
    _places = places;
    [self reloadTableView];
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
    [self.loadingIndicator startAnimating];
    CLLocation *location = [BBLocationManager userLocation];
    [BBGoogleManager fetchCompletionWithString:string location:location block:^(NSDictionary *json, NSError *error) {
        self.places = [self placeNamesFromJson:json];
        [self.loadingIndicator stopAnimating];
    }];
}

#define GOOGLE_KEY_PREDICTIONS @"predictions"
#define GOOGLE_KEY_TERMS @"terms"
#define GOOGLE_KEY_VALUE @"value"

#define BBPLACE_KEY_TITLE @"title"
#define BBPLACE_KEY_SUBTITLE @"subtitle"

- (NSArray *)placeNamesFromJson:(NSDictionary *)json {
    NSArray *predictions = [json objectForKey:GOOGLE_KEY_PREDICTIONS];
    NSMutableArray *places = [[NSMutableArray alloc] initWithCapacity:predictions.count];
    for (NSDictionary *prediction in predictions) {
        NSMutableArray *terms = [[prediction objectForKey:GOOGLE_KEY_TERMS] mutableCopy];
        
//        Title
        NSString *title = [[terms firstObject] objectForKey:GOOGLE_KEY_VALUE];
        [terms removeObjectAtIndex:0];
        NSMutableDictionary *place = [NSMutableDictionary dictionaryWithObject:title forKey:BBPLACE_KEY_TITLE];
        
//        Subtitle
        NSString *subtitle = [[terms firstObject] objectForKey:GOOGLE_KEY_VALUE];
        [terms removeObjectAtIndex:0];
        for (NSDictionary *term in terms) {
            subtitle = [subtitle stringByAppendingFormat:@", %@", [term objectForKey:GOOGLE_KEY_VALUE]];
        }
        [place setObject:subtitle forKey:BBPLACE_KEY_SUBTITLE];
        
        [places addObject:place];
    }
    return places;
}

#pragma mark - UISearchBarDelegate

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    [self fetchPlacesForString:searchText];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    [self fetchPlacesForString:searchBar.text];
}
#pragma mark - UITableViewDataSource

- (void)reloadTableView {
    [self.tableView reloadData];
}

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
    
    NSDictionary *place = [self.places objectAtIndex:indexPath.row];
    cell.textLabel.text = [place objectForKey:BBPLACE_KEY_TITLE];
    cell.detailTextLabel.text = [place objectForKey:BBPLACE_KEY_SUBTITLE];
    
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}

@end
