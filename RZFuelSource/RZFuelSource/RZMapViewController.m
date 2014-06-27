//
//  RZViewController.m
//  RZFuelSource
//
//  Created by Stephen Barnes on 6/27/14.
//  Copyright (c) 2014 Raizlabs. All rights reserved.
//

#import "RZMapViewController.h"
#import "RZFuelStation.h"
#import "RZFuelWebService.h"

typedef enum : NSUInteger {
    RZMapViewControllerQueryUserLocation,
    RZMapViewControllerQueryMapLocation,
    RZMapViewControllerQueryRoute,
} RZMapViewControllerQuery;

@interface RZMapViewController () <MKMapViewDelegate>

@property (nonatomic, strong) NSURLSessionDataTask *queryTask;

@property (nonatomic, assign) RZMapViewControllerQuery queryType;

@property (nonatomic, strong) NSArray *fuelStations;
@end


@implementation RZMapViewController

- (void)focusOn:(id)coordinateOrPolyline
{
    if (self.queryTask) {
        return;
    }
    
    if ([coordinateOrPolyline isKindOfClass:[NSValue class]]) {
        CLLocationCoordinate2D coordinate = [(NSValue *)coordinateOrPolyline MKCoordinateValue];
        self.queryTask = [[RZFuelWebService sharedInstance] fetchNearbyLocationWithLat:coordinate.latitude
                                                                                   lon:coordinate.longitude
                                                                       completionBlock:^(NSArray *objects, NSError *error)
                          {
                              if (error) {
                                  [[[UIAlertView alloc] initWithTitle:@"Access Problem!"
                                                              message:@"Encountered an issue obtaining station data."
                                                             delegate:self
                                                    cancelButtonTitle:@"OK"
                                                    otherButtonTitles:nil] show];
                              } else {
                                  [self loadFuelStations:objects];
                              }
                              self.queryTask = nil;
                          }];

    }
}

- (void)focusOnCoordinate:(CLLocationCoordinate2D)coordinate
{
    [self focusOn:[NSValue valueWithMKCoordinate:coordinate]];
}

- (void)loadFuelStations:(NSArray *)fuelStations
{
    if (self.fuelStations) {
        [self.mapView removeAnnotations:self.fuelStations];
        self.fuelStations = nil;
    }
    self.fuelStations = fuelStations;
    if (self.fuelStations) {
        [self.mapView showAnnotations:self.fuelStations animated:YES];
    }
}


#pragma mark UIViewController

- (void)loadView
{
    self.view = [[MKMapView alloc] initWithFrame:CGRectZero];
    self.mapView.delegate = self;

    self.navigationItem.rightBarButtonItem = [[MKUserTrackingBarButtonItem alloc] initWithMapView:self.mapView];
    
    self.mapView.showsUserLocation = YES;
    self.queryType = RZMapViewControllerQueryUserLocation;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

}

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (MKMapView *)mapView
{
    return (id)self.view;
}

#pragma mark MKMapViewDelegate - DataSource

- (void)mapView:(MKMapView *)mapView regionDidChangeAnimated:(BOOL)animated
{
    
}

- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control
{
    NSLog(@"Oh, Hi");
}

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation
{
    if ([annotation isKindOfClass:[MKUserLocation class]]) {
        return nil;
    }
    static NSString *pinReuseIdentifier = @"FuelSource";
    MKAnnotationView *view = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:pinReuseIdentifier];
    return view;
}

- (void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation
{
    if (self.queryType == RZMapViewControllerQueryUserLocation) {
        [self focusOnCoordinate:self.mapView.userLocation.coordinate];
    }
}

@end
