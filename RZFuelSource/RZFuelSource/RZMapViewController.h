//
//  RZViewController.h
//  RZFuelSource
//
//  Created by Stephen Barnes on 6/27/14.
//  Copyright (c) 2014 Raizlabs. All rights reserved.
//

#import <MapKit/MapKit.h>

@interface RZMapViewController : UIViewController

- (void)focusOnCoordinate:(CLLocationCoordinate2D)coordinate;
- (void)focusOnDirectionRequest:(MKDirectionsRequest *)request;
@end
