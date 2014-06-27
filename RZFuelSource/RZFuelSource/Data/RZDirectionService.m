//
//  RZDirectionService.m
//  RZFuelSource
//
//  Created by alex.rouse on 6/27/14.
//  Copyright (c) 2014 Raizlabs. All rights reserved.
//

#import "RZDirectionService.h"
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
    request.transportType = MKDirectionsTransportTypeAutomobile;
    request.requestsAlternateRoutes = NO;
    MKDirections *drivingDirections = [[MKDirections alloc] initWithRequest:request];
    
    [drivingDirections calculateDirectionsWithCompletionHandler:^(MKDirectionsResponse *response, NSError *error) {
        if (error == nil)
        {
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
            for (int c=0; c < pointCount; c++)
            {
                CLLocationCoordinate2D coord = routeCoordinates[c];
                [lineString appendFormat:@"%f %f %@", coord.latitude, coord.longitude, ((c == pointCount-1) ? @"" : @", ")];
                
            }
            
            NSLog(@"LineString: %@", lineString);
            //free the memory used by the C array when done with it...
            free(routeCoordinates);
        }
    }];

}
@end
