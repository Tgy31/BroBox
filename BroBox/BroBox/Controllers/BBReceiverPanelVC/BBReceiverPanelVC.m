//
//  BBReceiverPanelVC.m
//  BroBox
//
//  Created by Tanguy Hélesbeux on 04/03/2015.
//  Copyright (c) 2015 Brobox. All rights reserved.
//

#import "BBReceiverPanelVC.h"

// Frameworks
#import <MapKit/MapKit.h>

// Controllers
#import "BBQRReaderVC.h"
#import "BBMissionOverviewVC.h"
#import "BBChatVC.h"

// Managers
#import "AppDelegate.h"
#import "BBCanalTpManager.h"
#import "BBParseManager.h"

// Views
#import "BBUserProfileCell.h"
#import "BBMissionAnnotationView.h"
#import "BBCarrierAnnotationView.h"

// Model
#import "BBCarrierAnnotation.h"

#define CARRIER_REFRESH_TIMEINTERVAL 10 // in seconds

typedef NS_ENUM(NSInteger, BBClientPanelSection) {
    BBClientPanelSectionInformations,
    BBClientPanelSectionCheckins,
    BBClientPanelSectionOptions,
};


typedef NS_ENUM(NSInteger, BBClientPanelCheckinRow) {
    BBClientPanelCheckinRowPickUp,
    BBClientPanelCheckinRowDropOff,
};


typedef NS_ENUM(NSInteger, BBClientPanelInformationRow) {
    BBClientPanelInformationRowCarrier,
    BBClientPanelInformationRowMission,
    BBClientPanelInformationRowChat,
};

@interface BBReceiverPanelVC () <UITableViewDataSource, UITableViewDelegate, UIAlertViewDelegate, MKMapViewDelegate, BBQRReaderDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (weak, nonatomic) IBOutlet MKMapView *mapView;

@property (strong, nonatomic) BBCarrierAnnotation *carrierAnnotation;

@property (nonatomic) BOOL hasCheckedPickUp;
@property (nonatomic) BOOL hasCheckedDropOff;

@end

@implementation BBReceiverPanelVC

#pragma mark - View life cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initializeTableView];
    [self initializeMapView];
}

#pragma mark - Getters & Setters

- (void)setCarrierAnnotation:(BBCarrierAnnotation *)carrierAnnotation {
    [self.mapView removeAnnotation:_carrierAnnotation];
    [self.mapView addAnnotation:carrierAnnotation];
    [self.mapView showAnnotations:self.mapView.annotations animated:YES];
    _carrierAnnotation = carrierAnnotation;
}

#pragma mark - TableView

#define CELL_IDENTIFIER @"BBCellIdentifier"

- (void)initializeTableView {
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.estimatedRowHeight = 44.0;
    
    [BBUserProfileCell registerToTableView:self.tableView];
}

- (void)initializeMapView {
    
    self.mapView.delegate = self;
    
    [self showMissionDetails:self.mission];
    [self pollCarrierLocationWithTimeInterval:CARRIER_REFRESH_TIMEINTERVAL];
}

#pragma mark UITableviewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return BBClientPanelSectionOptions + 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    switch (section) {
        case BBClientPanelSectionInformations:
            return 3;
        case BBClientPanelSectionCheckins:
            return 2;
        case BBClientPanelSectionOptions:
            return 1;
            
        default:
            return 0;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    switch (indexPath.section) {
        case BBClientPanelSectionInformations:
            return [self tableView:tableView informationCellForIndexPath:indexPath];
            
        case BBClientPanelSectionCheckins:
            return [self tableView:tableView checkinCellForIndexPath:indexPath];
            
        case BBClientPanelSectionOptions:
            return [self tableView:tableView optionCellForIndexPath:indexPath];
            
        default:
            return nil;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView
       checkinCellForIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CELL_IDENTIFIER];
    
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle
                                      reuseIdentifier:CELL_IDENTIFIER];
    }
    
    
    switch (indexPath.row) {
        case BBClientPanelCheckinRowPickUp:
            cell.textLabel.text = NSLocalizedString(@"Pick up", @"");
            cell.accessoryType = self.hasCheckedPickUp ? UITableViewCellAccessoryCheckmark : UITableViewCellAccessoryDisclosureIndicator;
            break;
            
        case BBClientPanelCheckinRowDropOff:
            cell.textLabel.text = NSLocalizedString(@"Drop off", @"");
            cell.accessoryType = self.hasCheckedDropOff ? UITableViewCellAccessoryCheckmark : UITableViewCellAccessoryDisclosureIndicator;
            break;
            
        default:
            break;
    }
    
    return cell;
}

- (UITableViewCell *)tableView:(UITableView *)tableView
   informationCellForIndexPath:(NSIndexPath *)indexPath {
    
    switch (indexPath.row) {
        case BBClientPanelInformationRowMission: {
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CELL_IDENTIFIER];
            
            if (!cell) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle
                                              reuseIdentifier:CELL_IDENTIFIER];
            }
            
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            cell.textLabel.text = NSLocalizedString(@"Mission details", @"");
            
            return cell;
        }
            
        case BBClientPanelInformationRowCarrier: {
            NSString *identifier = [BBUserProfileCell reusableIdentifier];
            BBUserProfileCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier forIndexPath:indexPath];
            cell.user = self.mission.carrier;
            return cell;
        }
        case BBClientPanelInformationRowChat: {
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CELL_IDENTIFIER];
            
            if (!cell) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle
                                              reuseIdentifier:CELL_IDENTIFIER];
            }
            
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            cell.textLabel.text = NSLocalizedString(@"Messages", @"");
            
            return cell;
        }
            
        default:
            return nil;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView
        optionCellForIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CELL_IDENTIFIER];
    
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle
                                      reuseIdentifier:CELL_IDENTIFIER];
    }
    
    cell.accessoryType = UITableViewCellAccessoryNone;
    cell.textLabel.text = NSLocalizedString(@"Abort mission", @"");
    cell.textLabel.textColor = [UIColor redColor];
    
    return cell;
}

#pragma mark UITableViewDelegate

- (void)tableView:(UITableView *)tableView
didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    switch (indexPath.section) {
        case BBClientPanelSectionInformations: {
            switch (indexPath.row) {
                case BBClientPanelInformationRowMission:
                    [self missionDetailsHandler];
                    break;
                case BBClientPanelInformationRowChat:
                    [self messagesHandler];
                    break;
                    
                default:
                    break;
            }
            break;
        }
            
        case BBClientPanelSectionCheckins: {
            switch (indexPath.row) {
                case BBClientPanelCheckinRowPickUp:
                    [self pickUpCheckinHandler];
                    break;
                case BBClientPanelCheckinRowDropOff:
                    [self dropOffCheckinHandler];
                    break;
                    
                default:
                    break;
            }
            break;
        }
            
        case BBClientPanelSectionOptions: {
            [self abortMissionHandler];
            break;
        }
            
        default:
            break;
    }
    
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == BBClientPanelSectionInformations && indexPath.row == BBClientPanelInformationRowCarrier) {
        return [BBUserProfileCell preferedHeight];
    } else {
        return 44.0;
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    switch (section) {
        case BBClientPanelSectionCheckins: {
            return NSLocalizedString(@"Checkings", @"");
            break;
        }
            
        default:
            return nil;;
    }
}

#pragma mark - Handlers

- (void)pickUpCheckinHandler {
    if (!self.hasCheckedPickUp) {
        BBQRReaderVC *destination = [BBQRReaderVC new];
        destination.type = BBQRReaderTypePickUp;
        destination.mission = self.mission;
        destination.delegate = self;
        [self.navigationController pushViewController:destination animated:YES];
    }
}

- (void)dropOffCheckinHandler {
    if (!self.hasCheckedDropOff) {
        BBQRReaderVC *destination = [BBQRReaderVC new];
        destination.type = BBQRReaderTypeDropOff;
        destination.mission = self.mission;
        destination.delegate = self;
        [self.navigationController pushViewController:destination animated:YES];
    }
}

- (void)missionDetailsHandler {
    BBMissionOverviewVC *destination = [BBMissionOverviewVC new];
    destination.mission = self.mission;
    destination.actionType = BBMissionOverviewActionTypeNone;
    [self.navigationController pushViewController:destination animated:YES];
}

- (void)messagesHandler {
    BBChatVC *destination = [BBChatVC new];
    destination.mission = self.mission;
    [self.navigationController pushViewController:destination animated:YES];
}

- (void)abortMissionHandler {
    
    NSString *title = NSLocalizedString(@"Abort mission", @"");
    NSString *message = NSLocalizedString(@"If you abort the mission now, you will not get your money back. Do you wish to abort mission ?", @"");
    NSString *cancelButtonTitle = NSLocalizedString(@"No", @"");
    NSString *confirmButtonTitle = NSLocalizedString(@"Yes and lose money", @"");
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:title
                                                        message:message
                                                       delegate:self
                                              cancelButtonTitle:cancelButtonTitle
                                              otherButtonTitles:confirmButtonTitle, nil];
    
    [alertView show];
}

#pragma mark - UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {
    switch (buttonIndex) {
        case 1: {
            [AppDelegate presentRootScreen];
            break;
        }
            
        default:
            break;
    }
}

#pragma mark - MapView -


- (void)fetchJourneyForMission:(BBParseMission *)mission {
    
    if (mission) {
        BBGeoPoint *geoFrom = mission.from;
        CLLocationCoordinate2D from = CLLocationCoordinate2DMake(geoFrom.coordinate.latitude, geoFrom.coordinate.longitude);
        BBGeoPoint *geoTo = mission.to;
        CLLocationCoordinate2D to = CLLocationCoordinate2DMake(geoTo.coordinate.latitude, geoTo.coordinate.longitude);
        [BBCanalTpManager getJourneyFrom:from to:to withBlock:^(NSDictionary *json, NSError *error) {
            if (!error) {
                NSDictionary *journey = [[json objectForKey:@"journeys"] firstObject];
                NSArray *path = [BBCanalTpManager pathForJourney:journey];
                [self drawRoute:path];
            }
        }];
    }
}

- (void)fetchCarrierLocationForMission:(BBParseMission *)mission {
    [BBParseManager fetchActiveCarrierAndLocationForMission:mission withBlock:^(PFObject *object, NSError *error) {
        self.mission.carrier = (BBParseUser *)object;
        self.carrierAnnotation = [BBCarrierAnnotation annotationForCarrier:self.mission.carrier];
    }];
}

- (void)showMissionDetails:(BBParseMission *)mission {
    [self fetchJourneyForMission:mission];
    
    //    Add drop off annotation and move camera
    BBMissionAnnotation *pickUpAnnotation = [BBMissionAnnotation annotationForMission:mission
                                                                             withType:BBMissionAnnotationTypeFrom];
    [self.mapView addAnnotation:pickUpAnnotation];
    BBMissionAnnotation *dropOffAnnotation = [BBMissionAnnotation annotationForMission:mission
                                                                              withType:BBMissionAnnotationTypeTo];
    [self.mapView addAnnotation:dropOffAnnotation];
    
    [self.mapView showAnnotations:self.mapView.annotations animated:YES];
}

#pragma mark AnnotationViews

#define ANNOTATIONVIEW_MISSION_IDENTIFIER @"missionAnnotationView"
#define ANNOTATIONVIEW_CARRIER_IDENTIFIER @"carrierAnnotationView"

- (MKAnnotationView *)mapView:(MKMapView *)mapView
            viewForAnnotation:(id<MKAnnotation>)annotation {
    if ([annotation isKindOfClass:[BBMissionAnnotation class]]) {
        return [self mapView:mapView viewForMissionAnnotation:annotation];
    } else if ([annotation isKindOfClass:[BBCarrierAnnotation class]]) {
        return [self mapView:mapView viewForCarrierAnnotation:annotation];
    } else {
        return nil;
    }
}

- (BBMissionAnnotationView *)mapView:(MKMapView *)mapView
            viewForMissionAnnotation:(BBMissionAnnotation *)annotation {
    BBMissionAnnotationView *annotationView = (BBMissionAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:ANNOTATIONVIEW_MISSION_IDENTIFIER];
    if (!annotationView) {
        annotationView = [[BBMissionAnnotationView alloc] initWithAnnotation:annotation
                                                             reuseIdentifier:ANNOTATIONVIEW_MISSION_IDENTIFIER];
    }
    annotationView.annotation = annotation;
    return annotationView;
}

- (BBCarrierAnnotationView *)mapView:(MKMapView *)mapView
            viewForCarrierAnnotation:(BBCarrierAnnotation *)annotation {
    BBCarrierAnnotationView *annotationView = (BBCarrierAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:ANNOTATIONVIEW_CARRIER_IDENTIFIER];
    if (!annotationView) {
        annotationView = [[BBCarrierAnnotationView alloc] initWithAnnotation:annotation
                                                             reuseIdentifier:ANNOTATIONVIEW_CARRIER_IDENTIFIER];
    }
    annotationView.annotation = annotation;
    return annotationView;
}

- (void)pollCarrierLocationWithTimeInterval:(NSInteger)time {
    [self fetchCarrierLocationForMission:self.mission];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(time * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self pollCarrierLocationWithTimeInterval:time];
    });
}


#pragma mark Overlay

- (void)drawRoute:(NSArray *)path
{
    NSInteger numberOfSteps = path.count;
    
    CLLocationCoordinate2D coordinates[numberOfSteps];
    for (NSInteger index = 0; index < numberOfSteps; index++) {
        CLLocation *location = [path objectAtIndex:index];
        CLLocationCoordinate2D coordinate = location.coordinate;
        coordinates[index] = coordinate;
    }
    
    MKPolyline *polyLine = [MKPolyline polylineWithCoordinates:coordinates count:numberOfSteps];
    [self.mapView addOverlay:polyLine];
}

#pragma mark Overlay views

- (MKOverlayView *)mapView:(MKMapView *)mapView viewForOverlay:(id <MKOverlay>)overlay {
    MKPolylineView *polylineView = [[MKPolylineView alloc] initWithPolyline:overlay];
    polylineView.strokeColor = [UIColor colorWithRed:0.89f green:0.40f blue:0.00f alpha:1.00f];
    polylineView.lineWidth = 15.0;
    polylineView.alpha = 0.5;
    
    return polylineView;
}

#pragma mark - BBQRReaderDelegate

- (void)QRReaderDidSucced:(BBQRReaderVC *)readerVC {
    switch (readerVC.type) {
        case BBQRReaderTypePickUp: {
            self.hasCheckedPickUp = YES;
            break;
        }
            
        case BBQRReaderTypeDropOff: {
            self.hasCheckedDropOff = YES;
            break;
        }
    }
    
    NSIndexSet *indexSet = [NSIndexSet indexSetWithIndex:BBClientPanelSectionCheckins];
    [self.tableView reloadSections:indexSet withRowAnimation:UITableViewRowAnimationFade];
}

@end
