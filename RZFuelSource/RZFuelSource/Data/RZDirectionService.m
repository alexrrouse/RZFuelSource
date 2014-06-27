//
//  RZDirectionService.m
//  RZFuelSource
//
//  Created by alex.rouse on 6/27/14.
//  Copyright (c) 2014 Raizlabs. All rights reserved.
//

#import "RZDirectionService.h"
#import "RZFuelWebService.h"

@import MapKit;

@implementation RZDirectionService

+ (instancetype)sharedInstance
{
    static RZDirectionService *s_manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        s_manager = [[self alloc] init];
    });
    return s_manager;
}

- (void)directionsFromDirectionRequest:(MKDirectionsRequest *)request
{
    // WHYYYYY APPLE WHYYYYY
    MKDirectionsRequest * newRequest = [[MKDirectionsRequest alloc] init];
    newRequest.transportType = MKDirectionsTransportTypeAutomobile;
    newRequest.requestsAlternateRoutes = NO;
    newRequest.source = request.source;
    newRequest.destination = request.destination;
    
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{

        MKDirections *drivingDirections = [[MKDirections alloc] initWithRequest:newRequest];

        [drivingDirections calculateDirectionsWithCompletionHandler:^(MKDirectionsResponse *response, NSError *error) {
            if (error == nil)
            {
                NSArray *routes = [response routes];
                MKRoute *route = [response.routes firstObject];
                
                NSMutableString *lineString = [NSMutableString stringWithString:@"LINESTRING("];
                NSUInteger pointCount = route.polyline.pointCount;
                
                //allocate a C array to hold this many points/coordinates...
                CLLocationCoordinate2D *routeCoordinates
                = malloc(pointCount * sizeof(CLLocationCoordinate2D));
                
                //get the coordinates (all of them)...
                [route.polyline getCoordinates:routeCoordinates
                                         range:NSMakeRange(0, pointCount)];
                
                //this part just shows how to use the results...
                NSLog(@"route pointCount = %d", pointCount);
//                for (int c=0; c < pointCount; c++)
//                {
//                    CLLocationCoordinate2D coord = routeCoordinates[0];
//                    [lineString appendFormat:@"%f %f%@", coord.longitude, coord.latitude, ((c == pointCount-1) ? @"" : @",")];
//                    
//                }
                
                [lineString appendFormat:@"%f %f,", routeCoordinates[0].longitude, routeCoordinates[0].latitude];
                [lineString appendFormat:@"%f %f", routeCoordinates[pointCount-1].longitude, routeCoordinates[pointCount-1].latitude];
                [lineString appendString:@")"];
                
                NSLog(@"LineString: %@", lineString);
                //free the memory used by the C array when done with it...
                free(routeCoordinates);
                
                //@"LINESTRING(-74.0 40.7, -87.63 41.87, -104.98 39.76)"
                [[RZFuelWebService sharedInstance] fetchNearbyLocationsWithFuelType:RZFuelTypeAll route:lineString completionBlock:^(NSArray *objects, NSError *error) {
                    
                }];
            }
        }];

//    });
    
}
@end
