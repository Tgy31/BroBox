//
//  BBMapVC.m
//  BroBox
//
//  Created by Tanguy Hélesbeux on 23/01/2015.
//  Copyright (c) 2015 Brobox. All rights reserved.
//

#import "BBMissionRequestsMapVC.h"

// Frameworks
#import <MapKit/MapKit.h>

// Controllers
#import "BBMissionRequestVC.h"

// Managers
#import "BBParseManager.h"
#import "BBCanalTpManager.h"

// Objects
#import "BBMissionAnnotation.h"

// Views
#import "BBMissionAnnotationView.h"


@interface BBMissionRequestsMapVC () <MKMapViewDelegate>

// Views
@property (weak, nonatomic) IBOutlet MKMapView *mapView;

@property (strong, nonatomic) BBMissionAnnotationView *selectedMissionRequestView;

// Properties
@property (strong, nonatomic) NSArray *missionRequests;

@end

@implementation BBMissionRequestsMapVC

#pragma mark - Life cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initializeMapView];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self fetchMissionRequests];
}

#pragma mark - API

- (void)fetchMissionRequests {
    [BBParseManager fetchMissionRequestsWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            self.missionRequests = objects;
        } else {
            NSLog(@"%@", error);
        }
    }];
    
    
}

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

- (void)fetchDirectionsFromAppleForMission:(BBParseMission *)mission {
    
}

#pragma mark - Getters & Setters

- (void)setMissionRequests:(NSArray *)missionRequests {
    _missionRequests = missionRequests;
    
    if (!self.selectedMissionRequestView) { // If no selection, update annotations
        [self showMissionRequestList:missionRequests];
    }
}

- (void)setSelectedMissionRequestView:(BBMissionAnnotationView *)selectedMissionRequestView {
    _selectedMissionRequestView = selectedMissionRequestView;
    
    if (selectedMissionRequestView) {
        [self showMissionDetails:selectedMissionRequestView.missionAnnotation.mission];
    } else {
        [self showMissionRequestList:self.missionRequests];
    }
}

#pragma mark - Helpers

- (BBMissionAnnotation *)annotationForMission:(BBParseMission *)mission {
    for (BBMissionAnnotation *annotation in self.mapView.annotations) {
        if ([annotation.mission isEqual:mission]) {
            return annotation;
        }
    }
    return nil;
}

#pragma mark - Handlers

- (void)presentViewControllerForMission:(BBParseMission *)mission {
    BBMissionRequestVC *destination = [BBMissionRequestVC new];
    
    [self.navigationController pushViewController:destination animated:YES];
}

#pragma mark - Mapview -

- (void)initializeMapView {
    self.mapView.delegate = self;
}

#pragma mark Annotations

- (void)showMissionRequestList:(NSArray *)missionRequests {
    [self.mapView removeAnnotations:self.mapView.annotations];
    [self.mapView removeOverlays:self.mapView.overlays];
    
    for (BBParseMissionRequest *missionRequest in self.missionRequests) {
        BBMissionAnnotation *missionAnnotation = [BBMissionAnnotation annotationForMission:missionRequest.mission
                                                                                  withType:BBMissionAnnotationTypeFrom];
        [self.mapView addAnnotation:missionAnnotation];
    }
}

- (void)showMissionDetails:(BBParseMission *)mission {
    [self fetchJourneyForMission:mission];
    
    //    Remove unselected annotations
//    NSMutableArray *otherAnnotations = [self.mapView.annotations mutableCopy];
//    [otherAnnotations removeObject:self.selectedMissionRequestView.missionAnnotation];
//    [self.mapView removeAnnotations:otherAnnotations];
    
    //    Add drop off annotation and move camera
    BBMissionAnnotation *pickUpAnnotation = [self annotationForMission:mission];
    BBMissionAnnotation *dropOffAnnotation = [BBMissionAnnotation annotationForMission:mission
                                                                              withType:BBMissionAnnotationTypeTo];
    [self.mapView addAnnotation:dropOffAnnotation];
    
    [self.mapView showAnnotations:@[pickUpAnnotation, dropOffAnnotation] animated:YES];
}

#pragma mark AnnotationViews

#define ANNOTATIONVIEW_IDENTIFIER @"missionRequestAnnotationView"

- (MKAnnotationView *)mapView:(MKMapView *)mapView
            viewForAnnotation:(id<MKAnnotation>)annotation {
    BBMissionAnnotationView *annotationView = (BBMissionAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:ANNOTATIONVIEW_IDENTIFIER];
    if (!annotationView) {
        annotationView = [[BBMissionAnnotationView alloc] initWithAnnotation:annotation
                                                                    reuseIdentifier:ANNOTATIONVIEW_IDENTIFIER];
    }
    annotationView.annotation = annotation;
    return annotationView;
}

- (void)mapView:(MKMapView *)mapView
didSelectAnnotationView:(MKAnnotationView *)view {
    
    if ([view.annotation isKindOfClass:[BBMissionAnnotation class]]) {
        self.selectedMissionRequestView = (BBMissionAnnotationView *)view;
    }
}

- (void)mapView:(MKMapView *)mapView
didDeselectAnnotationView:(MKAnnotationView *)view {
    
    if ([view.annotation isKindOfClass:[BBMissionAnnotation class]]) {
        self.selectedMissionRequestView = nil;
    }
}


- (void)mapView:(MKMapView *)mapView
 annotationView:(MKAnnotationView *)view
calloutAccessoryControlTapped:(UIControl *)control {
    if ([control isEqual:view.rightCalloutAccessoryView]) {
        if ([view isKindOfClass:[BBMissionAnnotationView class]]) {
            [self presentViewControllerForMission:((BBMissionAnnotationView *)view).missionAnnotation.mission];
        }
    } else if ([control isEqual:view.leftCalloutAccessoryView]) {
        
    } else {
        
    }
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
    polylineView.strokeColor = [UIColor blueColor];
    polylineView.lineWidth = 5.0;
    polylineView.alpha = 0.7;
    
    return polylineView;
}

@end
