//
//  RZDirectionService.h
//  RZFuelSource
//
//  Created by alex.rouse on 6/27/14.
//  Copyright (c) 2014 Raizlabs. All rights reserved.
//

#import <Foundation/Foundation.h>
@import MapKit;

typedef void(^RZDirectionsServiceLineStringBlock)(NSString *lineString, MKRoute *route, NSError *error);

@class MKDirectionsRequest;
@interface RZDirectionService : NSObject

+ (instancetype)sharedInstance;

- (void)directionsFromSourceCoordinate:(CLLocationCoordinate2D)source destinationCoordinate:(CLLocationCoordinate2D)destination completion:(RZDirectionsServiceLineStringBlock)completion;

- (void)directionsFromDirectionRequest:(MKDirectionsRequest *)request completion:(RZDirectionsServiceLineStringBlock)completion;

- (void)directionsFromSourceLocation:(MKMapItem *)source destinationLocation:(MKMapItem *)destination completion:(RZDirectionsServiceLineStringBlock)completion;

@end
