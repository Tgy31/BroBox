//
//  BBMapVC.m
//  BroBox
//
//  Created by Tanguy Hélesbeux on 23/01/2015.
//  Copyright (c) 2015 Brobox. All rights reserved.
//

#import "BBMissionsMapVC.h"

// Frameworks
#import <MapKit/MapKit.h>

// Controllers
#import "BBMissionOverviewVC.h"

// Managers
#import "BBParseManager.h"
#import "BBCanalTpManager.h"

// Objects
#import "BBMissionAnnotation.h"

// Views
#import "BBMissionAnnotationView.h"


@interface BBMissionsMapVC () <MKMapViewDelegate>

// Views
@property (weak, nonatomic) IBOutlet MKMapView *mapView;

@property (strong, nonatomic) BBMissionAnnotationView *selectedMissionView;

// Properties
@property (strong, nonatomic) NSArray *missions;

@end

@implementation BBMissionsMapVC

#pragma mark - Life cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initializeMapView];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self fetchMissions];
}

#pragma mark - API

- (void)fetchMissions {
    [BBParseManager fetchMissionsAwaitingWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            self.missions = objects;
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

- (void)setMissions:(NSArray *)missions {
    _missions = missions;
    
    if (!self.selectedMissionView) { // If no selection, update annotations
        [self showMissionList:missions];
    }
}

- (void)setSelectedMissionView:(BBMissionAnnotationView *)selectedMissionView {
    _selectedMissionView = selectedMissionView;
    
    if (selectedMissionView) {
        [self showMissionDetails:selectedMissionView.missionAnnotation.mission];
    } else {
        [self showMissionList:self.missions];
    }
}

#pragma mark - Helpers

- (BBMissionAnnotation *)annotationForMission:(BBParseMission *)mission {
    for (BBMissionAnnotation *annotation in self.mapView.annotations) {
        if ([annotation isKindOfClass:[BBMissionAnnotation class]]) {
            if ([annotation.mission isEqual:mission]) {
                return annotation;
            }
        }
    }
    return nil;
}

#pragma mark - Handlers

- (void)presentViewControllerForMission:(BBParseMission *)mission {
    
    BBMissionOverviewVC *destination = [BBMissionOverviewVC new];
    destination.mission = mission;
    destination.actionType = BBMissionOverviewActionTypeAccept;
    [self.navigationController pushViewController:destination animated:YES];
}

#pragma mark - Mapview -

- (void)initializeMapView {
    self.mapView.delegate = self;
    self.mapView.showsUserLocation = YES;
    self.mapView.showsPointsOfInterest = NO;
    self.mapView.showsBuildings = NO;
}

#pragma mark Annotations

- (void)showMissionList:(NSArray *)missions {
    [self.mapView removeAnnotations:self.mapView.annotations];
    [self.mapView removeOverlays:self.mapView.overlays];
    
    for (BBParseMission *mission in self.missions) {
        BBMissionAnnotation *missionAnnotation = [BBMissionAnnotation annotationForMission:mission
                                                                                  withType:BBMissionAnnotationTypeFrom];
        [self.mapView addAnnotation:missionAnnotation];
    }
    
    [self.mapView showAnnotations:self.mapView.annotations animated:YES];
}

- (void)showMissionDetails:(BBParseMission *)mission {
    [self fetchJourneyForMission:mission];
    
    //    Add drop off annotation and move camera
    BBMissionAnnotation *pickUpAnnotation = [self annotationForMission:mission];
    BBMissionAnnotation *dropOffAnnotation = [BBMissionAnnotation annotationForMission:mission
                                                                              withType:BBMissionAnnotationTypeTo];
    [self.mapView addAnnotation:dropOffAnnotation];
    
    [self.mapView showAnnotations:@[pickUpAnnotation, dropOffAnnotation] animated:YES];
}

#pragma mark AnnotationViews

#define ANNOTATIONVIEW_IDENTIFIER @"missionAnnotationView"

- (MKAnnotationView *)mapView:(MKMapView *)mapView
            viewForAnnotation:(id<MKAnnotation>)annotation {
    if ([annotation isKindOfClass:[BBMissionAnnotation class]]) {
        return [self mapView:mapView viewForMissionAnnotation:annotation];
    } else {
        return nil;
    }
}


- (BBMissionAnnotationView *)mapView:(MKMapView *)mapView
            viewForMissionAnnotation:(BBMissionAnnotation *)annotation {
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
        self.selectedMissionView = (BBMissionAnnotationView *)view;
    }
}

- (void)mapView:(MKMapView *)mapView
didDeselectAnnotationView:(MKAnnotationView *)view {
    
    if ([view.annotation isKindOfClass:[BBMissionAnnotation class]]) {
        self.selectedMissionView = nil;
    }
}


- (void)mapView:(MKMapView *)mapView
 annotationView:(MKAnnotationView *)view
calloutAccessoryControlTapped:(UIControl *)control {
    if ([control isEqual:view.rightCalloutAccessoryView]) {
        if ([view isKindOfClass:[BBMissionAnnotationView class]]) {
            BBParseMission *mission = ((BBMissionAnnotation *)view.annotation).mission;
            [self presentViewControllerForMission:mission];
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
