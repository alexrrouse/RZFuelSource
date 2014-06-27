//
//  RZViewController.m
//  RZFuelSource
//
//  Created by Stephen Barnes on 6/27/14.
//  Copyright (c) 2014 Raizlabs. All rights reserved.
//

#import "RZMapViewController.h"

// Services
#import "RZFuelWebService.h"
#import "RZDirectionService.h"

// Model Data
#import "RZFuelType.h"
#import "RZFuelStation.h"

// Categories
#import "NSString+FuelType.h"
#import "UIImage+RZSnapshotHelpers.h"

// Utilities
#import "RZFuelSourceAppearance.h"

// Views
#import "RZTitleView.h"
#import "RZFuelQueryStateView.h"

// Third Party
#import "REMenu.h"
#import "REMenuItem.h"
#import "RZViewFactory.h"
#import "RZButtonView.h"

typedef NS_ENUM(NSInteger, RZMapViewControllerDisplayState) {
    kRZMapViewControllerDisplayStateCustom,
    kRZMapViewControllerDisplayStateRoute
};

typedef enum : NSUInteger {
    RZMapViewControllerQueryUserLocation,
    RZMapViewControllerQueryMapLocation,
    RZMapViewControllerQueryRoute,
} RZMapViewControllerQuery;

@interface RZMapViewController () <MKMapViewDelegate>

@property (nonatomic, assign) RZFuelType  selectedFuelType;
@property (nonatomic, strong) REMenu      *dropdownMenu;
@property (nonatomic, strong) UIImageView *blurredImageView;
@property (nonatomic, strong) NSArray     *fuelTypes;
@property (nonatomic, strong) NSURLSessionDataTask      *queryTask;
@property (nonatomic, assign) RZMapViewControllerQuery  queryType;
@property (nonatomic, strong) NSTimer                   *panReloadTimer;
@property (nonatomic, strong) RZTitleView *navTitleView;
@property (nonatomic, assign) RZMapViewControllerDisplayState displayState;
@property (nonatomic, strong) RZFuelQueryStateView *queryView;
@end

@implementation RZMapViewController

#pragma mark - Init Methods

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self commonInit];
    }
    return self;
}

- (void)commonInit
{
    _selectedFuelType = RZFuelTypeAll;
}

- (MKMapView *)mapView
{
    return (id)self.view;
}

- (void)focusOnDirectionRequest:(MKDirectionsRequest *)request
{
    if (self.queryTask) {
        [self.queryTask cancel];
    }
    self.displayState = kRZMapViewControllerDisplayStateRoute;
    [self.navTitleView.titleLabel setText:[@"Route" uppercaseString]];
    [self.queryView setState:RZFuelQueryStateWaiting animated:YES];

    [[RZDirectionService sharedInstance] directionsFromDirectionRequest:request completion:^(NSString *lineString, MKRoute *route, NSError *error) {
        self.queryTask = [[RZFuelWebService sharedInstance] fetchNearbyLocationsWithFuelType:self.selectedFuelType
                                                                                       route:lineString
                                                                             completionBlock:^(NSArray *objects, NSError *error)
                          {
                              self.queryType = RZMapViewControllerQueryRoute;
                              if (error) {
                                  [self showWebServiceError:error];
                              } else {
                                  [self loadFuelStations:objects];
                              }
                              self.queryTask = nil;
                              [self.queryView setState:RZFuelQueryStateIsGood animated:YES];
                          }];
    }];
}

- (void)focusOnCoordinate:(CLLocationCoordinate2D)coordinate
{
    if (self.queryTask || self.displayState == kRZMapViewControllerDisplayStateRoute) {
        return;
    }
    [self.queryView setState:RZFuelQueryStateQueryActive animated:YES];
    self.queryTask = [[RZFuelWebService sharedInstance] fetchNearbyLocationWithFuelType:self.selectedFuelType
                                                                                    lat:coordinate.latitude
                                                                                    lon:coordinate.longitude
                                                                        completionBlock:^(NSArray *objects, NSError *error)
                      {
                          if (error) {
                              [self showWebServiceError:error];
                          } else {
                              [self loadFuelStations:objects];
                          }
                          self.queryTask = nil;

                          [self.queryView setState:RZFuelQueryStateIsGood animated:YES];
                      }];
}

- (void)loadFuelStations:(NSArray *)fuelStations
{
    // Remove any fuel stations that have gone out of our scope
    NSMutableArray *oldStations = [@[] mutableCopy];
    for (RZFuelStation *station in self.mapView.annotations) {
        if ([fuelStations containsObject:station] == NO && [station isKindOfClass:[RZFuelStation class]]) {
            [oldStations addObject:station];
        }
    }
    [self.mapView removeAnnotations:oldStations];
    
    // Determine the stations added to our scope
    NSMutableArray *newStations = [@[] mutableCopy];
    for (RZFuelStation *station in fuelStations) {
        if ([self.mapView.annotations containsObject:station] == NO) {
            [newStations addObject:station];
        }
    }

    // Update the new stations, dependent on the query type.
    if ([newStations count]) {
        if (self.queryType == RZMapViewControllerQueryMapLocation) {
            [self.mapView addAnnotations:newStations];
        } else {
            // The load was not caused by a drag, so animate to the location
            [self.mapView showAnnotations:newStations animated:YES];
        }
    }
}

- (void)updateFocusDueToMapChange
{
    [self focusOnCoordinate:self.mapView.centerCoordinate];
}

- (void)showWebServiceError:(NSError *)error
{
    [[[UIAlertView alloc] initWithTitle:@"Access Problem!"
                                message:@"Encountered an issue obtaining station data."
                               delegate:self
                      cancelButtonTitle:@"OK"
                      otherButtonTitles:nil] show];
}

#pragma mark - ViewController Lifecycle
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesBegan:touches withEvent:event];
    self.queryType = RZMapViewControllerQueryMapLocation;
    [self.queryView setState:RZFuelQueryStateWaiting animated:YES];
}

- (void)loadView
{
    self.queryType = RZMapViewControllerQueryUserLocation;
    self.view = [[MKMapView alloc] initWithFrame:CGRectZero];
    self.mapView.delegate = self;
    self.mapView.showsUserLocation = YES;
    
    self.queryView = [[RZFuelQueryStateView alloc] initWithFrame:CGRectMake(0, 0, 36, 36)];
    
    self.navTitleView = (RZTitleView *)[UIView rz_loadFromNibNamed:NSStringFromClass([RZTitleView class])];
    [self.navTitleView.titleLabel setText:[[NSString shortDescriptionForFuelType:self.selectedFuelType] uppercaseString]];
    [self.navTitleView.titleButton addTarget:self action:@selector(fuelTypeFilterWithSender:) forControlEvents:UIControlEventTouchUpInside];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.queryView];
    self.navigationItem.rightBarButtonItem = [[MKUserTrackingBarButtonItem alloc] initWithMapView:self.mapView];
    [[self navigationItem] setTitleView:self.navTitleView];
}

#pragma mark - Overidden Properties

- (NSArray *)fuelTypes
{
    if (_fuelTypes == nil) {
        NSMutableArray *mutableFuelTypes = [[NSMutableArray alloc] initWithCapacity:kRZFuelTypeNumObjects];
        for (NSUInteger i = kRZFuelTypeFirstObject; i < kRZFuelTypeNumObjects; i++ ) {
            [mutableFuelTypes addObject:[NSNumber numberWithUnsignedInteger:i]];
        }
        _fuelTypes = [mutableFuelTypes copy];
    }
    return _fuelTypes;
}

- (REMenu *)dropdownMenu
{
    if (_dropdownMenu == nil) {
        _dropdownMenu = [[REMenu alloc] initWithItems:[self dropDownItems]];
        [_dropdownMenu setCloseOnSelection:YES];
        __weak RZMapViewController *weakSelf = self;
        [_dropdownMenu setCloseCompletionHandler:^{
            [weakSelf removeBlur];
        }];
        [RZFuelSourceAppearance themeREMenu:_dropdownMenu];
    }
    return _dropdownMenu;
}

- (void)setSelectedFuelType:(RZFuelType)selectedFuelType
{
    _selectedFuelType = selectedFuelType;
    self.displayState = kRZMapViewControllerDisplayStateCustom;
    [self updateFocusDueToMapChange];
    [self.navTitleView.titleLabel setText:[[NSString shortDescriptionForFuelType:selectedFuelType] uppercaseString]];
}

#pragma mark - Create Drop Down Items

- (NSArray *)dropDownItems
{
    NSMutableArray *menuItems = [[NSMutableArray alloc] initWithCapacity:[[self fuelTypes] count]];
    
    __weak RZMapViewController *weakSelf = self;
    for (NSUInteger i = 0; i < [[self fuelTypes] count]; i++ ) {
        RZFuelType fuelTypeForItem = [[[self fuelTypes] objectAtIndex:i] unsignedIntegerValue];
        
        REMenuItem *item = [[REMenuItem alloc] initWithTitle:[[NSString descriptionForFuelType:fuelTypeForItem] uppercaseString]
                                                       image:nil
                                            highlightedImage:nil
                                                      action:^(REMenuItem *item) {
                                                          [weakSelf setSelectedFuelType:item.tag];
                                                          
                                                      }];
        item.tag = fuelTypeForItem;
        [menuItems addObject:item];
    }
    
    return [menuItems copy];
}

#pragma mark - Blurring

- (void)removeBlur
{
    if (self.blurredImageView != nil) {
        [UIView animateWithDuration:0.3f animations:^{
            self.blurredImageView.alpha = 0.f;
        } completion:^(BOOL finished) {
            [self.blurredImageView removeFromSuperview];
            self.blurredImageView = nil;
        }];
    }
}

- (void)blurAndAddView
{
    self.blurredImageView = [[UIImageView alloc] initWithImage:[UIImage rz_blurredImageByCapturingView:self.view afterScreenUpdate:NO withRadius:5.f tintColor:[UIColor colorWithWhite:0.4f alpha:0.65f] saturationDeltaFactor:0.5f]];
    self.blurredImageView.alpha = 0.f;
    [self.view addSubview:self.blurredImageView];
    [UIView animateWithDuration:0.3f animations:^{
        self.blurredImageView.alpha = 1.f;
    }];
}
     
#pragma mark - Actions
     
- (void)fuelTypeFilterWithSender:(id)sender
{
    if (![self.dropdownMenu isOpen]) {
        [self blurAndAddView];
        [self.dropdownMenu showFromNavigationController:self.navigationController];
    } else {
        [self.dropdownMenu closeWithCompletion:nil];
    }
}

#pragma mark MKMapViewDelegate - DataSource

- (void)mapView:(MKMapView *)mapView regionWillChangeAnimated:(BOOL)animated
{
    [self.panReloadTimer invalidate];
    self.panReloadTimer = nil;
}

- (void)mapView:(MKMapView *)mapView regionDidChangeAnimated:(BOOL)animated
{
    [self.panReloadTimer invalidate];
    if (self.queryType == RZMapViewControllerQueryMapLocation) {
        self.panReloadTimer = [NSTimer scheduledTimerWithTimeInterval:0.6 target:self selector:@selector(updateFocusDueToMapChange) userInfo:nil repeats:NO];
    }
}

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation
{
    static NSString *pinReuseIdentifier = @"FuelSource";
    if ([annotation isKindOfClass:[MKUserLocation class]]) {
        return nil;
    }

    MKAnnotationView *view = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:pinReuseIdentifier];
    [view setCanShowCallout:YES];
    return view;
}

- (void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation
{
    if (self.queryType == RZMapViewControllerQueryUserLocation) {
        [self focusOnCoordinate:self.mapView.userLocation.coordinate];
    }
}

@end
