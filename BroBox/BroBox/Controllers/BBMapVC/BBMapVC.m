//
//  BBMapVC.m
//  BroBox
//
//  Created by Tanguy Hélesbeux on 23/01/2015.
//  Copyright (c) 2015 Brobox. All rights reserved.
//

#import "BBMapVC.h"

// Frameworks
#import <MapKit/MapKit.h>

// Controllers

// Managers
#import "BBParseManager.h"
#import "BBCanalTpManager.h"

// Objects
#import "BBMissionRequestAnnotation.h"

// Views
#import "BBMissionRequestAnnotationView.h"


@interface BBMapVC () <MKMapViewDelegate>

// Views
@property (weak, nonatomic) IBOutlet MKMapView *mapView;

// Properties
@property (strong, nonatomic) NSArray *missionRequests;

@end

@implementation BBMapVC

#pragma mark - Life cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    [self fetchMissionRequests];
    [self initializeMapView];
}

#pragma mark - API

- (void)fetchMissionRequests {
    [BBParseManager fetchGeoPointsWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            self.missionRequests = objects;
            [self fetchJourney];
        } else {
            NSLog(@"%@", error);
        }
    }];
    
    
}

- (void)fetchJourney {
    
    BBGeoPoint *geoFrom = [self.missionRequests firstObject];
    CLLocationCoordinate2D from = CLLocationCoordinate2DMake(geoFrom.coordinate.latitude, geoFrom.coordinate.longitude);
    BBGeoPoint *geoTo = [self.missionRequests lastObject];
    CLLocationCoordinate2D to = CLLocationCoordinate2DMake(geoTo.coordinate.latitude, geoTo.coordinate.longitude);
    [BBCanalTpManager getJourneyFrom:from to:to withBlock:^(NSDictionary *json, NSError *error) {
        
    }];
}

#pragma mark - Getters & Setters

- (void)setMissionRequests:(NSArray *)missionRequests {
    _missionRequests = missionRequests;
    [self updateAnnotations];
}

#pragma mark - Mapview

- (void)initializeMapView {
    self.mapView.delegate = self;
}

#pragma mark - Annotations

#define SUBTITLE_PATERN @"x: %f - y: %f"

- (void)updateAnnotations {
    NSMutableArray *tempAnnotations = [[NSMutableArray alloc] init];
    
    for (BBGeoPoint *geoPoint in self.missionRequests) {
        
        MKPointAnnotation *annotation = [[MKPointAnnotation alloc] init];
        annotation.title = @"GeoPoint";
        annotation.subtitle = [NSString stringWithFormat:SUBTITLE_PATERN, geoPoint.coordinate.latitude, geoPoint.coordinate.longitude];
        annotation.coordinate = CLLocationCoordinate2DMake(geoPoint.coordinate.latitude, geoPoint.coordinate.longitude);
        [tempAnnotations addObject:annotation];
        
    }
    
    [self.mapView addAnnotations:tempAnnotations];
}

#pragma mark - AnnotationViews

#define ANNOTATIONVIEW_IDENTIFIER @"missionRequestAnnotationView"

- (MKAnnotationView *)mapView:(MKMapView *)mapView
            viewForAnnotation:(id<MKAnnotation>)annotation {
    BBMissionRequestAnnotationView *annotationView = (BBMissionRequestAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:ANNOTATIONVIEW_IDENTIFIER];
    if (!annotationView) {
        annotationView = [[BBMissionRequestAnnotationView alloc] initWithAnnotation:annotation
                                                                    reuseIdentifier:ANNOTATIONVIEW_IDENTIFIER];
    }
    annotationView.annotation = annotation;
    return annotationView;
}

- (void)mapView:(MKMapView *)mapView
didSelectAnnotationView:(MKAnnotationView *)view {
    
}

- (void)mapView:(MKMapView *)mapView
 annotationView:(MKAnnotationView *)view
calloutAccessoryControlTapped:(UIControl *)control {
    
}

@end
