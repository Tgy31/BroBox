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
        if (!error) {
            self.places = [self placeNamesFromJson:json];
            [self.loadingIndicator stopAnimating];
        } else {
            NSLog(@"%@", error);
        }
    }];
}

#define GOOGLE_KEY_PREDICTIONS @"predictions"
#define GOOGLE_KEY_TERMS @"terms"
#define GOOGLE_KEY_VALUE @"value"
#define GOOGLE_KEY_REFERENCE @"reference"

#define BBPLACE_KEY_TITLE @"title"
#define BBPLACE_KEY_SUBTITLE @"subtitle"
#define BBPLACE_KEY_REFERENCE @"reference"
#define BBPLACE_KEY_LOCATION @"location"

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
        
//        Reference
        NSString *reference = [prediction objectForKey:GOOGLE_KEY_REFERENCE];
        [place setObject:reference forKey:BBPLACE_KEY_REFERENCE];
        [self fetchDetailsForPlace:place withReference:reference];
        
        [places addObject:place];
    }
    return places;
}

#define GOOGLE_KEY_LATITUDE @"lat"
#define GOOGLE_KEY_LONGITUDE @"lng"

- (void)fetchDetailsForPlace:(NSMutableDictionary *)place withReference:(NSString *)reference {
    [BBGoogleManager fetchDetailsForPlaceReference:reference block:^(NSDictionary *json, NSError *error) {
        if (!error) {
            NSDictionary *coordinate = [[[json objectForKey:@"result"] objectForKey:@"geometry"] objectForKey:@"location"];
            double latitude = [[coordinate objectForKey:GOOGLE_KEY_LATITUDE] floatValue];
            double longitude = [[coordinate objectForKey:GOOGLE_KEY_LONGITUDE] floatValue];
            CLLocation *location = [[CLLocation alloc] initWithLatitude:latitude longitude:longitude];
            [place setObject:location forKey:BBPLACE_KEY_LOCATION];
        } else {
            NSLog(@"%@", error);
        }
    }];
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
    NSDictionary *placeInfo = [self.places objectAtIndex:indexPath.row];
    if ([self.delegate respondsToSelector:@selector(locationAutocompleteReturnedPlace:)]) {
        BBGeoPoint *place = [self geoPointFromPlaceInfo:placeInfo];
        [self.delegate locationAutocompleteReturnedPlace:place];
    }
    if (self.completionBlock) {
        BBGeoPoint *place = [self geoPointFromPlaceInfo:placeInfo];
        self.completionBlock(place);
    }
}

#pragma mark - GeoPoint Helpers

- (BBGeoPoint *)geoPointFromPlaceInfo:(NSDictionary *)place {
    CLLocation *location = [place objectForKey:BBPLACE_KEY_LOCATION];
    BBGeoPoint *geoPoint = [BBGeoPoint geoPointWithLatitude:location.coordinate.latitude
                                                  longitude:location.coordinate.longitude];
    geoPoint.googleReference = [place objectForKey:BBPLACE_KEY_REFERENCE];
    geoPoint.title = [place objectForKey:BBPLACE_KEY_TITLE];
    geoPoint.subtitle = [place objectForKey:BBPLACE_KEY_SUBTITLE];
    return geoPoint;
}

@end
